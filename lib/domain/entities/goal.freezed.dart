// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Goal {
  int get id;
  int get studentId;
  String get title;
  String get goalType;
  int? get targetSurahId;
  int? get targetJuzNumber;
  DateTime get startDate;
  DateTime? get targetDate;
  String get status;
  DateTime? get createdAt;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalCopyWith<Goal> get copyWith =>
      _$GoalCopyWithImpl<Goal>(this as Goal, _$identity);

  /// Serializes this Goal to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Goal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.goalType, goalType) ||
                other.goalType == goalType) &&
            (identical(other.targetSurahId, targetSurahId) ||
                other.targetSurahId == targetSurahId) &&
            (identical(other.targetJuzNumber, targetJuzNumber) ||
                other.targetJuzNumber == targetJuzNumber) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, studentId, title, goalType,
      targetSurahId, targetJuzNumber, startDate, targetDate, status, createdAt);

  @override
  String toString() {
    return 'Goal(id: $id, studentId: $studentId, title: $title, goalType: $goalType, targetSurahId: $targetSurahId, targetJuzNumber: $targetJuzNumber, startDate: $startDate, targetDate: $targetDate, status: $status, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $GoalCopyWith<$Res> {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) _then) =
      _$GoalCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int studentId,
      String title,
      String goalType,
      int? targetSurahId,
      int? targetJuzNumber,
      DateTime startDate,
      DateTime? targetDate,
      String status,
      DateTime? createdAt});
}

/// @nodoc
class _$GoalCopyWithImpl<$Res> implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._self, this._then);

  final Goal _self;
  final $Res Function(Goal) _then;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? title = null,
    Object? goalType = null,
    Object? targetSurahId = freezed,
    Object? targetJuzNumber = freezed,
    Object? startDate = null,
    Object? targetDate = freezed,
    Object? status = null,
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
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      goalType: null == goalType
          ? _self.goalType
          : goalType // ignore: cast_nullable_to_non_nullable
              as String,
      targetSurahId: freezed == targetSurahId
          ? _self.targetSurahId
          : targetSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      targetJuzNumber: freezed == targetJuzNumber
          ? _self.targetJuzNumber
          : targetJuzNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      targetDate: freezed == targetDate
          ? _self.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Goal].
extension GoalPatterns on Goal {
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
    TResult Function(_Goal value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Goal() when $default != null:
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
    TResult Function(_Goal value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Goal():
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
    TResult? Function(_Goal value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Goal() when $default != null:
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
            String title,
            String goalType,
            int? targetSurahId,
            int? targetJuzNumber,
            DateTime startDate,
            DateTime? targetDate,
            String status,
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Goal() when $default != null:
        return $default(
            _that.id,
            _that.studentId,
            _that.title,
            _that.goalType,
            _that.targetSurahId,
            _that.targetJuzNumber,
            _that.startDate,
            _that.targetDate,
            _that.status,
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
            String title,
            String goalType,
            int? targetSurahId,
            int? targetJuzNumber,
            DateTime startDate,
            DateTime? targetDate,
            String status,
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Goal():
        return $default(
            _that.id,
            _that.studentId,
            _that.title,
            _that.goalType,
            _that.targetSurahId,
            _that.targetJuzNumber,
            _that.startDate,
            _that.targetDate,
            _that.status,
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
            String title,
            String goalType,
            int? targetSurahId,
            int? targetJuzNumber,
            DateTime startDate,
            DateTime? targetDate,
            String status,
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Goal() when $default != null:
        return $default(
            _that.id,
            _that.studentId,
            _that.title,
            _that.goalType,
            _that.targetSurahId,
            _that.targetJuzNumber,
            _that.startDate,
            _that.targetDate,
            _that.status,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Goal implements Goal {
  const _Goal(
      {this.id = 0,
      required this.studentId,
      required this.title,
      this.goalType = 'سورة',
      this.targetSurahId,
      this.targetJuzNumber,
      required this.startDate,
      this.targetDate,
      this.status = 'لم يبدأ',
      this.createdAt});
  factory _Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  final int studentId;
  @override
  final String title;
  @override
  @JsonKey()
  final String goalType;
  @override
  final int? targetSurahId;
  @override
  final int? targetJuzNumber;
  @override
  final DateTime startDate;
  @override
  final DateTime? targetDate;
  @override
  @JsonKey()
  final String status;
  @override
  final DateTime? createdAt;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoalCopyWith<_Goal> get copyWith =>
      __$GoalCopyWithImpl<_Goal>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GoalToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Goal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.goalType, goalType) ||
                other.goalType == goalType) &&
            (identical(other.targetSurahId, targetSurahId) ||
                other.targetSurahId == targetSurahId) &&
            (identical(other.targetJuzNumber, targetJuzNumber) ||
                other.targetJuzNumber == targetJuzNumber) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, studentId, title, goalType,
      targetSurahId, targetJuzNumber, startDate, targetDate, status, createdAt);

  @override
  String toString() {
    return 'Goal(id: $id, studentId: $studentId, title: $title, goalType: $goalType, targetSurahId: $targetSurahId, targetJuzNumber: $targetJuzNumber, startDate: $startDate, targetDate: $targetDate, status: $status, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$GoalCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$GoalCopyWith(_Goal value, $Res Function(_Goal) _then) =
      __$GoalCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int studentId,
      String title,
      String goalType,
      int? targetSurahId,
      int? targetJuzNumber,
      DateTime startDate,
      DateTime? targetDate,
      String status,
      DateTime? createdAt});
}

/// @nodoc
class __$GoalCopyWithImpl<$Res> implements _$GoalCopyWith<$Res> {
  __$GoalCopyWithImpl(this._self, this._then);

  final _Goal _self;
  final $Res Function(_Goal) _then;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? title = null,
    Object? goalType = null,
    Object? targetSurahId = freezed,
    Object? targetJuzNumber = freezed,
    Object? startDate = null,
    Object? targetDate = freezed,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(_Goal(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      goalType: null == goalType
          ? _self.goalType
          : goalType // ignore: cast_nullable_to_non_nullable
              as String,
      targetSurahId: freezed == targetSurahId
          ? _self.targetSurahId
          : targetSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      targetJuzNumber: freezed == targetJuzNumber
          ? _self.targetJuzNumber
          : targetJuzNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      targetDate: freezed == targetDate
          ? _self.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
