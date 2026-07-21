import 'package:drift/drift.dart';
import 'students_table.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(Students, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get time => text()(); // HH:mm format
  TextColumn get attendanceStatus => text().withLength(max: 20).withDefault(const Constant('حاضر'))();
  TextColumn? get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
