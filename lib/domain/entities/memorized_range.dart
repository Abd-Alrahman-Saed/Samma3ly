import 'package:freezed_annotation/freezed_annotation.dart';

part 'memorized_range.freezed.dart';
part 'memorized_range.g.dart';

@freezed
class MemorizedRange with _$MemorizedRange {
  const factory MemorizedRange({
    @Default(0) int id,
    required int studentId,
    required int surahId,
    required int fromAyah,
    required int toAyah,
    @Default('محفوظ') String status,
    @Default(7) int revisionCycleDays,
    DateTime? lastRevisedAt,
    DateTime? nextReviewDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MemorizedRange;

  factory MemorizedRange.fromJson(Map<String, dynamic> json) =>
      _$MemorizedRangeFromJson(json);
}
