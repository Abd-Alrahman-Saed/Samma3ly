import 'package:freezed_annotation/freezed_annotation.dart';

part 'surah.freezed.dart';
part 'surah.g.dart';

@freezed
class Surah with _$Surah {
  const factory Surah({
    @Default(0) int id,
    required int number,
    required String name,
    required int ayahCount,
  }) = _Surah;

  factory Surah.fromJson(Map<String, dynamic> json) => _$SurahFromJson(json);
}
