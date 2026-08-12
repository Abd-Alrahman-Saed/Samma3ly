enum SessionType {
  individual('فردي'),
  group('جماعي');

  final String arabic;
  const SessionType(this.arabic);

  static SessionType fromArabic(String value) {
    return SessionType.values.firstWhere(
      (s) => s.arabic == value,
      orElse: () => SessionType.individual,
    );
  }
}
