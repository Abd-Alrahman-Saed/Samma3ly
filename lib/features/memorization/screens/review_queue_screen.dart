import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/empty_state.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/features/memorization/providers/memorization_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';

class ReviewQueueScreen extends ConsumerWidget {
  const ReviewQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueAsync = ref.watch(dueForReviewProvider);
    final surahsAsync = ref.watch(surahListProvider);
    final surahNames = <int, String>{
      for (final s in surahsAsync.valueOrNull ?? const []) s.id: s.name,
    };
    String surahLabel(int surahId) => surahNames[surahId] ?? 'سورة $surahId';

    return Scaffold(
      appBar: AppBar(title: const Text('قائمة المراجعة')),
      body: dueAsync.when(
        loading: () => const ListSkeleton(),
        error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(dueForReviewProvider)),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.event_available,
              title: 'لا توجد مراجعات مستحقة',
              description: 'ستظهر هنا نطاقات الحفظ التي حان أو اقترب موعد مراجعتها',
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(dueForReviewProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                final dueDate = item.range.nextReviewDate!;
                final today = DateTime.now();
                final daysUntil = DateTime(dueDate.year, dueDate.month, dueDate.day).difference(DateTime(today.year, today.month, today.day)).inDays;
                final isOverdue = daysUntil < 0;
                final statusColor = isOverdue ? AppColors.error : (daysUntil == 0 ? AppColors.orange : AppColors.textMuted);
                final statusText = isOverdue ? 'متأخرة ${-daysUntil} يوم' : (daysUntil == 0 ? 'اليوم' : 'خلال $daysUntil يوم');
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: statusColor.withAlpha(31),
                      child: Icon(Icons.auto_stories, color: statusColor),
                    ),
                    title: Text('${item.studentName} — ${surahLabel(item.range.surahId)}', style: AppTextStyles.body),
                    subtitle: Text('${item.range.fromAyah}-${item.range.toAyah} · ${AppDateUtils.formatDate(dueDate)}', style: AppTextStyles.muted),
                    trailing: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12)),
                    onTap: () => context.goNamed('memorization', pathParameters: {'id': '${item.studentId}'}),
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
