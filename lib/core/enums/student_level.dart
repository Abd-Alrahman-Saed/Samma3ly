enum StudentLevel {
  beginner('مبتدئ'),
  intermediate('متوسط'),
  advanced('متقدم');

  final String arabic;
  const StudentLevel(this.arabic);

  static StudentLevel fromArabic(String value) {
    return StudentLevel.values.firstWhere(
      (s) => s.arabic == value,
      orElse: () => StudentLevel.beginner,
    );
  }
}
