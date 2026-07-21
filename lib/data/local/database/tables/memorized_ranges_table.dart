import 'package:drift/drift.dart';
import 'students_table.dart';
import 'surahs_table.dart';

class MemorizedRanges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(Students, #id)();
  IntColumn get surahId => integer().references(Surahs, #id)();
  IntColumn get fromAyah => integer()();
  IntColumn get toAyah => integer()();
  TextColumn get status => text().withLength(max: 20).withDefault(const Constant('محفوظ'))();
  IntColumn get revisionCycleDays => integer().withDefault(const Constant(7))();
  DateTimeColumn? get lastRevisedAt => dateTime().nullable()();
  DateTimeColumn? get nextReviewDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
