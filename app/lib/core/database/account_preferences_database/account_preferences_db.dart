import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

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

])
class AccountPreferencesDatabase extends _$AccountPreferencesDatabase {
  final int localId;

  AccountPreferencesDatabase({required this.localId}) : super(_openConnection(localId));

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(int id) {
    return driftDatabase(name: 'session_${id}_db');
  }
}

