// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz_surah_range.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JuzSurahRangeImpl _$$JuzSurahRangeImplFromJson(Map<String, dynamic> json) =>
    _$JuzSurahRangeImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      juzNumber: (json['juzNumber'] as num).toInt(),
      surahId: (json['surahId'] as num).toInt(),
      fromAyah: (json['fromAyah'] as num).toInt(),
      toAyah: (json['toAyah'] as num).toInt(),
    );

Map<String, dynamic> _$$JuzSurahRangeImplToJson(_$JuzSurahRangeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'juzNumber': instance.juzNumber,
      'surahId': instance.surahId,
      'fromAyah': instance.fromAyah,
      'toAyah': instance.toAyah,
    };
