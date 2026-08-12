import 'package:drift/drift.dart';
import 'users_table.dart';

/// حلقة/مجموعة تحفيظ — تجمع عدة طلاب تحت معلّم واحد بجدول أسبوعي متكرر.
/// Sprint 2 (schema v4). راجع docs/IMPLEMENTATION_PLAN.md القسم ب.
class Groups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 100)();
  IntColumn? get teacherId => integer().references(Users, #id).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
