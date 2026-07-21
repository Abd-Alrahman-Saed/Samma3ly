import 'package:drift/drift.dart';
import 'sessions_table.dart';
import 'surahs_table.dart';

class SessionMemorizations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id).unique()();
  IntColumn get surahId => integer().references(Surahs, #id)();
  IntColumn get fromAyah => integer()();
  IntColumn get toAyah => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
