// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memorized_range.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemorizedRange {
  int get id;
  int get studentId;
  int get surahId;
  int get fromAyah;
  int get toAyah;
  String get status;
  int get revisionCycleDays;
  DateTime? get lastRevisedAt;
  DateTime? get nextReviewDate;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of MemorizedRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MemorizedRangeCopyWith<MemorizedRange> get copyWith =>
      _$MemorizedRangeCopyWithImpl<MemorizedRange>(
          this as MemorizedRange, _$identity);

  /// Serializes this MemorizedRange to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MemorizedRange &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.surahId, surahId) || other.surahId == surahId) &&
            (identical(other.fromAyah, fromAyah) ||
                other.fromAyah == fromAyah) &&
            (identical(other.toAyah, toAyah) || other.toAyah == toAyah) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.revisionCycleDays, revisionCycleDays) ||
                other.revisionCycleDays == revisionCycleDays) &&
            (identical(other.lastRevisedAt, lastRevisedAt) ||
                other.lastRevisedAt == lastRevisedAt) &&
            (identical(other.nextReviewDate, nextReviewDate) ||
                other.nextReviewDate == nextReviewDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      surahId,
      fromAyah,
      toAyah,
      status,
      revisionCycleDays,
      lastRevisedAt,
      nextReviewDate,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'MemorizedRange(id: $id, studentId: $studentId, surahId: $surahId, fromAyah: $fromAyah, toAyah: $toAyah, status: $status, revisionCycleDays: $revisionCycleDays, lastRevisedAt: $lastRevisedAt, nextReviewDate: $nextReviewDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $MemorizedRangeCopyWith<$Res> {
  factory $MemorizedRangeCopyWith(
          MemorizedRange value, $Res Function(MemorizedRange) _then) =
      _$MemorizedRangeCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int studentId,
      int surahId,
      int fromAyah,
      int toAyah,
      String status,
      int revisionCycleDays,
      DateTime? lastRevisedAt,
      DateTime? nextReviewDate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$MemorizedRangeCopyWithImpl<$Res>
    implements $MemorizedRangeCopyWith<$Res> {
  _$MemorizedRangeCopyWithImpl(this._self, this._then);

  final MemorizedRange _self;
  final $Res Function(MemorizedRange) _then;

  /// Create a copy of MemorizedRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? surahId = null,
    Object? fromAyah = null,
    Object? toAyah = null,
    Object? status = null,
    Object? revisionCycleDays = null,
    Object? lastRevisedAt = freezed,
    Object? nextReviewDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
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
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      revisionCycleDays: null == revisionCycleDays
          ? _self.revisionCycleDays
          : revisionCycleDays // ignore: cast_nullable_to_non_nullable
              as int,
      lastRevisedAt: freezed == lastRevisedAt
          ? _self.lastRevisedAt
          : lastRevisedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextReviewDate: freezed == nextReviewDate
          ? _self.nextReviewDate
          : nextReviewDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MemorizedRange].
extension MemorizedRangePatterns on MemorizedRange {
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
    TResult Function(_MemorizedRange value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MemorizedRange() when $default != null:
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
    TResult Function(_MemorizedRange value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemorizedRange():
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
    TResult? Function(_MemorizedRange value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemorizedRange() when $default != null:
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
            int id,
            int studentId,
            int surahId,
            int fromAyah,
            int toAyah,
            String status,
            int revisionCycleDays,
            DateTime? lastRevisedAt,
            DateTime? nextReviewDate,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MemorizedRange() when $default != null:
        return $default(
            _that.id,
            _that.studentId,
            _that.surahId,
            _that.fromAyah,
            _that.toAyah,
            _that.status,
            _that.revisionCycleDays,
            _that.lastRevisedAt,
            _that.nextReviewDate,
            _that.createdAt,
            _that.updatedAt);
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
            int id,
            int studentId,
            int surahId,
            int fromAyah,
            int toAyah,
            String status,
            int revisionCycleDays,
            DateTime? lastRevisedAt,
            DateTime? nextReviewDate,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemorizedRange():
        return $default(
            _that.id,
            _that.studentId,
            _that.surahId,
            _that.fromAyah,
            _that.toAyah,
            _that.status,
            _that.revisionCycleDays,
            _that.lastRevisedAt,
            _that.nextReviewDate,
            _that.createdAt,
            _that.updatedAt);
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
            int id,
            int studentId,
            int surahId,
            int fromAyah,
            int toAyah,
            String status,
            int revisionCycleDays,
            DateTime? lastRevisedAt,
            DateTime? nextReviewDate,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemorizedRange() when $default != null:
        return $default(
            _that.id,
            _that.studentId,
            _that.surahId,
            _that.fromAyah,
            _that.toAyah,
            _that.status,
            _that.revisionCycleDays,
            _that.lastRevisedAt,
            _that.nextReviewDate,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MemorizedRange implements MemorizedRange {
  const _MemorizedRange(
      {this.id = 0,
      required this.studentId,
      required this.surahId,
      required this.fromAyah,
      required this.toAyah,
      this.status = 'محفوظ',
      this.revisionCycleDays = 7,
      this.lastRevisedAt,
      this.nextReviewDate,
      this.createdAt,
      this.updatedAt});
  factory _MemorizedRange.fromJson(Map<String, dynamic> json) =>
      _$MemorizedRangeFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  final int studentId;
  @override
  final int surahId;
  @override
  final int fromAyah;
  @override
  final int toAyah;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final int revisionCycleDays;
  @override
  final DateTime? lastRevisedAt;
  @override
  final DateTime? nextReviewDate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of MemorizedRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MemorizedRangeCopyWith<_MemorizedRange> get copyWith =>
      __$MemorizedRangeCopyWithImpl<_MemorizedRange>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MemorizedRangeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MemorizedRange &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.surahId, surahId) || other.surahId == surahId) &&
            (identical(other.fromAyah, fromAyah) ||
                other.fromAyah == fromAyah) &&
            (identical(other.toAyah, toAyah) || other.toAyah == toAyah) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.revisionCycleDays, revisionCycleDays) ||
                other.revisionCycleDays == revisionCycleDays) &&
            (identical(other.lastRevisedAt, lastRevisedAt) ||
                other.lastRevisedAt == lastRevisedAt) &&
            (identical(other.nextReviewDate, nextReviewDate) ||
                other.nextReviewDate == nextReviewDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      surahId,
      fromAyah,
      toAyah,
      status,
      revisionCycleDays,
      lastRevisedAt,
      nextReviewDate,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'MemorizedRange(id: $id, studentId: $studentId, surahId: $surahId, fromAyah: $fromAyah, toAyah: $toAyah, status: $status, revisionCycleDays: $revisionCycleDays, lastRevisedAt: $lastRevisedAt, nextReviewDate: $nextReviewDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$MemorizedRangeCopyWith<$Res>
    implements $MemorizedRangeCopyWith<$Res> {
  factory _$MemorizedRangeCopyWith(
          _MemorizedRange value, $Res Function(_MemorizedRange) _then) =
      __$MemorizedRangeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int studentId,
      int surahId,
      int fromAyah,
      int toAyah,
      String status,
      int revisionCycleDays,
      DateTime? lastRevisedAt,
      DateTime? nextReviewDate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$MemorizedRangeCopyWithImpl<$Res>
    implements _$MemorizedRangeCopyWith<$Res> {
  __$MemorizedRangeCopyWithImpl(this._self, this._then);

  final _MemorizedRange _self;
  final $Res Function(_MemorizedRange) _then;

  /// Create a copy of MemorizedRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? surahId = null,
    Object? fromAyah = null,
    Object? toAyah = null,
    Object? status = null,
    Object? revisionCycleDays = null,
    Object? lastRevisedAt = freezed,
    Object? nextReviewDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_MemorizedRange(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
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
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      revisionCycleDays: null == revisionCycleDays
          ? _self.revisionCycleDays
          : revisionCycleDays // ignore: cast_nullable_to_non_nullable
              as int,
      lastRevisedAt: freezed == lastRevisedAt
          ? _self.lastRevisedAt
          : lastRevisedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextReviewDate: freezed == nextReviewDate
          ? _self.nextReviewDate
          : nextReviewDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
