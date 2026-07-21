// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'juz_surah_range.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JuzSurahRange _$JuzSurahRangeFromJson(Map<String, dynamic> json) {
  return _JuzSurahRange.fromJson(json);
}

/// @nodoc
mixin _$JuzSurahRange {
  int get id => throw _privateConstructorUsedError;
  int get juzNumber => throw _privateConstructorUsedError;
  int get surahId => throw _privateConstructorUsedError;
  int get fromAyah => throw _privateConstructorUsedError;
  int get toAyah => throw _privateConstructorUsedError;

  /// Serializes this JuzSurahRange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JuzSurahRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JuzSurahRangeCopyWith<JuzSurahRange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JuzSurahRangeCopyWith<$Res> {
  factory $JuzSurahRangeCopyWith(
          JuzSurahRange value, $Res Function(JuzSurahRange) then) =
      _$JuzSurahRangeCopyWithImpl<$Res, JuzSurahRange>;
  @useResult
  $Res call({int id, int juzNumber, int surahId, int fromAyah, int toAyah});
}

/// @nodoc
class _$JuzSurahRangeCopyWithImpl<$Res, $Val extends JuzSurahRange>
    implements $JuzSurahRangeCopyWith<$Res> {
  _$JuzSurahRangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JuzSurahRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? juzNumber = null,
    Object? surahId = null,
    Object? fromAyah = null,
    Object? toAyah = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      juzNumber: null == juzNumber
          ? _value.juzNumber
          : juzNumber // ignore: cast_nullable_to_non_nullable
              as int,
      surahId: null == surahId
          ? _value.surahId
          : surahId // ignore: cast_nullable_to_non_nullable
              as int,
      fromAyah: null == fromAyah
          ? _value.fromAyah
          : fromAyah // ignore: cast_nullable_to_non_nullable
              as int,
      toAyah: null == toAyah
          ? _value.toAyah
          : toAyah // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JuzSurahRangeImplCopyWith<$Res>
    implements $JuzSurahRangeCopyWith<$Res> {
  factory _$$JuzSurahRangeImplCopyWith(
          _$JuzSurahRangeImpl value, $Res Function(_$JuzSurahRangeImpl) then) =
      __$$JuzSurahRangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int juzNumber, int surahId, int fromAyah, int toAyah});
}

/// @nodoc
class __$$JuzSurahRangeImplCopyWithImpl<$Res>
    extends _$JuzSurahRangeCopyWithImpl<$Res, _$JuzSurahRangeImpl>
    implements _$$JuzSurahRangeImplCopyWith<$Res> {
  __$$JuzSurahRangeImplCopyWithImpl(
      _$JuzSurahRangeImpl _value, $Res Function(_$JuzSurahRangeImpl) _then)
      : super(_value, _then);

  /// Create a copy of JuzSurahRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? juzNumber = null,
    Object? surahId = null,
    Object? fromAyah = null,
    Object? toAyah = null,
  }) {
    return _then(_$JuzSurahRangeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      juzNumber: null == juzNumber
          ? _value.juzNumber
          : juzNumber // ignore: cast_nullable_to_non_nullable
              as int,
      surahId: null == surahId
          ? _value.surahId
          : surahId // ignore: cast_nullable_to_non_nullable
              as int,
      fromAyah: null == fromAyah
          ? _value.fromAyah
          : fromAyah // ignore: cast_nullable_to_non_nullable
              as int,
      toAyah: null == toAyah
          ? _value.toAyah
          : toAyah // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JuzSurahRangeImpl implements _JuzSurahRange {
  const _$JuzSurahRangeImpl(
      {this.id = 0,
      required this.juzNumber,
      required this.surahId,
      required this.fromAyah,
      required this.toAyah});

  factory _$JuzSurahRangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$JuzSurahRangeImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  final int juzNumber;
  @override
  final int surahId;
  @override
  final int fromAyah;
  @override
  final int toAyah;

  @override
  String toString() {
    return 'JuzSurahRange(id: $id, juzNumber: $juzNumber, surahId: $surahId, fromAyah: $fromAyah, toAyah: $toAyah)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JuzSurahRangeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.juzNumber, juzNumber) ||
                other.juzNumber == juzNumber) &&
            (identical(other.surahId, surahId) || other.surahId == surahId) &&
            (identical(other.fromAyah, fromAyah) ||
                other.fromAyah == fromAyah) &&
            (identical(other.toAyah, toAyah) || other.toAyah == toAyah));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, juzNumber, surahId, fromAyah, toAyah);

  /// Create a copy of JuzSurahRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JuzSurahRangeImplCopyWith<_$JuzSurahRangeImpl> get copyWith =>
      __$$JuzSurahRangeImplCopyWithImpl<_$JuzSurahRangeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JuzSurahRangeImplToJson(
      this,
    );
  }
}

abstract class _JuzSurahRange implements JuzSurahRange {
  const factory _JuzSurahRange(
      {final int id,
      required final int juzNumber,
      required final int surahId,
      required final int fromAyah,
      required final int toAyah}) = _$JuzSurahRangeImpl;

  factory _JuzSurahRange.fromJson(Map<String, dynamic> json) =
      _$JuzSurahRangeImpl.fromJson;

  @override
  int get id;
  @override
  int get juzNumber;
  @override
  int get surahId;
  @override
  int get fromAyah;
  @override
  int get toAyah;

  /// Create a copy of JuzSurahRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JuzSurahRangeImplCopyWith<_$JuzSurahRangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
