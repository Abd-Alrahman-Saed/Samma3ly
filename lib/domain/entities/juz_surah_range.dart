import 'package:freezed_annotation/freezed_annotation.dart';

part 'juz_surah_range.freezed.dart';
part 'juz_surah_range.g.dart';

@freezed
class JuzSurahRange with _$JuzSurahRange {
  const factory JuzSurahRange({
    @Default(0) int id,
    required int juzNumber,
    required int surahId,
    required int fromAyah,
    required int toAyah,
  }) = _JuzSurahRange;

  factory JuzSurahRange.fromJson(Map<String, dynamic> json) =>
      _$JuzSurahRangeFromJson(json);
}
