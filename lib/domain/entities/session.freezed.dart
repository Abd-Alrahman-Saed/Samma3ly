// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Session {
  int get id; // nullable منذ Sprint 2 (v4): جلسة جماعية لا طالب واحد لها. لسه
// مطلوب فعلياً لكل الجلسات الفردية — راجع sessions_table.dart.
  int? get studentId; // Sprint 2 (v4) — null لجلسة فردية.
  int? get groupId;
  String
      get sessionType; // Sprint 2 (v4) — تُملأ فقط للجلسات المُنشأة من حلقة متكرّرة (بند 2.7).
  DateTime? get occurrenceDate;
  DateTime get date;
  String
      get time; // القيمة الفعلية تُقرأ/تُكتب عبر SessionAttendances منذ v4 (Sprint 2)
// — هذا الحقل مجرد راحة على مستوى الـdomain للحالة الشائعة (جلسة
// فردية = صف حضور واحد بالضبط)؛ الـrepository هو المسؤول عن الـjoin.
// راجع docs/DESIGN_SPEC.md وdocs/IMPLEMENTATION_PLAN.md القسم ب.
  String get attendanceStatus;
  String?
      get notes; // القسم ح.6 (v7): قرار المعلّم السريع بعد التسميع — "اجتاز" أو "يُعاد".
// يُعرَض في "معلومات الجلسة الخارجية" (بطاقات القوائم) منذ القسم ح.12
// ليعرف المعلّم من غير فتح الجلسة أن حفظها/مراجعتها تحتاج إعادة.
  String? get recitationOutcome;
  DateTime? get createdAt;
  SessionMemorization?
      get memorization; // القسم ح.14: مراجعات متعددة للجلسة الواحدة (قريبة/بعيدة/عامة…)، كل
// واحدة بتقييمها المستقلّ — كانت `SessionRevision?` مفردة قبل هذا
// التحديث. راجع getter `revision` أدناه للتوافق مع مسارات لا تزال
// بحاجة "مراجعة واحدة" (جلسات الحلقات).
  List<SessionRevision>
      get revisions; // تقييم **الحفظ الجديد** فقط. تقييم كل مراجعة أصبح على صفّها في
// [revisions] (القسم ح.14) — لم يعد هنا.
  SessionEvaluation? get evaluation;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionCopyWith<Session> get copyWith =>
      _$SessionCopyWithImpl<Session>(this as Session, _$identity);

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Session &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.occurrenceDate, occurrenceDate) ||
                other.occurrenceDate == occurrenceDate) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.attendanceStatus, attendanceStatus) ||
                other.attendanceStatus == attendanceStatus) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.recitationOutcome, recitationOutcome) ||
                other.recitationOutcome == recitationOutcome) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.memorization, memorization) ||
                other.memorization == memorization) &&
            const DeepCollectionEquality().equals(other.revisions, revisions) &&
            (identical(other.evaluation, evaluation) ||
                other.evaluation == evaluation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      groupId,
      sessionType,
      occurrenceDate,
      date,
      time,
      attendanceStatus,
      notes,
      recitationOutcome,
      createdAt,
      memorization,
      const DeepCollectionEquality().hash(revisions),
      evaluation);

  @override
  String toString() {
    return 'Session(id: $id, studentId: $studentId, groupId: $groupId, sessionType: $sessionType, occurrenceDate: $occurrenceDate, date: $date, time: $time, attendanceStatus: $attendanceStatus, notes: $notes, recitationOutcome: $recitationOutcome, createdAt: $createdAt, memorization: $memorization, revisions: $revisions, evaluation: $evaluation)';
  }
}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res> {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) =
      _$SessionCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int? studentId,
      int? groupId,
      String sessionType,
      DateTime? occurrenceDate,
      DateTime date,
      String time,
      String attendanceStatus,
      String? notes,
      String? recitationOutcome,
      DateTime? createdAt,
      SessionMemorization? memorization,
      List<SessionRevision> revisions,
      SessionEvaluation? evaluation});

  $SessionMemorizationCopyWith<$Res>? get memorization;
  $SessionEvaluationCopyWith<$Res>? get evaluation;
}

