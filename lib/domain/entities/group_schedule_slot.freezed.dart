// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_schedule_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupScheduleSlot {
  int get id;
  int get groupId;

  /// ١ (الاثنين) إلى ٧ (الأحد) — مطابق لـ DateTime.weekday.
  int get weekday;

  /// 'وقت محدد' أو 'مرتبط بصلاة' — راجع core/enums/anchor_type.dart.
  String get anchorType;
  String? get fixedTime;
  String? get prayerName;
  int get offsetMinutes;
  DateTime get effectiveFrom;
  DateTime? get effectiveTo;
  DateTime? get createdAt;

  /// Create a copy of GroupScheduleSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupScheduleSlotCopyWith<GroupScheduleSlot> get copyWith =>
      _$GroupScheduleSlotCopyWithImpl<GroupScheduleSlot>(
          this as GroupScheduleSlot, _$identity);

  /// Serializes this GroupScheduleSlot to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupScheduleSlot &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.weekday, weekday) || other.weekday == weekday) &&
            (identical(other.anchorType, anchorType) ||
                other.anchorType == anchorType) &&
            (identical(other.fixedTime, fixedTime) ||
                other.fixedTime == fixedTime) &&
            (identical(other.prayerName, prayerName) ||
                other.prayerName == prayerName) &&
            (identical(other.offsetMinutes, offsetMinutes) ||
                other.offsetMinutes == offsetMinutes) &&
            (identical(other.effectiveFrom, effectiveFrom) ||
                other.effectiveFrom == effectiveFrom) &&
            (identical(other.effectiveTo, effectiveTo) ||
                other.effectiveTo == effectiveTo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      groupId,
      weekday,
      anchorType,
      fixedTime,
      prayerName,
      offsetMinutes,
      effectiveFrom,
      effectiveTo,
      createdAt);

  @override
  String toString() {
    return 'GroupScheduleSlot(id: $id, groupId: $groupId, weekday: $weekday, anchorType: $anchorType, fixedTime: $fixedTime, prayerName: $prayerName, offsetMinutes: $offsetMinutes, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $GroupScheduleSlotCopyWith<$Res> {
  factory $GroupScheduleSlotCopyWith(
          GroupScheduleSlot value, $Res Function(GroupScheduleSlot) _then) =
      _$GroupScheduleSlotCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int groupId,
      int weekday,
      String anchorType,
      String? fixedTime,
      String? prayerName,
      int offsetMinutes,
      DateTime effectiveFrom,
      DateTime? effectiveTo,
      DateTime? createdAt});
}

/// @nodoc
class _$GroupScheduleSlotCopyWithImpl<$Res>
    implements $GroupScheduleSlotCopyWith<$Res> {
  _$GroupScheduleSlotCopyWithImpl(this._self, this._then);

  final GroupScheduleSlot _self;
  final $Res Function(GroupScheduleSlot) _then;

  /// Create a copy of GroupScheduleSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? weekday = null,
    Object? anchorType = null,
    Object? fixedTime = freezed,
    Object? prayerName = freezed,
    Object? offsetMinutes = null,
    Object? effectiveFrom = null,
    Object? effectiveTo = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _self.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      weekday: null == weekday
          ? _self.weekday
          : weekday // ignore: cast_nullable_to_non_nullable
              as int,
      anchorType: null == anchorType
          ? _self.anchorType
          : anchorType // ignore: cast_nullable_to_non_nullable
              as String,
      fixedTime: freezed == fixedTime
          ? _self.fixedTime
          : fixedTime // ignore: cast_nullable_to_non_nullable
              as String?,
      prayerName: freezed == prayerName
          ? _self.prayerName
          : prayerName // ignore: cast_nullable_to_non_nullable
              as String?,
      offsetMinutes: null == offsetMinutes
          ? _self.offsetMinutes
          : offsetMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      effectiveFrom: null == effectiveFrom
          ? _self.effectiveFrom
          : effectiveFrom // ignore: cast_nullable_to_non_nullable
              as DateTime,
      effectiveTo: freezed == effectiveTo
          ? _self.effectiveTo
          : effectiveTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GroupScheduleSlot].
