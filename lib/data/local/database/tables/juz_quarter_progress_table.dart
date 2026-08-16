import 'package:drift/drift.dart';
import 'students_table.dart';

/// طلب المستخدم بعد الإطلاق (القسم ح.2، docs/IMPLEMENTATION_PLAN.md): تتبّع
/// يدوي بالكامل للحفظ، بمعزل عن أي حساب تلقائي من بيانات الجلسات
/// (ProgressService/MemorizedRanges). كل جزء من الـ30 جزء مقسَّم لثمانية
/// أرباع (تقسيم "ربع الحزب" المطبوع فعلياً في المصحف — لا حاجة لجدول نطاقات
/// سور/آيات مثل JuzSurahRanges، فقط رقم الربع 1..8 داخل كل جزء).
///
/// وجود صفّ = الربع محفوظ. لا عمود "completed" منفصل: تعليم الربع "غير
/// محفوظ" يحذف الصفّ بدل تحديث علم — أبسط، ولا يترك حالة نصف-معرَّفة.
class JuzQuarterProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(Students, #id)();
  IntColumn get juzNumber => integer()();
  IntColumn get quarterIndex => integer()();
  DateTimeColumn get completedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {studentId, juzNumber, quarterIndex},
      ];
}
