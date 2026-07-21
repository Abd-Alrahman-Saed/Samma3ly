enum GoalType {
  surah('سورة'),
  juz('جزء');

  final String arabic;
  const GoalType(this.arabic);

  static GoalType fromArabic(String value) {
    return GoalType.values.firstWhere(
      (s) => s.arabic == value,
      orElse: () => GoalType.surah,
    );
  }
}
