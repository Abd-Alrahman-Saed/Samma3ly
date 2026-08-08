import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/convert_to_session_button.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/core/widgets/score_display.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/enums/goal_status.dart';
import 'package:quran_mobile/domain/entities/goal.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/features/sessions/providers/session_provider.dart';
import 'package:quran_mobile/features/schedules/providers/schedule_provider.dart';
import 'package:quran_mobile/features/goals/providers/goal_provider.dart';
import 'package:quran_mobile/features/memorization/providers/memorization_provider.dart';
import 'package:quran_mobile/providers.dart';

class StudentDetailsScreen extends ConsumerWidget {
  final int studentId;

  const StudentDetailsScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentByIdProvider(studentId));

    return studentAsync.when(
      loading: () => const Scaffold(body: LoadingOverlay()),
      error: (e, st) => Scaffold(body: ErrorBanner(message: e.toString())),
      data: (student) {
        if (student == null) {
          return const Scaffold(body: Center(child: Text('الطالب غير موجود')));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(student.fullName),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'تعديل بيانات الطالب',
                onPressed: () => context.goNamed('studentEdit', pathParameters: {'id': '$studentId'}),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('معلومات الطالب', style: AppTextStyles.sectionTitle),
                      const Divider(),
                      _InfoRow(label: 'الاسم', value: student.fullName),
                      _InfoRow(label: 'العمر', value: '${student.age}'),
                      _InfoRow(label: 'رقم الهاتف', value: student.phone ?? '', isPhone: true),
                      _InfoRow(label: 'العنوان', value: student.address ?? ''),
                      _InfoRow(label: 'ولي الأمر', value: student.parentName ?? ''),
                      _InfoRow(label: 'هاتف ولي الأمر', value: student.parentPhone ?? '', isPhone: true),
                      _InfoRow(label: 'المستوى', value: student.level),
                      _InfoRow(label: 'الأجزاء المكتملة', value: '${student.totalCompletedJuz}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.playlist_add_check,
                      label: 'جلسة جديدة',
                      onTap: () => context.goNamed('sessionCreate', pathParameters: {'id': '$studentId'}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.schedule,
                      label: 'جدولة',
                      onTap: () => context.goNamed('scheduleCreateForStudent', pathParameters: {'id': '$studentId'}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.auto_stories,
                      label: 'الحفظ',
                      onTap: () => context.goNamed('memorization', pathParameters: {'id': '$studentId'}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.flag,
                      label: 'هدف جديد',
                      onTap: () => context.goNamed('goalCreate', pathParameters: {'id': '$studentId'}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('الجلسات القادمة', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              _StudentUpcomingSchedulesList(studentId: studentId),
              const SizedBox(height: 24),
              Text('الجلسات السابقة', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              _StudentSessionsList(studentId: studentId),
              const SizedBox(height: 24),
              Text('الأهداف', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              _StudentGoalsList(studentId: studentId),
            ],
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isPhone;

  const _InfoRow({required this.label, required this.value, this.isPhone = false});

  Future<void> _call(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: value.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: value.trim()));
    if (context.mounted) {
      AppSnackbar.info(context, 'تم نسخ الرقم');
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value.trim().isNotEmpty;
    final showPhone = isPhone && hasValue;
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 120, child: Text('$label:', style: AppTextStyles.infoLabel)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            hasValue ? value : '—',
            style: showPhone ? AppTextStyles.infoValue.copyWith(color: AppColors.primary) : AppTextStyles.infoValue,
          ),
        ),
        if (showPhone) const Icon(Icons.call, size: 16, color: AppColors.primary),
      ],
    );

    if (showPhone) {
      return InkWell(
        onTap: () => _call(context),
        onLongPress: () => _copy(context),
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: row),
      );
    }
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: row);
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 4),
              Text(label, style: AppTextStyles.small),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudentUpcomingSchedulesList extends ConsumerWidget {
  final int studentId;

  const _StudentUpcomingSchedulesList({required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(schedulesByStudentProvider(studentId));
    final surahsAsync = ref.watch(surahListProvider);
    return schedulesAsync.when(
      loading: () => const LoadingOverlay(),
      error: (e, _) => ErrorBanner(message: e.toString()),
      data: (schedules) {
        if (schedules.isEmpty) return Text('لا توجد جلسات قادمة', style: AppTextStyles.muted);
        final surahNames = <int, String>{
          for (final s in surahsAsync.valueOrNull ?? const []) s.id: s.name,
        };
        String surahLabel(int surahId) => surahNames[surahId] ?? 'سورة $surahId';
        return Column(
          children: schedules.map((s) => Card(
            child: ListTile(
              leading: const Icon(Icons.schedule, color: AppColors.primary),
              title: Text('${AppDateUtils.formatDate(s.date)} - ${s.time}', style: AppTextStyles.cardTitle),
              subtitle: s.memorizationSurahId != null
                  ? Text('حفظ مقرر: ${surahLabel(s.memorizationSurahId!)}', style: AppTextStyles.small)
                  : null,
              trailing: ConvertToSessionButton(
                scheduleId: s.id,
                onConverted: () {
                  ref.invalidate(schedulesByStudentProvider(studentId));
                  ref.invalidate(sessionsByStudentProvider(studentId));
                  ref.invalidate(studentByIdProvider(studentId));
                },
              ),
            ),
          )).toList(),
        );
      },
    );
  }
}

class _StudentSessionsList extends ConsumerWidget {
  final int studentId;

  const _StudentSessionsList({required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionsByStudentProvider(studentId));
    final surahsAsync = ref.watch(surahListProvider);
    return sessionsAsync.when(
      loading: () => const LoadingOverlay(),
      error: (e, _) => ErrorBanner(message: e.toString()),
      data: (sessions) {
        if (sessions.isEmpty) return Text('لا توجد جلسات', style: AppTextStyles.muted);
        final surahNames = <int, String>{
          for (final s in surahsAsync.valueOrNull ?? const []) s.id: s.name,
        };
        String surahLabel(int surahId) => surahNames[surahId] ?? 'سورة $surahId';
        return Column(
          children: sessions.take(5).map((s) => Card(
            child: InkWell(
              onTap: () => context.goNamed('sessionEdit', pathParameters: {'id': '${s.id}'}),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppDateUtils.formatDate(s.date), style: AppTextStyles.cardTitle),
                        if (s.evaluation != null)
                          ScoreDisplay(score: s.evaluation!.finalScore),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('الحضور: ${s.attendanceStatus}', style: AppTextStyles.small),
                    if (s.memorization != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'حفظ: ${surahLabel(s.memorization!.surahId)} (${s.memorization!.fromAyah}-${s.memorization!.toAyah})',
                          style: const TextStyle(fontSize: 12, color: AppColors.primary),
                        ),
                      ),
                    if (s.revision != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'مراجعة: ${surahLabel(s.revision!.surahId)} (${s.revision!.fromAyah}-${s.revision!.toAyah})',
                          style: const TextStyle(fontSize: 12, color: AppColors.secondary),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )).toList(),
        );
      },
    );
  }
}

class _StudentGoalsList extends ConsumerWidget {
  final int studentId;

  const _StudentGoalsList({required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsByStudentProvider(studentId));
    return goalsAsync.when(
      loading: () => const LoadingOverlay(),
      error: (e, _) => ErrorBanner(message: e.toString()),
      data: (goals) {
        if (goals.isEmpty) return Text('لا توجد أهداف', style: AppTextStyles.muted);
        return Column(
          children: goals.map((g) => Card(
            child: ListTile(
              title: Text(g.title),
              subtitle: Text(
                '${AppDateUtils.formatDate(g.startDate)}'
                '${g.targetDate != null ? ' → ${AppDateUtils.formatDate(g.targetDate!)}' : ''}',
                style: AppTextStyles.muted,
              ),
              trailing: _GoalStatusMenu(goal: g, studentId: studentId),
            ),
          )).toList(),
        );
      },
    );
  }
}

class _GoalStatusMenu extends ConsumerStatefulWidget {
  final Goal goal;
  final int studentId;

  const _GoalStatusMenu({required this.goal, required this.studentId});

  @override
  ConsumerState<_GoalStatusMenu> createState() => _GoalStatusMenuState();
}

class _GoalStatusMenuState extends ConsumerState<_GoalStatusMenu> {
  bool _isLoading = false;

  Future<void> _updateStatus(GoalStatus status) async {
    setState(() => _isLoading = true);
    try {
      await ref.read(goalRepositoryProvider).update(widget.goal.copyWith(status: status.arabic));
      ref.invalidate(goalsByStudentProvider(widget.studentId));
      ref.invalidate(goalListProvider);
      ref.invalidate(activeGoalListProvider);
    } catch (e) {
      if (mounted) {
        AppSnackbar.error(context, e);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = GoalStatus.fromArabic(widget.goal.status);
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return PopupMenuButton<GoalStatus>(
      onSelected: _updateStatus,
      itemBuilder: (context) => GoalStatus.values.map((s) => PopupMenuItem(
        value: s,
        child: Text(s.arabic),
      )).toList(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(status.icon, color: status.color),
              const SizedBox(width: 4),
              Text(widget.goal.status, style: AppTextStyles.small),
            ],
          ),
        ),
      ),
    );
  }
}
