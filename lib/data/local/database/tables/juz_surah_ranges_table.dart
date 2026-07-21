import 'package:drift/drift.dart';
import 'surahs_table.dart';

class JuzSurahRanges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get juzNumber => integer()();
  IntColumn get surahId => integer().references(Surahs, #id)();
  IntColumn get fromAyah => integer()();
  IntColumn get toAyah => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
