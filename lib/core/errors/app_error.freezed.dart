// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppError {
  String get message;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppErrorCopyWith<AppError> get copyWith =>
      _$AppErrorCopyWithImpl<AppError>(this as AppError, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AppError(message: $message)';
  }
}

/// @nodoc
abstract mixin class $AppErrorCopyWith<$Res> {
  factory $AppErrorCopyWith(AppError value, $Res Function(AppError) _then) =
      _$AppErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AppErrorCopyWithImpl<$Res> implements $AppErrorCopyWith<$Res> {
  _$AppErrorCopyWithImpl(this._self, this._then);

  final AppError _self;
  final $Res Function(AppError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_self.copyWith(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [AppError].
extension AppErrorPatterns on AppError {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseError value)? database,
    TResult Function(ValidationError value)? validation,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DatabaseError() when database != null:
        return database(_that);
      case ValidationError() when validation != null:
        return validation(_that);
      case UnknownError() when unknown != null:
        return unknown(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseError value) database,
    required TResult Function(ValidationError value) validation,
    required TResult Function(UnknownError value) unknown,
  }) {
    final _that = this;
    switch (_that) {
      case DatabaseError():
        return database(_that);
      case ValidationError():
        return validation(_that);
      case UnknownError():
        return unknown(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseError value)? database,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(UnknownError value)? unknown,
  }) {
    final _that = this;
    switch (_that) {
      case DatabaseError() when database != null:
        return database(_that);
      case ValidationError() when validation != null:
        return validation(_that);
      case UnknownError() when unknown != null:
        return unknown(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? operation)? database,
    TResult Function(String message, Map<String, String> fieldErrors)?
        validation,
    TResult Function(String message, Object? originalError)? unknown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DatabaseError() when database != null:
        return database(_that.message, _that.operation);
      case ValidationError() when validation != null:
        return validation(_that.message, _that.fieldErrors);
      case UnknownError() when unknown != null:
        return unknown(_that.message, _that.originalError);
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
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? operation) database,
    required TResult Function(String message, Map<String, String> fieldErrors)
        validation,
    required TResult Function(String message, Object? originalError) unknown,
  }) {
    final _that = this;
    switch (_that) {
      case DatabaseError():
        return database(_that.message, _that.operation);
      case ValidationError():
        return validation(_that.message, _that.fieldErrors);
      case UnknownError():
        return unknown(_that.message, _that.originalError);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? operation)? database,
    TResult? Function(String message, Map<String, String> fieldErrors)?
        validation,
    TResult? Function(String message, Object? originalError)? unknown,
  }) {
    final _that = this;
    switch (_that) {
      case DatabaseError() when database != null:
        return database(_that.message, _that.operation);
      case ValidationError() when validation != null:
        return validation(_that.message, _that.fieldErrors);
      case UnknownError() when unknown != null:
        return unknown(_that.message, _that.originalError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class DatabaseError implements AppError {
  const DatabaseError({required this.message, this.operation});

  @override
  final String message;
  final String? operation;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DatabaseErrorCopyWith<DatabaseError> get copyWith =>
      _$DatabaseErrorCopyWithImpl<DatabaseError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DatabaseError &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.operation, operation) ||
                other.operation == operation));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, operation);

  @override
  String toString() {
    return 'AppError.database(message: $message, operation: $operation)';
  }
}

/// @nodoc
abstract mixin class $DatabaseErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $DatabaseErrorCopyWith(
          DatabaseError value, $Res Function(DatabaseError) _then) =
      _$DatabaseErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message, String? operation});
}

/// @nodoc
class _$DatabaseErrorCopyWithImpl<$Res>
    implements $DatabaseErrorCopyWith<$Res> {
  _$DatabaseErrorCopyWithImpl(this._self, this._then);

  final DatabaseError _self;
  final $Res Function(DatabaseError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? operation = freezed,
  }) {
    return _then(DatabaseError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      operation: freezed == operation
          ? _self.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class ValidationError implements AppError {
  const ValidationError(
      {required this.message, final Map<String, String> fieldErrors = const {}})
      : _fieldErrors = fieldErrors;

  @override
  final String message;
  final Map<String, String> _fieldErrors;
  @JsonKey()
  Map<String, String> get fieldErrors {
    if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fieldErrors);
  }

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ValidationErrorCopyWith<ValidationError> get copyWith =>
      _$ValidationErrorCopyWithImpl<ValidationError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ValidationError &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(_fieldErrors));

  @override
  String toString() {
    return 'AppError.validation(message: $message, fieldErrors: $fieldErrors)';
  }
}

/// @nodoc
abstract mixin class $ValidationErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $ValidationErrorCopyWith(
          ValidationError value, $Res Function(ValidationError) _then) =
      _$ValidationErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message, Map<String, String> fieldErrors});
}

/// @nodoc
class _$ValidationErrorCopyWithImpl<$Res>
    implements $ValidationErrorCopyWith<$Res> {
  _$ValidationErrorCopyWithImpl(this._self, this._then);

  final ValidationError _self;
  final $Res Function(ValidationError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? fieldErrors = null,
  }) {
    return _then(ValidationError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      fieldErrors: null == fieldErrors
          ? _self._fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class UnknownError implements AppError {
  const UnknownError({required this.message, this.originalError});

  @override
  final String message;
  final Object? originalError;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnknownErrorCopyWith<UnknownError> get copyWith =>
      _$UnknownErrorCopyWithImpl<UnknownError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnknownError &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(originalError));

  @override
  String toString() {
    return 'AppError.unknown(message: $message, originalError: $originalError)';
  }
}

/// @nodoc
abstract mixin class $UnknownErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $UnknownErrorCopyWith(
          UnknownError value, $Res Function(UnknownError) _then) =
      _$UnknownErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message, Object? originalError});
}

/// @nodoc
class _$UnknownErrorCopyWithImpl<$Res> implements $UnknownErrorCopyWith<$Res> {
  _$UnknownErrorCopyWithImpl(this._self, this._then);

  final UnknownError _self;
  final $Res Function(UnknownError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? originalError = freezed,
  }) {
    return _then(UnknownError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      originalError:
          freezed == originalError ? _self.originalError : originalError,
    ));
  }
}

// dart format on
