// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Surah _$SurahFromJson(Map<String, dynamic> json) => _Surah(
      id: (json['id'] as num?)?.toInt() ?? 0,
      number: (json['number'] as num).toInt(),
      name: json['name'] as String,
      ayahCount: (json['ayahCount'] as num).toInt(),
    );

Map<String, dynamic> _$SurahToJson(_Surah instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'name': instance.name,
      'ayahCount': instance.ayahCount,
    };
