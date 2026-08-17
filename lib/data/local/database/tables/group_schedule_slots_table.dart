import 'package:drift/drift.dart';
import 'groups_table.dart';

/// نمط تكرار أسبوعي لمجموعة — «كل [weekday] الساعة [fixedTime]». يُوسَّع فعلياً
/// إلى مواعيد محدَّدة بواسطة RecurrenceService.expand() (بند 2.2) — هذا الصف
/// نفسه لا يمثّل أي موعد بعينه، بل القاعدة اللي تُولِّد المواعيد.
///
/// كان فيه خيار "مرتبط بصلاة" (anchorType/prayerName/offsetMinutes، بند 2.3)
/// — أُزيل بالكامل؛ راجع docs/IMPLEMENTATION_PLAN.md للتفاصيل ولسبب حذفه
/// (v9). عمود fixedTime وحده الآن يحدّد توقيت أي موعد.
class GroupScheduleSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer().references(Groups, #id)();

  /// ١ (الاثنين) إلى ٧ (الأحد) — مطابق لـ DateTime.weekday في Dart.
  IntColumn get weekday => integer()();

  /// HH:mm.
  TextColumn? get fixedTime => text().nullable()();

  DateTimeColumn get effectiveFrom => dateTime()();
  DateTimeColumn? get effectiveTo => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
