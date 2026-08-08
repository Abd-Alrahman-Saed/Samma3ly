import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/empty_state.dart';
import 'package:quran_mobile/core/widgets/kpi_card.dart';
import 'package:quran_mobile/core/widgets/score_display.dart';
import 'package:quran_mobile/core/widgets/session_card.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/features/dashboard/providers/dashboard_provider.dart';
import 'package:quran_mobile/features/memorization/providers/memorization_provider.dart';
import 'package:quran_mobile/features/sessions/providers/session_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final dueReviewAsync = ref.watch(dueForReviewProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية')),
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
          return RefreshIndicator(
            onRefresh: () => ref.refresh(dashboardProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('نظرة عامة على الطلاب والجلسات وتقدم الحفظ', style: AppTextStyles.muted),
                const SizedBox(height: 16),
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
                    Expanded(child: KpiCard(icon: Icons.auto_stories, title: 'الصفحات المحفوظة', value: '${data.totalPagesMemorized}')),
                    const SizedBox(width: 12),
                    Expanded(child: KpiCard(icon: Icons.star, title: 'السور المكتملة', value: '${data.totalSurahsCompleted}')),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.flag_outlined, color: AppColors.primary),
                    title: const Text('الأهداف النشطة'),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () => context.goNamed('goalsList'),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.schedule_outlined, color: AppColors.primary),
                    title: const Text('الجداول القادمة'),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () => context.goNamed('schedulesList'),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.event_available_outlined, color: AppColors.primary),
                    title: const Text('قائمة المراجعة'),
                    subtitle: dueReviewAsync.when(
                      data: (items) => Text(items.isEmpty ? 'لا توجد مراجعات مستحقة' : '${items.length} مراجعة مستحقة'),
                      loading: () => null,
                      error: (_, __) => null,
                    ),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () => context.goNamed('reviewQueue'),
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
                else
                  ...data.topStudents.asMap().entries.map((entry) => Card(
                    child: ListTile(
                      leading: Semantics(
                        label: 'الترتيب ${entry.key + 1}',
                        child: ExcludeSemantics(
                          child: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text('${entry.key + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      title: Text(entry.value.studentName),
                      trailing: ScoreDisplay(score: entry.value.averageScore),
                      onTap: () => context.goNamed('studentDetails', pathParameters: {'id': '${entry.value.studentId}'}),
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
    final studentsAsync = ref.watch(studentListProvider);
    final surahsAsync = ref.watch(surahListProvider);
    return sessionsAsync.when(
      loading: () => const SizedBox(height: 320, child: ListSkeleton(itemCount: 3)),
      error: (e, _) => ErrorBanner(message: e.toString()),
      data: (sessions) {
        if (sessions.isEmpty) {
          return EmptyState(
            icon: Icons.calendar_today_outlined,
            title: 'لا توجد جلسات بعد',
            description: 'ابدأ بتسجيل أول جلسة لأحد الطلاب',
            card: true,
            ctaLabel: 'إضافة جلسة',
            onCta: () => context.goNamed('sessionCreateStandalone'),
          );
        }
        final studentNames = <int, String>{
          for (final s in studentsAsync.valueOrNull ?? const []) s.id: s.fullName,
        };
        final surahNames = <int, String>{
          for (final s in surahsAsync.valueOrNull ?? const []) s.id: s.name,
        };
        String surahLabel(int surahId) => surahNames[surahId] ?? 'سورة $surahId';
        final recent = sessions.take(5).toList();
        return Column(
          children: recent.map((s) => SessionCard(
            item: SessionCardItem(
              id: s.id,
              studentId: s.studentId,
              studentName: studentNames[s.studentId] ?? 'طالب رقم ${s.studentId}',
              initials: (studentNames[s.studentId] ?? 'ط').substring(0, 1),
              date: s.date,
              timeDisplay: s.time,
              attendanceStatus: s.attendanceStatus,
              finalScore: s.evaluation?.finalScore ?? 0,
              memorizationInfo: s.memorization != null ? 'حفظ: ${surahLabel(s.memorization!.surahId)} (${s.memorization!.fromAyah}-${s.memorization!.toAyah})' : '',
              revisionInfo: s.revision != null ? 'مراجعة: ${surahLabel(s.revision!.surahId)} (${s.revision!.fromAyah}-${s.revision!.toAyah})' : '',
            ),
            onTap: () => context.goNamed('sessionEdit', pathParameters: {'id': '${s.id}'}),
          )).toList(),
        );
      },
    );
  }
}
