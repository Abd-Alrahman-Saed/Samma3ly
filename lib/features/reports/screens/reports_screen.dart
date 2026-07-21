import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/core/widgets/kpi_card.dart';
import 'package:quran_mobile/features/dashboard/providers/dashboard_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final studentCountAsync = ref.watch(studentCountProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('التقارير')),
      body: dashboardAsync.when(
        loading: () => const LoadingOverlay(),
        error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(dashboardProvider)),
        data: (data) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('إحصائيات عامة', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: KpiCard(icon: Icons.people, title: 'إجمالي الطلاب', value: '${data.totalStudents}')),
                  const SizedBox(width: 12),
                  Expanded(child: KpiCard(icon: Icons.calendar_today, title: 'الجلسات', value: '${data.totalSessionsEver}')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: KpiCard(icon: Icons.person, title: 'المعلمون', value: '${data.totalTeachers}')),
                  const SizedBox(width: 12),
                  Expanded(child: KpiCard(icon: Icons.check_circle, title: 'الحضور', value: '${data.averageAttendance.toStringAsFixed(0)}%')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: KpiCard(icon: Icons.auto_stories, title: 'الأجزاء', value: '${data.totalPagesMemorized}')),
                  const SizedBox(width: 12),
                  Expanded(child: KpiCard(icon: Icons.star, title: 'السور', value: '${data.totalSurahsCompleted}')),
                ],
              ),
              const SizedBox(height: 24),
              Text('أفضل 5 طلاب', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              if (data.topStudents.isEmpty)
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('لا توجد بيانات', style: AppTextStyles.muted)))
              else
                ...data.topStudents.asMap().entries.map((entry) => Card(
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: AppColors.primary, child: Text('${entry.key + 1}', style: const TextStyle(color: Colors.white))),
                    title: Text(entry.value.studentName),
                    trailing: Text('${entry.value.averageScore.toStringAsFixed(1)}%', style: AppTextStyles.score),
                  ),
                )),
            ],
          );
        },
      ),
    );
  }
}
