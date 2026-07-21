import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_data.freezed.dart';
part 'dashboard_data.g.dart';

@freezed
class DashboardData with _$DashboardData {
  const factory DashboardData({
    @Default(0) int totalStudents,
    @Default(0) int todaySessions,
    @Default(0) int upcomingSessions,
    @Default(0.0) double averageAttendance,
    @Default(0) int totalPagesMemorized,
    @Default(0) int totalSurahsCompleted,
    @Default(0) int totalSessionsEver,
    @Default(0) int totalTeachers,
    @Default(<DashboardTopStudent>[])
    List<DashboardTopStudent> topStudents,
    @Default(<WeeklyAttendanceData>[])
    List<WeeklyAttendanceData> weeklyAttendance,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);
}

@freezed
class DashboardTopStudent with _$DashboardTopStudent {
  const factory DashboardTopStudent({
    required String studentName,
    required double averageScore,
  }) = _DashboardTopStudent;

  factory DashboardTopStudent.fromJson(Map<String, dynamic> json) =>
      _$DashboardTopStudentFromJson(json);
}

@freezed
class WeeklyAttendanceData with _$WeeklyAttendanceData {
  const factory WeeklyAttendanceData({
    required DateTime date,
    @Default(0.0) double percent,
  }) = _WeeklyAttendanceData;

  factory WeeklyAttendanceData.fromJson(Map<String, dynamic> json) =>
      _$WeeklyAttendanceDataFromJson(json);
}