/// @nodoc
class _$SessionCopyWithImpl<$Res> implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = freezed,
    Object? groupId = freezed,
    Object? sessionType = null,
    Object? occurrenceDate = freezed,
    Object? date = null,
    Object? time = null,
    Object? attendanceStatus = null,
    Object? notes = freezed,
    Object? recitationOutcome = freezed,
    Object? createdAt = freezed,
    Object? memorization = freezed,
    Object? revisions = null,
    Object? evaluation = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      studentId: freezed == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as int?,
      groupId: freezed == groupId
          ? _self.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int?,
      sessionType: null == sessionType
          ? _self.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      occurrenceDate: freezed == occurrenceDate
          ? _self.occurrenceDate
          : occurrenceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      attendanceStatus: null == attendanceStatus
          ? _self.attendanceStatus
          : attendanceStatus // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      recitationOutcome: freezed == recitationOutcome
          ? _self.recitationOutcome
          : recitationOutcome // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memorization: freezed == memorization
          ? _self.memorization
          : memorization // ignore: cast_nullable_to_non_nullable
              as SessionMemorization?,
      revisions: null == revisions
          ? _self.revisions
          : revisions // ignore: cast_nullable_to_non_nullable
              as List<SessionRevision>,
      evaluation: freezed == evaluation
          ? _self.evaluation
          : evaluation // ignore: cast_nullable_to_non_nullable
              as SessionEvaluation?,
    ));
  }

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionMemorizationCopyWith<$Res>? get memorization {
    if (_self.memorization == null) {
      return null;
    }

    return $SessionMemorizationCopyWith<$Res>(_self.memorization!, (value) {
      return _then(_self.copyWith(memorization: value));
    });
  }

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionEvaluationCopyWith<$Res>? get evaluation {
    if (_self.evaluation == null) {
      return null;
    }

    return $SessionEvaluationCopyWith<$Res>(_self.evaluation!, (value) {
      return _then(_self.copyWith(evaluation: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Session].
extension SessionPatterns on Session {
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
    TResult Function(_Session value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Session() when $default != null:
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
    TResult Function(_Session value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Session():
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
    TResult? Function(_Session value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Session() when $default != null:
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
            int? studentId,
            int? groupId,
            String sessionType,
            DateTime? occurrenceDate,
            DateTime date,
            String time,
            String attendanceStatus,
            String? notes,
            String? recitationOutcome,
            DateTime? createdAt,
            SessionMemorization? memorization,
            List<SessionRevision> revisions,
            SessionEvaluation? evaluation)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Session() when $default != null:
        return $default(
            _that.id,
            _that.studentId,
            _that.groupId,
            _that.sessionType,
            _that.occurrenceDate,
            _that.date,
            _that.time,
            _that.attendanceStatus,
            _that.notes,
            _that.recitationOutcome,
            _that.createdAt,
            _that.memorization,
            _that.revisions,
            _that.evaluation);
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
            int? studentId,
            int? groupId,
            String sessionType,
            DateTime? occurrenceDate,
            DateTime date,
            String time,
            String attendanceStatus,
            String? notes,
            String? recitationOutcome,
            DateTime? createdAt,
            SessionMemorization? memorization,
            List<SessionRevision> revisions,
            SessionEvaluation? evaluation)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Session():
        return $default(
            _that.id,
            _that.studentId,
            _that.groupId,
            _that.sessionType,
            _that.occurrenceDate,
            _that.date,
            _that.time,
            _that.attendanceStatus,
            _that.notes,
            _that.recitationOutcome,
            _that.createdAt,
            _that.memorization,
            _that.revisions,
            _that.evaluation);
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
            int? studentId,
            int? groupId,
            String sessionType,
            DateTime? occurrenceDate,
            DateTime date,
            String time,
            String attendanceStatus,
            String? notes,
            String? recitationOutcome,
            DateTime? createdAt,
            SessionMemorization? memorization,
            List<SessionRevision> revisions,
            SessionEvaluation? evaluation)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Session() when $default != null:
        return $default(
            _that.id,
            _that.studentId,
            _that.groupId,
            _that.sessionType,
            _that.occurrenceDate,
            _that.date,
            _that.time,
            _that.attendanceStatus,
            _that.notes,
            _that.recitationOutcome,
            _that.createdAt,
            _that.memorization,
            _that.revisions,
            _that.evaluation);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Session extends Session {
  const _Session(
      {this.id = 0,
      this.studentId,
      this.groupId,
      this.sessionType = 'فردي',
      this.occurrenceDate,
      required this.date,
      this.time = '00:00',
      this.attendanceStatus = 'حاضر',
      this.notes,
      this.recitationOutcome,
      this.createdAt,
      this.memorization,
      final List<SessionRevision> revisions = const <SessionRevision>[],
      this.evaluation})
      : _revisions = revisions,
        super._();
  factory _Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  @override
  @JsonKey()
  final int id;
// nullable منذ Sprint 2 (v4): جلسة جماعية لا طالب واحد لها. لسه
// مطلوب فعلياً لكل الجلسات الفردية — راجع sessions_table.dart.
  @override
  final int? studentId;
// Sprint 2 (v4) — null لجلسة فردية.
  @override
  final int? groupId;
  @override
  @JsonKey()
  final String sessionType;
// Sprint 2 (v4) — تُملأ فقط للجلسات المُنشأة من حلقة متكرّرة (بند 2.7).
  @override
  final DateTime? occurrenceDate;
  @override
  final DateTime date;
  @override
  @JsonKey()
  final String time;
// القيمة الفعلية تُقرأ/تُكتب عبر SessionAttendances منذ v4 (Sprint 2)
// — هذا الحقل مجرد راحة على مستوى الـdomain للحالة الشائعة (جلسة
// فردية = صف حضور واحد بالضبط)؛ الـrepository هو المسؤول عن الـjoin.
// راجع docs/DESIGN_SPEC.md وdocs/IMPLEMENTATION_PLAN.md القسم ب.
  @override
  @JsonKey()
  final String attendanceStatus;
  @override
  final String? notes;
// القسم ح.6 (v7): قرار المعلّم السريع بعد التسميع — "اجتاز" أو "يُعاد".
// يُعرَض في "معلومات الجلسة الخارجية" (بطاقات القوائم) منذ القسم ح.12
// ليعرف المعلّم من غير فتح الجلسة أن حفظها/مراجعتها تحتاج إعادة.
  @override
  final String? recitationOutcome;
  @override
  final DateTime? createdAt;
  @override
  final SessionMemorization? memorization;
// القسم ح.14: مراجعات متعددة للجلسة الواحدة (قريبة/بعيدة/عامة…)، كل
// واحدة بتقييمها المستقلّ — كانت `SessionRevision?` مفردة قبل هذا
// التحديث. راجع getter `revision` أدناه للتوافق مع مسارات لا تزال
// بحاجة "مراجعة واحدة" (جلسات الحلقات).
  final List<SessionRevision> _revisions;
// القسم ح.14: مراجعات متعددة للجلسة الواحدة (قريبة/بعيدة/عامة…)، كل
// واحدة بتقييمها المستقلّ — كانت `SessionRevision?` مفردة قبل هذا
// التحديث. راجع getter `revision` أدناه للتوافق مع مسارات لا تزال
// بحاجة "مراجعة واحدة" (جلسات الحلقات).
  @override
  @JsonKey()
  List<SessionRevision> get revisions {
    if (_revisions is EqualUnmodifiableListView) return _revisions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_revisions);
  }

// تقييم **الحفظ الجديد** فقط. تقييم كل مراجعة أصبح على صفّها في
// [revisions] (القسم ح.14) — لم يعد هنا.
  @override
  final SessionEvaluation? evaluation;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionCopyWith<_Session> get copyWith =>
      __$SessionCopyWithImpl<_Session>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SessionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Session &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.occurrenceDate, occurrenceDate) ||
                other.occurrenceDate == occurrenceDate) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.attendanceStatus, attendanceStatus) ||
                other.attendanceStatus == attendanceStatus) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.recitationOutcome, recitationOutcome) ||
                other.recitationOutcome == recitationOutcome) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.memorization, memorization) ||
                other.memorization == memorization) &&
            const DeepCollectionEquality()
                .equals(other._revisions, _revisions) &&
            (identical(other.evaluation, evaluation) ||
                other.evaluation == evaluation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      groupId,
      sessionType,
      occurrenceDate,
      date,
      time,
      attendanceStatus,
      notes,
      recitationOutcome,
      createdAt,
      memorization,
      const DeepCollectionEquality().hash(_revisions),
      evaluation);

  @override
  String toString() {
    return 'Session(id: $id, studentId: $studentId, groupId: $groupId, sessionType: $sessionType, occurrenceDate: $occurrenceDate, date: $date, time: $time, attendanceStatus: $attendanceStatus, notes: $notes, recitationOutcome: $recitationOutcome, createdAt: $createdAt, memorization: $memorization, revisions: $revisions, evaluation: $evaluation)';
  }
}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) =
      __$SessionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int? studentId,
      int? groupId,
      String sessionType,
      DateTime? occurrenceDate,
      DateTime date,
      String time,
      String attendanceStatus,
      String? notes,
      String? recitationOutcome,
      DateTime? createdAt,
      SessionMemorization? memorization,
      List<SessionRevision> revisions,
      SessionEvaluation? evaluation});

  @override
  $SessionMemorizationCopyWith<$Res>? get memorization;
  @override
  $SessionEvaluationCopyWith<$Res>? get evaluation;
}

