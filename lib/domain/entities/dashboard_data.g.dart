// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    _DashboardData(
      totalStudents: (json['totalStudents'] as num?)?.toInt() ?? 0,
      todaySessions: (json['todaySessions'] as num?)?.toInt() ?? 0,
      upcomingSessions: (json['upcomingSessions'] as num?)?.toInt() ?? 0,
      averageAttendance: (json['averageAttendance'] as num?)?.toDouble() ?? 0.0,
      totalPagesMemorized: (json['totalPagesMemorized'] as num?)?.toInt() ?? 0,
      totalSurahsCompleted:
          (json['totalSurahsCompleted'] as num?)?.toInt() ?? 0,
      totalSessionsEver: (json['totalSessionsEver'] as num?)?.toInt() ?? 0,
      totalTeachers: (json['totalTeachers'] as num?)?.toInt() ?? 0,
      topStudents: (json['topStudents'] as List<dynamic>?)
              ?.map((e) =>
                  DashboardTopStudent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DashboardTopStudent>[],
      weeklyAttendance: (json['weeklyAttendance'] as List<dynamic>?)
              ?.map((e) =>
                  WeeklyAttendanceData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WeeklyAttendanceData>[],
    );

Map<String, dynamic> _$DashboardDataToJson(_DashboardData instance) =>
    <String, dynamic>{
      'totalStudents': instance.totalStudents,
      'todaySessions': instance.todaySessions,
      'upcomingSessions': instance.upcomingSessions,
      'averageAttendance': instance.averageAttendance,
      'totalPagesMemorized': instance.totalPagesMemorized,
      'totalSurahsCompleted': instance.totalSurahsCompleted,
      'totalSessionsEver': instance.totalSessionsEver,
      'totalTeachers': instance.totalTeachers,
      'topStudents': instance.topStudents,
      'weeklyAttendance': instance.weeklyAttendance,
    };

_DashboardTopStudent _$DashboardTopStudentFromJson(Map<String, dynamic> json) =>
    _DashboardTopStudent(
      studentId: (json['studentId'] as num).toInt(),
      studentName: json['studentName'] as String,
      averageScore: (json['averageScore'] as num).toDouble(),
    );

Map<String, dynamic> _$DashboardTopStudentToJson(
        _DashboardTopStudent instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'averageScore': instance.averageScore,
    };

_WeeklyAttendanceData _$WeeklyAttendanceDataFromJson(
        Map<String, dynamic> json) =>
    _WeeklyAttendanceData(
      date: DateTime.parse(json['date'] as String),
      percent: (json['percent'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$WeeklyAttendanceDataToJson(
        _WeeklyAttendanceData instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'percent': instance.percent,
    };
