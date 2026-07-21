import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(max: 50).unique()();
  TextColumn get passwordHash => text()();
  TextColumn get fullName => text().withLength(max: 100)();
  TextColumn get role => text().withLength(max: 20).withDefault(const Constant('Teacher'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
