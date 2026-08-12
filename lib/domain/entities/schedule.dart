import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

@freezed
abstract class Schedule with _$Schedule {
  const factory Schedule({
    @Default(0) int id,
    required int studentId,
    required DateTime date,
    @Default('00:00') String time,
    int? memorizationSurahId,
    int? memorizationFromAyah,
    int? memorizationToAyah,
    int? revisionSurahId,
    int? revisionFromAyah,
    int? revisionToAyah,
    @Default(false) bool isCompleted,
    DateTime? createdAt,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}
