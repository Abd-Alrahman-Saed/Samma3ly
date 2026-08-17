import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quran_mobile/core/enums/goal_status.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/convert_to_session_button.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/core/widgets/score_display.dart';
import 'package:quran_mobile/domain/entities/goal.dart';
import 'package:quran_mobile/domain/entities/student.dart';
import 'package:quran_mobile/domain/services/juz_quarter_progress_service.dart';
import 'package:quran_mobile/features/goals/providers/goal_provider.dart';
import 'package:quran_mobile/features/goals/screens/goal_form_sheet.dart';
import 'package:quran_mobile/features/memorization/providers/juz_quarter_progress_provider.dart';
import 'package:quran_mobile/features/schedules/providers/schedule_provider.dart';
import 'package:quran_mobile/features/schedules/screens/schedule_form_sheet.dart';
import 'package:quran_mobile/features/sessions/providers/session_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

class StudentDetailsScreen extends ConsumerWidget {
  final int studentId;

  const StudentDetailsScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentByIdProvider(studentId));
    final surahsAsync = ref.watch(surahListProvider);

    return studentAsync.when(
      loading: () => const Scaffold(body: LoadingOverlay()),
      error: (e, st) => Scaffold(body: ErrorBanner(message: e.toString())),
      data: (student) {
        if (student == null) {
          return const Scaffold(body: Center(child: Text('الطالب غير موجود')));
        }
        final currentSurahName = student.currentSurahId != null
            ? (surahsAsync.valueOrNull ?? const []).where((s) => s.id == student.currentSurahId).firstOrNull?.name
            : null;
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      _RoundIconButton(icon: AppIcons.chevronRight, onTap: () => context.pop()),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(student.fullName, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge),
                      ),
                      const SizedBox(width: 10),
                      _RoundIconButton(icon: AppIcons.edit, onTap: () => context.goNamed('studentEdit', pathParameters: {'id': '$studentId'})),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileCard(student: student, currentSurahName: currentSurahName),
                      if ((student.phone).trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _PhoneRow(student: student),
                      ],
                      const SizedBox(height: 12),
                      _QuranMemorizationCard(studentId: studentId),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _QuickAction(
                              icon: AppIcons.calendar,
                              label: 'جلسة جديدة',
                              onTap: () => context.goNamed('sessionCreate', pathParameters: {'id': '$studentId'}),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _QuickAction(
                              icon: AppIcons.clock,
                              label: 'جدولة',
                              onTap: () => ScheduleFormSheet.show(context, studentId: studentId),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _QuickAction(
                              icon: AppIcons.flag,
                              label: 'هدف جديد',
                              onTap: () => GoalFormSheet.show(context, studentId: studentId),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      const Text('الجلسات القادمة', style: TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      _StudentUpcomingSchedulesList(studentId: studentId),
                      const SizedBox(height: 22),
                      const Text('الجلسات السابقة', style: TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      _StudentSessionsList(studentId: studentId),
                      const SizedBox(height: 22),
                      const Text('الأهداف', style: TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      _StudentGoalsList(studentId: studentId),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
          child: AppIcon(icon, size: 15, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Student student;
  final String? currentSurahName;

  const _ProfileCard({required this.student, required this.currentSurahName});

  @override
  Widget build(BuildContext context) {
    final levelColors = StatusColors.forLevel(student.level);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Text(
              student.fullName.isNotEmpty ? student.fullName[0] : '؟',
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.onPrimary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(color: levelColors.bg, borderRadius: BorderRadius.circular(999)),
                      child: Text(student.level, style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, fontWeight: FontWeight.w700, color: levelColors.fg)),
                    ),
                    const SizedBox(width: 8),
                    Text('${student.age} سنة', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 6),
                // القسم ح.7: عدد الأجزاء المكتملة (المُشتقّ آلياً من
                // الجلسات) أُزيل من هنا — بطاقة "المحفوظ من القرآن" أسفل
                // هذه البطاقة مباشرة (القسم ح.2) هي المصدر الوحيد الآن
                // لتقدّم الحفظ، يحدّدها المعلّم يدوياً بالجزء/الربع.
                Text(
                  'السورة الحالية: ${currentSurahName ?? '—'}',
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// القسم ح.2 — تتبّع الحفظ اليدوي بالجزء/الربع (المعلّم هو اللي يعلّم كل
/// ربع، لا حساب تلقائي من بيانات الجلسات). الضغط يفتح JuzProgressScreen
/// (قائمة الـ30 جزء) ثم كل جزء أرباعه الثمانية.
class _QuranMemorizationCard extends ConsumerWidget {
  final int studentId;

  const _QuranMemorizationCard({required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedAsync = ref.watch(juzQuarterProgressProvider(studentId));
    final percentage = completedAsync.valueOrNull != null ? JuzQuarterProgressService.overallPercentage(completedAsync.value!) : 0.0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => context.goNamed('juzProgress', pathParameters: {'id': '$studentId'}),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                child: const AppIcon(AppIcons.book, size: 17, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('المحفوظ من القرآن', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        minHeight: 5,
                        backgroundColor: AppColors.dividerLight,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text('${percentage.toStringAsFixed(0)}%', style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
              const SizedBox(width: 4),
              const AppIcon(AppIcons.chevronLeft, size: 13, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class _PhoneRow extends StatelessWidget {
  final Student student;

  const _PhoneRow({required this.student});

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: student.phone.trim());
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: student.phone.trim()));
    if (context.mounted) AppSnackbar.info(context, 'تم نسخ الرقم');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _call,
      onLongPress: () => _copy(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
        child: Row(
          children: [
            const AppIcon(AppIcons.phone, size: 15, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(student.phone, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
            const Spacer(),
            if ((student.parentName ?? '').trim().isNotEmpty)
              Text('ولي الأمر: ${student.parentName}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
          child: Column(
            children: [
              AppIcon(icon, size: 18, color: AppColors.primary),
              const SizedBox(height: 5),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
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
        if (schedules.isEmpty) {
          return const Text('لا توجد جلسات قادمة', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary));
        }
        final surahNames = <int, String>{for (final s in surahsAsync.valueOrNull ?? const []) s.id: s.name};
        String surahLabel(int surahId) => surahNames[surahId] ?? 'سورة $surahId';
        return Column(
          children: schedules
              .map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
                      child: Row(
                        children: [
                          const AppIcon(AppIcons.clock, size: 15, color: AppColors.streakIconFg),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${AppDateUtils.formatDate(s.date)} - ${s.time}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                if (s.memorizationSurahId != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text('حفظ مقرر: ${surahLabel(s.memorizationSurahId!)}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textSecondary)),
                                  ),
                              ],
                            ),
                          ),
                          ConvertToSessionButton(
                            scheduleId: s.id,
                            onConverted: () {
                              ref.invalidate(schedulesByStudentProvider(studentId));
                              ref.invalidate(sessionsByStudentProvider(studentId));
                              ref.invalidate(studentByIdProvider(studentId));
                            },
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
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
        if (sessions.isEmpty) {
          return const Text('لا توجد جلسات', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary));
        }
        final surahNames = <int, String>{for (final s in surahsAsync.valueOrNull ?? const []) s.id: s.name};
        String surahLabel(int surahId) => surahNames[surahId] ?? 'سورة $surahId';
        return Column(
          children: sessions.take(5).map((s) {
            final statusColors = StatusColors.forAttendance(s.attendanceStatus);
            // القسم ح.12: نفس منطق ألوان SessionCard — "يُعاد" تحذيري،
            // "اجتاز" نجاح.
            final outcomeColors = s.recitationOutcome == 'يُعاد' ? StatusColors.attendanceLate : StatusColors.present;
            final revisionFinalScore = s.evaluation?.revisionFinalScore ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  // القسم ح.10: جلسة الحلقة (groupId != null) تفتح شاشة
                  // تسميع الطالب داخل الحلقة (لا شاشة الجلسة الفردية —
                  // تفترض طالباً واحداً، لا تعرف شيئاً عن هذه الجلسة).
                  onTap: () => s.groupId != null
                      ? context.goNamed('groupStudentRecitation', pathParameters: {
                          'id': '${s.groupId}',
                          'sessionId': '${s.id}',
                          'studentId': '$studentId',
                        })
                      : context.goNamed('sessionEdit', pathParameters: {'id': '${s.id}'}),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppDateUtils.formatDate(s.date), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                            Row(
                              children: [
                                if (s.evaluation != null) ...[
                                  ScoreDisplay(score: s.evaluation!.finalScore),
                                  const SizedBox(width: 8),
                                ],
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(color: statusColors.bg, borderRadius: BorderRadius.circular(999)),
                                  child: Text(s.attendanceStatus, style: TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w700, color: statusColors.fg)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // القسم ح.12: "معلومات الجلسة الخارجية" — القرار
                        // السريع (اجتاز/يُعاد) ودرجة المراجعة المنفصلة،
                        // بدون فتح الجلسة.
                        if (s.recitationOutcome != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(color: outcomeColors.bg, borderRadius: BorderRadius.circular(999)),
                                  child: Text(s.recitationOutcome!, style: TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w700, color: outcomeColors.fg)),
                                ),
                                if (revisionFinalScore > 0) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                    decoration: BoxDecoration(color: const Color(0xFFE9F3EF), borderRadius: BorderRadius.circular(999)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('مراجعة', style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.streakIconFg)),
                                        const SizedBox(width: 4),
                                        ScoreDisplay(score: revisionFinalScore, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        if (s.memorization != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'حفظ: ${surahLabel(s.memorization!.surahId)} (${s.memorization!.fromAyah}-${s.memorization!.toAyah})',
                              style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.primary),
                            ),
                          ),
                        if (s.revision != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              'مراجعة: ${surahLabel(s.revision!.surahId)} (${s.revision!.fromAyah}-${s.revision!.toAyah})',
                              style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.streakIconFg),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
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
        if (goals.isEmpty) {
          return const Text('لا توجد أهداف', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary));
        }
        return Column(
          children: goals
              .map((g) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(g.title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                const SizedBox(height: 4),
                                Text(
                                  '${AppDateUtils.formatDate(g.startDate)}'
                                  '${g.targetDate != null ? ' → ${AppDateUtils.formatDate(g.targetDate!)}' : ''}',
                                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          _GoalStatusMenu(goal: g, studentId: studentId),
                        ],
                      ),
                    ),
                  ))
              .toList(),
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
      if (mounted) AppSnackbar.error(context, e);
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
        child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return PopupMenuButton<GoalStatus>(
      onSelected: _updateStatus,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: AppColors.inputBorder)),
      color: Colors.white,
      elevation: 6,
      itemBuilder: (context) => GoalStatus.values
          .map((s) => PopupMenuItem(
                value: s,
                child: Text(s.arabic, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textPrimary)),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: status.backgroundColor, borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.goal.status, style: TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w700, color: status.color)),
            const SizedBox(width: 3),
            AppIcon(AppIcons.chevronDown, size: 10, color: status.color),
          ],
        ),
      ),
    );
  }
}
