import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

@freezed
abstract class Goal with _$Goal {
  const factory Goal({
    @Default(0) int id,
    required int studentId,
    required String title,
    @Default('سورة') String goalType,
    int? targetSurahId,
    int? targetJuzNumber,
    required DateTime startDate,
    DateTime? targetDate,
    @Default('لم يبدأ') String status,
    DateTime? createdAt,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
