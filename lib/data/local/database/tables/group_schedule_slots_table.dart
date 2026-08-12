import 'package:drift/drift.dart';
import 'groups_table.dart';

/// نمط تكرار أسبوعي لمجموعة — «كل [weekday] الساعة [fixedTime]» أو «كل
/// [weekday] بعد [prayerName] بـ[offsetMinutes] دقيقة». يُوسَّع فعلياً إلى
/// مواعيد محدَّدة بواسطة RecurrenceService.expand() (بند 2.2) — هذا الصف
/// نفسه لا يمثّل أي موعد بعينه، بل القاعدة اللي تُولِّد المواعيد.
class GroupScheduleSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer().references(Groups, #id)();

  /// ١ (الاثنين) إلى ٧ (الأحد) — مطابق لـ DateTime.weekday في Dart.
  IntColumn get weekday => integer()();

  /// 'وقت محدد' أو 'مرتبط بصلاة' — راجع core/enums/anchor_type.dart.
  TextColumn get anchorType => text().withLength(max: 20)();

  /// HH:mm — مطلوب فقط لو anchorType == 'وقت محدد'.
  TextColumn? get fixedTime => text().nullable()();

  /// اسم الصلاة (مثال: 'المغرب') — مطلوب فقط لو anchorType == 'مرتبط بصلاة'.
  TextColumn? get prayerName => text().nullable()();

  /// الإزاحة بالدقائق عن وقت الصلاة (يمكن أن تكون سالبة = قبل الصلاة).
  IntColumn get offsetMinutes => integer().withDefault(const Constant(0))();

  DateTimeColumn get effectiveFrom => dateTime()();
  DateTimeColumn? get effectiveTo => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
