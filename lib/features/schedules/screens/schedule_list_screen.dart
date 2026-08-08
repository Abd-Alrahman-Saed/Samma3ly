import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/confirm_delete.dart';
import 'package:quran_mobile/core/widgets/convert_to_session_button.dart';
import 'package:quran_mobile/core/widgets/empty_state.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/core/widgets/staggered_list_item.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Schedule;
import 'package:quran_mobile/domain/entities/schedule.dart';
import 'package:quran_mobile/features/schedules/providers/schedule_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

class ScheduleListScreen extends ConsumerWidget {
  const ScheduleListScreen({super.key});

  Future<void> _deleteSchedule(BuildContext context, WidgetRef ref, Schedule schedule) async {
    final dao = ref.read(scheduleDaoProvider);
    await dao.deleteById(schedule.id);
    ref.invalidate(upcomingScheduleListProvider);
    if (!context.mounted) return;
    showUndoSnackbar(context, 'تم حذف الجدولة', () async {
      await dao.insert(SchedulesCompanion(
        id: Value(schedule.id),
        studentId: Value(schedule.studentId),
        date: Value(schedule.date),
        time: Value(schedule.time),
        memorizationSurahId: Value(schedule.memorizationSurahId),
        memorizationFromAyah: Value(schedule.memorizationFromAyah),
        memorizationToAyah: Value(schedule.memorizationToAyah),
        revisionSurahId: Value(schedule.revisionSurahId),
        revisionFromAyah: Value(schedule.revisionFromAyah),
        revisionToAyah: Value(schedule.revisionToAyah),
        isCompleted: Value(schedule.isCompleted),
        createdAt: Value(schedule.createdAt ?? DateTime.now()),
      ));
      ref.invalidate(upcomingScheduleListProvider);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(upcomingScheduleListProvider);
    final studentsAsync = ref.watch(studentListProvider);
    final studentNames = <int, String>{
      for (final s in studentsAsync.valueOrNull ?? const []) s.id: s.fullName,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('الجداول'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'إضافة جدول',
            onPressed: () => context.goNamed('scheduleCreate'),
          ),
        ],
      ),
      body: schedulesAsync.when(
        loading: () => const ListSkeleton(),
        error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(upcomingScheduleListProvider)),
        data: (schedules) {
          if (schedules.isEmpty) {
            return EmptyState(
              icon: Icons.schedule,
              title: 'لا توجد جداول قادمة',
              ctaLabel: 'إضافة جدول',
              onCta: () => context.goNamed('scheduleCreate'),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(upcomingScheduleListProvider.future),
            child: AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: schedules.length,
              itemBuilder: (_, i) {
                final s = schedules[i];
                final studentName = studentNames[s.studentId] ?? 'طالب رقم ${s.studentId}';
                return StaggeredListItem(index: i, child: Dismissible(
                  key: ValueKey('schedule-${s.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) => confirmDelete(context, message: 'هل أنت متأكد من حذف جدولة "$studentName"؟'),
                  onDismissed: (_) => _deleteSchedule(context, ref, s),
                  child: Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: ExcludeSemantics(
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child: Text(studentName.substring(0, 1), style: const TextStyle(color: AppColors.primary)),
                      ),
                    ),
                    title: Text(studentName, style: AppTextStyles.body),
                    subtitle: Text('${AppDateUtils.formatDate(s.date)} - ${s.time}', style: AppTextStyles.muted),
                    onTap: () => context.goNamed('studentDetails', pathParameters: {'id': '${s.studentId}'}),
                    trailing: ConvertToSessionButton(
                      scheduleId: s.id,
                      onConverted: () => ref.invalidate(upcomingScheduleListProvider),
                    ),
                  ),
                  ),
                ));
              },
            ),
            ),
          );
        },
      ),
    );
  }
}
