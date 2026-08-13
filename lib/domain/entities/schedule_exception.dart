import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_exception.freezed.dart';
part 'schedule_exception.g.dart';

@freezed
abstract class ScheduleException with _$ScheduleException {
  const factory ScheduleException({
    @Default(0) int id,
    required int groupScheduleSlotId,
    required DateTime occurrenceDate,

    /// 'إلغاء' أو 'إعادة جدولة' — راجع core/enums/schedule_exception_type.dart.
    @Default('إلغاء') String exceptionType,
    DateTime? newDate,
    String? newTime,
    DateTime? createdAt,
  }) = _ScheduleException;

  factory ScheduleException.fromJson(Map<String, dynamic> json) =>
      _$ScheduleExceptionFromJson(json);
}
