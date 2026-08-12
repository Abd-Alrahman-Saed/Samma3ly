// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Schedule {
  int get id;
  int get studentId;
  DateTime get date;
  String get time;
  int? get memorizationSurahId;
  int? get memorizationFromAyah;
  int? get memorizationToAyah;
  int? get revisionSurahId;
  int? get revisionFromAyah;
  int? get revisionToAyah;
  bool get isCompleted;
  DateTime? get createdAt;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduleCopyWith<Schedule> get copyWith =>
      _$ScheduleCopyWithImpl<Schedule>(this as Schedule, _$identity);

  /// Serializes this Schedule to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Schedule &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.memorizationSurahId, memorizationSurahId) ||
                other.memorizationSurahId == memorizationSurahId) &&
            (identical(other.memorizationFromAyah, memorizationFromAyah) ||
                other.memorizationFromAyah == memorizationFromAyah) &&
            (identical(other.memorizationToAyah, memorizationToAyah) ||
                other.memorizationToAyah == memorizationToAyah) &&
            (identical(other.revisionSurahId, revisionSurahId) ||
                other.revisionSurahId == revisionSurahId) &&
            (identical(other.revisionFromAyah, revisionFromAyah) ||
                other.revisionFromAyah == revisionFromAyah) &&
            (identical(other.revisionToAyah, revisionToAyah) ||
                other.revisionToAyah == revisionToAyah) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      date,
      time,
      memorizationSurahId,
      memorizationFromAyah,
      memorizationToAyah,
      revisionSurahId,
      revisionFromAyah,
      revisionToAyah,
      isCompleted,
      createdAt);

  @override
  String toString() {
    return 'Schedule(id: $id, studentId: $studentId, date: $date, time: $time, memorizationSurahId: $memorizationSurahId, memorizationFromAyah: $memorizationFromAyah, memorizationToAyah: $memorizationToAyah, revisionSurahId: $revisionSurahId, revisionFromAyah: $revisionFromAyah, revisionToAyah: $revisionToAyah, isCompleted: $isCompleted, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ScheduleCopyWith<$Res> {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) _then) =
      _$ScheduleCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int studentId,
      DateTime date,
      String time,
      int? memorizationSurahId,
      int? memorizationFromAyah,
      int? memorizationToAyah,
      int? revisionSurahId,
      int? revisionFromAyah,
      int? revisionToAyah,
      bool isCompleted,
      DateTime? createdAt});
}

/// @nodoc
class _$ScheduleCopyWithImpl<$Res> implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._self, this._then);

  final Schedule _self;
  final $Res Function(Schedule) _then;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? date = null,
    Object? time = null,
    Object? memorizationSurahId = freezed,
    Object? memorizationFromAyah = freezed,
    Object? memorizationToAyah = freezed,
    Object? revisionSurahId = freezed,
    Object? revisionFromAyah = freezed,
    Object? revisionToAyah = freezed,
    Object? isCompleted = null,
    Object? createdAt = freezed,
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
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      memorizationSurahId: freezed == memorizationSurahId
          ? _self.memorizationSurahId
          : memorizationSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      memorizationFromAyah: freezed == memorizationFromAyah
          ? _self.memorizationFromAyah
          : memorizationFromAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      memorizationToAyah: freezed == memorizationToAyah
          ? _self.memorizationToAyah
          : memorizationToAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      revisionSurahId: freezed == revisionSurahId
          ? _self.revisionSurahId
          : revisionSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      revisionFromAyah: freezed == revisionFromAyah
          ? _self.revisionFromAyah
          : revisionFromAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      revisionToAyah: freezed == revisionToAyah
          ? _self.revisionToAyah
          : revisionToAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      isCompleted: null == isCompleted
          ? _self.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Schedule].
