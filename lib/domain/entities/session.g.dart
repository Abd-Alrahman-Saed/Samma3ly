// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
      id: (json['id'] as num?)?.toInt() ?? 0,
      studentId: (json['studentId'] as num?)?.toInt(),
      groupId: (json['groupId'] as num?)?.toInt(),
      sessionType: json['sessionType'] as String? ?? 'فردي',
      occurrenceDate: json['occurrenceDate'] == null
          ? null
          : DateTime.parse(json['occurrenceDate'] as String),
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String? ?? '00:00',
      attendanceStatus: json['attendanceStatus'] as String? ?? 'حاضر',
      notes: json['notes'] as String?,
      recitationOutcome: json['recitationOutcome'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      memorization: json['memorization'] == null
          ? null
          : SessionMemorization.fromJson(
              json['memorization'] as Map<String, dynamic>),
      revisions: (json['revisions'] as List<dynamic>?)
              ?.map((e) => SessionRevision.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SessionRevision>[],
      evaluation: json['evaluation'] == null
          ? null
          : SessionEvaluation.fromJson(
              json['evaluation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'groupId': instance.groupId,
      'sessionType': instance.sessionType,
      'occurrenceDate': instance.occurrenceDate?.toIso8601String(),
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'attendanceStatus': instance.attendanceStatus,
      'notes': instance.notes,
      'recitationOutcome': instance.recitationOutcome,
      'createdAt': instance.createdAt?.toIso8601String(),
      'memorization': instance.memorization,
      'revisions': instance.revisions,
      'evaluation': instance.evaluation,
    };

_SessionMemorization _$SessionMemorizationFromJson(Map<String, dynamic> json) =>
    _SessionMemorization(
      id: (json['id'] as num?)?.toInt() ?? 0,
      sessionId: (json['sessionId'] as num?)?.toInt() ?? 0,
      surahId: (json['surahId'] as num).toInt(),
      fromAyah: (json['fromAyah'] as num?)?.toInt() ?? 1,
      toAyah: (json['toAyah'] as num?)?.toInt() ?? 1,
      isFullSurah: json['isFullSurah'] as bool? ?? false,
    );

Map<String, dynamic> _$SessionMemorizationToJson(
        _SessionMemorization instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'surahId': instance.surahId,
      'fromAyah': instance.fromAyah,
      'toAyah': instance.toAyah,
      'isFullSurah': instance.isFullSurah,
    };

_SessionRevision _$SessionRevisionFromJson(Map<String, dynamic> json) =>
    _SessionRevision(
      id: (json['id'] as num?)?.toInt() ?? 0,
      sessionId: (json['sessionId'] as num?)?.toInt() ?? 0,
      surahId: (json['surahId'] as num).toInt(),
      fromAyah: (json['fromAyah'] as num?)?.toInt() ?? 1,
      toAyah: (json['toAyah'] as num?)?.toInt() ?? 1,
      label: json['label'] as String? ?? 'مراجعة',
      isFullSurah: json['isFullSurah'] as bool? ?? false,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      memorizationScore: (json['memorizationScore'] as num?)?.toDouble() ?? 0.0,
      tajweedScore: (json['tajweedScore'] as num?)?.toDouble() ?? 0.0,
      fluencyScore: (json['fluencyScore'] as num?)?.toDouble() ?? 0.0,
      accuracyScore: (json['accuracyScore'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$SessionRevisionToJson(_SessionRevision instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'surahId': instance.surahId,
      'fromAyah': instance.fromAyah,
      'toAyah': instance.toAyah,
      'label': instance.label,
      'isFullSurah': instance.isFullSurah,
      'sortOrder': instance.sortOrder,
      'memorizationScore': instance.memorizationScore,
      'tajweedScore': instance.tajweedScore,
      'fluencyScore': instance.fluencyScore,
      'accuracyScore': instance.accuracyScore,
    };

_SessionEvaluation _$SessionEvaluationFromJson(Map<String, dynamic> json) =>
    _SessionEvaluation(
      id: (json['id'] as num?)?.toInt() ?? 0,
      sessionId: (json['sessionId'] as num?)?.toInt() ?? 0,
      memorizationScore: (json['memorizationScore'] as num?)?.toDouble() ?? 0.0,
      tajweedScore: (json['tajweedScore'] as num?)?.toDouble() ?? 0.0,
      fluencyScore: (json['fluencyScore'] as num?)?.toDouble() ?? 0.0,
      accuracyScore: (json['accuracyScore'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$SessionEvaluationToJson(_SessionEvaluation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'memorizationScore': instance.memorizationScore,
      'tajweedScore': instance.tajweedScore,
      'fluencyScore': instance.fluencyScore,
      'accuracyScore': instance.accuracyScore,
    };
