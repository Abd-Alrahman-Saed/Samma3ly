// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SurahImpl _$$SurahImplFromJson(Map<String, dynamic> json) => _$SurahImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      number: (json['number'] as num).toInt(),
      name: json['name'] as String,
      ayahCount: (json['ayahCount'] as num).toInt(),
    );

Map<String, dynamic> _$$SurahImplToJson(_$SurahImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'name': instance.name,
      'ayahCount': instance.ayahCount,
    };