/// @nodoc
class __$SessionCopyWithImpl<$Res> implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? studentId = freezed,
    Object? groupId = freezed,
    Object? sessionType = null,
    Object? occurrenceDate = freezed,
    Object? date = null,
    Object? time = null,
    Object? attendanceStatus = null,
    Object? notes = freezed,
    Object? recitationOutcome = freezed,
    Object? createdAt = freezed,
    Object? memorization = freezed,
    Object? revisions = null,
    Object? evaluation = freezed,
  }) {
    return _then(_Session(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      studentId: freezed == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as int?,
      groupId: freezed == groupId
          ? _self.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int?,
      sessionType: null == sessionType
          ? _self.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      occurrenceDate: freezed == occurrenceDate
          ? _self.occurrenceDate
          : occurrenceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      attendanceStatus: null == attendanceStatus
          ? _self.attendanceStatus
          : attendanceStatus // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      recitationOutcome: freezed == recitationOutcome
          ? _self.recitationOutcome
          : recitationOutcome // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memorization: freezed == memorization
          ? _self.memorization
          : memorization // ignore: cast_nullable_to_non_nullable
              as SessionMemorization?,
      revisions: null == revisions
          ? _self._revisions
          : revisions // ignore: cast_nullable_to_non_nullable
              as List<SessionRevision>,
      evaluation: freezed == evaluation
          ? _self.evaluation
          : evaluation // ignore: cast_nullable_to_non_nullable
              as SessionEvaluation?,
    ));
  }

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionMemorizationCopyWith<$Res>? get memorization {
    if (_self.memorization == null) {
      return null;
    }

    return $SessionMemorizationCopyWith<$Res>(_self.memorization!, (value) {
      return _then(_self.copyWith(memorization: value));
    });
  }

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionEvaluationCopyWith<$Res>? get evaluation {
    if (_self.evaluation == null) {
      return null;
    }

    return $SessionEvaluationCopyWith<$Res>(_self.evaluation!, (value) {
      return _then(_self.copyWith(evaluation: value));
    });
  }
}

