// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Student {
  int get id;
  String get fullName;
  int get age;
  String get phone;
  String get address;
  String? get parentName;
  String? get parentPhone;
  int? get currentSurahId;
  int? get lastCompletedSurahId;
  int get totalCompletedJuz;
  String get level;
  DateTime? get createdAt;

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StudentCopyWith<Student> get copyWith =>
      _$StudentCopyWithImpl<Student>(this as Student, _$identity);

  /// Serializes this Student to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Student &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.parentName, parentName) ||
                other.parentName == parentName) &&
            (identical(other.parentPhone, parentPhone) ||
                other.parentPhone == parentPhone) &&
            (identical(other.currentSurahId, currentSurahId) ||
                other.currentSurahId == currentSurahId) &&
            (identical(other.lastCompletedSurahId, lastCompletedSurahId) ||
                other.lastCompletedSurahId == lastCompletedSurahId) &&
            (identical(other.totalCompletedJuz, totalCompletedJuz) ||
                other.totalCompletedJuz == totalCompletedJuz) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fullName,
      age,
      phone,
      address,
      parentName,
      parentPhone,
      currentSurahId,
      lastCompletedSurahId,
      totalCompletedJuz,
      level,
      createdAt);

  @override
  String toString() {
    return 'Student(id: $id, fullName: $fullName, age: $age, phone: $phone, address: $address, parentName: $parentName, parentPhone: $parentPhone, currentSurahId: $currentSurahId, lastCompletedSurahId: $lastCompletedSurahId, totalCompletedJuz: $totalCompletedJuz, level: $level, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $StudentCopyWith<$Res> {
  factory $StudentCopyWith(Student value, $Res Function(Student) _then) =
      _$StudentCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String fullName,
      int age,
      String phone,
      String address,
      String? parentName,
      String? parentPhone,
      int? currentSurahId,
      int? lastCompletedSurahId,
      int totalCompletedJuz,
      String level,
      DateTime? createdAt});
}

/// @nodoc
class _$StudentCopyWithImpl<$Res> implements $StudentCopyWith<$Res> {
  _$StudentCopyWithImpl(this._self, this._then);

