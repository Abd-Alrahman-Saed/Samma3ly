// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardData {
  int get totalStudents;
  int get todaySessions;
  int get upcomingSessions;
  double get averageAttendance;
  int get totalPagesMemorized;
  int get totalSurahsCompleted;
  int get totalSessionsEver;
  int get totalTeachers;
  List<DashboardTopStudent> get topStudents;
  List<WeeklyAttendanceData> get weeklyAttendance;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DashboardDataCopyWith<DashboardData> get copyWith =>
      _$DashboardDataCopyWithImpl<DashboardData>(
          this as DashboardData, _$identity);

  /// Serializes this DashboardData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DashboardData &&
            (identical(other.totalStudents, totalStudents) ||
                other.totalStudents == totalStudents) &&
            (identical(other.todaySessions, todaySessions) ||
                other.todaySessions == todaySessions) &&
            (identical(other.upcomingSessions, upcomingSessions) ||
                other.upcomingSessions == upcomingSessions) &&
            (identical(other.averageAttendance, averageAttendance) ||
                other.averageAttendance == averageAttendance) &&
            (identical(other.totalPagesMemorized, totalPagesMemorized) ||
                other.totalPagesMemorized == totalPagesMemorized) &&
            (identical(other.totalSurahsCompleted, totalSurahsCompleted) ||
                other.totalSurahsCompleted == totalSurahsCompleted) &&
            (identical(other.totalSessionsEver, totalSessionsEver) ||
                other.totalSessionsEver == totalSessionsEver) &&
            (identical(other.totalTeachers, totalTeachers) ||
                other.totalTeachers == totalTeachers) &&
            const DeepCollectionEquality()
                .equals(other.topStudents, topStudents) &&
            const DeepCollectionEquality()
                .equals(other.weeklyAttendance, weeklyAttendance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalStudents,
      todaySessions,
      upcomingSessions,
      averageAttendance,
      totalPagesMemorized,
      totalSurahsCompleted,
      totalSessionsEver,
      totalTeachers,
      const DeepCollectionEquality().hash(topStudents),
      const DeepCollectionEquality().hash(weeklyAttendance));

  @override
  String toString() {
    return 'DashboardData(totalStudents: $totalStudents, todaySessions: $todaySessions, upcomingSessions: $upcomingSessions, averageAttendance: $averageAttendance, totalPagesMemorized: $totalPagesMemorized, totalSurahsCompleted: $totalSurahsCompleted, totalSessionsEver: $totalSessionsEver, totalTeachers: $totalTeachers, topStudents: $topStudents, weeklyAttendance: $weeklyAttendance)';
  }
}

/// @nodoc
abstract mixin class $DashboardDataCopyWith<$Res> {
  factory $DashboardDataCopyWith(
          DashboardData value, $Res Function(DashboardData) _then) =
      _$DashboardDataCopyWithImpl;
  @useResult
  $Res call(
      {int totalStudents,
      int todaySessions,
      int upcomingSessions,
      double averageAttendance,
      int totalPagesMemorized,
      int totalSurahsCompleted,
      int totalSessionsEver,
      int totalTeachers,
      List<DashboardTopStudent> topStudents,
      List<WeeklyAttendanceData> weeklyAttendance});
}

/// @nodoc
class _$DashboardDataCopyWithImpl<$Res>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._self, this._then);

  final DashboardData _self;
  final $Res Function(DashboardData) _then;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalStudents = null,
    Object? todaySessions = null,
    Object? upcomingSessions = null,
    Object? averageAttendance = null,
    Object? totalPagesMemorized = null,
    Object? totalSurahsCompleted = null,
    Object? totalSessionsEver = null,
    Object? totalTeachers = null,
    Object? topStudents = null,
    Object? weeklyAttendance = null,
  }) {
    return _then(_self.copyWith(
      totalStudents: null == totalStudents
          ? _self.totalStudents
          : totalStudents // ignore: cast_nullable_to_non_nullable
              as int,
      todaySessions: null == todaySessions
          ? _self.todaySessions
          : todaySessions // ignore: cast_nullable_to_non_nullable
              as int,
      upcomingSessions: null == upcomingSessions
          ? _self.upcomingSessions
          : upcomingSessions // ignore: cast_nullable_to_non_nullable
              as int,
      averageAttendance: null == averageAttendance
          ? _self.averageAttendance
          : averageAttendance // ignore: cast_nullable_to_non_nullable
              as double,
      totalPagesMemorized: null == totalPagesMemorized
          ? _self.totalPagesMemorized
          : totalPagesMemorized // ignore: cast_nullable_to_non_nullable
              as int,
      totalSurahsCompleted: null == totalSurahsCompleted
          ? _self.totalSurahsCompleted
          : totalSurahsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalSessionsEver: null == totalSessionsEver
          ? _self.totalSessionsEver
          : totalSessionsEver // ignore: cast_nullable_to_non_nullable
              as int,
      totalTeachers: null == totalTeachers
          ? _self.totalTeachers
          : totalTeachers // ignore: cast_nullable_to_non_nullable
              as int,
      topStudents: null == topStudents
          ? _self.topStudents
          : topStudents // ignore: cast_nullable_to_non_nullable
              as List<DashboardTopStudent>,
      weeklyAttendance: null == weeklyAttendance
          ? _self.weeklyAttendance
          : weeklyAttendance // ignore: cast_nullable_to_non_nullable
              as List<WeeklyAttendanceData>,
    ));
  }
}

