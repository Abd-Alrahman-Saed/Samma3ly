import 'package:flutter/material.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/utils/grade_utils.dart';

/// Renders a 0–10 score consistently as "X.X/10", optionally with its
/// qualitative grade label, color-coded via [GradeUtils].
class ScoreDisplay extends StatelessWidget {
  final double score;
  final bool showGrade;
  final TextStyle? style;

  const ScoreDisplay({super.key, required this.score, this.showGrade = false, this.style});

  static Color colorFor(double score) => Color(int.parse(GradeUtils.colorForScore(score).replaceFirst('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    final text = showGrade ? '${score.toStringAsFixed(1)}/10 · ${GradeUtils.scoreToGrade(score)}' : '${score.toStringAsFixed(1)}/10';
    return Text(text, style: (style ?? AppTextStyles.score).copyWith(color: colorFor(score)));
  }
}
