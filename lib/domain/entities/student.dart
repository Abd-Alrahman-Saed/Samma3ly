import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@freezed
class Student with _$Student {
  const factory Student({
    @Default(0) int id,
    required String fullName,
    required int age,
    @Default('') String phone,
    @Default('') String address,
    String? parentName,
    String? parentPhone,
    int? currentSurahId,
    int? lastCompletedSurahId,
    @Default(0) int totalCompletedJuz,
    @Default('مبتدئ') String level,
    DateTime? createdAt,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);
}
