import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/empty_state.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/kpi_card.dart';
import 'package:quran_mobile/core/widgets/score_display.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/domain/entities/dashboard_data.dart';
import 'package:quran_mobile/features/dashboard/providers/dashboard_provider.dart';
import 'package:quran_mobile/features/reports/widgets/attendance_trend_chart.dart';
import 'package:quran_mobile/features/reports/widgets/top_students_score_chart.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  String _summaryText(DashboardData data) {
    final buffer = StringBuffer()
      ..writeln('تقرير نظام إدارة وتحفيظ القرآن الكريم')
      ..writeln('إجمالي الطلاب: ${data.totalStudents}')
      ..writeln('إجمالي الجلسات: ${data.totalSessionsEver}')
      ..writeln('المعلمون: ${data.totalTeachers}')
      ..writeln('نسبة الحضور: ${data.averageAttendance.toStringAsFixed(0)}%')
      ..writeln('الصفحات المحفوظة: ${data.totalPagesMemorized}')
      ..writeln('السور المكتملة: ${data.totalSurahsCompleted}');
    if (data.topStudents.isNotEmpty) {
      buffer.writeln('\nأفضل الطلاب:');
      for (final s in data.topStudents) {
        buffer.writeln('- ${s.studentName}: ${s.averageScore.toStringAsFixed(1)}/10');
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final studentCountAsync = ref.watch(studentCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير'),
        actions: [
          if (dashboardAsync.hasValue)
            IconButton(
              icon: const Icon(Icons.ios_share),
              tooltip: 'مشاركة التقرير',
              onPressed: () => SharePlus.instance.share(
                ShareParams(text: _summaryText(dashboardAsync.value!), subject: 'تقرير نظام إدارة وتحفيظ القرآن الكريم'),
              ),
            ),
        ],
      ),
      body: dashboardAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              KpiGridSkeleton(),
              SizedBox(height: 24),
              Expanded(child: ListSkeleton(itemCount: 5)),
            ],
          ),
        ),
        error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(dashboardProvider)),
        data: (data) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('تقارير وإحصائيات شاملة عن أداء الطلاب والمعلمين', style: AppTextStyles.muted),
              const SizedBox(height: 12),
              Text('إحصائيات عامة', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: KpiCard(icon: AppIcons.people, title: 'إجمالي الطلاب', value: '${data.totalStudents}')),
                  const SizedBox(width: 12),
                  Expanded(child: KpiCard(icon: AppIcons.calendar, title: 'الجلسات', value: '${data.totalSessionsEver}')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: KpiCard(icon: AppIcons.person, title: 'المعلمون', value: '${data.totalTeachers}')),
                  const SizedBox(width: 12),
                  Expanded(child: KpiCard(icon: AppIcons.checkCircle, title: 'الحضور', value: '${data.averageAttendance.toStringAsFixed(0)}%')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: KpiCard(icon: AppIcons.book, title: 'الصفحات', value: '${data.totalPagesMemorized}')),
                  const SizedBox(width: 12),
                  Expanded(child: KpiCard(icon: AppIcons.star, title: 'السور', value: '${data.totalSurahsCompleted}')),
                ],
              ),
              const SizedBox(height: 24),
              Text('اتجاه الحضور الأسبوعي', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              if (data.weeklyAttendance.isEmpty)
                Text('لا توجد بيانات حضور كافية بعد', style: AppTextStyles.muted)
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                    child: AttendanceTrendChart(data: data.weeklyAttendance),
                  ),
                ),
              const SizedBox(height: 24),
              Text('أفضل 5 طلاب', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              if (data.topStudents.isEmpty)
                const EmptyState(
                  icon: Icons.leaderboard_outlined,
                  title: 'لا توجد بيانات كافية بعد',
                  description: 'سجّل جلسات مع تقييم لعرض ترتيب أفضل الطلاب',
                  card: true,
                )
              else ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                    child: TopStudentsScoreChart(students: data.topStudents),
                  ),
                ),
                const SizedBox(height: 8),
                ...data.topStudents.asMap().entries.map((entry) => Card(
                  child: ListTile(
                    leading: Semantics(
                      label: 'الترتيب ${entry.key + 1}',
                      child: ExcludeSemantics(
                        child: CircleAvatar(backgroundColor: AppColors.primary, child: Text('${entry.key + 1}', style: const TextStyle(color: Colors.white))),
                      ),
                    ),
                    title: Text(entry.value.studentName),
                    trailing: ScoreDisplay(score: entry.value.averageScore),
                    onTap: () => context.goNamed('studentDetails', pathParameters: {'id': '${entry.value.studentId}'}),
                  ),
                )),
              ],
            ],
          );
        },
      ),
    );
  }
}
