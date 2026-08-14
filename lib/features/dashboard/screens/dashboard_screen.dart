import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/widgets/app_logo_mark.dart';
import 'package:quran_mobile/core/widgets/empty_state.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/kpi_card.dart';
import 'package:quran_mobile/core/widgets/score_display.dart';
import 'package:quran_mobile/core/widgets/session_card.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/domain/entities/dashboard_data.dart';
import 'package:quran_mobile/features/auth/providers/auth_provider.dart';
import 'package:quran_mobile/features/dashboard/providers/dashboard_provider.dart';
import 'package:quran_mobile/features/goals/providers/goal_provider.dart';
import 'package:quran_mobile/features/groups/providers/group_provider.dart';
import 'package:quran_mobile/features/memorization/providers/memorization_provider.dart';
import 'package:quran_mobile/features/schedules/providers/schedule_provider.dart';
import 'package:quran_mobile/features/sessions/providers/session_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final teacherName = ref.watch(currentUserProvider)?.fullName ?? '';

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(20),
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
                padding: EdgeInsets.zero,
                children: [
                  _Header(teacherName: teacherName),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _NewSessionButton(onTap: () => context.goNamed('sessionCreateStandalone')),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _KpiGrid(data: data),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _QuickLinks(),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text('أفضل 5 طلاب', style: TextStyle(fontFamily: 'Cairo', fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ),
                  const SizedBox(height: 10),
                  if (data.topStudents.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: EmptyState(
                        icon: Icons.leaderboard_outlined,
                        title: 'لا توجد بيانات كافية بعد',
                        description: 'سجّل جلسات مع تقييم لعرض ترتيب أفضل الطلاب',
                        card: true,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: data.topStudents.asMap().entries.map((entry) => _TopStudentRow(rank: entry.key + 1, student: entry.value)).toList(),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text('آخر الجلسات', style: TextStyle(fontFamily: 'Cairo', fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _RecentSessionsList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String teacherName;
  const _Header({required this.teacherName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('مرحباً بك', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(teacherName, style: const TextStyle(fontFamily: 'Reem Kufi', fontSize: 21, color: AppColors.textPrimary)),
              ],
            ),
          ),
          const AppLogoMark(size: 44, radius: 13, iconSize: 22, showBadge: false),
        ],
      ),
    );
  }
}

class _NewSessionButton extends StatelessWidget {
  final VoidCallback onTap;
  const _NewSessionButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppColors.onPrimary.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: AppIcon(AppIcons.plus, size: 18, color: AppColors.onPrimary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('تسجيل جلسة جديدة', style: TextStyle(fontFamily: 'Cairo', fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.onPrimary)),
                    const SizedBox(height: 2),
                    Text('حضور، حفظ، مراجعة وتقييم', style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.onPrimary.withValues(alpha: 0.75))),
                  ],
                ),
              ),
              AppIcon(AppIcons.chevronLeft, size: 16, color: AppColors.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  final DashboardData data;
  const _KpiGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: [
        KpiCard(icon: AppIcons.people, title: 'الطلاب', value: '${data.totalStudents}'),
        KpiCard(icon: AppIcons.calendarCheck, title: 'جلسات اليوم', value: '${data.todaySessions}'),
        KpiCard(icon: AppIcons.clock, title: 'الجلسات القادمة', value: '${data.upcomingSessions}'),
        KpiCard(icon: AppIcons.checkCircle, title: 'نسبة الحضور', value: '${data.averageAttendance.toStringAsFixed(0)}%'),
        KpiCard(icon: AppIcons.book, title: 'الصفحات المحفوظة', value: '${data.totalPagesMemorized}'),
        KpiCard(icon: AppIcons.star, title: 'السور المكتملة', value: '${data.totalSurahsCompleted}', iconColor: AppColors.accent),
      ],
    );
  }
}

class _QuickLinks extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeGoals = ref.watch(activeGoalListProvider).valueOrNull?.length;
    final upcomingSchedules = ref.watch(upcomingScheduleListProvider).valueOrNull?.length;
    final dueReview = ref.watch(dueForReviewProvider).valueOrNull?.length;
    final groupCount = ref.watch(groupCountProvider).valueOrNull;

    return Column(
      children: [
        _QuickLinkRow(
          icon: AppIcons.peopleTab,
          iconBg: const Color(0xFFE9F3EF),
          iconColor: AppColors.primary,
          label: 'الحلقات الجماعية',
          count: groupCount,
          onTap: () => context.goNamed('groupsList'),
        ),
        const SizedBox(height: 8),
        _QuickLinkRow(
          icon: AppIcons.calendarCheck,
          iconBg: const Color(0xFFE9F3EF),
          iconColor: AppColors.primary,
          label: 'التقويم الأسبوعي',
          count: null,
          onTap: () => context.goNamed('weeklyCalendar'),
        ),
        const SizedBox(height: 8),
        _QuickLinkRow(
          icon: AppIcons.flag,
          iconBg: const Color(0xFFE9F3EF),
          iconColor: AppColors.primary,
          label: 'الأهداف النشطة',
          count: activeGoals,
          onTap: () => context.goNamed('goalsList'),
        ),
        const SizedBox(height: 8),
        _QuickLinkRow(
          icon: AppIcons.clock,
          iconBg: const Color(0xFFFBF3DD),
          iconColor: AppColors.streakIconFg,
          label: 'الجداول القادمة',
          count: upcomingSchedules,
          onTap: () => context.goNamed('schedulesList'),
        ),
        const SizedBox(height: 8),
        _QuickLinkRow(
          icon: AppIcons.book,
          iconBg: AppColors.dividerLight,
          iconColor: AppColors.textSecondary,
          label: 'قائمة المراجعة',
          count: dueReview,
          onTap: () => context.goNamed('reviewQueue'),
        ),
      ],
    );
  }
}

class _QuickLinkRow extends StatelessWidget {
  final String icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final int? count;
  final VoidCallback onTap;

  const _QuickLinkRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: AppIcon(icon, size: 17, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ),
              if (count != null)
                Text('$count', style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
              const SizedBox(width: 4),
              AppIcon(AppIcons.chevronLeft, size: 15, color: AppColors.textDisabled),
            ],
          ),
        ),
      ),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.goNamed('studentDetails', pathParameters: {'id': '${student.studentId}'}),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              Semantics(
                label: 'الترتيب $rank',
                child: ExcludeSemantics(
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: badgeColors.bg, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text('$rank', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w800, color: badgeColors.fg)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(student.studentName, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ),
              if (isTop) ...[
                AppIcon(AppIcons.star, size: 14, color: AppColors.accent),
                const SizedBox(width: 6),
              ],
              ScoreDisplay(score: student.averageScore),
            ],
          ),
        ),
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
              studentId: s.studentId!,
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
