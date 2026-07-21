// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppError {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? operation) database,
    required TResult Function(String message, Map<String, String> fieldErrors)
        validation,
    required TResult Function(String message, Object? originalError) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? operation)? database,
    TResult? Function(String message, Map<String, String> fieldErrors)?
        validation,
    TResult? Function(String message, Object? originalError)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? operation)? database,
    TResult Function(String message, Map<String, String> fieldErrors)?
        validation,
    TResult Function(String message, Object? originalError)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseError value) database,
    required TResult Function(ValidationError value) validation,
    required TResult Function(UnknownError value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseError value)? database,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(UnknownError value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseError value)? database,
    TResult Function(ValidationError value)? validation,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppErrorCopyWith<AppError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppErrorCopyWith<$Res> {
  factory $AppErrorCopyWith(AppError value, $Res Function(AppError) then) =
      _$AppErrorCopyWithImpl<$Res, AppError>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AppErrorCopyWithImpl<$Res, $Val extends AppError>
    implements $AppErrorCopyWith<$Res> {
  _$AppErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DatabaseErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$DatabaseErrorImplCopyWith(
          _$DatabaseErrorImpl value, $Res Function(_$DatabaseErrorImpl) then) =
      __$$DatabaseErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? operation});
}

/// @nodoc
class __$$DatabaseErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$DatabaseErrorImpl>
    implements _$$DatabaseErrorImplCopyWith<$Res> {
  __$$DatabaseErrorImplCopyWithImpl(
      _$DatabaseErrorImpl _value, $Res Function(_$DatabaseErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? operation = freezed,
  }) {
    return _then(_$DatabaseErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      operation: freezed == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$DatabaseErrorImpl implements DatabaseError {
  const _$DatabaseErrorImpl({required this.message, this.operation});

  @override
  final String message;
  @override
  final String? operation;

  @override
  String toString() {
    return 'AppError.database(message: $message, operation: $operation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatabaseErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.operation, operation) ||
                other.operation == operation));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, operation);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DatabaseErrorImplCopyWith<_$DatabaseErrorImpl> get copyWith =>
      __$$DatabaseErrorImplCopyWithImpl<_$DatabaseErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? operation) database,
    required TResult Function(String message, Map<String, String> fieldErrors)
        validation,
    required TResult Function(String message, Object? originalError) unknown,
  }) {
    return database(message, operation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? operation)? database,
    TResult? Function(String message, Map<String, String> fieldErrors)?
        validation,
    TResult? Function(String message, Object? originalError)? unknown,
  }) {
    return database?.call(message, operation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? operation)? database,
    TResult Function(String message, Map<String, String> fieldErrors)?
        validation,
    TResult Function(String message, Object? originalError)? unknown,
    required TResult orElse(),
  }) {
    if (database != null) {
      return database(message, operation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseError value) database,
    required TResult Function(ValidationError value) validation,
    required TResult Function(UnknownError value) unknown,
  }) {
    return database(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseError value)? database,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return database?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseError value)? database,
    TResult Function(ValidationError value)? validation,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (database != null) {
      return database(this);
    }
    return orElse();
  }
}

abstract class DatabaseError implements AppError {
  const factory DatabaseError(
      {required final String message,
      final String? operation}) = _$DatabaseErrorImpl;

  @override
  String get message;
  String? get operation;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DatabaseErrorImplCopyWith<_$DatabaseErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidationErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$ValidationErrorImplCopyWith(_$ValidationErrorImpl value,
          $Res Function(_$ValidationErrorImpl) then) =
      __$$ValidationErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Map<String, String> fieldErrors});
}

