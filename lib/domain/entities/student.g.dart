// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Student _$StudentFromJson(Map<String, dynamic> json) => _Student(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fullName: json['fullName'] as String,
      age: (json['age'] as num).toInt(),
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      parentName: json['parentName'] as String?,
      parentPhone: json['parentPhone'] as String?,
      currentSurahId: (json['currentSurahId'] as num?)?.toInt(),
      lastCompletedSurahId: (json['lastCompletedSurahId'] as num?)?.toInt(),
      totalCompletedJuz: (json['totalCompletedJuz'] as num?)?.toInt() ?? 0,
      level: json['level'] as String? ?? 'مبتدئ',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$StudentToJson(_Student instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'age': instance.age,
      'phone': instance.phone,
      'address': instance.address,
      'parentName': instance.parentName,
      'parentPhone': instance.parentPhone,
      'currentSurahId': instance.currentSurahId,
      'lastCompletedSurahId': instance.lastCompletedSurahId,
      'totalCompletedJuz': instance.totalCompletedJuz,
      'level': instance.level,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
