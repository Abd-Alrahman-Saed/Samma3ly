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
    // القسم ح.14: مراجعات متعددة للجلسة الواحدة (قريبة/بعيدة/عامة…)، كل
    // واحدة بتقييمها المستقلّ — كانت `SessionRevision?` مفردة قبل هذا
    // التحديث. راجع getter `revision` أدناه للتوافق مع مسارات لا تزال
    // بحاجة "مراجعة واحدة" (جلسات الحلقات).
    @Default(<SessionRevision>[]) List<SessionRevision> revisions,
    // تقييم **الحفظ الجديد** فقط. تقييم كل مراجعة أصبح على صفّها في
    // [revisions] (القسم ح.14) — لم يعد هنا.
    SessionEvaluation? evaluation,
  }) = _Session;

  const Session._();

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  /// أول مراجعة فقط — توافقية لمسارات لا تزال بمراجعة واحدة بالضبط (جلسات
  /// الحلقات، مصدرها `SessionAttendances` لا `SessionRevisions`). الشاشات
  /// التي تدعم مراجعات متعددة تستخدم [revisions] مباشرة.
  SessionRevision? get revision => revisions.isEmpty ? null : revisions.first;

  /// متوسط كل الأجزاء المُقيَّمة فعلاً في الجلسة — الحفظ الجديد (لو
  /// قُيِّم) وكل مراجعة قُيِّمت، بمعزل عن أي جزء لم يُدخَل له تقييم (لا
  /// صفر وهمي يخفّض المتوسط، بخلاف `finalScore` القديم الذي كان يفترض
  /// دائماً وجود حفظ). `null` لو لا يوجد أي تقييم فعلي بالجلسة كلها —
  /// يميّز "جلسة بلا أي تقييم" عن "جلسة بتقييم صفر فعلي".
  double? get overallScore {
    final parts = <double>[
      if (evaluation != null && evaluation!.hasEvaluation) evaluation!.finalScore,
      for (final r in revisions)
        if (r.hasEvaluation) r.finalScore,
    ];
    if (parts.isEmpty) return null;
    return (parts.reduce((a, b) => a + b) / parts.length * 10).roundToDouble() / 10;
  }
}

@freezed
abstract class SessionMemorization with _$SessionMemorization {
  const factory SessionMemorization({
    @Default(0) int id,
    @Default(0) int sessionId,
    required int surahId,
    @Default(1) int fromAyah,
    @Default(1) int toAyah,
    // القسم ح.14 (v10): "السورة كاملة" — `fromAyah`/`toAyah` تُملآن آلياً
    // (1 → عدد آيات السورة عبر `QuranUtils.getAyahCount`)، والعلم هنا
    // لعرض "(كاملة)" بدل المدى الرقمي ولإعادة فتح الشاشة على نفس الاختيار.
    @Default(false) bool isFullSurah,
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
    // القسم ح.14 (v10): نوع المراجعة كما اختاره المعلّم — "قريبة"/"بعيدة"/
    // "عامة" أو نصّ مخصَّص. تسمية حرّة عمداً (لا enum).
    @Default('مراجعة') String label,
    @Default(false) bool isFullSurah,
    @Default(0) int sortOrder,
    // القسم ح.14 (v10): تقييم هذه المراجعة بعينها — كان مشتركاً على مستوى
    // الجلسة كلها (`SessionEvaluation.revision*Score`) قبل دعم أكثر من
    // مراجعة واحدة؛ الآن كل مراجعة تحمل تقييمها المستقلّ.
    @Default(0.0) double memorizationScore,
    @Default(0.0) double tajweedScore,
    @Default(0.0) double fluencyScore,
    @Default(0.0) double accuracyScore,
  }) = _SessionRevision;

  const SessionRevision._();

  factory SessionRevision.fromJson(Map<String, dynamic> json) =>
      _$SessionRevisionFromJson(json);

  /// نفس معادلة `SessionEvaluation.finalScore`: متوسط المعايير الأربعة × ١٠.
  double get finalScore {
    final sum = memorizationScore + tajweedScore + fluencyScore + accuracyScore;
    return (sum / 4 * 10).roundToDouble() / 10;
  }

  /// true فقط لو أُدخلت أي درجة فعلياً (لا كلها صفر افتراضي).
  bool get hasEvaluation =>
      memorizationScore > 0 || tajweedScore > 0 || fluencyScore > 0 || accuracyScore > 0;
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

  /// true فقط لو أُدخلت أي درجة حفظ فعلياً — يميّز "جلسة فيها تقييم حفظ"
  /// عن "جلسة بلا تقييم حفظ إطلاقاً" (مثال: جلسة مراجعة فقط، القسم ح.14).
  bool get hasEvaluation =>
      memorizationScore > 0 || tajweedScore > 0 || fluencyScore > 0 || accuracyScore > 0;
}
