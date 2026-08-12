// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Schedule _$ScheduleFromJson(Map<String, dynamic> json) => _Schedule(
      id: (json['id'] as num?)?.toInt() ?? 0,
      studentId: (json['studentId'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String? ?? '00:00',
      memorizationSurahId: (json['memorizationSurahId'] as num?)?.toInt(),
      memorizationFromAyah: (json['memorizationFromAyah'] as num?)?.toInt(),
      memorizationToAyah: (json['memorizationToAyah'] as num?)?.toInt(),
      revisionSurahId: (json['revisionSurahId'] as num?)?.toInt(),
      revisionFromAyah: (json['revisionFromAyah'] as num?)?.toInt(),
      revisionToAyah: (json['revisionToAyah'] as num?)?.toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ScheduleToJson(_Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'memorizationSurahId': instance.memorizationSurahId,
      'memorizationFromAyah': instance.memorizationFromAyah,
      'memorizationToAyah': instance.memorizationToAyah,
      'revisionSurahId': instance.revisionSurahId,
      'revisionFromAyah': instance.revisionFromAyah,
      'revisionToAyah': instance.revisionToAyah,
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