/// Adds pattern-matching-related methods to [DashboardData].
extension DashboardDataPatterns on DashboardData {
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
    TResult Function(_DashboardData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DashboardData() when $default != null:
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
    TResult Function(_DashboardData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardData():
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
    TResult? Function(_DashboardData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardData() when $default != null:
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
            int totalStudents,
            int todaySessions,
            int upcomingSessions,
            double averageAttendance,
            int totalPagesMemorized,
            int totalSurahsCompleted,
            int totalSessionsEver,
            int totalTeachers,
            List<DashboardTopStudent> topStudents,
            List<WeeklyAttendanceData> weeklyAttendance)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DashboardData() when $default != null:
        return $default(
            _that.totalStudents,
            _that.todaySessions,
            _that.upcomingSessions,
            _that.averageAttendance,
            _that.totalPagesMemorized,
            _that.totalSurahsCompleted,
            _that.totalSessionsEver,
            _that.totalTeachers,
            _that.topStudents,
            _that.weeklyAttendance);
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
            int totalStudents,
            int todaySessions,
            int upcomingSessions,
            double averageAttendance,
            int totalPagesMemorized,
            int totalSurahsCompleted,
            int totalSessionsEver,
            int totalTeachers,
            List<DashboardTopStudent> topStudents,
            List<WeeklyAttendanceData> weeklyAttendance)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardData():
        return $default(
            _that.totalStudents,
            _that.todaySessions,
            _that.upcomingSessions,
            _that.averageAttendance,
            _that.totalPagesMemorized,
            _that.totalSurahsCompleted,
            _that.totalSessionsEver,
            _that.totalTeachers,
            _that.topStudents,
            _that.weeklyAttendance);
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
            int totalStudents,
            int todaySessions,
            int upcomingSessions,
            double averageAttendance,
            int totalPagesMemorized,
            int totalSurahsCompleted,
            int totalSessionsEver,
            int totalTeachers,
            List<DashboardTopStudent> topStudents,
            List<WeeklyAttendanceData> weeklyAttendance)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardData() when $default != null:
        return $default(
            _that.totalStudents,
            _that.todaySessions,
            _that.upcomingSessions,
            _that.averageAttendance,
            _that.totalPagesMemorized,
            _that.totalSurahsCompleted,
            _that.totalSessionsEver,
            _that.totalTeachers,
            _that.topStudents,
            _that.weeklyAttendance);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DashboardData implements DashboardData {
  const _DashboardData(
      {this.totalStudents = 0,
      this.todaySessions = 0,
      this.upcomingSessions = 0,
      this.averageAttendance = 0.0,
      this.totalPagesMemorized = 0,
      this.totalSurahsCompleted = 0,
      this.totalSessionsEver = 0,
      this.totalTeachers = 0,
      final List<DashboardTopStudent> topStudents =
          const <DashboardTopStudent>[],
      final List<WeeklyAttendanceData> weeklyAttendance =
          const <WeeklyAttendanceData>[]})
      : _topStudents = topStudents,
        _weeklyAttendance = weeklyAttendance;
  factory _DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);

