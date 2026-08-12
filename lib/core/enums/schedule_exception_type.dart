/// A single-occurrence override for a recurring [GroupScheduleSlots] row —
/// either skip that date entirely, or move it to a different date/time.
enum ScheduleExceptionType {
  skip('إلغاء'),
  reschedule('إعادة جدولة');

  final String arabic;
  const ScheduleExceptionType(this.arabic);

  static ScheduleExceptionType fromArabic(String value) {
    return ScheduleExceptionType.values.firstWhere(
      (s) => s.arabic == value,
      orElse: () => ScheduleExceptionType.skip,
    );
  }
}
