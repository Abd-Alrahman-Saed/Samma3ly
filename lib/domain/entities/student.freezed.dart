// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Student _$StudentFromJson(Map<String, dynamic> json) {
  return _Student.fromJson(json);
}

/// @nodoc
mixin _$Student {
  int get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get parentName => throw _privateConstructorUsedError;
  String? get parentPhone => throw _privateConstructorUsedError;
  int? get currentSurahId => throw _privateConstructorUsedError;
  int? get lastCompletedSurahId => throw _privateConstructorUsedError;
  int get totalCompletedJuz => throw _privateConstructorUsedError;
  String get level => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Student to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentCopyWith<Student> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentCopyWith<$Res> {
  factory $StudentCopyWith(Student value, $Res Function(Student) then) =
      _$StudentCopyWithImpl<$Res, Student>;
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
class _$StudentCopyWithImpl<$Res, $Val extends Student>
    implements $StudentCopyWith<$Res> {
  _$StudentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      parentName: freezed == parentName
          ? _value.parentName
          : parentName // ignore: cast_nullable_to_non_nullable
              as String?,
      parentPhone: freezed == parentPhone
          ? _value.parentPhone
          : parentPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      currentSurahId: freezed == currentSurahId
          ? _value.currentSurahId
          : currentSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      lastCompletedSurahId: freezed == lastCompletedSurahId
          ? _value.lastCompletedSurahId
          : lastCompletedSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      totalCompletedJuz: null == totalCompletedJuz
          ? _value.totalCompletedJuz
          : totalCompletedJuz // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StudentImplCopyWith<$Res> implements $StudentCopyWith<$Res> {
  factory _$$StudentImplCopyWith(
          _$StudentImpl value, $Res Function(_$StudentImpl) then) =
      __$$StudentImplCopyWithImpl<$Res>;
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
class __$$StudentImplCopyWithImpl<$Res>
    extends _$StudentCopyWithImpl<$Res, _$StudentImpl>
    implements _$$StudentImplCopyWith<$Res> {
  __$$StudentImplCopyWithImpl(
      _$StudentImpl _value, $Res Function(_$StudentImpl) _then)
      : super(_value, _then);

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
    return _then(_$StudentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      parentName: freezed == parentName
          ? _value.parentName
          : parentName // ignore: cast_nullable_to_non_nullable
              as String?,
      parentPhone: freezed == parentPhone
          ? _value.parentPhone
          : parentPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      currentSurahId: freezed == currentSurahId
          ? _value.currentSurahId
          : currentSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      lastCompletedSurahId: freezed == lastCompletedSurahId
          ? _value.lastCompletedSurahId
          : lastCompletedSurahId // ignore: cast_nullable_to_non_nullable
              as int?,
      totalCompletedJuz: null == totalCompletedJuz
          ? _value.totalCompletedJuz
          : totalCompletedJuz // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
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
class _$StudentImpl implements _Student {
  const _$StudentImpl(
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

  factory _$StudentImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentImplFromJson(json);

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

  @override
  String toString() {
    return 'Student(id: $id, fullName: $fullName, age: $age, phone: $phone, address: $address, parentName: $parentName, parentPhone: $parentPhone, currentSurahId: $currentSurahId, lastCompletedSurahId: $lastCompletedSurahId, totalCompletedJuz: $totalCompletedJuz, level: $level, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentImpl &&
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

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentImplCopyWith<_$StudentImpl> get copyWith =>
      __$$StudentImplCopyWithImpl<_$StudentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentImplToJson(
      this,
    );
  }
}

abstract class _Student implements Student {
  const factory _Student(
      {final int id,
      required final String fullName,
      required final int age,
      final String phone,
      final String address,
      final String? parentName,
      final String? parentPhone,
      final int? currentSurahId,
      final int? lastCompletedSurahId,
      final int totalCompletedJuz,
      final String level,
      final DateTime? createdAt}) = _$StudentImpl;

  factory _Student.fromJson(Map<String, dynamic> json) = _$StudentImpl.fromJson;

  @override
  int get id;
  @override
  String get fullName;
  @override
  int get age;
  @override
  String get phone;
  @override
  String get address;
  @override
  String? get parentName;
  @override
  String? get parentPhone;
  @override
  int? get currentSurahId;
  @override
  int? get lastCompletedSurahId;
  @override
  int get totalCompletedJuz;
  @override
  String get level;
  @override
  DateTime? get createdAt;

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentImplCopyWith<_$StudentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