extension GroupScheduleSlotPatterns on GroupScheduleSlot {
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
    TResult Function(_GroupScheduleSlot value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GroupScheduleSlot() when $default != null:
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
    TResult Function(_GroupScheduleSlot value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupScheduleSlot():
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
    TResult? Function(_GroupScheduleSlot value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupScheduleSlot() when $default != null:
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
            int groupId,
            int weekday,
            String anchorType,
            String? fixedTime,
            String? prayerName,
            int offsetMinutes,
            DateTime effectiveFrom,
            DateTime? effectiveTo,
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GroupScheduleSlot() when $default != null:
        return $default(
            _that.id,
            _that.groupId,
            _that.weekday,
            _that.anchorType,
            _that.fixedTime,
            _that.prayerName,
            _that.offsetMinutes,
            _that.effectiveFrom,
            _that.effectiveTo,
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
            int groupId,
            int weekday,
            String anchorType,
            String? fixedTime,
            String? prayerName,
            int offsetMinutes,
            DateTime effectiveFrom,
            DateTime? effectiveTo,
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupScheduleSlot():
        return $default(
            _that.id,
            _that.groupId,
            _that.weekday,
            _that.anchorType,
            _that.fixedTime,
            _that.prayerName,
            _that.offsetMinutes,
            _that.effectiveFrom,
            _that.effectiveTo,
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
            int groupId,
            int weekday,
            String anchorType,
            String? fixedTime,
            String? prayerName,
            int offsetMinutes,
            DateTime effectiveFrom,
            DateTime? effectiveTo,
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupScheduleSlot() when $default != null:
        return $default(
            _that.id,
            _that.groupId,
            _that.weekday,
            _that.anchorType,
            _that.fixedTime,
            _that.prayerName,
            _that.offsetMinutes,
            _that.effectiveFrom,
            _that.effectiveTo,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GroupScheduleSlot implements GroupScheduleSlot {
  const _GroupScheduleSlot(
      {this.id = 0,
      required this.groupId,
      required this.weekday,
      this.anchorType = 'وقت محدد',
      this.fixedTime,
      this.prayerName,
      this.offsetMinutes = 0,
      required this.effectiveFrom,
      this.effectiveTo,
      this.createdAt});
  factory _GroupScheduleSlot.fromJson(Map<String, dynamic> json) =>
      _$GroupScheduleSlotFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  final int groupId;

  /// ١ (الاثنين) إلى ٧ (الأحد) — مطابق لـ DateTime.weekday.
  @override
  final int weekday;

  /// 'وقت محدد' أو 'مرتبط بصلاة' — راجع core/enums/anchor_type.dart.
  @override
  @JsonKey()
  final String anchorType;
  @override
  final String? fixedTime;
  @override
  final String? prayerName;
  @override
  @JsonKey()
  final int offsetMinutes;
  @override
  final DateTime effectiveFrom;
  @override
  final DateTime? effectiveTo;
  @override
  final DateTime? createdAt;

  /// Create a copy of GroupScheduleSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupScheduleSlotCopyWith<_GroupScheduleSlot> get copyWith =>
      __$GroupScheduleSlotCopyWithImpl<_GroupScheduleSlot>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupScheduleSlotToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GroupScheduleSlot &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.weekday, weekday) || other.weekday == weekday) &&
            (identical(other.anchorType, anchorType) ||
                other.anchorType == anchorType) &&
            (identical(other.fixedTime, fixedTime) ||
                other.fixedTime == fixedTime) &&
            (identical(other.prayerName, prayerName) ||
                other.prayerName == prayerName) &&
            (identical(other.offsetMinutes, offsetMinutes) ||
                other.offsetMinutes == offsetMinutes) &&
            (identical(other.effectiveFrom, effectiveFrom) ||
                other.effectiveFrom == effectiveFrom) &&
            (identical(other.effectiveTo, effectiveTo) ||
                other.effectiveTo == effectiveTo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      groupId,
      weekday,
      anchorType,
      fixedTime,
      prayerName,
      offsetMinutes,
      effectiveFrom,
      effectiveTo,
      createdAt);

  @override
  String toString() {
    return 'GroupScheduleSlot(id: $id, groupId: $groupId, weekday: $weekday, anchorType: $anchorType, fixedTime: $fixedTime, prayerName: $prayerName, offsetMinutes: $offsetMinutes, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$GroupScheduleSlotCopyWith<$Res>
    implements $GroupScheduleSlotCopyWith<$Res> {
  factory _$GroupScheduleSlotCopyWith(
          _GroupScheduleSlot value, $Res Function(_GroupScheduleSlot) _then) =
      __$GroupScheduleSlotCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int groupId,
      int weekday,
      String anchorType,
      String? fixedTime,
      String? prayerName,
      int offsetMinutes,
      DateTime effectiveFrom,
      DateTime? effectiveTo,
      DateTime? createdAt});
}

/// @nodoc
class __$GroupScheduleSlotCopyWithImpl<$Res>
    implements _$GroupScheduleSlotCopyWith<$Res> {
  __$GroupScheduleSlotCopyWithImpl(this._self, this._then);

  final _GroupScheduleSlot _self;
  final $Res Function(_GroupScheduleSlot) _then;

  /// Create a copy of GroupScheduleSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? weekday = null,
    Object? anchorType = null,
    Object? fixedTime = freezed,
    Object? prayerName = freezed,
    Object? offsetMinutes = null,
    Object? effectiveFrom = null,
    Object? effectiveTo = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_GroupScheduleSlot(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _self.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      weekday: null == weekday
          ? _self.weekday
          : weekday // ignore: cast_nullable_to_non_nullable
              as int,
      anchorType: null == anchorType
          ? _self.anchorType
          : anchorType // ignore: cast_nullable_to_non_nullable
              as String,
      fixedTime: freezed == fixedTime
          ? _self.fixedTime
          : fixedTime // ignore: cast_nullable_to_non_nullable
              as String?,
      prayerName: freezed == prayerName
          ? _self.prayerName
          : prayerName // ignore: cast_nullable_to_non_nullable
              as String?,
      offsetMinutes: null == offsetMinutes
          ? _self.offsetMinutes
          : offsetMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      effectiveFrom: null == effectiveFrom
          ? _self.effectiveFrom
          : effectiveFrom // ignore: cast_nullable_to_non_nullable
              as DateTime,
      effectiveTo: freezed == effectiveTo
          ? _self.effectiveTo
          : effectiveTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
