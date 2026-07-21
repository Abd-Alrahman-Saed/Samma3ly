import 'package:drift/drift.dart';
import 'students_table.dart';
import 'surahs_table.dart';

class Schedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(Students, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get time => text()(); // HH:mm format
  IntColumn? get memorizationSurahId => integer().references(Surahs, #id).nullable()();
  IntColumn? get memorizationFromAyah => integer().nullable()();
  IntColumn? get memorizationToAyah => integer().nullable()();
  IntColumn? get revisionSurahId => integer().references(Surahs, #id).nullable()();
  IntColumn? get revisionFromAyah => integer().nullable()();
  IntColumn? get revisionToAyah => integer().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
