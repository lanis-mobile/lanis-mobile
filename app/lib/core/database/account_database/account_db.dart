import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/logger.dart';
import '../../sph/sph.dart';
import '../account_preferences_database/kv_defaults.dart';

part 'account_db.g.dart';

class ClearTextAccount {
  final int localId;
  final int schoolID;
  final String username;
  final String password;
  final String schoolName;
  final bool firstLogin;

  ClearTextAccount({
    required this.localId,
    required this.schoolID,
    required this.username,
    required this.password,
    required this.schoolName,
    this.firstLogin = false,
  });
}

class AppPreferencesTable extends Table {
  TextColumn get key => text().withLength(min: 1, max: 50)();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

class AccountsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get schoolId => integer()();
  TextColumn get schoolName => text()();
  TextColumn get username => text().withLength(min: 1, max: 50)();
  TextColumn get passwordHash => text()();
  DateTimeColumn get lastLogin => dateTime().nullable()();
  DateTimeColumn get creationDate => dateTime()();
}

@DriftDatabase(tables: [
  AccountsTable, AppPreferencesTable
])
class AccountDatabase extends _$AccountDatabase {
  late final KV kv = KV(this);

  AccountDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<String> _cryptPassword(String password) async {
    String? key = await FlutterKeychain.get(key: 'encryption_key');
    if (key == null) {
      final cryptKey = Key.fromSecureRandom(32); // 256 bits
      await FlutterKeychain.put(key: 'encryption_key', value: cryptKey.base64);
      key = cryptKey.base64;
      logger.i('Generated new encryption key');
    }
    final cryptKey = Key.fromBase64(key);
    final iv = IV.fromSecureRandom(16); // 128 bits
    final encrypter = Encrypter(AES(cryptKey, mode: AESMode.gcm));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  Future<String> _decryptPassword(String encryptedPassword) async {
    logger.i(encryptedPassword);
    final String? key = await FlutterKeychain.get(key: 'encryption_key');
    if (key == null) {
      throw Exception('Encryption key not found');
    }
    final cryptKey = Key.fromBase64(key);
    final parts = encryptedPassword.split(':');
    if (parts.length != 2) {
      throw Exception('Invalid encrypted password format');
    }
    final iv = IV.fromBase64(parts[0]);
    final encrypter = Encrypter(AES(cryptKey, mode: AESMode.gcm));
    return encrypter.decrypt64(parts[1], iv: iv);
  }

  Future <void> addAccountToDatabase({required int schoolID, required String username, required String password, required String schoolName}) async {
    String passwordHash = await _cryptPassword(password);
    await into(accountsTable).insert(AccountsTableCompanion(
      schoolId: Value(schoolID),
      schoolName: Value(schoolName),
      username: Value(username),
      passwordHash: Value(passwordHash),
      lastLogin: Value(null),
      creationDate: Value(DateTime.now()),
    ));
  }

  Future<ClearTextAccount?> getLastLoggedInAccount() async {
    final _account = await (select(accountsTable)
          ..orderBy([
            (u) => OrderingTerm(
                expression: u.lastLogin,
                mode: OrderingMode.desc,
                nulls: NullsOrder.first),
          ])).get();
    final account = _account.isNotEmpty ? _account.first : null;
    if (account == null) return null;

    return ClearTextAccount(
      localId: account.id,
      schoolID: account.schoolId,
      username: account.username,
      password: await _decryptPassword(account.passwordHash),
      schoolName: account.schoolName,
      firstLogin: account.lastLogin == null,
    );
  }

  Future<void> deleteAccount(int id) async {
    if (id == sph?.account.localId) {
      sph?.prefs.close();
      final Directory databasesDirectory = await getApplicationDocumentsDirectory();
      final dbFile = File('${databasesDirectory.path}/session_${id}_db.sqlite');
      if (dbFile.existsSync()) {
        dbFile.deleteSync();
      }
    }
    final int rows = await (delete(accountsTable)..where((tbl) => tbl.id.equals(id))).go();
    if (rows == 0) {
      logger.w('Account with id $id not found');
    }
    final tempDir = await getTemporaryDirectory();
    final userDir = Directory("${tempDir.path}/$id");
    if (!userDir.existsSync()) {
      userDir.deleteSync(recursive: true);
    }
  }

  void updateLastLogin(int id) async {
    (await (update(accountsTable)..where((tbl) => tbl.id.equals(id))).write(AccountsTableCompanion(
      lastLogin: Value(DateTime.now()),
    )));
  }

  void setNextLogin(int id) async {
    // check weather a account with null is already in the db and return if so
    final account = await (select(accountsTable)..where((tbl) => tbl.lastLogin.isNull())).get();
    if (account.isNotEmpty) {
      return;
    }

    (await (update(accountsTable)..where((tbl) => tbl.id.equals(id))).write(AccountsTableCompanion(
      lastLogin: Value(null),
    )));
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'accounts_database');
  }
}

class KV {
  final AccountDatabase db;

  KV(this.db);

  Future<void> set(String key, String value) async {
    await db.into(db.appPreferencesTable).insert(AppPreferencesTableCompanion.insert(key: key, value: Value(value)), mode: InsertMode.insertOrReplace);
  }

  Future<String?> get(String key) async {
    final val = (await (db.select(db.appPreferencesTable)..where((tbl) => tbl.key.equals(key))).getSingleOrNull())?.value;
    if (val == null && kvDefaults.keys.contains(key)) {
      set(key, kvDefaults[key]!);
      return kvDefaults[key];
    }
    return val;
  }

  Stream<String?> subscribe(String key) {
    final stream = (db.select(db.appPreferencesTable)..where((tbl) => tbl.key.equals(key))).watchSingleOrNull();
    return stream.map((event) => event?.value);
  }

  Stream<Map<String, String?>> subscribeMultiple(List<String> keys) {
    final stream = (db.select(db.appPreferencesTable)..where((tbl) => tbl.key.isIn(keys))).watch();
    return stream.map((event) => Map.fromEntries(event.map((e) => MapEntry(e.key, e.value))));
  }
}

late final AccountDatabase accountDatabase;
