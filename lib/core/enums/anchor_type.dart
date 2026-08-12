/// How a [GroupScheduleSlots] row's daily time is anchored — a fixed
/// clock time, or an offset from a prayer time (item 2.3).
enum AnchorType {
  fixedTime('وقت محدد'),
  prayer('مرتبط بصلاة');

  final String arabic;
  const AnchorType(this.arabic);

  static AnchorType fromArabic(String value) {
    return AnchorType.values.firstWhere(
      (s) => s.arabic == value,
      orElse: () => AnchorType.fixedTime,
    );
  }
}
