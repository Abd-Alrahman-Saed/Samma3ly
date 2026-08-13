// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleException {
  int get id;
  int get groupScheduleSlotId;
  DateTime get occurrenceDate;

  /// 'إلغاء' أو 'إعادة جدولة' — راجع core/enums/schedule_exception_type.dart.
  String get exceptionType;
  DateTime? get newDate;
  String? get newTime;
  DateTime? get createdAt;

  /// Create a copy of ScheduleException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduleExceptionCopyWith<ScheduleException> get copyWith =>
      _$ScheduleExceptionCopyWithImpl<ScheduleException>(
          this as ScheduleException, _$identity);

  /// Serializes this ScheduleException to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduleException &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupScheduleSlotId, groupScheduleSlotId) ||
                other.groupScheduleSlotId == groupScheduleSlotId) &&
            (identical(other.occurrenceDate, occurrenceDate) ||
                other.occurrenceDate == occurrenceDate) &&
            (identical(other.exceptionType, exceptionType) ||
                other.exceptionType == exceptionType) &&
            (identical(other.newDate, newDate) || other.newDate == newDate) &&
            (identical(other.newTime, newTime) || other.newTime == newTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, groupScheduleSlotId,
      occurrenceDate, exceptionType, newDate, newTime, createdAt);

  @override
  String toString() {
    return 'ScheduleException(id: $id, groupScheduleSlotId: $groupScheduleSlotId, occurrenceDate: $occurrenceDate, exceptionType: $exceptionType, newDate: $newDate, newTime: $newTime, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ScheduleExceptionCopyWith<$Res> {
  factory $ScheduleExceptionCopyWith(
          ScheduleException value, $Res Function(ScheduleException) _then) =
      _$ScheduleExceptionCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int groupScheduleSlotId,
      DateTime occurrenceDate,
      String exceptionType,
      DateTime? newDate,
      String? newTime,
      DateTime? createdAt});
}

