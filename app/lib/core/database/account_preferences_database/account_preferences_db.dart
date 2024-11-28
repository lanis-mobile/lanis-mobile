import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'kv_defaults.dart';

part 'account_preferences_db.g.dart';

class AppPreferencesTable extends Table {
  TextColumn get key => text().withLength(min: 1, max: 50)();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

class AppletPreferencesTable extends Table {
  TextColumn get appletId => text().withLength(min: 1, max: 30)();
  TextColumn get key => text().withLength(min: 1, max: 50)();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {appletId, key};
}

class AppletData extends Table {
  TextColumn get appletId => text().withLength(min: 1, max: 30)();
  TextColumn get json => text().nullable()();

  @override
  Set<Column> get primaryKey => {appletId};

}

@DriftDatabase(tables: [
  AppPreferencesTable, AppletPreferencesTable, AppletData
])
class AccountPreferencesDatabase extends _$AccountPreferencesDatabase {
  late final KV kv = KV(this);
  final int localId;

  AccountPreferencesDatabase({required this.localId}) : super(_openConnection(localId));



  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(int id) {
    return driftDatabase(name: 'session_${id}_db');
  }
}

class KV {
  final AccountPreferencesDatabase db;

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
    return stream.map((event) {
      if (event?.value == null && kvDefaults.containsKey(key)) {
        return kvDefaults[key];
      }
      return event?.value;
    });
  }

  Stream<Map<String, String?>> subscribeMultiple(List<String> keys) {
    final stream = (db.select(db.appPreferencesTable)..where((tbl) => tbl.key.isIn(keys))).watch();
    return stream.map((event) {
      final result = Map.fromEntries(event.map((e) => MapEntry(e.key, e.value)));
      for (var key in keys) {
        if (!result.containsKey(key)) {
          result[key] = kvDefaults.containsKey(key) ? kvDefaults[key] : null;
        }
      }
      return result;
    });
  }

  Stream<Map<String, String?>> subscribeAllApplet(String appletId, Map<String, String?> defaults) {
    final stream = (db.select(db.appletPreferencesTable)..where((tbl) => tbl.appletId.equals(appletId))).watch();
    return stream.map((event) {
      final result = Map.fromEntries(event.map((e) => MapEntry(e.key, e.value)));
      for (var key in defaults.keys) {
        if (!result.containsKey(key) && defaults.containsKey(key)) {
          result[key] = defaults[key];
        }
      }
      return result;
    });
  }
  Future<Map<String, String?>> getAllApplet(String appletId, Map<String, String?> defaults) async {
    final result = Map<String, String?>.fromEntries((await (db.select(db.appletPreferencesTable)..where((tbl) => tbl.appletId.equals(appletId))).get()).map((e) => MapEntry(e.key, e.value)));
    for (var key in defaults.keys) {
      if (!result.containsKey(key) && defaults.containsKey(key)) {
        result[key] = defaults[key];
      }
    }
    return result;
  }

  Future<void> setAppletValue(String appletId, String key, String value) async {
    await db.into(db.appletPreferencesTable).insert(AppletPreferencesTableCompanion.insert(appletId: appletId, key: key, value: Value(value)), mode: InsertMode.insertOrReplace);
  }
}