/// @nodoc
class __$$ValidationErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$ValidationErrorImpl>
    implements _$$ValidationErrorImplCopyWith<$Res> {
  __$$ValidationErrorImplCopyWithImpl(
      _$ValidationErrorImpl _value, $Res Function(_$ValidationErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? fieldErrors = null,
  }) {
    return _then(_$ValidationErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      fieldErrors: null == fieldErrors
          ? _value._fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$ValidationErrorImpl implements ValidationError {
  const _$ValidationErrorImpl(
      {required this.message, final Map<String, String> fieldErrors = const {}})
      : _fieldErrors = fieldErrors;

  @override
  final String message;
  final Map<String, String> _fieldErrors;
  @override
  @JsonKey()
  Map<String, String> get fieldErrors {
    if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fieldErrors);
  }

  @override
  String toString() {
    return 'AppError.validation(message: $message, fieldErrors: $fieldErrors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(_fieldErrors));

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationErrorImplCopyWith<_$ValidationErrorImpl> get copyWith =>
      __$$ValidationErrorImplCopyWithImpl<_$ValidationErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? operation) database,
    required TResult Function(String message, Map<String, String> fieldErrors)
        validation,
    required TResult Function(String message, Object? originalError) unknown,
  }) {
    return validation(message, fieldErrors);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? operation)? database,
    TResult? Function(String message, Map<String, String> fieldErrors)?
        validation,
    TResult? Function(String message, Object? originalError)? unknown,
  }) {
    return validation?.call(message, fieldErrors);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? operation)? database,
    TResult Function(String message, Map<String, String> fieldErrors)?
        validation,
    TResult Function(String message, Object? originalError)? unknown,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(message, fieldErrors);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseError value) database,
    required TResult Function(ValidationError value) validation,
    required TResult Function(UnknownError value) unknown,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseError value)? database,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseError value)? database,
    TResult Function(ValidationError value)? validation,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class ValidationError implements AppError {
  const factory ValidationError(
      {required final String message,
      final Map<String, String> fieldErrors}) = _$ValidationErrorImpl;

  @override
  String get message;
  Map<String, String> get fieldErrors;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationErrorImplCopyWith<_$ValidationErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$UnknownErrorImplCopyWith(
          _$UnknownErrorImpl value, $Res Function(_$UnknownErrorImpl) then) =
      __$$UnknownErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? originalError});
}

/// @nodoc
class __$$UnknownErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$UnknownErrorImpl>
    implements _$$UnknownErrorImplCopyWith<$Res> {
  __$$UnknownErrorImplCopyWithImpl(
      _$UnknownErrorImpl _value, $Res Function(_$UnknownErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? originalError = freezed,
  }) {
    return _then(_$UnknownErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      originalError:
          freezed == originalError ? _value.originalError : originalError,
    ));
  }
}

/// @nodoc

class _$UnknownErrorImpl implements UnknownError {
  const _$UnknownErrorImpl({required this.message, this.originalError});

  @override
  final String message;
  @override
  final Object? originalError;

  @override
  String toString() {
    return 'AppError.unknown(message: $message, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(originalError));

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownErrorImplCopyWith<_$UnknownErrorImpl> get copyWith =>
      __$$UnknownErrorImplCopyWithImpl<_$UnknownErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? operation) database,
    required TResult Function(String message, Map<String, String> fieldErrors)
        validation,
    required TResult Function(String message, Object? originalError) unknown,
  }) {
    return unknown(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? operation)? database,
    TResult? Function(String message, Map<String, String> fieldErrors)?
        validation,
    TResult? Function(String message, Object? originalError)? unknown,
  }) {
    return unknown?.call(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? operation)? database,
    TResult Function(String message, Map<String, String> fieldErrors)?
        validation,
    TResult Function(String message, Object? originalError)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseError value) database,
    required TResult Function(ValidationError value) validation,
    required TResult Function(UnknownError value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseError value)? database,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseError value)? database,
    TResult Function(ValidationError value)? validation,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownError implements AppError {
  const factory UnknownError(
      {required final String message,
      final Object? originalError}) = _$UnknownErrorImpl;

  @override
  String get message;
  Object? get originalError;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownErrorImplCopyWith<_$UnknownErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
