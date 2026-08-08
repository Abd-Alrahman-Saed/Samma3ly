import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/enums/goal_status.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/confirm_delete.dart';
import 'package:quran_mobile/core/widgets/empty_state.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/core/widgets/staggered_list_item.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Goal;
import 'package:quran_mobile/domain/entities/goal.dart';
import 'package:quran_mobile/features/goals/providers/goal_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

class GoalListScreen extends ConsumerWidget {
  const GoalListScreen({super.key});

  Future<void> _deleteGoal(BuildContext context, WidgetRef ref, Goal goal) async {
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
    final studentNames = <int, String>{
      for (final s in studentsAsync.valueOrNull ?? const []) s.id: s.fullName,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأهداف'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'إضافة هدف',
            onPressed: () => context.goNamed('goalCreate'),
          ),
        ],
      ),
      body: goalsAsync.when(
        loading: () => const ListSkeleton(),
        error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(goalListProvider)),
        data: (goals) {
          if (goals.isEmpty) {
            return EmptyState(
              icon: Icons.flag_outlined,
              title: 'لا توجد أهداف',
              ctaLabel: 'إضافة هدف',
              onCta: () => context.goNamed('goalCreate'),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(goalListProvider.future),
            child: AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              itemBuilder: (_, i) {
                final g = goals[i];
                final status = GoalStatus.fromArabic(g.status);
                return StaggeredListItem(index: i, child: Dismissible(
                  key: ValueKey('goal-${g.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) => confirmDelete(context, message: 'هل أنت متأكد من حذف الهدف "${g.title}"؟'),
                  onDismissed: (_) => _deleteGoal(context, ref, g),
                  child: Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: ExcludeSemantics(
                      child: CircleAvatar(
                        backgroundColor: status.backgroundColor,
                        child: Icon(status.icon, color: status.color),
                      ),
                    ),
                    title: Text(g.title, style: AppTextStyles.body),
                    subtitle: Text(
                      '${studentNames[g.studentId] ?? 'طالب رقم ${g.studentId}'} - ${g.goalType}\n'
                      '${AppDateUtils.formatDate(g.startDate)}'
                      '${g.targetDate != null ? ' → ${AppDateUtils.formatDate(g.targetDate!)}' : ''}',
                      style: AppTextStyles.muted,
                    ),
                    isThreeLine: true,
                    trailing: _GoalStatusMenu(goal: g),
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
      if (mounted) {
        AppSnackbar.error(context, e);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return PopupMenuButton<GoalStatus>(
      onSelected: _updateStatus,
      itemBuilder: (context) => GoalStatus.values.map((status) => PopupMenuItem(
        value: status,
        child: Text(status.arabic),
      )).toList(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.goal.status, style: AppTextStyles.small),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