/// @nodoc
mixin _$SessionMemorization {
  int get id;
  int get sessionId;
  int get surahId;
  int get fromAyah;
  int get toAyah; // القسم ح.14 (v10): "السورة كاملة" — `fromAyah`/`toAyah` تُملآن آلياً
// (1 → عدد آيات السورة عبر `QuranUtils.getAyahCount`)، والعلم هنا
// لعرض "(كاملة)" بدل المدى الرقمي ولإعادة فتح الشاشة على نفس الاختيار.
  bool get isFullSurah;

  /// Create a copy of SessionMemorization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionMemorizationCopyWith<SessionMemorization> get copyWith =>
      _$SessionMemorizationCopyWithImpl<SessionMemorization>(
          this as SessionMemorization, _$identity);

  /// Serializes this SessionMemorization to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionMemorization &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.surahId, surahId) || other.surahId == surahId) &&
            (identical(other.fromAyah, fromAyah) ||
                other.fromAyah == fromAyah) &&
            (identical(other.toAyah, toAyah) || other.toAyah == toAyah) &&
            (identical(other.isFullSurah, isFullSurah) ||
                other.isFullSurah == isFullSurah));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, sessionId, surahId, fromAyah, toAyah, isFullSurah);

  @override
  String toString() {
    return 'SessionMemorization(id: $id, sessionId: $sessionId, surahId: $surahId, fromAyah: $fromAyah, toAyah: $toAyah, isFullSurah: $isFullSurah)';
  }
}

/// @nodoc
abstract mixin class $SessionMemorizationCopyWith<$Res> {
  factory $SessionMemorizationCopyWith(
          SessionMemorization value, $Res Function(SessionMemorization) _then) =
      _$SessionMemorizationCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int sessionId,
      int surahId,
      int fromAyah,
      int toAyah,
      bool isFullSurah});
}

