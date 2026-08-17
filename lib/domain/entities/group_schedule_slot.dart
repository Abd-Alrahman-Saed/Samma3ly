import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_schedule_slot.freezed.dart';
part 'group_schedule_slot.g.dart';

@freezed
abstract class GroupScheduleSlot with _$GroupScheduleSlot {
  const factory GroupScheduleSlot({
    @Default(0) int id,
    required int groupId,

    /// ١ (الاثنين) إلى ٧ (الأحد) — مطابق لـ DateTime.weekday.
    required int weekday,

    /// HH:mm. كان اختيارياً قبل حذف ميزة "مرتبط بصلاة" (راجع
    /// docs/IMPLEMENTATION_PLAN.md) — الآن هو التوقيت الوحيد لأي موعد.
    String? fixedTime,
    required DateTime effectiveFrom,
    DateTime? effectiveTo,
    DateTime? createdAt,
  }) = _GroupScheduleSlot;

  factory GroupScheduleSlot.fromJson(Map<String, dynamic> json) =>
      _$GroupScheduleSlotFromJson(json);
}
