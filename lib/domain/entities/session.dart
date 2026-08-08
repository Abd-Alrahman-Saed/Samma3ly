import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  const factory Session({
    @Default(0) int id,
    required int studentId,
    required DateTime date,
    @Default('00:00') String time,
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
class SessionMemorization with _$SessionMemorization {
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
class SessionRevision with _$SessionRevision {
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
class SessionEvaluation with _$SessionEvaluation {
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
