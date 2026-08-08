import 'package:flutter/material.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';

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

  IconData get icon => switch (this) {
        GoalStatus.completed => Icons.check_circle,
        GoalStatus.inProgress => Icons.hourglass_top,
        GoalStatus.notStarted => Icons.radio_button_unchecked,
      };

  Color get color => switch (this) {
        GoalStatus.completed => AppColors.success,
        GoalStatus.inProgress => AppColors.warning,
        GoalStatus.notStarted => AppColors.textMuted,
      };

  Color get backgroundColor => switch (this) {
        GoalStatus.completed => AppColors.successBg,
        GoalStatus.inProgress => AppColors.warningBg,
        GoalStatus.notStarted => AppColors.badgeGray,
      };
}
