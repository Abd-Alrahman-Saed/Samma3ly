// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      studentId: (json['studentId'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String? ?? '00:00',
      attendanceStatus: json['attendanceStatus'] as String? ?? 'حاضر',
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      memorization: json['memorization'] == null
          ? null
          : SessionMemorization.fromJson(
              json['memorization'] as Map<String, dynamic>),
      revision: json['revision'] == null
          ? null
          : SessionRevision.fromJson(json['revision'] as Map<String, dynamic>),
      evaluation: json['evaluation'] == null
          ? null
          : SessionEvaluation.fromJson(
              json['evaluation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'attendanceStatus': instance.attendanceStatus,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'memorization': instance.memorization,
      'revision': instance.revision,
      'evaluation': instance.evaluation,
    };

_$SessionMemorizationImpl _$$SessionMemorizationImplFromJson(
        Map<String, dynamic> json) =>
    _$SessionMemorizationImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      sessionId: (json['sessionId'] as num?)?.toInt() ?? 0,
      surahId: (json['surahId'] as num).toInt(),
      fromAyah: (json['fromAyah'] as num?)?.toInt() ?? 1,
      toAyah: (json['toAyah'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$SessionMemorizationImplToJson(
        _$SessionMemorizationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'surahId': instance.surahId,
      'fromAyah': instance.fromAyah,
      'toAyah': instance.toAyah,
    };

_$SessionRevisionImpl _$$SessionRevisionImplFromJson(
        Map<String, dynamic> json) =>
    _$SessionRevisionImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      sessionId: (json['sessionId'] as num?)?.toInt() ?? 0,
      surahId: (json['surahId'] as num).toInt(),
      fromAyah: (json['fromAyah'] as num?)?.toInt() ?? 1,
      toAyah: (json['toAyah'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$SessionRevisionImplToJson(
        _$SessionRevisionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'surahId': instance.surahId,
      'fromAyah': instance.fromAyah,
      'toAyah': instance.toAyah,
    };

_$SessionEvaluationImpl _$$SessionEvaluationImplFromJson(
        Map<String, dynamic> json) =>
    _$SessionEvaluationImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      sessionId: (json['sessionId'] as num?)?.toInt() ?? 0,
      memorizationScore: (json['memorizationScore'] as num?)?.toDouble() ?? 0.0,
      tajweedScore: (json['tajweedScore'] as num?)?.toDouble() ?? 0.0,
      fluencyScore: (json['fluencyScore'] as num?)?.toDouble() ?? 0.0,
      accuracyScore: (json['accuracyScore'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$SessionEvaluationImplToJson(
        _$SessionEvaluationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'memorizationScore': instance.memorizationScore,
      'tajweedScore': instance.tajweedScore,
      'fluencyScore': instance.fluencyScore,
      'accuracyScore': instance.accuracyScore,
    };