  @override
  @JsonKey()
  final int totalStudents;
  @override
  @JsonKey()
  final int todaySessions;
  @override
  @JsonKey()
  final int upcomingSessions;
  @override
  @JsonKey()
  final double averageAttendance;
  @override
  @JsonKey()
  final int totalPagesMemorized;
  @override
  @JsonKey()
  final int totalSurahsCompleted;
  @override
  @JsonKey()
  final int totalSessionsEver;
  @override
  @JsonKey()
  final int totalTeachers;
  final List<DashboardTopStudent> _topStudents;
  @override
  @JsonKey()
  List<DashboardTopStudent> get topStudents {
    if (_topStudents is EqualUnmodifiableListView) return _topStudents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topStudents);
  }

  final List<WeeklyAttendanceData> _weeklyAttendance;
  @override
  @JsonKey()
  List<WeeklyAttendanceData> get weeklyAttendance {
    if (_weeklyAttendance is EqualUnmodifiableListView)
      return _weeklyAttendance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyAttendance);
  }

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DashboardDataCopyWith<_DashboardData> get copyWith =>
      __$DashboardDataCopyWithImpl<_DashboardData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DashboardDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DashboardData &&
            (identical(other.totalStudents, totalStudents) ||
                other.totalStudents == totalStudents) &&
            (identical(other.todaySessions, todaySessions) ||
                other.todaySessions == todaySessions) &&
            (identical(other.upcomingSessions, upcomingSessions) ||
                other.upcomingSessions == upcomingSessions) &&
            (identical(other.averageAttendance, averageAttendance) ||
                other.averageAttendance == averageAttendance) &&
            (identical(other.totalPagesMemorized, totalPagesMemorized) ||
                other.totalPagesMemorized == totalPagesMemorized) &&
            (identical(other.totalSurahsCompleted, totalSurahsCompleted) ||
                other.totalSurahsCompleted == totalSurahsCompleted) &&
            (identical(other.totalSessionsEver, totalSessionsEver) ||
                other.totalSessionsEver == totalSessionsEver) &&
            (identical(other.totalTeachers, totalTeachers) ||
                other.totalTeachers == totalTeachers) &&
            const DeepCollectionEquality()
                .equals(other._topStudents, _topStudents) &&
            const DeepCollectionEquality()
                .equals(other._weeklyAttendance, _weeklyAttendance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalStudents,
      todaySessions,
      upcomingSessions,
      averageAttendance,
      totalPagesMemorized,
      totalSurahsCompleted,
      totalSessionsEver,
      totalTeachers,
      const DeepCollectionEquality().hash(_topStudents),
      const DeepCollectionEquality().hash(_weeklyAttendance));

  @override
  String toString() {
    return 'DashboardData(totalStudents: $totalStudents, todaySessions: $todaySessions, upcomingSessions: $upcomingSessions, averageAttendance: $averageAttendance, totalPagesMemorized: $totalPagesMemorized, totalSurahsCompleted: $totalSurahsCompleted, totalSessionsEver: $totalSessionsEver, totalTeachers: $totalTeachers, topStudents: $topStudents, weeklyAttendance: $weeklyAttendance)';
  }
}

/// @nodoc
abstract mixin class _$DashboardDataCopyWith<$Res>
    implements $DashboardDataCopyWith<$Res> {
  factory _$DashboardDataCopyWith(
          _DashboardData value, $Res Function(_DashboardData) _then) =
      __$DashboardDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int totalStudents,
      int todaySessions,
      int upcomingSessions,
      double averageAttendance,
      int totalPagesMemorized,
      int totalSurahsCompleted,
      int totalSessionsEver,
      int totalTeachers,
      List<DashboardTopStudent> topStudents,
      List<WeeklyAttendanceData> weeklyAttendance});
}

/// @nodoc
class __$DashboardDataCopyWithImpl<$Res>
    implements _$DashboardDataCopyWith<$Res> {
  __$DashboardDataCopyWithImpl(this._self, this._then);

  final _DashboardData _self;
  final $Res Function(_DashboardData) _then;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalStudents = null,
    Object? todaySessions = null,
    Object? upcomingSessions = null,
    Object? averageAttendance = null,
    Object? totalPagesMemorized = null,
    Object? totalSurahsCompleted = null,
    Object? totalSessionsEver = null,
    Object? totalTeachers = null,
    Object? topStudents = null,
    Object? weeklyAttendance = null,
  }) {
    return _then(_DashboardData(
      totalStudents: null == totalStudents
          ? _self.totalStudents
          : totalStudents // ignore: cast_nullable_to_non_nullable
              as int,
      todaySessions: null == todaySessions
          ? _self.todaySessions
          : todaySessions // ignore: cast_nullable_to_non_nullable
              as int,
      upcomingSessions: null == upcomingSessions
          ? _self.upcomingSessions
          : upcomingSessions // ignore: cast_nullable_to_non_nullable
              as int,
      averageAttendance: null == averageAttendance
          ? _self.averageAttendance
          : averageAttendance // ignore: cast_nullable_to_non_nullable
              as double,
      totalPagesMemorized: null == totalPagesMemorized
          ? _self.totalPagesMemorized
          : totalPagesMemorized // ignore: cast_nullable_to_non_nullable
              as int,
      totalSurahsCompleted: null == totalSurahsCompleted
          ? _self.totalSurahsCompleted
          : totalSurahsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalSessionsEver: null == totalSessionsEver
          ? _self.totalSessionsEver
          : totalSessionsEver // ignore: cast_nullable_to_non_nullable
              as int,
      totalTeachers: null == totalTeachers
          ? _self.totalTeachers
          : totalTeachers // ignore: cast_nullable_to_non_nullable
              as int,
      topStudents: null == topStudents
          ? _self._topStudents
          : topStudents // ignore: cast_nullable_to_non_nullable
              as List<DashboardTopStudent>,
      weeklyAttendance: null == weeklyAttendance
          ? _self._weeklyAttendance
          : weeklyAttendance // ignore: cast_nullable_to_non_nullable
              as List<WeeklyAttendanceData>,
    ));
  }
}

