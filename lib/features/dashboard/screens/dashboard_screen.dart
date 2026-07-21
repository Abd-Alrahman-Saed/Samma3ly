import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/kpi_card.dart';
import 'package:quran_mobile/core/widgets/session_card.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/features/dashboard/providers/dashboard_provider.dart';
import 'package:quran_mobile/features/sessions/providers/session_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية')),
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(dashboardProvider)),
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(dashboardProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(child: KpiCard(icon: Icons.people, title: 'الطلاب', value: '${data.totalStudents}')),
                    const SizedBox(width: 12),
                    Expanded(child: KpiCard(icon: Icons.today, title: 'جلسات اليوم', value: '${data.todaySessions}')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: KpiCard(icon: Icons.schedule, title: 'الجلسات القادمة', value: '${data.upcomingSessions}')),
                    const SizedBox(width: 12),
                    Expanded(child: KpiCard(icon: Icons.check_circle, title: 'نسبة الحضور', value: '${data.averageAttendance.toStringAsFixed(0)}%')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: KpiCard(icon: Icons.auto_stories, title: 'الأجزاء المكتملة', value: '${data.totalPagesMemorized}')),
                    const SizedBox(width: 12),
                    Expanded(child: KpiCard(icon: Icons.star, title: 'السور المكتملة', value: '${data.totalSurahsCompleted}')),
                  ],
                ),
                const SizedBox(height: 24),
                Text('أفضل 5 طلاب', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 8),
                if (data.topStudents.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('لا توجد بيانات', style: AppTextStyles.muted),
                    ),
                  )
                else
                  ...data.topStudents.asMap().entries.map((entry) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text('${entry.key + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(entry.value.studentName),
                      trailing: Text('${entry.value.averageScore.toStringAsFixed(0)}%', style: AppTextStyles.score),
                    ),
                  )),
                const SizedBox(height: 24),
                Text('آخر الجلسات', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 8),
                _RecentSessionsList(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RecentSessionsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionListProvider);
    return sessionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorBanner(message: e.toString()),
      data: (sessions) {
        if (sessions.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('لا توجد جلسات', style: AppTextStyles.muted),
            ),
          );
        }
        final recent = sessions.take(5).toList();
        return Column(
          children: recent.map((s) => SessionCard(
            item: SessionCardItem(
              id: s.id,
              studentId: s.studentId,
              studentName: 'طالب رقم ${s.studentId}',
              initials: 'ط',
              date: s.date,
              timeDisplay: s.time,
              attendanceStatus: s.attendanceStatus,
              finalScore: s.evaluation?.finalScore ?? 0,
              memorizationInfo: s.memorization != null ? 'حفظ: سورة ${s.memorization!.surahId} (${s.memorization!.fromAyah}-${s.memorization!.toAyah})' : '',
              revisionInfo: s.revision != null ? 'مراجعة: سورة ${s.revision!.surahId} (${s.revision!.fromAyah}-${s.revision!.toAyah})' : '',
            ),
            onTap: () => context.goNamed('sessionEdit', pathParameters: {'id': '${s.id}'}),
          )).toList(),
        );
      },
    );
  }
}
