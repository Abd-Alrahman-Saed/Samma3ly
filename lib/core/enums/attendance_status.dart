enum AttendanceStatus {
  present('حاضر'),
  absent('غائب'),
  // "مستأذن" — matches the adopted design's exact wording (was "معذور"
  // before the design adoption; renamed here as the single source of
  // truth so every screen stays consistent). See docs/DESIGN_SPEC.md.
  excused('مستأذن'),
  late('متأخر');

  final String arabic;
  const AttendanceStatus(this.arabic);

  static AttendanceStatus fromArabic(String value) {
    return AttendanceStatus.values.firstWhere(
      (s) => s.arabic == value,
      orElse: () => AttendanceStatus.present,
    );
  }
}
