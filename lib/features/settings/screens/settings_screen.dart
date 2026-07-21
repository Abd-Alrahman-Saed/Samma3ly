import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/features/auth/providers/auth_provider.dart';
import 'package:quran_mobile/features/dashboard/providers/dashboard_provider.dart';
import 'package:quran_mobile/features/settings/providers/settings_provider.dart';
import 'package:quran_mobile/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('المستخدمون', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          usersAsync.when(
            loading: () => const LoadingOverlay(),
            error: (e, _) => ErrorBanner(message: e.toString()),
            data: (users) => Column(
              children: users.map((u) => Card(
                child: ListTile(
                  leading: CircleAvatar(child: Icon(u.role == 'Admin' ? Icons.admin_panel_settings : Icons.person)),
                  title: Text(u.fullName),
                  subtitle: Text(u.role == 'Admin' ? 'مشرف' : 'معلم'),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 24),
          Text('النسخ الاحتياطي', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.backup, color: AppColors.primary),
                  title: const Text('إنشاء نسخة احتياطية'),
                  subtitle: const Text('حفظ جميع البيانات في ملف JSON'),
                  onTap: () async {
                    try {
                      final backupService = ref.read(backupServiceProvider);
                      final dir = Directory('${Directory.current.path}/backups');
                      if (!await dir.exists()) await dir.create(recursive: true);
                      final filePath = '${dir.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json';
                      await backupService.backup(filePath);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إنشاء النسخة الاحتياطية: $filePath')));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                      }
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restore, color: AppColors.warning),
                  title: const Text('استعادة نسخة احتياطية'),
                  subtitle: const Text('تحميل البيانات من ملف JSON'),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('تأكيد الاستعادة'),
                        content: const Text('سيتم استبدال جميع البيانات الحالية. هل أنت متأكد؟'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
                          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('استعادة')),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      try {
                        final backupService = ref.read(backupServiceProvider);
                        final dir = Directory('${Directory.current.path}/backups');
                        if (await dir.exists()) {
                          final files = await dir.list().where((e) => e.path.endsWith('.json')).toList();
                          if (files.isNotEmpty) {
                            await backupService.restore(files.last.path);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم استعادة البيانات بنجاح')));
                              ref.invalidate(dashboardProvider);
                            }
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('الحساب', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text('تسجيل الخروج'),
              onTap: () {
                ref.read(authStateProvider.notifier).logout();
                context.goNamed('login');
              },
            ),
          ),
        ],
      ),
    );
  }
}
