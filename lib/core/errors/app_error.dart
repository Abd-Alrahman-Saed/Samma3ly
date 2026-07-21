import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
sealed class AppError with _$AppError {
  const factory AppError.database({
    required String message,
    String? operation,
  }) = DatabaseError;

  const factory AppError.validation({
    required String message,
    @Default({}) Map<String, String> fieldErrors,
  }) = ValidationError;

  const factory AppError.unknown({
    required String message,
    Object? originalError,
  }) = UnknownError;
}
