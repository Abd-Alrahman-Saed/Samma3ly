// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Goal _$GoalFromJson(Map<String, dynamic> json) => _Goal(
      id: (json['id'] as num?)?.toInt() ?? 0,
      studentId: (json['studentId'] as num).toInt(),
      title: json['title'] as String,
      goalType: json['goalType'] as String? ?? 'سورة',
      targetSurahId: (json['targetSurahId'] as num?)?.toInt(),
      targetJuzNumber: (json['targetJuzNumber'] as num?)?.toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      targetDate: json['targetDate'] == null
          ? null
          : DateTime.parse(json['targetDate'] as String),
      status: json['status'] as String? ?? 'لم يبدأ',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GoalToJson(_Goal instance) => <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'title': instance.title,
      'goalType': instance.goalType,
      'targetSurahId': instance.targetSurahId,
      'targetJuzNumber': instance.targetJuzNumber,
      'startDate': instance.startDate.toIso8601String(),
      'targetDate': instance.targetDate?.toIso8601String(),
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