/// @nodoc
class _$ScheduleExceptionCopyWithImpl<$Res>
    implements $ScheduleExceptionCopyWith<$Res> {
  _$ScheduleExceptionCopyWithImpl(this._self, this._then);

  final ScheduleException _self;
  final $Res Function(ScheduleException) _then;

  /// Create a copy of ScheduleException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupScheduleSlotId = null,
    Object? occurrenceDate = null,
    Object? exceptionType = null,
    Object? newDate = freezed,
    Object? newTime = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      groupScheduleSlotId: null == groupScheduleSlotId
          ? _self.groupScheduleSlotId
          : groupScheduleSlotId // ignore: cast_nullable_to_non_nullable
              as int,
      occurrenceDate: null == occurrenceDate
          ? _self.occurrenceDate
          : occurrenceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      exceptionType: null == exceptionType
          ? _self.exceptionType
          : exceptionType // ignore: cast_nullable_to_non_nullable
              as String,
      newDate: freezed == newDate
          ? _self.newDate
          : newDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      newTime: freezed == newTime
          ? _self.newTime
          : newTime // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ScheduleException].
extension ScheduleExceptionPatterns on ScheduleException {
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
    TResult Function(_ScheduleException value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScheduleException() when $default != null:
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
    TResult Function(_ScheduleException value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleException():
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
    TResult? Function(_ScheduleException value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleException() when $default != null:
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
            int groupScheduleSlotId,
            DateTime occurrenceDate,
            String exceptionType,
            DateTime? newDate,
            String? newTime,
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScheduleException() when $default != null:
        return $default(
            _that.id,
            _that.groupScheduleSlotId,
            _that.occurrenceDate,
            _that.exceptionType,
            _that.newDate,
            _that.newTime,
            _that.createdAt);
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
            int groupScheduleSlotId,
            DateTime occurrenceDate,
            String exceptionType,
            DateTime? newDate,
            String? newTime,
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleException():
        return $default(
            _that.id,
            _that.groupScheduleSlotId,
            _that.occurrenceDate,
            _that.exceptionType,
            _that.newDate,
            _that.newTime,
            _that.createdAt);
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
            int groupScheduleSlotId,
            DateTime occurrenceDate,
            String exceptionType,
            DateTime? newDate,
            String? newTime,
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleException() when $default != null:
        return $default(
            _that.id,
            _that.groupScheduleSlotId,
            _that.occurrenceDate,
            _that.exceptionType,
            _that.newDate,
            _that.newTime,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ScheduleException implements ScheduleException {
  const _ScheduleException(
      {this.id = 0,
      required this.groupScheduleSlotId,
      required this.occurrenceDate,
      this.exceptionType = 'إلغاء',
      this.newDate,
      this.newTime,
      this.createdAt});
  factory _ScheduleException.fromJson(Map<String, dynamic> json) =>
      _$ScheduleExceptionFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  final int groupScheduleSlotId;
  @override
  final DateTime occurrenceDate;

  /// 'إلغاء' أو 'إعادة جدولة' — راجع core/enums/schedule_exception_type.dart.
  @override
  @JsonKey()
  final String exceptionType;
  @override
  final DateTime? newDate;
  @override
  final String? newTime;
  @override
  final DateTime? createdAt;

  /// Create a copy of ScheduleException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScheduleExceptionCopyWith<_ScheduleException> get copyWith =>
      __$ScheduleExceptionCopyWithImpl<_ScheduleException>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ScheduleExceptionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScheduleException &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupScheduleSlotId, groupScheduleSlotId) ||
                other.groupScheduleSlotId == groupScheduleSlotId) &&
            (identical(other.occurrenceDate, occurrenceDate) ||
                other.occurrenceDate == occurrenceDate) &&
            (identical(other.exceptionType, exceptionType) ||
                other.exceptionType == exceptionType) &&
            (identical(other.newDate, newDate) || other.newDate == newDate) &&
            (identical(other.newTime, newTime) || other.newTime == newTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, groupScheduleSlotId,
      occurrenceDate, exceptionType, newDate, newTime, createdAt);

  @override
  String toString() {
    return 'ScheduleException(id: $id, groupScheduleSlotId: $groupScheduleSlotId, occurrenceDate: $occurrenceDate, exceptionType: $exceptionType, newDate: $newDate, newTime: $newTime, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ScheduleExceptionCopyWith<$Res>
    implements $ScheduleExceptionCopyWith<$Res> {
  factory _$ScheduleExceptionCopyWith(
          _ScheduleException value, $Res Function(_ScheduleException) _then) =
      __$ScheduleExceptionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int groupScheduleSlotId,
      DateTime occurrenceDate,
      String exceptionType,
      DateTime? newDate,
      String? newTime,
      DateTime? createdAt});
}

/// @nodoc
class __$ScheduleExceptionCopyWithImpl<$Res>
    implements _$ScheduleExceptionCopyWith<$Res> {
  __$ScheduleExceptionCopyWithImpl(this._self, this._then);

  final _ScheduleException _self;
  final $Res Function(_ScheduleException) _then;

  /// Create a copy of ScheduleException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? groupScheduleSlotId = null,
    Object? occurrenceDate = null,
    Object? exceptionType = null,
    Object? newDate = freezed,
    Object? newTime = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_ScheduleException(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      groupScheduleSlotId: null == groupScheduleSlotId
          ? _self.groupScheduleSlotId
          : groupScheduleSlotId // ignore: cast_nullable_to_non_nullable
              as int,
      occurrenceDate: null == occurrenceDate
          ? _self.occurrenceDate
          : occurrenceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      exceptionType: null == exceptionType
          ? _self.exceptionType
          : exceptionType // ignore: cast_nullable_to_non_nullable
              as String,
      newDate: freezed == newDate
          ? _self.newDate
          : newDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      newTime: freezed == newTime
          ? _self.newTime
          : newTime // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