/// @nodoc
class _$SessionMemorizationCopyWithImpl<$Res>
    implements $SessionMemorizationCopyWith<$Res> {
  _$SessionMemorizationCopyWithImpl(this._self, this._then);

  final SessionMemorization _self;
  final $Res Function(SessionMemorization) _then;

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
    Object? isFullSurah = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
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
      isFullSurah: null == isFullSurah
          ? _self.isFullSurah
          : isFullSurah // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [SessionMemorization].
extension SessionMemorizationPatterns on SessionMemorization {
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
    TResult Function(_SessionMemorization value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionMemorization() when $default != null:
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
    TResult Function(_SessionMemorization value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionMemorization():
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
    TResult? Function(_SessionMemorization value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionMemorization() when $default != null:
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
    TResult Function(int id, int sessionId, int surahId, int fromAyah,
            int toAyah, bool isFullSurah)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionMemorization() when $default != null:
        return $default(_that.id, _that.sessionId, _that.surahId,
            _that.fromAyah, _that.toAyah, _that.isFullSurah);
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
    TResult Function(int id, int sessionId, int surahId, int fromAyah,
            int toAyah, bool isFullSurah)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionMemorization():
        return $default(_that.id, _that.sessionId, _that.surahId,
            _that.fromAyah, _that.toAyah, _that.isFullSurah);
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
    TResult? Function(int id, int sessionId, int surahId, int fromAyah,
            int toAyah, bool isFullSurah)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionMemorization() when $default != null:
        return $default(_that.id, _that.sessionId, _that.surahId,
            _that.fromAyah, _that.toAyah, _that.isFullSurah);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SessionMemorization implements SessionMemorization {
  const _SessionMemorization(
      {this.id = 0,
      this.sessionId = 0,
      required this.surahId,
      this.fromAyah = 1,
      this.toAyah = 1,
      this.isFullSurah = false});
  factory _SessionMemorization.fromJson(Map<String, dynamic> json) =>
      _$SessionMemorizationFromJson(json);

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
// القسم ح.14 (v10): "السورة كاملة" — `fromAyah`/`toAyah` تُملآن آلياً
// (1 → عدد آيات السورة عبر `QuranUtils.getAyahCount`)، والعلم هنا
// لعرض "(كاملة)" بدل المدى الرقمي ولإعادة فتح الشاشة على نفس الاختيار.
  @override
  @JsonKey()
  final bool isFullSurah;

  /// Create a copy of SessionMemorization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionMemorizationCopyWith<_SessionMemorization> get copyWith =>
      __$SessionMemorizationCopyWithImpl<_SessionMemorization>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SessionMemorizationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionMemorization &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.surahId, surahId) || other.surahId == surahId) &&
            (identical(other.fromAyah, fromAyah) ||
                other.fromAyah == fromAyah) &&
            (identical(other.toAyah, toAyah) || other.toAyah == toAyah) &&
            (identical(other.isFullSurah, isFullSurah) ||
                other.isFullSurah == isFullSurah));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, sessionId, surahId, fromAyah, toAyah, isFullSurah);

  @override
  String toString() {
    return 'SessionMemorization(id: $id, sessionId: $sessionId, surahId: $surahId, fromAyah: $fromAyah, toAyah: $toAyah, isFullSurah: $isFullSurah)';
  }
}

/// @nodoc
abstract mixin class _$SessionMemorizationCopyWith<$Res>
    implements $SessionMemorizationCopyWith<$Res> {
  factory _$SessionMemorizationCopyWith(_SessionMemorization value,
          $Res Function(_SessionMemorization) _then) =
      __$SessionMemorizationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int sessionId,
      int surahId,
      int fromAyah,
      int toAyah,
      bool isFullSurah});
}

/// @nodoc
class __$SessionMemorizationCopyWithImpl<$Res>
    implements _$SessionMemorizationCopyWith<$Res> {
  __$SessionMemorizationCopyWithImpl(this._self, this._then);

  final _SessionMemorization _self;
  final $Res Function(_SessionMemorization) _then;

  /// Create a copy of SessionMemorization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? surahId = null,
    Object? fromAyah = null,
    Object? toAyah = null,
    Object? isFullSurah = null,
  }) {
    return _then(_SessionMemorization(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
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
      isFullSurah: null == isFullSurah
          ? _self.isFullSurah
          : isFullSurah // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$SessionRevision {
  int get id;
  int get sessionId;
  int get surahId;
  int get fromAyah;
  int get toAyah; // القسم ح.14 (v10): نوع المراجعة كما اختاره المعلّم — "قريبة"/"بعيدة"/
// "عامة" أو نصّ مخصَّص. تسمية حرّة عمداً (لا enum).
  String get label;
  bool get isFullSurah;
  int get sortOrder; // القسم ح.14 (v10): تقييم هذه المراجعة بعينها — كان مشتركاً على مستوى
// الجلسة كلها (`SessionEvaluation.revision*Score`) قبل دعم أكثر من
// مراجعة واحدة؛ الآن كل مراجعة تحمل تقييمها المستقلّ.
  double get memorizationScore;
  double get tajweedScore;
  double get fluencyScore;
  double get accuracyScore;

  /// Create a copy of SessionRevision
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionRevisionCopyWith<SessionRevision> get copyWith =>
      _$SessionRevisionCopyWithImpl<SessionRevision>(
          this as SessionRevision, _$identity);

  /// Serializes this SessionRevision to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionRevision &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.surahId, surahId) || other.surahId == surahId) &&
            (identical(other.fromAyah, fromAyah) ||
                other.fromAyah == fromAyah) &&
            (identical(other.toAyah, toAyah) || other.toAyah == toAyah) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.isFullSurah, isFullSurah) ||
                other.isFullSurah == isFullSurah) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
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
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sessionId,
      surahId,
      fromAyah,
      toAyah,
      label,
      isFullSurah,
      sortOrder,
      memorizationScore,
      tajweedScore,
      fluencyScore,
      accuracyScore);

  @override
  String toString() {
    return 'SessionRevision(id: $id, sessionId: $sessionId, surahId: $surahId, fromAyah: $fromAyah, toAyah: $toAyah, label: $label, isFullSurah: $isFullSurah, sortOrder: $sortOrder, memorizationScore: $memorizationScore, tajweedScore: $tajweedScore, fluencyScore: $fluencyScore, accuracyScore: $accuracyScore)';
  }
}

