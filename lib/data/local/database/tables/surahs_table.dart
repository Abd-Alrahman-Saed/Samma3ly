import 'package:drift/drift.dart';

class Surahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get number => integer().unique()();
  TextColumn get name => text().withLength(max: 50)();
  IntColumn get ayahCount => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
