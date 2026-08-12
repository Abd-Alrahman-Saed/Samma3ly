import 'package:drift/drift.dart';
import 'group_schedule_slots_table.dart';

/// استثناء لمناسبة واحدة من حلقة متكرّرة — إلغاء أو إعادة جدولة يوم بعينه
/// بدون التأثير على باقي الحلقة.
class ScheduleExceptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupScheduleSlotId => integer().references(GroupScheduleSlots, #id)();

  /// التاريخ الأصلي للمناسبة المُستثناة (قبل أي إعادة جدولة).
  DateTimeColumn get occurrenceDate => dateTime()();

  /// 'إلغاء' أو 'إعادة جدولة' — راجع core/enums/schedule_exception_type.dart.
  TextColumn get exceptionType => text().withLength(max: 20)();

  /// مطلوبان فقط لو exceptionType == 'إعادة جدولة'.
  DateTimeColumn? get newDate => dateTime().nullable()();
  TextColumn? get newTime => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
