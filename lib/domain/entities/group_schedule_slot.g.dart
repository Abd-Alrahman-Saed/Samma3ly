// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_schedule_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupScheduleSlot _$GroupScheduleSlotFromJson(Map<String, dynamic> json) =>
    _GroupScheduleSlot(
      id: (json['id'] as num?)?.toInt() ?? 0,
      groupId: (json['groupId'] as num).toInt(),
      weekday: (json['weekday'] as num).toInt(),
      fixedTime: json['fixedTime'] as String?,
      effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
      effectiveTo: json['effectiveTo'] == null
          ? null
          : DateTime.parse(json['effectiveTo'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GroupScheduleSlotToJson(_GroupScheduleSlot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'weekday': instance.weekday,
      'fixedTime': instance.fixedTime,
      'effectiveFrom': instance.effectiveFrom.toIso8601String(),
      'effectiveTo': instance.effectiveTo?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
