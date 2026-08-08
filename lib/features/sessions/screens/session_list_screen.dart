import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/confirm_delete.dart';
import 'package:quran_mobile/core/widgets/empty_state.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/core/widgets/staggered_list_item.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/session_card.dart';
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
    final dao = ref.read(sessionDaoProvider);
    await ref.read(sessionRepositoryProvider).delete(session.id);
    ref.invalidate(sessionListProvider);
    ref.invalidate(sessionsByStudentProvider(session.studentId));
    if (!mounted) return;
    showUndoSnackbar(context, 'تم حذف الجلسة', () async {
      await dao.insert(SessionsCompanion(
        id: Value(session.id),
        studentId: Value(session.studentId),
        date: Value(session.date),
        time: Value(session.time),
        attendanceStatus: Value(session.attendanceStatus),
        notes: Value(session.notes),
        createdAt: Value(session.createdAt ?? DateTime.now()),
      ));
      final mem = session.memorization;
      if (mem != null) {
        await dao.insertMemorization(SessionMemorizationsCompanion(
          sessionId: Value(session.id),
          surahId: Value(mem.surahId),
          fromAyah: Value(mem.fromAyah),
          toAyah: Value(mem.toAyah),
        ));
      }
      final rev = session.revision;
      if (rev != null) {
        await dao.insertRevision(SessionRevisionsCompanion(
          sessionId: Value(session.id),
          surahId: Value(rev.surahId),
          fromAyah: Value(rev.fromAyah),
          toAyah: Value(rev.toAyah),
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
      ref.invalidate(sessionsByStudentProvider(session.studentId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(sessionListProvider);
    final surahsAsync = ref.watch(surahListProvider);
    final studentsAsync = ref.watch(studentListProvider);
    final timeFilter = ref.watch(sessionTimeFilterProvider);
    final dateFilter = ref.watch(sessionDateFilterProvider);
    final surahNames = <int, String>{
      for (final s in surahsAsync.valueOrNull ?? const []) s.id: s.name,
    };
    final studentNames = <int, String>{
      for (final s in studentsAsync.valueOrNull ?? const []) s.id: s.fullName,
    };
    String surahLabel(int surahId) => surahNames[surahId] ?? 'سورة $surahId';

    return Scaffold(
      appBar: AppBar(
        title: const Text('الجلسات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'تصفية حسب التاريخ',
            onPressed: _pickDateRange,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SegmentedButton<SessionTimeFilter>(
              segments: const [
                ButtonSegment(value: SessionTimeFilter.all, label: Text('الكل')),
                ButtonSegment(value: SessionTimeFilter.past, label: Text('سابقة')),
                ButtonSegment(value: SessionTimeFilter.upcoming, label: Text('قادمة')),
              ],
              selected: {timeFilter},
              onSelectionChanged: (v) => ref.read(sessionTimeFilterProvider.notifier).state = v.first,
            ),
          ),
          if (dateFilter != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: Chip(
                  label: Text(
                    '${AppDateUtils.formatDate(dateFilter.start)} - ${AppDateUtils.formatDate(dateFilter.end)}',
                    style: AppTextStyles.small,
                  ),
                  onDeleted: _clearDateRange,
                  deleteIconColor: Colors.grey[700],
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
                  return EmptyState(
                    icon: Icons.calendar_today,
                    title: 'لا توجد جلسات',
                    ctaLabel: 'إضافة جلسة',
                    onCta: () => context.goNamed('sessionCreateStandalone'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(sessionListProvider.future),
                  child: AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sessions.length,
                    itemBuilder: (_, i) {
                      final session = sessions[i];
                      final studentName = studentNames[session.studentId] ?? 'طالب رقم ${session.studentId}';
                      return StaggeredListItem(index: i, child: Dismissible(
                        key: ValueKey('session-${session.id}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) => confirmDelete(context, message: 'هل أنت متأكد من حذف جلسة "$studentName"؟'),
                        onDismissed: (_) => _deleteSession(session),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: SessionCard(
                            item: SessionCardItem(
                              id: session.id,
                              studentId: session.studentId,
                              studentName: studentName,
                              initials: studentName.substring(0, 1),
                              date: session.date,
                              timeDisplay: session.time,
                              attendanceStatus: session.attendanceStatus,
                              finalScore: session.evaluation?.finalScore ?? 0,
                              memorizationInfo: session.memorization != null ? 'حفظ: ${surahLabel(session.memorization!.surahId)} (${session.memorization!.fromAyah}-${session.memorization!.toAyah})' : '',
                              revisionInfo: session.revision != null ? 'مراجعة: ${surahLabel(session.revision!.surahId)} (${session.revision!.fromAyah}-${session.revision!.toAyah})' : '',
                            ),
                            onTap: () => context.goNamed('sessionEdit', pathParameters: {'id': '${session.id}'}),
                          ),
                        ),
                      ));
                    },
                  ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'إضافة جلسة',
        onPressed: () => context.goNamed('sessionCreateStandalone'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
