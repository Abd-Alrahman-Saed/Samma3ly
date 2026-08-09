import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/confirm_delete.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/core/widgets/staggered_list_item.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Schedule;
import 'package:quran_mobile/domain/entities/schedule.dart';
import 'package:quran_mobile/features/schedules/providers/schedule_provider.dart';
import 'package:quran_mobile/features/schedules/screens/schedule_form_sheet.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

class ScheduleListScreen extends ConsumerWidget {
  const ScheduleListScreen({super.key});

  Future<void> _deleteSchedule(BuildContext context, WidgetRef ref, Schedule schedule, String studentName) async {
    final confirmed = await confirmDelete(context, message: 'هل أنت متأكد من حذف جدولة "$studentName"؟');
    if (!confirmed) return;
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
    final studentNames = <int, String>{for (final s in studentsAsync.valueOrNull ?? const []) s.id: s.fullName};

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
                        child: const AppIcon(AppIcons.chevronRight, size: 16, color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text('الجداول', style: Theme.of(context).textTheme.titleLarge)),
                  InkWell(
                    onTap: () => ScheduleFormSheet.show(context),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                      child: const AppIcon(AppIcons.plus, size: 16, color: AppColors.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: schedulesAsync.when(
                loading: () => const ListSkeleton(),
                error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(upcomingScheduleListProvider)),
                data: (schedules) {
                  if (schedules.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                      child: Text('لا توجد جداول قادمة', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref.refresh(upcomingScheduleListProvider.future),
                    child: AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        itemCount: schedules.length,
                        itemBuilder: (_, i) {
                          final s = schedules[i];
                          final studentName = studentNames[s.studentId] ?? 'طالب رقم ${s.studentId}';
                          return StaggeredListItem(
                            index: i,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _ScheduleRow(
                                schedule: s,
                                studentName: studentName,
                                onTap: () => context.goNamed('studentDetails', pathParameters: {'id': '${s.studentId}'}),
                                onConverted: () => ref.invalidate(upcomingScheduleListProvider),
                                onDelete: () => _deleteSchedule(context, ref, s, studentName),
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
      ),
    );
  }
}

class _ScheduleRow extends ConsumerStatefulWidget {
  final Schedule schedule;
  final String studentName;
  final VoidCallback onTap;
  final VoidCallback onConverted;
  final VoidCallback onDelete;

  const _ScheduleRow({required this.schedule, required this.studentName, required this.onTap, required this.onConverted, required this.onDelete});

  @override
  ConsumerState<_ScheduleRow> createState() => _ScheduleRowState();
}

class _ScheduleRowState extends ConsumerState<_ScheduleRow> {
  bool _isConverting = false;

  Future<void> _convert() async {
    setState(() => _isConverting = true);
    try {
      await ref.read(scheduleRepositoryProvider).convertToSession(widget.schedule.id);
      widget.onConverted();
    } finally {
      if (mounted) setState(() => _isConverting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: widget.onTap,
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
                decoration: const BoxDecoration(color: Color(0xFFE9F3EF), shape: BoxShape.circle),
                child: Text(widget.studentName.isNotEmpty ? widget.studentName[0] : '؟', style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.studentName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text('${AppDateUtils.formatDate(widget.schedule.date)} - ${widget.schedule.time}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (_isConverting)
                const Padding(padding: EdgeInsets.all(8), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)))
              else
                InkWell(
                  onTap: _convert,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(color: const Color(0xFFE9F3EF), borderRadius: BorderRadius.circular(999)),
                    child: const Text('تحويل', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                ),
              IconButton(
                onPressed: widget.onDelete,
                tooltip: 'حذف الجدولة',
                icon: const AppIcon(AppIcons.trash, size: 15, color: AppColors.deleteIcon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
