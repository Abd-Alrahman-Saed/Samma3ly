import 'package:drift/drift.dart';
import 'sessions_table.dart';
import 'students_table.dart';
import 'surahs_table.dart';

/// حضور طالب واحد في جلسة واحدة. جلسة فردية لها صف واحد بالضبط؛ جلسة
/// جماعية (Sessions.sessionType == 'جماعي') لها صف لكل طالب حضر. كانت
/// هذه القيمة عمود attendanceStatus مباشرة على Sessions قبل v4 — نُقلت
/// هنا لأن الجلسة الجماعية تحتاج حالة حضور مستقلة لكل طالب فيها.
///
/// v5 (Sprint 3، بند 3.4): أضيفت حقول التسميع (حفظ/مراجعة/تقييم) هنا لا
/// في SessionMemorizations/SessionRevisions/SessionEvaluations —
/// `sessionId` في تلك الجداول `unique()` (صفّ واحد لكل *جلسة*، مناسب
/// لجلسة فردية طالبها واحد)، بينما جلسة جماعية فيها طلاب متعددين يحتاج
/// كل واحد منهم تسميعاً مستقلاً. هذا الجدول أصلاً مفتاحه الفريد
/// (sessionId, studentId) — التمثيل الطبيعي لتسميع طالب واحد داخل جلسة
/// واحدة، فردية كانت أو جماعية.
///
/// v7 (القسم ح.6): `recitationOutcome` — قرار المعلّم السريع بعد التسميع
/// ("اجتاز" أو "يُعاد")، مستقلّ عن تفاصيل التقييم الأربعة. لا يمثّل نتيجة
/// اشتقاقاً آلياً (مثلاً من متوسط الدرجات) — هذا حكم المعلّم المباشر.
///
/// v8 (القسم ح.12): تقييم منفصل للمراجعة (revisionMemorizationScore...)
/// — نفس المعايير الأربعة لكن لأداء المراجعة، مستقلّ تماماً عن تقييم
/// الحفظ الجديد أعلاه. راجع نفس التعليق على SessionEvaluations.
class SessionAttendances extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  IntColumn get studentId => integer().references(Students, #id)();
  TextColumn get attendanceStatus => text().withLength(max: 20).withDefault(const Constant('حاضر'))();

  IntColumn? get memorizationSurahId => integer().references(Surahs, #id).nullable()();
  IntColumn? get memorizationFromAyah => integer().nullable()();
  IntColumn? get memorizationToAyah => integer().nullable()();

  IntColumn? get revisionSurahId => integer().references(Surahs, #id).nullable()();
  IntColumn? get revisionFromAyah => integer().nullable()();
  IntColumn? get revisionToAyah => integer().nullable()();

  RealColumn get memorizationScore => real().withDefault(const Constant(0.0))();
  RealColumn get tajweedScore => real().withDefault(const Constant(0.0))();
  RealColumn get fluencyScore => real().withDefault(const Constant(0.0))();
  RealColumn get accuracyScore => real().withDefault(const Constant(0.0))();

  RealColumn get revisionMemorizationScore => real().withDefault(const Constant(0.0))();
  RealColumn get revisionTajweedScore => real().withDefault(const Constant(0.0))();
  RealColumn get revisionFluencyScore => real().withDefault(const Constant(0.0))();
  RealColumn get revisionAccuracyScore => real().withDefault(const Constant(0.0))();

  TextColumn? get notes => text().nullable()();

  TextColumn? get recitationOutcome => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {sessionId, studentId},
      ];
}
