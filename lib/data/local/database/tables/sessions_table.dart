import 'package:drift/drift.dart';
import 'students_table.dart';
import 'groups_table.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// nullable منذ v4 (Sprint 2): جلسة جماعية (sessionType == 'جماعي') لا
  /// طالب واحد لها — الطلاب المرتبطون بها عبر SessionAttendances بدل هذا
  /// العمود. لسه مطلوب فعلياً لكل الجلسات الفردية الحالية.
  IntColumn? get studentId => integer().references(Students, #id).nullable()();

  /// nullable — فقط للجلسات الجماعية (sessionType == 'جماعي'). Sprint 2.
  IntColumn? get groupId => integer().references(Groups, #id).nullable()();

  /// 'فردي' أو 'جماعي' — راجع core/enums/session_type.dart. Sprint 2.
  TextColumn get sessionType => text().withLength(max: 20).withDefault(const Constant('فردي'))();

  /// تاريخ المناسبة المنطقي حين تُنشأ الجلسة من حلقة متكرّرة
  /// (materialize-on-write، بند 2.7) — يفرّق بين تاريخ *إنشاء* الصف وتاريخ
  /// *المناسبة* نفسها لو اختلفا (تسجيل حضور متأخر ليوم سابق مثلاً).
  /// Sprint 2.
  DateTimeColumn? get occurrenceDate => dateTime().nullable()();

  DateTimeColumn get date => dateTime()();
  TextColumn get time => text()(); // HH:mm format
  // attendanceStatus نُقل إلى SessionAttendances في v4 (Sprint 2) — جلسة
  // جماعية تحتاج حالة حضور مستقلة لكل طالب، فلم يعد عموداً واحداً هنا يكفي.
  TextColumn? get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