/// @nodoc
mixin _$DashboardTopStudent {
  int get studentId;
  String get studentName;
  double get averageScore;

  /// Create a copy of DashboardTopStudent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DashboardTopStudentCopyWith<DashboardTopStudent> get copyWith =>
      _$DashboardTopStudentCopyWithImpl<DashboardTopStudent>(
          this as DashboardTopStudent, _$identity);

  /// Serializes this DashboardTopStudent to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DashboardTopStudent &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, studentId, studentName, averageScore);

  @override
  String toString() {
    return 'DashboardTopStudent(studentId: $studentId, studentName: $studentName, averageScore: $averageScore)';
  }
}

/// @nodoc
abstract mixin class $DashboardTopStudentCopyWith<$Res> {
  factory $DashboardTopStudentCopyWith(
          DashboardTopStudent value, $Res Function(DashboardTopStudent) _then) =
      _$DashboardTopStudentCopyWithImpl;
  @useResult
  $Res call({int studentId, String studentName, double averageScore});
}

/// @nodoc
class _$DashboardTopStudentCopyWithImpl<$Res>
    implements $DashboardTopStudentCopyWith<$Res> {
  _$DashboardTopStudentCopyWithImpl(this._self, this._then);

  final DashboardTopStudent _self;
  final $Res Function(DashboardTopStudent) _then;

  /// Create a copy of DashboardTopStudent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? studentName = null,
    Object? averageScore = null,
  }) {
    return _then(_self.copyWith(
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as int,
      studentName: null == studentName
          ? _self.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      averageScore: null == averageScore
          ? _self.averageScore
          : averageScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [DashboardTopStudent].
extension DashboardTopStudentPatterns on DashboardTopStudent {
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
    TResult Function(_DashboardTopStudent value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DashboardTopStudent() when $default != null:
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
    TResult Function(_DashboardTopStudent value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardTopStudent():
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
    TResult? Function(_DashboardTopStudent value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardTopStudent() when $default != null:
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
    TResult Function(int studentId, String studentName, double averageScore)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DashboardTopStudent() when $default != null:
        return $default(_that.studentId, _that.studentName, _that.averageScore);
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
    TResult Function(int studentId, String studentName, double averageScore)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardTopStudent():
        return $default(_that.studentId, _that.studentName, _that.averageScore);
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
    TResult? Function(int studentId, String studentName, double averageScore)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardTopStudent() when $default != null:
        return $default(_that.studentId, _that.studentName, _that.averageScore);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DashboardTopStudent implements DashboardTopStudent {
  const _DashboardTopStudent(
      {required this.studentId,
      required this.studentName,
      required this.averageScore});
  factory _DashboardTopStudent.fromJson(Map<String, dynamic> json) =>
      _$DashboardTopStudentFromJson(json);

  @override
  final int studentId;
  @override
  final String studentName;
  @override
  final double averageScore;

  /// Create a copy of DashboardTopStudent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DashboardTopStudentCopyWith<_DashboardTopStudent> get copyWith =>
      __$DashboardTopStudentCopyWithImpl<_DashboardTopStudent>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DashboardTopStudentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DashboardTopStudent &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, studentId, studentName, averageScore);

  @override
  String toString() {
    return 'DashboardTopStudent(studentId: $studentId, studentName: $studentName, averageScore: $averageScore)';
  }
}

/// @nodoc
abstract mixin class _$DashboardTopStudentCopyWith<$Res>
    implements $DashboardTopStudentCopyWith<$Res> {
  factory _$DashboardTopStudentCopyWith(_DashboardTopStudent value,
          $Res Function(_DashboardTopStudent) _then) =
      __$DashboardTopStudentCopyWithImpl;
  @override
  @useResult
  $Res call({int studentId, String studentName, double averageScore});
}

/// @nodoc
class __$DashboardTopStudentCopyWithImpl<$Res>
    implements _$DashboardTopStudentCopyWith<$Res> {
  __$DashboardTopStudentCopyWithImpl(this._self, this._then);

  final _DashboardTopStudent _self;
  final $Res Function(_DashboardTopStudent) _then;

  /// Create a copy of DashboardTopStudent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? studentId = null,
    Object? studentName = null,
    Object? averageScore = null,
  }) {
    return _then(_DashboardTopStudent(
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as int,
      studentName: null == studentName
          ? _self.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      averageScore: null == averageScore
          ? _self.averageScore
          : averageScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$WeeklyAttendanceData {
  DateTime get date;
  double get percent;

  /// Create a copy of WeeklyAttendanceData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WeeklyAttendanceDataCopyWith<WeeklyAttendanceData> get copyWith =>
      _$WeeklyAttendanceDataCopyWithImpl<WeeklyAttendanceData>(
          this as WeeklyAttendanceData, _$identity);

  /// Serializes this WeeklyAttendanceData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WeeklyAttendanceData &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.percent, percent) || other.percent == percent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, percent);

  @override
  String toString() {
    return 'WeeklyAttendanceData(date: $date, percent: $percent)';
  }
}

/// @nodoc
abstract mixin class $WeeklyAttendanceDataCopyWith<$Res> {
  factory $WeeklyAttendanceDataCopyWith(WeeklyAttendanceData value,
          $Res Function(WeeklyAttendanceData) _then) =
      _$WeeklyAttendanceDataCopyWithImpl;
  @useResult
  $Res call({DateTime date, double percent});
}

/// @nodoc
class _$WeeklyAttendanceDataCopyWithImpl<$Res>
    implements $WeeklyAttendanceDataCopyWith<$Res> {
  _$WeeklyAttendanceDataCopyWithImpl(this._self, this._then);

  final WeeklyAttendanceData _self;
  final $Res Function(WeeklyAttendanceData) _then;

  /// Create a copy of WeeklyAttendanceData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? percent = null,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      percent: null == percent
          ? _self.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [WeeklyAttendanceData].
extension WeeklyAttendanceDataPatterns on WeeklyAttendanceData {
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
    TResult Function(_WeeklyAttendanceData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklyAttendanceData() when $default != null:
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
    TResult Function(_WeeklyAttendanceData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyAttendanceData():
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
    TResult? Function(_WeeklyAttendanceData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyAttendanceData() when $default != null:
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
    TResult Function(DateTime date, double percent)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklyAttendanceData() when $default != null:
        return $default(_that.date, _that.percent);
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
    TResult Function(DateTime date, double percent) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyAttendanceData():
        return $default(_that.date, _that.percent);
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
    TResult? Function(DateTime date, double percent)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyAttendanceData() when $default != null:
        return $default(_that.date, _that.percent);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WeeklyAttendanceData implements WeeklyAttendanceData {
  const _WeeklyAttendanceData({required this.date, this.percent = 0.0});
  factory _WeeklyAttendanceData.fromJson(Map<String, dynamic> json) =>
      _$WeeklyAttendanceDataFromJson(json);

  @override
  final DateTime date;
  @override
  @JsonKey()
  final double percent;

  /// Create a copy of WeeklyAttendanceData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WeeklyAttendanceDataCopyWith<_WeeklyAttendanceData> get copyWith =>
      __$WeeklyAttendanceDataCopyWithImpl<_WeeklyAttendanceData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WeeklyAttendanceDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WeeklyAttendanceData &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.percent, percent) || other.percent == percent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, percent);

  @override
  String toString() {
    return 'WeeklyAttendanceData(date: $date, percent: $percent)';
  }
}

/// @nodoc
abstract mixin class _$WeeklyAttendanceDataCopyWith<$Res>
    implements $WeeklyAttendanceDataCopyWith<$Res> {
  factory _$WeeklyAttendanceDataCopyWith(_WeeklyAttendanceData value,
          $Res Function(_WeeklyAttendanceData) _then) =
      __$WeeklyAttendanceDataCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime date, double percent});
}

/// @nodoc
class __$WeeklyAttendanceDataCopyWithImpl<$Res>
    implements _$WeeklyAttendanceDataCopyWith<$Res> {
  __$WeeklyAttendanceDataCopyWithImpl(this._self, this._then);

  final _WeeklyAttendanceData _self;
  final $Res Function(_WeeklyAttendanceData) _then;

  /// Create a copy of WeeklyAttendanceData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? percent = null,
  }) {
    return _then(_WeeklyAttendanceData(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      percent: null == percent
          ? _self.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
