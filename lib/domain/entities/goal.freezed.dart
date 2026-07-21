// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Goal _$GoalFromJson(Map<String, dynamic> json) {
  return _Goal.fromJson(json);
}

/// @nodoc
mixin _$Goal {
  int get id => throw _privateConstructorUsedError;
  int get studentId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get goalType => throw _privateConstructorUsedError;
  int? get targetSurahId => throw _privateConstructorUsedError;
  int? get targetJuzNumber => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get targetDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Goal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalCopyWith<Goal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalCopyWith<$Res> {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) then) =
      _$GoalCopyWithImpl<$Res, Goal>;
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
class _$GoalCopyWithImpl<$Res, $Val extends Goal>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      goalType: null == goalType
          ? _value.goalType
          : goalType // ignore: cast_nullable_to_non_nullable
              as String,
      targetSurahId: freezed == targetSurahId
          ? _value.targetSurahId
          : targetSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      targetJuzNumber: freezed == targetJuzNumber
          ? _value.targetJuzNumber
          : targetJuzNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      targetDate: freezed == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalImplCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$$GoalImplCopyWith(
          _$GoalImpl value, $Res Function(_$GoalImpl) then) =
      __$$GoalImplCopyWithImpl<$Res>;
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
class __$$GoalImplCopyWithImpl<$Res>
    extends _$GoalCopyWithImpl<$Res, _$GoalImpl>
    implements _$$GoalImplCopyWith<$Res> {
  __$$GoalImplCopyWithImpl(_$GoalImpl _value, $Res Function(_$GoalImpl) _then)
      : super(_value, _then);

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
    return _then(_$GoalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      goalType: null == goalType
          ? _value.goalType
          : goalType // ignore: cast_nullable_to_non_nullable
              as String,
      targetSurahId: freezed == targetSurahId
          ? _value.targetSurahId
          : targetSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      targetJuzNumber: freezed == targetJuzNumber
          ? _value.targetJuzNumber
          : targetJuzNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      targetDate: freezed == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalImpl implements _Goal {
  const _$GoalImpl(
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

  factory _$GoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalImplFromJson(json);

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

  @override
  String toString() {
    return 'Goal(id: $id, studentId: $studentId, title: $title, goalType: $goalType, targetSurahId: $targetSurahId, targetJuzNumber: $targetJuzNumber, startDate: $startDate, targetDate: $targetDate, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalImpl &&
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

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      __$$GoalImplCopyWithImpl<_$GoalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalImplToJson(
      this,
    );
  }
}

abstract class _Goal implements Goal {
  const factory _Goal(
      {final int id,
      required final int studentId,
      required final String title,
      final String goalType,
      final int? targetSurahId,
      final int? targetJuzNumber,
      required final DateTime startDate,
      final DateTime? targetDate,
      final String status,
      final DateTime? createdAt}) = _$GoalImpl;

  factory _Goal.fromJson(Map<String, dynamic> json) = _$GoalImpl.fromJson;

  @override
  int get id;
  @override
  int get studentId;
  @override
  String get title;
  @override
  String get goalType;
  @override
  int? get targetSurahId;
  @override
  int? get targetJuzNumber;
  @override
  DateTime get startDate;
  @override
  DateTime? get targetDate;
  @override
  String get status;
  @override
  DateTime? get createdAt;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
