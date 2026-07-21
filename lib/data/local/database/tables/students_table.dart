import 'package:drift/drift.dart';
import 'surahs_table.dart';

class Students extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fullName => text().withLength(max: 100)();
  IntColumn get age => integer()();
  TextColumn get phone => text()();
  TextColumn get address => text()();
  TextColumn? get parentName => text().withLength(max: 100).nullable()();
  TextColumn? get parentPhone => text().nullable()();
  IntColumn? get currentSurahId => integer().references(Surahs, #id).nullable()();
  IntColumn? get lastCompletedSurahId => integer().references(Surahs, #id).nullable()();
  IntColumn get totalCompletedJuz => integer().withDefault(const Constant(0))();
  TextColumn get level => text().withLength(max: 20).withDefault(const Constant('مبتدئ'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
