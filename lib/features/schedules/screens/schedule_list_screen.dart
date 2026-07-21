import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/features/schedules/providers/schedule_provider.dart';
import 'package:quran_mobile/providers.dart';

class ScheduleListScreen extends ConsumerWidget {
  const ScheduleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(upcomingScheduleListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الجداول'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.goNamed('scheduleCreate'),
          ),
        ],
      ),
      body: schedulesAsync.when(
        loading: () => const LoadingOverlay(),
        error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(upcomingScheduleListProvider)),
        data: (schedules) {
          if (schedules.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('لا توجد جداول قادمة', style: AppTextStyles.muted),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة جدول'),
                    onPressed: () => context.goNamed('scheduleCreate'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(upcomingScheduleListProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: schedules.length,
              itemBuilder: (_, i) {
                final s = schedules[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Text('${s.studentId}', style: const TextStyle(color: AppColors.primary)),
                    ),
                    title: Text('طالب رقم ${s.studentId}', style: AppTextStyles.body),
                    subtitle: Text('${AppDateUtils.formatDate(s.date)} - ${s.time}', style: AppTextStyles.muted),
                    trailing: IconButton(
                      icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
                      onPressed: () async {
                        try {
                          final repo = ref.read(scheduleRepositoryProvider);
                          await repo.convertToSession(s.id!);
                          ref.invalidate(upcomingScheduleListProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم تحويل الجدول إلى جلسة')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('خطأ: $e')),
                            );
                          }
                        }
                      },
                    ),
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
