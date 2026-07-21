// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Schedule _$ScheduleFromJson(Map<String, dynamic> json) {
  return _Schedule.fromJson(json);
}

/// @nodoc
mixin _$Schedule {
  int get id => throw _privateConstructorUsedError;
  int get studentId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  int? get memorizationSurahId => throw _privateConstructorUsedError;
  int? get memorizationFromAyah => throw _privateConstructorUsedError;
  int? get memorizationToAyah => throw _privateConstructorUsedError;
  int? get revisionSurahId => throw _privateConstructorUsedError;
  int? get revisionFromAyah => throw _privateConstructorUsedError;
  int? get revisionToAyah => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Schedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleCopyWith<Schedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleCopyWith<$Res> {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) then) =
      _$ScheduleCopyWithImpl<$Res, Schedule>;
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
class _$ScheduleCopyWithImpl<$Res, $Val extends Schedule>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      memorizationSurahId: freezed == memorizationSurahId
          ? _value.memorizationSurahId
          : memorizationSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      memorizationFromAyah: freezed == memorizationFromAyah
          ? _value.memorizationFromAyah
          : memorizationFromAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      memorizationToAyah: freezed == memorizationToAyah
          ? _value.memorizationToAyah
          : memorizationToAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      revisionSurahId: freezed == revisionSurahId
          ? _value.revisionSurahId
          : revisionSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      revisionFromAyah: freezed == revisionFromAyah
          ? _value.revisionFromAyah
          : revisionFromAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      revisionToAyah: freezed == revisionToAyah
          ? _value.revisionToAyah
          : revisionToAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleImplCopyWith<$Res>
    implements $ScheduleCopyWith<$Res> {
  factory _$$ScheduleImplCopyWith(
          _$ScheduleImpl value, $Res Function(_$ScheduleImpl) then) =
      __$$ScheduleImplCopyWithImpl<$Res>;
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
class __$$ScheduleImplCopyWithImpl<$Res>
    extends _$ScheduleCopyWithImpl<$Res, _$ScheduleImpl>
    implements _$$ScheduleImplCopyWith<$Res> {
  __$$ScheduleImplCopyWithImpl(
      _$ScheduleImpl _value, $Res Function(_$ScheduleImpl) _then)
      : super(_value, _then);

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
    return _then(_$ScheduleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      memorizationSurahId: freezed == memorizationSurahId
          ? _value.memorizationSurahId
          : memorizationSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      memorizationFromAyah: freezed == memorizationFromAyah
          ? _value.memorizationFromAyah
          : memorizationFromAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      memorizationToAyah: freezed == memorizationToAyah
          ? _value.memorizationToAyah
          : memorizationToAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      revisionSurahId: freezed == revisionSurahId
          ? _value.revisionSurahId
          : revisionSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      revisionFromAyah: freezed == revisionFromAyah
          ? _value.revisionFromAyah
          : revisionFromAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      revisionToAyah: freezed == revisionToAyah
          ? _value.revisionToAyah
          : revisionToAyah // ignore: cast_nullable_to_non_nullable
              as int?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleImpl implements _Schedule {
  const _$ScheduleImpl(
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

  factory _$ScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleImplFromJson(json);

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

  @override
  String toString() {
    return 'Schedule(id: $id, studentId: $studentId, date: $date, time: $time, memorizationSurahId: $memorizationSurahId, memorizationFromAyah: $memorizationFromAyah, memorizationToAyah: $memorizationToAyah, revisionSurahId: $revisionSurahId, revisionFromAyah: $revisionFromAyah, revisionToAyah: $revisionToAyah, isCompleted: $isCompleted, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleImpl &&
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

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleImplCopyWith<_$ScheduleImpl> get copyWith =>
      __$$ScheduleImplCopyWithImpl<_$ScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleImplToJson(
      this,
    );
  }
}

abstract class _Schedule implements Schedule {
  const factory _Schedule(
      {final int id,
      required final int studentId,
      required final DateTime date,
      final String time,
      final int? memorizationSurahId,
      final int? memorizationFromAyah,
      final int? memorizationToAyah,
      final int? revisionSurahId,
      final int? revisionFromAyah,
      final int? revisionToAyah,
      final bool isCompleted,
      final DateTime? createdAt}) = _$ScheduleImpl;

  factory _Schedule.fromJson(Map<String, dynamic> json) =
      _$ScheduleImpl.fromJson;

  @override
  int get id;
  @override
  int get studentId;
  @override
  DateTime get date;
  @override
  String get time;
  @override
  int? get memorizationSurahId;
  @override
  int? get memorizationFromAyah;
  @override
  int? get memorizationToAyah;
  @override
  int? get revisionSurahId;
  @override
  int? get revisionFromAyah;
  @override
  int? get revisionToAyah;
  @override
  bool get isCompleted;
  @override
  DateTime? get createdAt;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleImplCopyWith<_$ScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
