import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/features/goals/providers/goal_provider.dart';

class GoalListScreen extends ConsumerWidget {
  const GoalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأهداف'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.goNamed('goalCreate'),
          ),
        ],
      ),
      body: goalsAsync.when(
        loading: () => const LoadingOverlay(),
        error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(goalListProvider)),
        data: (goals) {
          if (goals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flag_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('لا توجد أهداف', style: AppTextStyles.muted),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة هدف'),
                    onPressed: () => context.goNamed('goalCreate'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(goalListProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              itemBuilder: (_, i) {
                final g = goals[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: g.status == 'مكتمل' ? AppColors.successBg : g.status == 'قيد التنفيذ' ? AppColors.warningBg : AppColors.badgeGray,
                      child: Icon(
                        g.status == 'مكتمل' ? Icons.check_circle : g.status == 'قيد التنفيذ' ? Icons.hourglass_top : Icons.radio_button_unchecked,
                        color: g.status == 'مكتمل' ? AppColors.success : g.status == 'قيد التنفيذ' ? AppColors.warning : AppColors.textMuted,
                      ),
                    ),
                    title: Text(g.title, style: AppTextStyles.body),
                    subtitle: Text('طالب رقم ${g.studentId} - ${g.goalType}', style: AppTextStyles.muted),
                    trailing: Text(g.status, style: AppTextStyles.small),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
