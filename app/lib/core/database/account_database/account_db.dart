import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:encrypt/encrypt.dart';

import '../../../utils/logger.dart';

part 'account_db.g.dart';

class ClearTextAccount {
  final int localId;
  final int schoolID;
  final String username;
  final String password;

  ClearTextAccount({
    required this.localId,
    required this.schoolID,
    required this.username,
    required this.password,
  });
}

class AccountsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get schoolId => integer()();
  TextColumn get username => text().withLength(min: 1, max: 50)();
  TextColumn get passwordHash => text().withLength(min: 1, max: 50)();
  DateTimeColumn get lastLogin => dateTime()();
  DateTimeColumn get creationDate => dateTime()();
}

@DriftDatabase(tables: [
  AccountsTable,
])
class AccountDatabase extends _$AccountDatabase {
  AccountDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<String> cryptPassword(String password) async {
    final String? key = await FlutterKeychain.get(key: 'encryption_key');
    if (key == null) {
      final cryptKey = Key.fromSecureRandom(32); // 256 bits
      await FlutterKeychain.put(key: 'encryption_key', value: cryptKey.base64);
      logger.i('Generated new encryption key');
    }
    final cryptKey = Key.fromBase64(key!);
    final iv = IV.fromSecureRandom(16); // 128 bits
    final encrypter = Encrypter(AES(cryptKey, mode: AESMode.gcm));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  Future<String> decryptPassword(String encryptedPassword) async {
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

  Future <void> addAccountToDatabase({required int schoolID, required String username, required String password}) async {
    String passwordHash = await cryptPassword(password);
    await into(accountsTable).insert(AccountsTableCompanion(
      schoolId: Value(schoolID),
      username: Value(username),
      passwordHash: Value(passwordHash),
      lastLogin: Value(DateTime.now()),
      creationDate: Value(DateTime.now()),
    ));
  }

  Future<ClearTextAccount?> getLastLoggedInAccount() async {
    final account = await (select(accountsTable)
          ..orderBy([
            (u) => OrderingTerm(
                expression: u.lastLogin,
                mode: OrderingMode.desc,
                nulls: NullsOrder.last),
          ]))
        .getSingleOrNull();
    if (account == null) return null;

    return ClearTextAccount(
      localId: account.id,
      schoolID: account.schoolId,
      username: account.username,
      password: await decryptPassword(account.passwordHash),
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'accounts_database');
  }
}

late final AccountDatabase accountDatabase;
