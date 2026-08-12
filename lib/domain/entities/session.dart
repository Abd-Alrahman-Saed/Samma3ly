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
  }) = _SessionEvaluation;

  const SessionEvaluation._();

  factory SessionEvaluation.fromJson(Map<String, dynamic> json) =>
      _$SessionEvaluationFromJson(json);

  double get finalScore {
    final sum = memorizationScore + tajweedScore + fluencyScore;
    return (sum / 3 * 10).roundToDouble() / 10;
  }
}
