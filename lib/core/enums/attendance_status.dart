enum AttendanceStatus {
  present('حاضر'),
  absent('غائب'),
  excused('معذور'),
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
