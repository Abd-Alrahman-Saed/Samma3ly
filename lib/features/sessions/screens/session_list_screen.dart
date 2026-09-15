import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/utils/quran_utils.dart';
import 'package:quran_mobile/core/widgets/confirm_delete.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/session_card.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/core/widgets/staggered_list_item.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Session;
import 'package:quran_mobile/domain/entities/session.dart';
import 'package:quran_mobile/features/sessions/providers/session_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

class SessionListScreen extends ConsumerStatefulWidget {
  const SessionListScreen({super.key});

  @override
  ConsumerState<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends ConsumerState<SessionListScreen> {
  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final current = ref.read(sessionDateFilterProvider);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: current ?? DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      ref.read(sessionDateFilterProvider.notifier).state = picked;
    }
  }

  void _clearDateRange() {
    ref.read(sessionDateFilterProvider.notifier).state = null;
  }

  Future<void> _deleteSession(Session session) async {
    final studentName = ref.read(studentListProvider).valueOrNull?.where((s) => s.id == session.studentId).firstOrNull?.fullName ?? 'الطالب';
    final confirmed = await confirmDelete(context, message: 'هل أنت متأكد من حذف جلسة "$studentName"؟');
    if (!confirmed) return;
    final dao = ref.read(sessionDaoProvider);
    await ref.read(sessionRepositoryProvider).delete(session.id);
    ref.invalidate(sessionListProvider);
    if (session.studentId != null) ref.invalidate(sessionsByStudentProvider(session.studentId!));
    if (!mounted) return;
    showUndoSnackbar(context, 'تم حذف الجلسة', () async {
      await dao.insert(SessionsCompanion(
        id: Value(session.id),
        studentId: Value(session.studentId),
        date: Value(session.date),
        time: Value(session.time),
        notes: Value(session.notes),
        createdAt: Value(session.createdAt ?? DateTime.now()),
      ));
      if (session.studentId != null) {
        await dao.upsertAttendance(session.id, session.studentId!, session.attendanceStatus);
      }
      final mem = session.memorization;
      if (mem != null) {
        await dao.insertMemorization(SessionMemorizationsCompanion(
          sessionId: Value(session.id),
          surahId: Value(mem.surahId),
          fromAyah: Value(mem.fromAyah),
          toAyah: Value(mem.toAyah),
          isFullSurah: Value(mem.isFullSurah),
        ));
      }
      for (var i = 0; i < session.revisions.length; i++) {
        final rev = session.revisions[i];
        await dao.insertRevision(SessionRevisionsCompanion(
          sessionId: Value(session.id),
          surahId: Value(rev.surahId),
          fromAyah: Value(rev.fromAyah),
          toAyah: Value(rev.toAyah),
          label: Value(rev.label),
          isFullSurah: Value(rev.isFullSurah),
          sortOrder: Value(i),
          memorizationScore: Value(rev.memorizationScore),
          tajweedScore: Value(rev.tajweedScore),
          fluencyScore: Value(rev.fluencyScore),
          accuracyScore: Value(rev.accuracyScore),
        ));
      }
      final eval = session.evaluation;
      if (eval != null) {
        await dao.insertEvaluation(SessionEvaluationsCompanion(
          sessionId: Value(session.id),
          memorizationScore: Value(eval.memorizationScore),
          tajweedScore: Value(eval.tajweedScore),
          fluencyScore: Value(eval.fluencyScore),
          accuracyScore: Value(eval.accuracyScore),
        ));
      }
      ref.invalidate(sessionListProvider);
      if (session.studentId != null) ref.invalidate(sessionsByStudentProvider(session.studentId!));
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(sessionListProvider);
    final surahsAsync = ref.watch(surahListProvider);
    final studentsAsync = ref.watch(studentListProvider);
    final timeFilter = ref.watch(sessionTimeFilterProvider);
    final dateFilter = ref.watch(sessionDateFilterProvider);
    final surahNames = <int, String>{for (final s in surahsAsync.valueOrNull ?? const []) s.id: s.name};
    final studentNames = <int, String>{for (final s in studentsAsync.valueOrNull ?? const []) s.id: s.fullName};
    String surahLabel(int surahId) => surahNames[surahId] ?? 'سورة $surahId';

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الجلسات', style: Theme.of(context).textTheme.headlineSmall),
                      IconButton(
                        icon: const AppIcon(AppIcons.calendar, size: 18, color: AppColors.textSecondary),
                        tooltip: 'تصفية حسب التاريخ',
                        onPressed: _pickDateRange,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: Row(
                    children: [
                      Expanded(child: _FilterTab(label: 'الكل', selected: timeFilter == SessionTimeFilter.all, onTap: () => ref.read(sessionTimeFilterProvider.notifier).state = SessionTimeFilter.all)),
                      const SizedBox(width: 8),
                      Expanded(child: _FilterTab(label: 'سابقة', selected: timeFilter == SessionTimeFilter.past, onTap: () => ref.read(sessionTimeFilterProvider.notifier).state = SessionTimeFilter.past)),
                      const SizedBox(width: 8),
                      Expanded(child: _FilterTab(label: 'قادمة', selected: timeFilter == SessionTimeFilter.upcoming, onTap: () => ref.read(sessionTimeFilterProvider.notifier).state = SessionTimeFilter.upcoming)),
                    ],
                  ),
                ),
                if (dateFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Chip(
                        label: Text(
                          '${AppDateUtils.formatDate(dateFilter.start)} - ${AppDateUtils.formatDate(dateFilter.end)}',
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5),
                        ),
                        onDeleted: _clearDateRange,
                        deleteIconColor: AppColors.textSecondary,
                      ),
                    ),
                  ),
                Expanded(
                  child: sessionsAsync.when(
                    loading: () => const ListSkeleton(),
                    error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(sessionListProvider)),
                    data: (allSessions) {
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      final sessions = allSessions.where((s) {
                        final sDate = DateTime(s.date.year, s.date.month, s.date.day);
                        switch (timeFilter) {
                          case SessionTimeFilter.past:
                            return sDate.isBefore(today);
                          case SessionTimeFilter.upcoming:
                            return !sDate.isBefore(today);
                          case SessionTimeFilter.all:
                            return true;
                        }
                      }).toList();
                      if (sessions.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(color: Color(0xFFE9F3EF), shape: BoxShape.circle),
                                child: const AppIcon(AppIcons.calendar, size: 26, color: AppColors.primary),
                              ),
                              const SizedBox(height: 14),
                              Text('لا توجد جلسات', style: Theme.of(context).textTheme.titleSmall),
                            ],
                          ),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () => ref.refresh(sessionListProvider.future),
                        child: AnimationLimiter(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 90),
                            itemCount: sessions.length,
                            itemBuilder: (_, i) {
                              final session = sessions[i];
                              final studentName = studentNames[session.studentId] ?? 'طالب رقم ${session.studentId}';
                              return StaggeredListItem(
                                index: i,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: SessionCard(
                                    item: SessionCardItem(
                                      id: session.id,
                                      studentId: session.studentId!,
                                      studentName: studentName,
                                      initials: studentName.substring(0, 1),
                                      date: session.date,
                                      timeDisplay: session.time,
                                      attendanceStatus: session.attendanceStatus,
                                      finalScore: session.evaluation?.finalScore ?? 0,
                                      memorizationInfo: session.memorization != null
                                          ? 'حفظ: ${surahLabel(session.memorization!.surahId)} ${QuranUtils.rangeLabel(fromAyah: session.memorization!.fromAyah, toAyah: session.memorization!.toAyah, isFullSurah: session.memorization!.isFullSurah)}'
                                          : '',
                                      recitationOutcome: session.recitationOutcome,
                                      revisions: [
                                        for (final r in session.revisions)
                                          SessionRevisionCardInfo(
                                            info: '${r.label}: ${surahLabel(r.surahId)} ${QuranUtils.rangeLabel(fromAyah: r.fromAyah, toAyah: r.toAyah, isFullSurah: r.isFullSurah)}',
                                            finalScore: r.finalScore,
                                          ),
                                      ],
                                    ),
                                    onTap: () => context.goNamed('sessionEdit', pathParameters: {'id': '${session.id}'}),
                                    onDelete: () => _deleteSession(session),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 26,
              left: 20,
              child: Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                elevation: 8,
                shadowColor: AppColors.primary.withValues(alpha: 0.35),
                child: InkWell(
                  onTap: () => context.goNamed('sessionCreateStandalone'),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    child: const AppIcon(AppIcons.plus, size: 22, color: AppColors.onPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterTab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: selected ? AppColors.primary : AppColors.inputBorder)),
          child: Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: selected ? AppColors.onPrimary : AppColors.textSecondary)),
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
