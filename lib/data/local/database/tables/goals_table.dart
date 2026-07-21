import 'package:drift/drift.dart';
import 'students_table.dart';
import 'surahs_table.dart';

class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(Students, #id)();
  TextColumn get title => text()();
  TextColumn get goalType => text().withLength(max: 20).withDefault(const Constant('سورة'))();
  IntColumn? get targetSurahId => integer().references(Surahs, #id).nullable()();
  IntColumn? get targetJuzNumber => integer().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn? get targetDate => dateTime().nullable()();
  TextColumn get status => text().withLength(max: 20).withDefault(const Constant('لم يبدأ'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
