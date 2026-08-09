import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/domain/entities/dashboard_data.dart';

/// Top-5-students ranking — exact layout from the adopted design: rank
/// badge, name, a thin inline progress bar, then the score. Not a bar
/// chart in the design source, so this isn't one either. See
/// docs/DESIGN_SPEC.md.
class TopStudentsScoreChart extends StatelessWidget {
  final List<DashboardTopStudent> students;

  const TopStudentsScoreChart({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        for (var i = 0; i < students.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == students.length - 1 ? 0 : 8),
            child: _TopStudentRow(rank: i + 1, student: students[i]),
          ),
      ],
    );
  }
}

class _TopStudentRow extends StatelessWidget {
  final int rank;
  final DashboardTopStudent student;

  const _TopStudentRow({required this.rank, required this.student});

  @override
  Widget build(BuildContext context) {
    final isTop = rank == 1;
    final badgeColors = isTop ? (bg: AppColors.streakBg, fg: AppColors.streakIconFg) : (bg: const Color(0xFFE9F3EF), fg: AppColors.primary);
    final scorePct = (student.averageScore / 10 * 100).clamp(0, 100).toDouble();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.goNamed('studentDetails', pathParameters: {'id': '${student.studentId}'}),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
          child: Row(
            children: [
              Semantics(
                label: 'الترتيب $rank',
                child: ExcludeSemantics(
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(color: badgeColors.bg, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text('$rank', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w800, color: badgeColors.fg)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(student.studentName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 70,
                height: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: scorePct / 100,
                    backgroundColor: AppColors.dividerLight,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 28,
                child: Text(student.averageScore.toStringAsFixed(1), textAlign: TextAlign.left, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
