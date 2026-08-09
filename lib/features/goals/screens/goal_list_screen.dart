import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quran_mobile/core/enums/goal_status.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/confirm_delete.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/core/widgets/staggered_list_item.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Goal;
import 'package:quran_mobile/domain/entities/goal.dart';
import 'package:quran_mobile/features/goals/providers/goal_provider.dart';
import 'package:quran_mobile/features/goals/screens/goal_form_sheet.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

class GoalListScreen extends ConsumerWidget {
  const GoalListScreen({super.key});

  Future<void> _deleteGoal(BuildContext context, WidgetRef ref, Goal goal) async {
    final confirmed = await confirmDelete(context, message: 'هل أنت متأكد من حذف الهدف "${goal.title}"؟');
    if (!confirmed) return;
    final dao = ref.read(goalDaoProvider);
    await dao.deleteById(goal.id);
    ref.invalidate(goalListProvider);
    ref.invalidate(goalsByStudentProvider(goal.studentId));
    ref.invalidate(activeGoalListProvider);
    if (!context.mounted) return;
    showUndoSnackbar(context, 'تم حذف الهدف "${goal.title}"', () async {
      await dao.insert(GoalsCompanion(
        id: Value(goal.id),
        studentId: Value(goal.studentId),
        title: Value(goal.title),
        goalType: Value(goal.goalType),
        targetSurahId: Value(goal.targetSurahId),
        targetJuzNumber: Value(goal.targetJuzNumber),
        startDate: Value(goal.startDate),
        targetDate: Value(goal.targetDate),
        status: Value(goal.status),
        createdAt: Value(goal.createdAt ?? DateTime.now()),
      ));
      ref.invalidate(goalListProvider);
      ref.invalidate(goalsByStudentProvider(goal.studentId));
      ref.invalidate(activeGoalListProvider);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalListProvider);
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
                  Expanded(child: Text('الأهداف', style: Theme.of(context).textTheme.titleLarge)),
                  InkWell(
                    onTap: () => GoalFormSheet.show(context),
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
              child: goalsAsync.when(
                loading: () => const ListSkeleton(),
                error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(goalListProvider)),
                data: (goals) {
                  if (goals.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                      child: Text('لا توجد أهداف', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref.refresh(goalListProvider.future),
                    child: AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        itemCount: goals.length,
                        itemBuilder: (_, i) {
                          final g = goals[i];
                          return StaggeredListItem(
                            index: i,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _GoalRow(
                                goal: g,
                                studentName: studentNames[g.studentId] ?? 'طالب رقم ${g.studentId}',
                                onDelete: () => _deleteGoal(context, ref, g),
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

class _GoalRow extends StatelessWidget {
  final Goal goal;
  final String studentName;
  final VoidCallback onDelete;

  const _GoalRow({required this.goal, required this.studentName, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(goal.title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
              _GoalStatusMenu(goal: goal),
            ],
          ),
          const SizedBox(height: 5),
          Text('$studentName · ${goal.goalType}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppDateUtils.formatDate(goal.startDate)}'
                '${goal.targetDate != null ? ' → ${AppDateUtils.formatDate(goal.targetDate!)}' : ''}',
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textSecondary),
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: 'حذف الهدف',
                icon: const AppIcon(AppIcons.trash, size: 14, color: AppColors.deleteIcon),
                constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalStatusMenu extends ConsumerStatefulWidget {
  final Goal goal;

  const _GoalStatusMenu({required this.goal});

  @override
  ConsumerState<_GoalStatusMenu> createState() => _GoalStatusMenuState();
}

class _GoalStatusMenuState extends ConsumerState<_GoalStatusMenu> {
  bool _isLoading = false;

  Future<void> _updateStatus(GoalStatus status) async {
    setState(() => _isLoading = true);
    try {
      await ref.read(goalRepositoryProvider).update(widget.goal.copyWith(status: status.arabic));
      ref.invalidate(goalListProvider);
      ref.invalidate(goalsByStudentProvider(widget.goal.studentId));
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