/// @nodoc
abstract mixin class $SessionRevisionCopyWith<$Res> {
  factory $SessionRevisionCopyWith(
          SessionRevision value, $Res Function(SessionRevision) _then) =
      _$SessionRevisionCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int sessionId,
      int surahId,
      int fromAyah,
      int toAyah,
      String label,
      bool isFullSurah,
      int sortOrder,
      double memorizationScore,
      double tajweedScore,
      double fluencyScore,
      double accuracyScore});
}

/// @nodoc
class _$SessionRevisionCopyWithImpl<$Res>
    implements $SessionRevisionCopyWith<$Res> {
  _$SessionRevisionCopyWithImpl(this._self, this._then);

  final SessionRevision _self;
  final $Res Function(SessionRevision) _then;

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
    Object? label = null,
    Object? isFullSurah = null,
    Object? sortOrder = null,
    Object? memorizationScore = null,
    Object? tajweedScore = null,
    Object? fluencyScore = null,
    Object? accuracyScore = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
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
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      isFullSurah: null == isFullSurah
          ? _self.isFullSurah
          : isFullSurah // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      memorizationScore: null == memorizationScore
          ? _self.memorizationScore
          : memorizationScore // ignore: cast_nullable_to_non_nullable
              as double,
      tajweedScore: null == tajweedScore
          ? _self.tajweedScore
          : tajweedScore // ignore: cast_nullable_to_non_nullable
              as double,
      fluencyScore: null == fluencyScore
          ? _self.fluencyScore
          : fluencyScore // ignore: cast_nullable_to_non_nullable
              as double,
      accuracyScore: null == accuracyScore
          ? _self.accuracyScore
          : accuracyScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [SessionRevision].
extension SessionRevisionPatterns on SessionRevision {
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
    TResult Function(_SessionRevision value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionRevision() when $default != null:
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
    TResult Function(_SessionRevision value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionRevision():
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
    TResult? Function(_SessionRevision value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionRevision() when $default != null:
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
            int sessionId,
            int surahId,
            int fromAyah,
            int toAyah,
            String label,
            bool isFullSurah,
            int sortOrder,
            double memorizationScore,
            double tajweedScore,
            double fluencyScore,
            double accuracyScore)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionRevision() when $default != null:
        return $default(
            _that.id,
            _that.sessionId,
            _that.surahId,
            _that.fromAyah,
            _that.toAyah,
            _that.label,
            _that.isFullSurah,
            _that.sortOrder,
            _that.memorizationScore,
            _that.tajweedScore,
            _that.fluencyScore,
            _that.accuracyScore);
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
            int sessionId,
            int surahId,
            int fromAyah,
            int toAyah,
            String label,
            bool isFullSurah,
            int sortOrder,
            double memorizationScore,
            double tajweedScore,
            double fluencyScore,
            double accuracyScore)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionRevision():
        return $default(
            _that.id,
            _that.sessionId,
            _that.surahId,
            _that.fromAyah,
            _that.toAyah,
            _that.label,
            _that.isFullSurah,
            _that.sortOrder,
            _that.memorizationScore,
            _that.tajweedScore,
            _that.fluencyScore,
            _that.accuracyScore);
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
            int sessionId,
            int surahId,
            int fromAyah,
            int toAyah,
            String label,
            bool isFullSurah,
            int sortOrder,
            double memorizationScore,
            double tajweedScore,
            double fluencyScore,
            double accuracyScore)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionRevision() when $default != null:
        return $default(
            _that.id,
            _that.sessionId,
            _that.surahId,
            _that.fromAyah,
            _that.toAyah,
            _that.label,
            _that.isFullSurah,
            _that.sortOrder,
            _that.memorizationScore,
            _that.tajweedScore,
            _that.fluencyScore,
            _that.accuracyScore);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SessionRevision extends SessionRevision {
  const _SessionRevision(
      {this.id = 0,
      this.sessionId = 0,
      required this.surahId,
      this.fromAyah = 1,
      this.toAyah = 1,
      this.label = 'مراجعة',
      this.isFullSurah = false,
      this.sortOrder = 0,
      this.memorizationScore = 0.0,
      this.tajweedScore = 0.0,
      this.fluencyScore = 0.0,
      this.accuracyScore = 0.0})
      : super._();
  factory _SessionRevision.fromJson(Map<String, dynamic> json) =>
      _$SessionRevisionFromJson(json);

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
// القسم ح.14 (v10): نوع المراجعة كما اختاره المعلّم — "قريبة"/"بعيدة"/
// "عامة" أو نصّ مخصَّص. تسمية حرّة عمداً (لا enum).
  @override
  @JsonKey()
  final String label;
  @override
  @JsonKey()
  final bool isFullSurah;
  @override
  @JsonKey()
  final int sortOrder;
// القسم ح.14 (v10): تقييم هذه المراجعة بعينها — كان مشتركاً على مستوى
// الجلسة كلها (`SessionEvaluation.revision*Score`) قبل دعم أكثر من
// مراجعة واحدة؛ الآن كل مراجعة تحمل تقييمها المستقلّ.
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

  /// Create a copy of SessionRevision
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionRevisionCopyWith<_SessionRevision> get copyWith =>
      __$SessionRevisionCopyWithImpl<_SessionRevision>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SessionRevisionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionRevision &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.surahId, surahId) || other.surahId == surahId) &&
            (identical(other.fromAyah, fromAyah) ||
                other.fromAyah == fromAyah) &&
            (identical(other.toAyah, toAyah) || other.toAyah == toAyah) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.isFullSurah, isFullSurah) ||
                other.isFullSurah == isFullSurah) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
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
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sessionId,
      surahId,
      fromAyah,
      toAyah,
      label,
      isFullSurah,
      sortOrder,
      memorizationScore,
      tajweedScore,
      fluencyScore,
      accuracyScore);

  @override
  String toString() {
    return 'SessionRevision(id: $id, sessionId: $sessionId, surahId: $surahId, fromAyah: $fromAyah, toAyah: $toAyah, label: $label, isFullSurah: $isFullSurah, sortOrder: $sortOrder, memorizationScore: $memorizationScore, tajweedScore: $tajweedScore, fluencyScore: $fluencyScore, accuracyScore: $accuracyScore)';
  }
}

