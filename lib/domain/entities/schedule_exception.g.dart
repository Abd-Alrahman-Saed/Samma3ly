// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleException _$ScheduleExceptionFromJson(Map<String, dynamic> json) =>
    _ScheduleException(
      id: (json['id'] as num?)?.toInt() ?? 0,
      groupScheduleSlotId: (json['groupScheduleSlotId'] as num).toInt(),
      occurrenceDate: DateTime.parse(json['occurrenceDate'] as String),
      exceptionType: json['exceptionType'] as String? ?? 'إلغاء',
      newDate: json['newDate'] == null
          ? null
          : DateTime.parse(json['newDate'] as String),
      newTime: json['newTime'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ScheduleExceptionToJson(_ScheduleException instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupScheduleSlotId': instance.groupScheduleSlotId,
      'occurrenceDate': instance.occurrenceDate.toIso8601String(),
      'exceptionType': instance.exceptionType,
      'newDate': instance.newDate?.toIso8601String(),
      'newTime': instance.newTime,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
