// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Session _$SessionFromJson(Map<String, dynamic> json) {
  return _Session.fromJson(json);
}

/// @nodoc
mixin _$Session {
  int get id => throw _privateConstructorUsedError;
  int get studentId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get attendanceStatus => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  SessionMemorization? get memorization => throw _privateConstructorUsedError;
  SessionRevision? get revision => throw _privateConstructorUsedError;
  SessionEvaluation? get evaluation => throw _privateConstructorUsedError;

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionCopyWith<Session> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionCopyWith<$Res> {
  factory $SessionCopyWith(Session value, $Res Function(Session) then) =
      _$SessionCopyWithImpl<$Res, Session>;
  @useResult
  $Res call(
      {int id,
      int studentId,
      DateTime date,
      String time,
      String attendanceStatus,
      String? notes,
      DateTime? createdAt,
      SessionMemorization? memorization,
      SessionRevision? revision,
      SessionEvaluation? evaluation});

  $SessionMemorizationCopyWith<$Res>? get memorization;
  $SessionRevisionCopyWith<$Res>? get revision;
  $SessionEvaluationCopyWith<$Res>? get evaluation;
}

/// @nodoc
class _$SessionCopyWithImpl<$Res, $Val extends Session>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? date = null,
    Object? time = null,
    Object? attendanceStatus = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? memorization = freezed,
    Object? revision = freezed,
    Object? evaluation = freezed,
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
      attendanceStatus: null == attendanceStatus
          ? _value.attendanceStatus
          : attendanceStatus // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memorization: freezed == memorization
          ? _value.memorization
          : memorization // ignore: cast_nullable_to_non_nullable
              as SessionMemorization?,
      revision: freezed == revision
          ? _value.revision
          : revision // ignore: cast_nullable_to_non_nullable
              as SessionRevision?,
      evaluation: freezed == evaluation
          ? _value.evaluation
          : evaluation // ignore: cast_nullable_to_non_nullable
              as SessionEvaluation?,
    ) as $Val);
  }

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionMemorizationCopyWith<$Res>? get memorization {
    if (_value.memorization == null) {
      return null;
    }

    return $SessionMemorizationCopyWith<$Res>(_value.memorization!, (value) {
      return _then(_value.copyWith(memorization: value) as $Val);
    });
  }

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionRevisionCopyWith<$Res>? get revision {
    if (_value.revision == null) {
      return null;
    }

    return $SessionRevisionCopyWith<$Res>(_value.revision!, (value) {
      return _then(_value.copyWith(revision: value) as $Val);
    });
  }

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionEvaluationCopyWith<$Res>? get evaluation {
    if (_value.evaluation == null) {
      return null;
    }

    return $SessionEvaluationCopyWith<$Res>(_value.evaluation!, (value) {
      return _then(_value.copyWith(evaluation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionImplCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$$SessionImplCopyWith(
          _$SessionImpl value, $Res Function(_$SessionImpl) then) =
      __$$SessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int studentId,
      DateTime date,
      String time,
      String attendanceStatus,
      String? notes,
      DateTime? createdAt,
      SessionMemorization? memorization,
      SessionRevision? revision,
      SessionEvaluation? evaluation});

  @override
  $SessionMemorizationCopyWith<$Res>? get memorization;
  @override
  $SessionRevisionCopyWith<$Res>? get revision;
  @override
  $SessionEvaluationCopyWith<$Res>? get evaluation;
}

/// @nodoc
class __$$SessionImplCopyWithImpl<$Res>
    extends _$SessionCopyWithImpl<$Res, _$SessionImpl>
    implements _$$SessionImplCopyWith<$Res> {
  __$$SessionImplCopyWithImpl(
      _$SessionImpl _value, $Res Function(_$SessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? date = null,
    Object? time = null,
    Object? attendanceStatus = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? memorization = freezed,
    Object? revision = freezed,
    Object? evaluation = freezed,
  }) {
    return _then(_$SessionImpl(
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
      attendanceStatus: null == attendanceStatus
          ? _value.attendanceStatus
          : attendanceStatus // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memorization: freezed == memorization
          ? _value.memorization
          : memorization // ignore: cast_nullable_to_non_nullable
              as SessionMemorization?,
      revision: freezed == revision
          ? _value.revision
          : revision // ignore: cast_nullable_to_non_nullable
              as SessionRevision?,
      evaluation: freezed == evaluation
          ? _value.evaluation
          : evaluation // ignore: cast_nullable_to_non_nullable
              as SessionEvaluation?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionImpl implements _Session {
  const _$SessionImpl(
      {this.id = 0,
      required this.studentId,
      required this.date,
      this.time = '00:00',
      this.attendanceStatus = 'حاضر',
      this.notes,
      this.createdAt,
      this.memorization,
      this.revision,
      this.evaluation});

  factory _$SessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionImplFromJson(json);

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
  @JsonKey()
  final String attendanceStatus;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final SessionMemorization? memorization;
  @override
  final SessionRevision? revision;
  @override
  final SessionEvaluation? evaluation;

  @override
  String toString() {
    return 'Session(id: $id, studentId: $studentId, date: $date, time: $time, attendanceStatus: $attendanceStatus, notes: $notes, createdAt: $createdAt, memorization: $memorization, revision: $revision, evaluation: $evaluation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.attendanceStatus, attendanceStatus) ||
                other.attendanceStatus == attendanceStatus) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.memorization, memorization) ||
                other.memorization == memorization) &&
            (identical(other.revision, revision) ||
                other.revision == revision) &&
            (identical(other.evaluation, evaluation) ||
                other.evaluation == evaluation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, studentId, date, time,
      attendanceStatus, notes, createdAt, memorization, revision, evaluation);

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      __$$SessionImplCopyWithImpl<_$SessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionImplToJson(
      this,
    );
  }
}

abstract class _Session implements Session {
  const factory _Session(
      {final int id,
      required final int studentId,
      required final DateTime date,
      final String time,
      final String attendanceStatus,
      final String? notes,
      final DateTime? createdAt,
      final SessionMemorization? memorization,
      final SessionRevision? revision,
      final SessionEvaluation? evaluation}) = _$SessionImpl;

  factory _Session.fromJson(Map<String, dynamic> json) = _$SessionImpl.fromJson;

  @override
  int get id;
  @override
  int get studentId;
  @override
  DateTime get date;
  @override
  String get time;
  @override
  String get attendanceStatus;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  SessionMemorization? get memorization;
  @override
  SessionRevision? get revision;
  @override
  SessionEvaluation? get evaluation;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionMemorization _$SessionMemorizationFromJson(Map<String, dynamic> json) {
  return _SessionMemorization.fromJson(json);
}

/// @nodoc
mixin _$SessionMemorization {
  int get id => throw _privateConstructorUsedError;
  int get sessionId => throw _privateConstructorUsedError;
  int get surahId => throw _privateConstructorUsedError;
  int get fromAyah => throw _privateConstructorUsedError;
  int get toAyah => throw _privateConstructorUsedError;

  /// Serializes this SessionMemorization to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionMemorization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionMemorizationCopyWith<SessionMemorization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionMemorizationCopyWith<$Res> {
  factory $SessionMemorizationCopyWith(
          SessionMemorization value, $Res Function(SessionMemorization) then) =
      _$SessionMemorizationCopyWithImpl<$Res, SessionMemorization>;
  @useResult
  $Res call({int id, int sessionId, int surahId, int fromAyah, int toAyah});
}

/// @nodoc
class _$SessionMemorizationCopyWithImpl<$Res, $Val extends SessionMemorization>
    implements $SessionMemorizationCopyWith<$Res> {
  _$SessionMemorizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionMemorization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? surahId = null,
    Object? fromAyah = null,
    Object? toAyah = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$SessionMemorizationImplCopyWith<$Res>
    implements $SessionMemorizationCopyWith<$Res> {
  factory _$$SessionMemorizationImplCopyWith(_$SessionMemorizationImpl value,
          $Res Function(_$SessionMemorizationImpl) then) =
      __$$SessionMemorizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int sessionId, int surahId, int fromAyah, int toAyah});
}

/// @nodoc
class __$$SessionMemorizationImplCopyWithImpl<$Res>
    extends _$SessionMemorizationCopyWithImpl<$Res, _$SessionMemorizationImpl>
    implements _$$SessionMemorizationImplCopyWith<$Res> {
  __$$SessionMemorizationImplCopyWithImpl(_$SessionMemorizationImpl _value,
      $Res Function(_$SessionMemorizationImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionMemorization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? surahId = null,
    Object? fromAyah = null,
    Object? toAyah = null,
  }) {
    return _then(_$SessionMemorizationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
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
class _$SessionMemorizationImpl implements _SessionMemorization {
  const _$SessionMemorizationImpl(
      {this.id = 0,
      this.sessionId = 0,
      required this.surahId,
      this.fromAyah = 1,
      this.toAyah = 1});

  factory _$SessionMemorizationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionMemorizationImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final int sessionId;
  @override
  final int surahId;
  @override
  @JsonKey()
  final int fromAyah;
  @override
  @JsonKey()
  final int toAyah;

  @override
  String toString() {
    return 'SessionMemorization(id: $id, sessionId: $sessionId, surahId: $surahId, fromAyah: $fromAyah, toAyah: $toAyah)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionMemorizationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.surahId, surahId) || other.surahId == surahId) &&
            (identical(other.fromAyah, fromAyah) ||
                other.fromAyah == fromAyah) &&
            (identical(other.toAyah, toAyah) || other.toAyah == toAyah));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, sessionId, surahId, fromAyah, toAyah);

  /// Create a copy of SessionMemorization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionMemorizationImplCopyWith<_$SessionMemorizationImpl> get copyWith =>
      __$$SessionMemorizationImplCopyWithImpl<_$SessionMemorizationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionMemorizationImplToJson(
      this,
    );
  }
}

abstract class _SessionMemorization implements SessionMemorization {
  const factory _SessionMemorization(
      {final int id,
      final int sessionId,
      required final int surahId,
      final int fromAyah,
      final int toAyah}) = _$SessionMemorizationImpl;

  factory _SessionMemorization.fromJson(Map<String, dynamic> json) =
      _$SessionMemorizationImpl.fromJson;

  @override
  int get id;
  @override
  int get sessionId;
  @override
  int get surahId;
  @override
  int get fromAyah;
  @override
  int get toAyah;

  /// Create a copy of SessionMemorization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionMemorizationImplCopyWith<_$SessionMemorizationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionRevision _$SessionRevisionFromJson(Map<String, dynamic> json) {
  return _SessionRevision.fromJson(json);
}

/// @nodoc
mixin _$SessionRevision {
  int get id => throw _privateConstructorUsedError;
  int get sessionId => throw _privateConstructorUsedError;
  int get surahId => throw _privateConstructorUsedError;
  int get fromAyah => throw _privateConstructorUsedError;
  int get toAyah => throw _privateConstructorUsedError;

  /// Serializes this SessionRevision to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionRevision
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionRevisionCopyWith<SessionRevision> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionRevisionCopyWith<$Res> {
  factory $SessionRevisionCopyWith(
          SessionRevision value, $Res Function(SessionRevision) then) =
      _$SessionRevisionCopyWithImpl<$Res, SessionRevision>;
  @useResult
  $Res call({int id, int sessionId, int surahId, int fromAyah, int toAyah});
}

/// @nodoc
class _$SessionRevisionCopyWithImpl<$Res, $Val extends SessionRevision>
    implements $SessionRevisionCopyWith<$Res> {
  _$SessionRevisionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionRevision
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? surahId = null,
    Object? fromAyah = null,
    Object? toAyah = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$SessionRevisionImplCopyWith<$Res>
    implements $SessionRevisionCopyWith<$Res> {
  factory _$$SessionRevisionImplCopyWith(_$SessionRevisionImpl value,
          $Res Function(_$SessionRevisionImpl) then) =
      __$$SessionRevisionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int sessionId, int surahId, int fromAyah, int toAyah});
}

/// @nodoc
class __$$SessionRevisionImplCopyWithImpl<$Res>
    extends _$SessionRevisionCopyWithImpl<$Res, _$SessionRevisionImpl>
    implements _$$SessionRevisionImplCopyWith<$Res> {
  __$$SessionRevisionImplCopyWithImpl(
      _$SessionRevisionImpl _value, $Res Function(_$SessionRevisionImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionRevision
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? surahId = null,
    Object? fromAyah = null,
    Object? toAyah = null,
  }) {
    return _then(_$SessionRevisionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
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
class _$SessionRevisionImpl implements _SessionRevision {
  const _$SessionRevisionImpl(
      {this.id = 0,
      this.sessionId = 0,
      required this.surahId,
      this.fromAyah = 1,
      this.toAyah = 1});

  factory _$SessionRevisionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionRevisionImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final int sessionId;
  @override
  final int surahId;
  @override
  @JsonKey()
  final int fromAyah;
  @override
  @JsonKey()
  final int toAyah;

  @override
  String toString() {
    return 'SessionRevision(id: $id, sessionId: $sessionId, surahId: $surahId, fromAyah: $fromAyah, toAyah: $toAyah)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionRevisionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.surahId, surahId) || other.surahId == surahId) &&
            (identical(other.fromAyah, fromAyah) ||
                other.fromAyah == fromAyah) &&
            (identical(other.toAyah, toAyah) || other.toAyah == toAyah));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, sessionId, surahId, fromAyah, toAyah);

  /// Create a copy of SessionRevision
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionRevisionImplCopyWith<_$SessionRevisionImpl> get copyWith =>
      __$$SessionRevisionImplCopyWithImpl<_$SessionRevisionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionRevisionImplToJson(
      this,
    );
  }
}

abstract class _SessionRevision implements SessionRevision {
  const factory _SessionRevision(
      {final int id,
      final int sessionId,
      required final int surahId,
      final int fromAyah,
      final int toAyah}) = _$SessionRevisionImpl;

  factory _SessionRevision.fromJson(Map<String, dynamic> json) =
      _$SessionRevisionImpl.fromJson;

  @override
  int get id;
  @override
  int get sessionId;
  @override
  int get surahId;
  @override
  int get fromAyah;
  @override
  int get toAyah;

  /// Create a copy of SessionRevision
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionRevisionImplCopyWith<_$SessionRevisionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionEvaluation _$SessionEvaluationFromJson(Map<String, dynamic> json) {
  return _SessionEvaluation.fromJson(json);
}

/// @nodoc
mixin _$SessionEvaluation {
  int get id => throw _privateConstructorUsedError;
  int get sessionId => throw _privateConstructorUsedError;
  double get memorizationScore => throw _privateConstructorUsedError;
  double get tajweedScore => throw _privateConstructorUsedError;
  double get fluencyScore => throw _privateConstructorUsedError;
  double get accuracyScore => throw _privateConstructorUsedError;

  /// Serializes this SessionEvaluation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionEvaluationCopyWith<SessionEvaluation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionEvaluationCopyWith<$Res> {
  factory $SessionEvaluationCopyWith(
          SessionEvaluation value, $Res Function(SessionEvaluation) then) =
      _$SessionEvaluationCopyWithImpl<$Res, SessionEvaluation>;
  @useResult
  $Res call(
      {int id,
      int sessionId,
      double memorizationScore,
      double tajweedScore,
      double fluencyScore,
      double accuracyScore});
}

/// @nodoc
class _$SessionEvaluationCopyWithImpl<$Res, $Val extends SessionEvaluation>
    implements $SessionEvaluationCopyWith<$Res> {
  _$SessionEvaluationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? memorizationScore = null,
    Object? tajweedScore = null,
    Object? fluencyScore = null,
    Object? accuracyScore = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as int,
      memorizationScore: null == memorizationScore
          ? _value.memorizationScore
          : memorizationScore // ignore: cast_nullable_to_non_nullable
              as double,
      tajweedScore: null == tajweedScore
          ? _value.tajweedScore
          : tajweedScore // ignore: cast_nullable_to_non_nullable
              as double,
      fluencyScore: null == fluencyScore
          ? _value.fluencyScore
          : fluencyScore // ignore: cast_nullable_to_non_nullable
              as double,
      accuracyScore: null == accuracyScore
          ? _value.accuracyScore
          : accuracyScore // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionEvaluationImplCopyWith<$Res>
    implements $SessionEvaluationCopyWith<$Res> {
  factory _$$SessionEvaluationImplCopyWith(_$SessionEvaluationImpl value,
          $Res Function(_$SessionEvaluationImpl) then) =
      __$$SessionEvaluationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int sessionId,
      double memorizationScore,
      double tajweedScore,
      double fluencyScore,
      double accuracyScore});
}

/// @nodoc
class __$$SessionEvaluationImplCopyWithImpl<$Res>
    extends _$SessionEvaluationCopyWithImpl<$Res, _$SessionEvaluationImpl>
    implements _$$SessionEvaluationImplCopyWith<$Res> {
  __$$SessionEvaluationImplCopyWithImpl(_$SessionEvaluationImpl _value,
      $Res Function(_$SessionEvaluationImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? memorizationScore = null,
    Object? tajweedScore = null,
    Object? fluencyScore = null,
    Object? accuracyScore = null,
  }) {
    return _then(_$SessionEvaluationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as int,
      memorizationScore: null == memorizationScore
          ? _value.memorizationScore
          : memorizationScore // ignore: cast_nullable_to_non_nullable
              as double,
      tajweedScore: null == tajweedScore
          ? _value.tajweedScore
          : tajweedScore // ignore: cast_nullable_to_non_nullable
              as double,
      fluencyScore: null == fluencyScore
          ? _value.fluencyScore
          : fluencyScore // ignore: cast_nullable_to_non_nullable
              as double,
      accuracyScore: null == accuracyScore
          ? _value.accuracyScore
          : accuracyScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionEvaluationImpl extends _SessionEvaluation {
  const _$SessionEvaluationImpl(
      {this.id = 0,
      this.sessionId = 0,
      this.memorizationScore = 0.0,
      this.tajweedScore = 0.0,
      this.fluencyScore = 0.0,
      this.accuracyScore = 0.0})
      : super._();

  factory _$SessionEvaluationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionEvaluationImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final int sessionId;
  @override
  @JsonKey()
  final double memorizationScore;
  @override
  @JsonKey()
  final double tajweedScore;
  @override
  @JsonKey()
  final double fluencyScore;
  @override
  @JsonKey()
  final double accuracyScore;

  @override
  String toString() {
    return 'SessionEvaluation(id: $id, sessionId: $sessionId, memorizationScore: $memorizationScore, tajweedScore: $tajweedScore, fluencyScore: $fluencyScore, accuracyScore: $accuracyScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionEvaluationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.memorizationScore, memorizationScore) ||
                other.memorizationScore == memorizationScore) &&
            (identical(other.tajweedScore, tajweedScore) ||
                other.tajweedScore == tajweedScore) &&
            (identical(other.fluencyScore, fluencyScore) ||
                other.fluencyScore == fluencyScore) &&
            (identical(other.accuracyScore, accuracyScore) ||
                other.accuracyScore == accuracyScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, sessionId, memorizationScore,
      tajweedScore, fluencyScore, accuracyScore);

  /// Create a copy of SessionEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionEvaluationImplCopyWith<_$SessionEvaluationImpl> get copyWith =>
      __$$SessionEvaluationImplCopyWithImpl<_$SessionEvaluationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionEvaluationImplToJson(
      this,
    );
  }
}

abstract class _SessionEvaluation extends SessionEvaluation {
  const factory _SessionEvaluation(
      {final int id,
      final int sessionId,
      final double memorizationScore,
      final double tajweedScore,
      final double fluencyScore,
      final double accuracyScore}) = _$SessionEvaluationImpl;
  const _SessionEvaluation._() : super._();

  factory _SessionEvaluation.fromJson(Map<String, dynamic> json) =
      _$SessionEvaluationImpl.fromJson;

  @override
  int get id;
  @override
  int get sessionId;
  @override
  double get memorizationScore;
  @override
  double get tajweedScore;
  @override
  double get fluencyScore;
  @override
  double get accuracyScore;

  /// Create a copy of SessionEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionEvaluationImplCopyWith<_$SessionEvaluationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
