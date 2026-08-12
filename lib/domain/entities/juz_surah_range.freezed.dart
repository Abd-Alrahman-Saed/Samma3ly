// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'juz_surah_range.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JuzSurahRange {
  int get id;
  int get juzNumber;
  int get surahId;
  int get fromAyah;
  int get toAyah;

  /// Create a copy of JuzSurahRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $JuzSurahRangeCopyWith<JuzSurahRange> get copyWith =>
      _$JuzSurahRangeCopyWithImpl<JuzSurahRange>(
          this as JuzSurahRange, _$identity);

  /// Serializes this JuzSurahRange to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is JuzSurahRange &&
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

  @override
  String toString() {
    return 'JuzSurahRange(id: $id, juzNumber: $juzNumber, surahId: $surahId, fromAyah: $fromAyah, toAyah: $toAyah)';
  }
}

/// @nodoc
abstract mixin class $JuzSurahRangeCopyWith<$Res> {
  factory $JuzSurahRangeCopyWith(
          JuzSurahRange value, $Res Function(JuzSurahRange) _then) =
      _$JuzSurahRangeCopyWithImpl;
  @useResult
  $Res call({int id, int juzNumber, int surahId, int fromAyah, int toAyah});
}

/// @nodoc
class _$JuzSurahRangeCopyWithImpl<$Res>
    implements $JuzSurahRangeCopyWith<$Res> {
  _$JuzSurahRangeCopyWithImpl(this._self, this._then);

  final JuzSurahRange _self;
  final $Res Function(JuzSurahRange) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      juzNumber: null == juzNumber
          ? _self.juzNumber
          : juzNumber // ignore: cast_nullable_to_non_nullable
              as int,
      surahId: null == surahId
          ? _self.surahId
          : surahId // ignore: cast_nullable_to_non_nullable
              as int,
      fromAyah: null == fromAyah
          ? _self.fromAyah
          : fromAyah // ignore: cast_nullable_to_non_nullable
              as int,
      toAyah: null == toAyah
          ? _self.toAyah
          : toAyah // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [JuzSurahRange].
extension JuzSurahRangePatterns on JuzSurahRange {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_JuzSurahRange value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _JuzSurahRange() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_JuzSurahRange value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JuzSurahRange():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_JuzSurahRange value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JuzSurahRange() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id, int juzNumber, int surahId, int fromAyah, int toAyah)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _JuzSurahRange() when $default != null:
        return $default(_that.id, _that.juzNumber, _that.surahId,
            _that.fromAyah, _that.toAyah);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id, int juzNumber, int surahId, int fromAyah, int toAyah)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JuzSurahRange():
        return $default(_that.id, _that.juzNumber, _that.surahId,
            _that.fromAyah, _that.toAyah);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id, int juzNumber, int surahId, int fromAyah, int toAyah)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JuzSurahRange() when $default != null:
        return $default(_that.id, _that.juzNumber, _that.surahId,
            _that.fromAyah, _that.toAyah);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _JuzSurahRange implements JuzSurahRange {
  const _JuzSurahRange(
      {this.id = 0,
      required this.juzNumber,
      required this.surahId,
      required this.fromAyah,
      required this.toAyah});
  factory _JuzSurahRange.fromJson(Map<String, dynamic> json) =>
      _$JuzSurahRangeFromJson(json);

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

  /// Create a copy of JuzSurahRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$JuzSurahRangeCopyWith<_JuzSurahRange> get copyWith =>
      __$JuzSurahRangeCopyWithImpl<_JuzSurahRange>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$JuzSurahRangeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _JuzSurahRange &&
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

  @override
  String toString() {
    return 'JuzSurahRange(id: $id, juzNumber: $juzNumber, surahId: $surahId, fromAyah: $fromAyah, toAyah: $toAyah)';
  }
}

/// @nodoc
abstract mixin class _$JuzSurahRangeCopyWith<$Res>
    implements $JuzSurahRangeCopyWith<$Res> {
  factory _$JuzSurahRangeCopyWith(
          _JuzSurahRange value, $Res Function(_JuzSurahRange) _then) =
      __$JuzSurahRangeCopyWithImpl;
  @override
  @useResult
  $Res call({int id, int juzNumber, int surahId, int fromAyah, int toAyah});
}

/// @nodoc
class __$JuzSurahRangeCopyWithImpl<$Res>
    implements _$JuzSurahRangeCopyWith<$Res> {
  __$JuzSurahRangeCopyWithImpl(this._self, this._then);

  final _JuzSurahRange _self;
  final $Res Function(_JuzSurahRange) _then;

  /// Create a copy of JuzSurahRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? juzNumber = null,
    Object? surahId = null,
    Object? fromAyah = null,
    Object? toAyah = null,
  }) {
    return _then(_JuzSurahRange(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      juzNumber: null == juzNumber
          ? _self.juzNumber
          : juzNumber // ignore: cast_nullable_to_non_nullable
              as int,
      surahId: null == surahId
          ? _self.surahId
          : surahId // ignore: cast_nullable_to_non_nullable
              as int,
      fromAyah: null == fromAyah
          ? _self.fromAyah
          : fromAyah // ignore: cast_nullable_to_non_nullable
              as int,
      toAyah: null == toAyah
          ? _self.toAyah
          : toAyah // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
