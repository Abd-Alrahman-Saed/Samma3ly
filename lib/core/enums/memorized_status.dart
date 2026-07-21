enum MemorizedStatus {
  memorized('محفوظ'),
  needsRevision('يحتاج مراجعة'),
  notMemorized('غير محفوظ');

  final String arabic;
  const MemorizedStatus(this.arabic);

  static MemorizedStatus fromArabic(String value) {
    return MemorizedStatus.values.firstWhere(
      (s) => s.arabic == value,
      orElse: () => MemorizedStatus.notMemorized,
    );
  }

  static String color(String status) {
    return switch (status) {
      'محفوظ' => '#22C55E',
      'يحتاج مراجعة' => '#F97316',
      _ => '#94A3B8',
    };
  }
}