/// @nodoc
abstract mixin class _$SessionRevisionCopyWith<$Res>
    implements $SessionRevisionCopyWith<$Res> {
  factory _$SessionRevisionCopyWith(
          _SessionRevision value, $Res Function(_SessionRevision) _then) =
      __$SessionRevisionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int sessionId,
      int surahId,
      int fromAyah,
      int toAyah,
      String label,
      bool isFullSurah,
      int sortOrder,
      double memorizationScore,
      double tajweedScore,
      double fluencyScore,
      double accuracyScore});
}

/// @nodoc
class __$SessionRevisionCopyWithImpl<$Res>
    implements _$SessionRevisionCopyWith<$Res> {
  __$SessionRevisionCopyWithImpl(this._self, this._then);

  final _SessionRevision _self;
  final $Res Function(_SessionRevision) _then;

  /// Create a copy of SessionRevision
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? surahId = null,
    Object? fromAyah = null,
    Object? toAyah = null,
    Object? label = null,
    Object? isFullSurah = null,
    Object? sortOrder = null,
    Object? memorizationScore = null,
    Object? tajweedScore = null,
    Object? fluencyScore = null,
    Object? accuracyScore = null,
  }) {
    return _then(_SessionRevision(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
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
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      isFullSurah: null == isFullSurah
          ? _self.isFullSurah
          : isFullSurah // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      memorizationScore: null == memorizationScore
          ? _self.memorizationScore
          : memorizationScore // ignore: cast_nullable_to_non_nullable
              as double,
      tajweedScore: null == tajweedScore
          ? _self.tajweedScore
          : tajweedScore // ignore: cast_nullable_to_non_nullable
              as double,
      fluencyScore: null == fluencyScore
          ? _self.fluencyScore
          : fluencyScore // ignore: cast_nullable_to_non_nullable
              as double,
      accuracyScore: null == accuracyScore
          ? _self.accuracyScore
          : accuracyScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$SessionEvaluation {
  int get id;
  int get sessionId;
  double get memorizationScore;
  double get tajweedScore;
  double get fluencyScore;
  double get accuracyScore;

  /// Create a copy of SessionEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionEvaluationCopyWith<SessionEvaluation> get copyWith =>
      _$SessionEvaluationCopyWithImpl<SessionEvaluation>(
          this as SessionEvaluation, _$identity);

  /// Serializes this SessionEvaluation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionEvaluation &&
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

  @override
  String toString() {
    return 'SessionEvaluation(id: $id, sessionId: $sessionId, memorizationScore: $memorizationScore, tajweedScore: $tajweedScore, fluencyScore: $fluencyScore, accuracyScore: $accuracyScore)';
  }
}

/// @nodoc
abstract mixin class $SessionEvaluationCopyWith<$Res> {
  factory $SessionEvaluationCopyWith(
          SessionEvaluation value, $Res Function(SessionEvaluation) _then) =
      _$SessionEvaluationCopyWithImpl;
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
class _$SessionEvaluationCopyWithImpl<$Res>
    implements $SessionEvaluationCopyWith<$Res> {
  _$SessionEvaluationCopyWithImpl(this._self, this._then);

  final SessionEvaluation _self;
  final $Res Function(SessionEvaluation) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as int,
      memorizationScore: null == memorizationScore
          ? _self.memorizationScore
          : memorizationScore // ignore: cast_nullable_to_non_nullable
              as double,
      tajweedScore: null == tajweedScore
          ? _self.tajweedScore
          : tajweedScore // ignore: cast_nullable_to_non_nullable
              as double,
      fluencyScore: null == fluencyScore
          ? _self.fluencyScore
          : fluencyScore // ignore: cast_nullable_to_non_nullable
              as double,
      accuracyScore: null == accuracyScore
          ? _self.accuracyScore
          : accuracyScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [SessionEvaluation].
extension SessionEvaluationPatterns on SessionEvaluation {
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
    TResult Function(_SessionEvaluation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionEvaluation() when $default != null:
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
    TResult Function(_SessionEvaluation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionEvaluation():
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
    TResult? Function(_SessionEvaluation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionEvaluation() when $default != null:
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
    TResult Function(int id, int sessionId, double memorizationScore,
            double tajweedScore, double fluencyScore, double accuracyScore)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionEvaluation() when $default != null:
        return $default(_that.id, _that.sessionId, _that.memorizationScore,
            _that.tajweedScore, _that.fluencyScore, _that.accuracyScore);
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
    TResult Function(int id, int sessionId, double memorizationScore,
            double tajweedScore, double fluencyScore, double accuracyScore)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionEvaluation():
        return $default(_that.id, _that.sessionId, _that.memorizationScore,
            _that.tajweedScore, _that.fluencyScore, _that.accuracyScore);
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
    TResult? Function(int id, int sessionId, double memorizationScore,
            double tajweedScore, double fluencyScore, double accuracyScore)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionEvaluation() when $default != null:
        return $default(_that.id, _that.sessionId, _that.memorizationScore,
            _that.tajweedScore, _that.fluencyScore, _that.accuracyScore);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SessionEvaluation extends SessionEvaluation {
  const _SessionEvaluation(
      {this.id = 0,
      this.sessionId = 0,
      this.memorizationScore = 0.0,
      this.tajweedScore = 0.0,
      this.fluencyScore = 0.0,
      this.accuracyScore = 0.0})
      : super._();
  factory _SessionEvaluation.fromJson(Map<String, dynamic> json) =>
      _$SessionEvaluationFromJson(json);

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

  /// Create a copy of SessionEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionEvaluationCopyWith<_SessionEvaluation> get copyWith =>
      __$SessionEvaluationCopyWithImpl<_SessionEvaluation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SessionEvaluationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionEvaluation &&
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

  @override
  String toString() {
    return 'SessionEvaluation(id: $id, sessionId: $sessionId, memorizationScore: $memorizationScore, tajweedScore: $tajweedScore, fluencyScore: $fluencyScore, accuracyScore: $accuracyScore)';
  }
}

/// @nodoc
abstract mixin class _$SessionEvaluationCopyWith<$Res>
    implements $SessionEvaluationCopyWith<$Res> {
  factory _$SessionEvaluationCopyWith(
          _SessionEvaluation value, $Res Function(_SessionEvaluation) _then) =
      __$SessionEvaluationCopyWithImpl;
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
class __$SessionEvaluationCopyWithImpl<$Res>
    implements _$SessionEvaluationCopyWith<$Res> {
  __$SessionEvaluationCopyWithImpl(this._self, this._then);

  final _SessionEvaluation _self;
  final $Res Function(_SessionEvaluation) _then;

  /// Create a copy of SessionEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? memorizationScore = null,
    Object? tajweedScore = null,
    Object? fluencyScore = null,
    Object? accuracyScore = null,
  }) {
    return _then(_SessionEvaluation(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as int,
      memorizationScore: null == memorizationScore
          ? _self.memorizationScore
          : memorizationScore // ignore: cast_nullable_to_non_nullable
              as double,
      tajweedScore: null == tajweedScore
          ? _self.tajweedScore
          : tajweedScore // ignore: cast_nullable_to_non_nullable
              as double,
      fluencyScore: null == fluencyScore
          ? _self.fluencyScore
          : fluencyScore // ignore: cast_nullable_to_non_nullable
              as double,
      accuracyScore: null == accuracyScore
          ? _self.accuracyScore
          : accuracyScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
