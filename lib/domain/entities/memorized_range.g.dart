// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memorized_range.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemorizedRangeImpl _$$MemorizedRangeImplFromJson(Map<String, dynamic> json) =>
    _$MemorizedRangeImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      studentId: (json['studentId'] as num).toInt(),
      surahId: (json['surahId'] as num).toInt(),
      fromAyah: (json['fromAyah'] as num).toInt(),
      toAyah: (json['toAyah'] as num).toInt(),
      status: json['status'] as String? ?? 'محفوظ',
      revisionCycleDays: (json['revisionCycleDays'] as num?)?.toInt() ?? 7,
      lastRevisedAt: json['lastRevisedAt'] == null
          ? null
          : DateTime.parse(json['lastRevisedAt'] as String),
      nextReviewDate: json['nextReviewDate'] == null
          ? null
          : DateTime.parse(json['nextReviewDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MemorizedRangeImplToJson(
        _$MemorizedRangeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'surahId': instance.surahId,
      'fromAyah': instance.fromAyah,
      'toAyah': instance.toAyah,
      'status': instance.status,
      'revisionCycleDays': instance.revisionCycleDays,
      'lastRevisedAt': instance.lastRevisedAt?.toIso8601String(),
      'nextReviewDate': instance.nextReviewDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
