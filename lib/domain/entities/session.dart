import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    @Default(0) int id,
    // nullable منذ Sprint 2 (v4): جلسة جماعية لا طالب واحد لها. لسه
    // مطلوب فعلياً لكل الجلسات الفردية — راجع sessions_table.dart.
    int? studentId,
    // Sprint 2 (v4) — null لجلسة فردية.
    int? groupId,
    @Default('فردي') String sessionType,
    // Sprint 2 (v4) — تُملأ فقط للجلسات المُنشأة من حلقة متكرّرة (بند 2.7).
    DateTime? occurrenceDate,
    required DateTime date,
    @Default('00:00') String time,
    // القيمة الفعلية تُقرأ/تُكتب عبر SessionAttendances منذ v4 (Sprint 2)
    // — هذا الحقل مجرد راحة على مستوى الـdomain للحالة الشائعة (جلسة
    // فردية = صف حضور واحد بالضبط)؛ الـrepository هو المسؤول عن الـjoin.
    // راجع docs/DESIGN_SPEC.md وdocs/IMPLEMENTATION_PLAN.md القسم ب.
    @Default('حاضر') String attendanceStatus,
    String? notes,
    // القسم ح.6 (v7): قرار المعلّم السريع بعد التسميع — "اجتاز" أو "يُعاد".
    // يُعرَض في "معلومات الجلسة الخارجية" (بطاقات القوائم) منذ القسم ح.12
    // ليعرف المعلّم من غير فتح الجلسة أن حفظها/مراجعتها تحتاج إعادة.
    String? recitationOutcome,
    DateTime? createdAt,
    SessionMemorization? memorization,
    SessionRevision? revision,
    SessionEvaluation? evaluation,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
}

@freezed
abstract class SessionMemorization with _$SessionMemorization {
  const factory SessionMemorization({
    @Default(0) int id,
    @Default(0) int sessionId,
    required int surahId,
    @Default(1) int fromAyah,
    @Default(1) int toAyah,
  }) = _SessionMemorization;

  factory SessionMemorization.fromJson(Map<String, dynamic> json) =>
      _$SessionMemorizationFromJson(json);
}

@freezed
abstract class SessionRevision with _$SessionRevision {
  const factory SessionRevision({
    @Default(0) int id,
    @Default(0) int sessionId,
    required int surahId,
    @Default(1) int fromAyah,
    @Default(1) int toAyah,
  }) = _SessionRevision;

  factory SessionRevision.fromJson(Map<String, dynamic> json) =>
      _$SessionRevisionFromJson(json);
}

@freezed
abstract class SessionEvaluation with _$SessionEvaluation {
  const factory SessionEvaluation({
    @Default(0) int id,
    @Default(0) int sessionId,
    @Default(0.0) double memorizationScore,
    @Default(0.0) double tajweedScore,
    @Default(0.0) double fluencyScore,
    @Default(0.0) double accuracyScore,
    // القسم ح.12 (v8): تقييم منفصل للمراجعة — نفس المعايير الأربعة، لكن
    // لأداء المراجعة لا الحفظ الجديد. مستقلّة تماماً عن الدرجات أعلاه لأن
    // جلسة واحدة قد تحتوي حفظاً جديداً ومراجعة معاً بتقييمين مختلفين.
    @Default(0.0) double revisionMemorizationScore,
    @Default(0.0) double revisionTajweedScore,
    @Default(0.0) double revisionFluencyScore,
    @Default(0.0) double revisionAccuracyScore,
  }) = _SessionEvaluation;

  const SessionEvaluation._();

  factory SessionEvaluation.fromJson(Map<String, dynamic> json) =>
      _$SessionEvaluationFromJson(json);

  // القسم ح.10: التشكيل بقى معياراً رابعاً فعلياً (كان accuracyScore
  // مخزَّناً دائماً لكن غير مُدخَل من أي شاشة فردية قبل الآن) — المتوسط
  // بقى على 4 لا 3، مطابقاً لنفس حساب GroupStudentRecitationScreen.
  double get finalScore {
    final sum = memorizationScore + tajweedScore + fluencyScore + accuracyScore;
    return (sum / 4 * 10).roundToDouble() / 10;
  }

  // القسم ح.12: نفس حساب finalScore، لكن لدرجات المراجعة المنفصلة.
  double get revisionFinalScore {
    final sum = revisionMemorizationScore +
        revisionTajweedScore +
        revisionFluencyScore +
        revisionAccuracyScore;
    return (sum / 4 * 10).roundToDouble() / 10;
  }

  // true فقط لو أُدخلت أي درجة مراجعة فعلياً (لا كلها صفر افتراضي) — يميّز
  // "جلسة فيها مراجعة مُقيَّمة" عن "جلسة بلا مراجعة إطلاقاً" لعرض بطاقة
  // المراجعة في القوائم فقط عند الحاجة.
  bool get hasRevisionEvaluation =>
      revisionMemorizationScore > 0 ||
      revisionTajweedScore > 0 ||
      revisionFluencyScore > 0 ||
      revisionAccuracyScore > 0;
}
