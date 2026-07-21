enum GoalStatus {
  notStarted('لم يبدأ'),
  inProgress('قيد التنفيذ'),
  completed('مكتمل');

  final String arabic;
  const GoalStatus(this.arabic);

  static GoalStatus fromArabic(String value) {
    return GoalStatus.values.firstWhere(
      (s) => s.arabic == value,
      orElse: () => GoalStatus.notStarted,
    );
  }
}