  final Student _self;
  final $Res Function(Student) _then;

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? age = null,
    Object? phone = null,
    Object? address = null,
    Object? parentName = freezed,
    Object? parentPhone = freezed,
    Object? currentSurahId = freezed,
    Object? lastCompletedSurahId = freezed,
    Object? totalCompletedJuz = null,
    Object? level = null,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _self.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      parentName: freezed == parentName
          ? _self.parentName
          : parentName // ignore: cast_nullable_to_non_nullable
              as String?,
      parentPhone: freezed == parentPhone
          ? _self.parentPhone
          : parentPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      currentSurahId: freezed == currentSurahId
          ? _self.currentSurahId
          : currentSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      lastCompletedSurahId: freezed == lastCompletedSurahId
          ? _self.lastCompletedSurahId
          : lastCompletedSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      totalCompletedJuz: null == totalCompletedJuz
          ? _self.totalCompletedJuz
          : totalCompletedJuz // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Student].
extension StudentPatterns on Student {
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
    TResult Function(_Student value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Student() when $default != null:
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
    TResult Function(_Student value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Student():
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
    TResult? Function(_Student value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Student() when $default != null:
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
            String fullName,
            int age,
            String phone,
            String address,
            String? parentName,
            String? parentPhone,
            int? currentSurahId,
            int? lastCompletedSurahId,
            int totalCompletedJuz,
            String level,
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Student() when $default != null:
        return $default(
            _that.id,
            _that.fullName,
            _that.age,
            _that.phone,
            _that.address,
            _that.parentName,
            _that.parentPhone,
            _that.currentSurahId,
            _that.lastCompletedSurahId,
            _that.totalCompletedJuz,
            _that.level,
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
            String fullName,
            int age,
            String phone,
            String address,
            String? parentName,
            String? parentPhone,
            int? currentSurahId,
            int? lastCompletedSurahId,
            int totalCompletedJuz,
            String level,
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Student():
        return $default(
            _that.id,
            _that.fullName,
            _that.age,
            _that.phone,
            _that.address,
            _that.parentName,
            _that.parentPhone,
            _that.currentSurahId,
            _that.lastCompletedSurahId,
            _that.totalCompletedJuz,
            _that.level,
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
            String fullName,
            int age,
            String phone,
            String address,
            String? parentName,
            String? parentPhone,
            int? currentSurahId,
            int? lastCompletedSurahId,
            int totalCompletedJuz,
            String level,
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Student() when $default != null:
        return $default(
            _that.id,
            _that.fullName,
            _that.age,
            _that.phone,
            _that.address,
            _that.parentName,
            _that.parentPhone,
            _that.currentSurahId,
            _that.lastCompletedSurahId,
            _that.totalCompletedJuz,
            _that.level,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Student implements Student {
  const _Student(
      {this.id = 0,
      required this.fullName,
      required this.age,
      this.phone = '',
      this.address = '',
      this.parentName,
      this.parentPhone,
      this.currentSurahId,
      this.lastCompletedSurahId,
      this.totalCompletedJuz = 0,
      this.level = 'مبتدئ',
      this.createdAt});
  factory _Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  final String fullName;
  @override
  final int age;
  @override
  @JsonKey()
  final String phone;
  @override
  @JsonKey()
  final String address;
  @override
  final String? parentName;
  @override
  final String? parentPhone;
  @override
  final int? currentSurahId;
  @override
  final int? lastCompletedSurahId;
  @override
  @JsonKey()
  final int totalCompletedJuz;
  @override
  @JsonKey()
  final String level;
  @override
  final DateTime? createdAt;

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StudentCopyWith<_Student> get copyWith =>
      __$StudentCopyWithImpl<_Student>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StudentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Student &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.parentName, parentName) ||
                other.parentName == parentName) &&
            (identical(other.parentPhone, parentPhone) ||
                other.parentPhone == parentPhone) &&
            (identical(other.currentSurahId, currentSurahId) ||
                other.currentSurahId == currentSurahId) &&
            (identical(other.lastCompletedSurahId, lastCompletedSurahId) ||
                other.lastCompletedSurahId == lastCompletedSurahId) &&
            (identical(other.totalCompletedJuz, totalCompletedJuz) ||
                other.totalCompletedJuz == totalCompletedJuz) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fullName,
      age,
      phone,
      address,
      parentName,
      parentPhone,
      currentSurahId,
      lastCompletedSurahId,
      totalCompletedJuz,
      level,
      createdAt);

  @override
  String toString() {
    return 'Student(id: $id, fullName: $fullName, age: $age, phone: $phone, address: $address, parentName: $parentName, parentPhone: $parentPhone, currentSurahId: $currentSurahId, lastCompletedSurahId: $lastCompletedSurahId, totalCompletedJuz: $totalCompletedJuz, level: $level, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$StudentCopyWith<$Res> implements $StudentCopyWith<$Res> {
  factory _$StudentCopyWith(_Student value, $Res Function(_Student) _then) =
      __$StudentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String fullName,
      int age,
      String phone,
      String address,
      String? parentName,
      String? parentPhone,
      int? currentSurahId,
      int? lastCompletedSurahId,
      int totalCompletedJuz,
      String level,
      DateTime? createdAt});
}

/// @nodoc
class __$StudentCopyWithImpl<$Res> implements _$StudentCopyWith<$Res> {
  __$StudentCopyWithImpl(this._self, this._then);

  final _Student _self;
  final $Res Function(_Student) _then;

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? age = null,
    Object? phone = null,
    Object? address = null,
    Object? parentName = freezed,
    Object? parentPhone = freezed,
    Object? currentSurahId = freezed,
    Object? lastCompletedSurahId = freezed,
    Object? totalCompletedJuz = null,
    Object? level = null,
    Object? createdAt = freezed,
  }) {
    return _then(_Student(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _self.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      parentName: freezed == parentName
          ? _self.parentName
          : parentName // ignore: cast_nullable_to_non_nullable
              as String?,
      parentPhone: freezed == parentPhone
          ? _self.parentPhone
          : parentPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      currentSurahId: freezed == currentSurahId
          ? _self.currentSurahId
          : currentSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      lastCompletedSurahId: freezed == lastCompletedSurahId
          ? _self.lastCompletedSurahId
          : lastCompletedSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      totalCompletedJuz: null == totalCompletedJuz
          ? _self.totalCompletedJuz
          : totalCompletedJuz // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