extension SchedulePatterns on Schedule {
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
    TResult Function(_Schedule value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Schedule() when $default != null:
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
    TResult Function(_Schedule value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Schedule():
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
    TResult? Function(_Schedule value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Schedule() when $default != null:
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
            DateTime date,
            String time,
            int? memorizationSurahId,
            int? memorizationFromAyah,
            int? memorizationToAyah,
            int? revisionSurahId,
            int? revisionFromAyah,
            int? revisionToAyah,
            bool isCompleted,
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Schedule() when $default != null:
        return $default(
            _that.id,
            _that.studentId,
            _that.date,
            _that.time,
            _that.memorizationSurahId,
            _that.memorizationFromAyah,
            _that.memorizationToAyah,
            _that.revisionSurahId,
            _that.revisionFromAyah,
            _that.revisionToAyah,
            _that.isCompleted,
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
            int studentId,
            DateTime date,
            String time,
            int? memorizationSurahId,
            int? memorizationFromAyah,
            int? memorizationToAyah,
            int? revisionSurahId,
            int? revisionFromAyah,
            int? revisionToAyah,
            bool isCompleted,
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Schedule():
        return $default(
            _that.id,
            _that.studentId,
            _that.date,
            _that.time,
            _that.memorizationSurahId,
            _that.memorizationFromAyah,
            _that.memorizationToAyah,
            _that.revisionSurahId,
            _that.revisionFromAyah,
            _that.revisionToAyah,
            _that.isCompleted,
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
            int studentId,
            DateTime date,
            String time,
            int? memorizationSurahId,
            int? memorizationFromAyah,
            int? memorizationToAyah,
            int? revisionSurahId,
            int? revisionFromAyah,
            int? revisionToAyah,
            bool isCompleted,
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Schedule() when $default != null:
        return $default(
            _that.id,
            _that.studentId,
            _that.date,
            _that.time,
            _that.memorizationSurahId,
            _that.memorizationFromAyah,
            _that.memorizationToAyah,
            _that.revisionSurahId,
            _that.revisionFromAyah,
            _that.revisionToAyah,
            _that.isCompleted,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Schedule implements Schedule {
  const _Schedule(
      {this.id = 0,
      required this.studentId,
      required this.date,
      this.time = '00:00',
      this.memorizationSurahId,
      this.memorizationFromAyah,
      this.memorizationToAyah,
      this.revisionSurahId,
      this.revisionFromAyah,
      this.revisionToAyah,
      this.isCompleted = false,
      this.createdAt});
  factory _Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  final int studentId;
  @override
  final DateTime date;
  @override
  @JsonKey()
  final String time;
  @override
  final int? memorizationSurahId;
  @override
  final int? memorizationFromAyah;
  @override
  final int? memorizationToAyah;
  @override
  final int? revisionSurahId;
  @override
  final int? revisionFromAyah;
  @override
  final int? revisionToAyah;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final DateTime? createdAt;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScheduleCopyWith<_Schedule> get copyWith =>
      __$ScheduleCopyWithImpl<_Schedule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ScheduleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Schedule &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.memorizationSurahId, memorizationSurahId) ||
                other.memorizationSurahId == memorizationSurahId) &&
            (identical(other.memorizationFromAyah, memorizationFromAyah) ||
                other.memorizationFromAyah == memorizationFromAyah) &&
            (identical(other.memorizationToAyah, memorizationToAyah) ||
                other.memorizationToAyah == memorizationToAyah) &&
            (identical(other.revisionSurahId, revisionSurahId) ||
                other.revisionSurahId == revisionSurahId) &&
            (identical(other.revisionFromAyah, revisionFromAyah) ||
                other.revisionFromAyah == revisionFromAyah) &&
            (identical(other.revisionToAyah, revisionToAyah) ||
                other.revisionToAyah == revisionToAyah) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      date,
      time,
      memorizationSurahId,
      memorizationFromAyah,
      memorizationToAyah,
      revisionSurahId,
      revisionFromAyah,
      revisionToAyah,
      isCompleted,
      createdAt);

  @override
  String toString() {
    return 'Schedule(id: $id, studentId: $studentId, date: $date, time: $time, memorizationSurahId: $memorizationSurahId, memorizationFromAyah: $memorizationFromAyah, memorizationToAyah: $memorizationToAyah, revisionSurahId: $revisionSurahId, revisionFromAyah: $revisionFromAyah, revisionToAyah: $revisionToAyah, isCompleted: $isCompleted, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ScheduleCopyWith<$Res>
    implements $ScheduleCopyWith<$Res> {
  factory _$ScheduleCopyWith(_Schedule value, $Res Function(_Schedule) _then) =
      __$ScheduleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int studentId,
      DateTime date,
      String time,
      int? memorizationSurahId,
      int? memorizationFromAyah,
      int? memorizationToAyah,
      int? revisionSurahId,
      int? revisionFromAyah,
      int? revisionToAyah,
      bool isCompleted,
      DateTime? createdAt});
}

/// @nodoc
class __$ScheduleCopyWithImpl<$Res> implements _$ScheduleCopyWith<$Res> {
  __$ScheduleCopyWithImpl(this._self, this._then);

  final _Schedule _self;
  final $Res Function(_Schedule) _then;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? date = null,
    Object? time = null,
    Object? memorizationSurahId = freezed,
    Object? memorizationFromAyah = freezed,
    Object? memorizationToAyah = freezed,
    Object? revisionSurahId = freezed,
    Object? revisionFromAyah = freezed,
    Object? revisionToAyah = freezed,
    Object? isCompleted = null,
    Object? createdAt = freezed,
  }) {
    return _then(_Schedule(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      memorizationSurahId: freezed == memorizationSurahId
          ? _self.memorizationSurahId
          : memorizationSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      memorizationFromAyah: freezed == memorizationFromAyah
          ? _self.memorizationFromAyah
          : memorizationFromAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      memorizationToAyah: freezed == memorizationToAyah
          ? _self.memorizationToAyah
          : memorizationToAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      revisionSurahId: freezed == revisionSurahId
          ? _self.revisionSurahId
          : revisionSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      revisionFromAyah: freezed == revisionFromAyah
          ? _self.revisionFromAyah
          : revisionFromAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      revisionToAyah: freezed == revisionToAyah
          ? _self.revisionToAyah
          : revisionToAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      isCompleted: null == isCompleted
          ? _self.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
