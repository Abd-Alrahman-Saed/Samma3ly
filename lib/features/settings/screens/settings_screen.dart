import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/confirm_dialog.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/features/auth/providers/auth_provider.dart';
import 'package:quran_mobile/features/dashboard/providers/dashboard_provider.dart';
import 'package:quran_mobile/features/settings/providers/settings_provider.dart';
import 'package:quran_mobile/features/settings/providers/theme_mode_provider.dart';
import 'package:quran_mobile/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);
    final user = ref.watch(currentUserProvider);
    final isAdmin = user?.role == 'Admin';
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('المظهر', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.brightness_6_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('وضع العرض')),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode_outlined), label: Text('فاتح')),
                      ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto_outlined), label: Text('تلقائي')),
                      ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode_outlined), label: Text('داكن')),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (selected) => ref.read(themeModeProvider.notifier).setThemeMode(selected.first),
                    showSelectedIcon: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('المستخدمون', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          if (!isAdmin)
            const Card(
              child: ListTile(
                leading: Icon(Icons.lock_outline, color: AppColors.textMuted),
                title: Text('قائمة المستخدمين'),
                subtitle: Text('متاحة للمشرف فقط'),
                enabled: false,
              ),
            )
          else
            usersAsync.when(
              loading: () => const LoadingOverlay(),
              error: (e, _) => ErrorBanner(message: e.toString()),
              data: (users) => Column(
                children: users.map((u) => Card(
                  child: ListTile(
                    leading: ExcludeSemantics(child: CircleAvatar(child: Icon(u.role == 'Admin' ? Icons.admin_panel_settings : Icons.person))),
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
                  leading: Icon(Icons.backup, color: isAdmin ? AppColors.primary : AppColors.textMuted),
                  title: const Text('إنشاء نسخة احتياطية'),
                  subtitle: isAdmin
                      ? FutureBuilder<String?>(
                          future: _lastBackupHint(Directory('${Directory.current.path}/backups')),
                          builder: (context, snapshot) => Text(snapshot.data ?? 'حفظ جميع البيانات في ملف JSON'),
                        )
                      : const Text('يتطلب صلاحيات المشرف'),
                  enabled: isAdmin,
                  onTap: () async {
                    try {
                      final backupService = ref.read(backupServiceProvider);
                      final dir = Directory('${Directory.current.path}/backups');
                      if (!await dir.exists()) await dir.create(recursive: true);
                      final filePath = '${dir.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json';
                      await backupService.backup(filePath);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('تم إنشاء نسخة احتياطية بنجاح'),
                            action: SnackBarAction(label: 'مشاركة', onPressed: () => _shareBackup(File(filePath))),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        AppSnackbar.error(context, e);
                      }
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.ios_share, color: isAdmin ? AppColors.primary : AppColors.textMuted),
                  title: const Text('مشاركة نسخة احتياطية'),
                  subtitle: Text(isAdmin ? 'إرسال نسخة احتياطية عبر تطبيق آخر' : 'يتطلب صلاحيات المشرف'),
                  enabled: isAdmin,
                  onTap: () async {
                    final dir = Directory('${Directory.current.path}/backups');
                    final picked = await _pickBackupFile(context, dir);
                    if (picked == null) return;
                    await _shareBackup(picked);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.restore, color: isAdmin ? AppColors.warning : AppColors.textMuted),
                  title: const Text('استعادة نسخة احتياطية'),
                  subtitle: Text(isAdmin ? 'تحميل البيانات من ملف JSON' : 'يتطلب صلاحيات المشرف'),
                  enabled: isAdmin,
                  onTap: () async {
                    final dir = Directory('${Directory.current.path}/backups');
                    final picked = await _pickBackupFile(context, dir);
                    if (picked == null || !context.mounted) return;
                    final modified = (await picked.stat()).modified;
                    if (!context.mounted) return;
                    final confirmed = await showConfirmDialog(
                      context,
                      title: 'تأكيد الاستعادة',
                      message: 'سيتم استبدال جميع البيانات الحالية بالنسخة المؤرخة ${AppDateUtils.formatDate(modified)}. هل أنت متأكد؟',
                      confirmLabel: 'استعادة',
                      destructive: true,
                    );
                    if (confirmed && context.mounted) {
                      try {
                        final backupService = ref.read(backupServiceProvider);
                        await backupService.restore(picked.path);
                        if (context.mounted) {
                          AppSnackbar.success(context, 'تم استعادة البيانات بنجاح');
                          ref.invalidate(dashboardProvider);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          AppSnackbar.error(context, e);
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('المساعدة', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.help_outline, color: AppColors.primary),
              title: const Text('دليل الاستخدام'),
              subtitle: const Text('جولة سريعة في خطوات العمل الأساسية'),
              onTap: () => context.goNamed('onboarding', queryParameters: {'next': 'dashboard'}),
            ),
          ),
          const SizedBox(height: 24),
          Text('الحساب', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text('تسجيل الخروج'),
              onTap: () async {
                final confirmed = await showConfirmDialog(
                  context,
                  title: 'تأكيد تسجيل الخروج',
                  message: 'هل أنت متأكد من تسجيل الخروج؟',
                  confirmLabel: 'تسجيل الخروج',
                );
                if (confirmed && context.mounted) {
                  ref.read(authStateProvider.notifier).logout();
                  context.goNamed('login');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _shareBackup(File file) async {
  await SharePlus.instance.share(
    ShareParams(files: [XFile(file.path)], subject: 'نسخة احتياطية - نظام إدارة وتحفيظ القرآن الكريم'),
  );
}

/// Returns a friendly hint about the most recent backup's age, or null if
/// none exists / the check fails (falls back to the default subtitle).
Future<String?> _lastBackupHint(Directory dir) async {
  try {
    if (!await dir.exists()) return 'لم يتم إنشاء أي نسخة احتياطية بعد';
    final entries = await dir.list().where((e) => e.path.endsWith('.json')).toList();
    if (entries.isEmpty) return 'لم يتم إنشاء أي نسخة احتياطية بعد';
    DateTime? latest;
    for (final e in entries) {
      final modified = (await File(e.path).stat()).modified;
      if (latest == null || modified.isAfter(latest)) latest = modified;
    }
    final days = DateTime.now().difference(latest!).inDays;
    if (days >= 7) return 'آخر نسخة احتياطية منذ $days يوماً — يُنصح بإنشاء نسخة جديدة';
    return null;
  } catch (_) {
    return null;
  }
}

Future<File?> _pickBackupFile(BuildContext context, Directory dir) async {
  if (!await dir.exists()) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا توجد نسخ احتياطية')));
    }
    return null;
  }
  final entries = await dir.list().where((e) => e.path.endsWith('.json')).toList();
  if (entries.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا توجد نسخ احتياطية')));
    }
    return null;
  }
  final withDates = <MapEntry<File, DateTime>>[];
  for (final e in entries) {
    final file = File(e.path);
    withDates.add(MapEntry(file, (await file.stat()).modified));
  }
  withDates.sort((a, b) => b.value.compareTo(a.value));

  if (!context.mounted) return null;
  return showDialog<File>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('اختر نسخة احتياطية'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: withDates.length,
          itemBuilder: (_, i) {
            final entry = withDates[i];
            return ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(AppDateUtils.formatDate(entry.value)),
              subtitle: Text(AppDateUtils.formatTime(TimeOfDay.fromDateTime(entry.value))),
              onTap: () => Navigator.pop(ctx, entry.key),
            );
          },
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
      ],
    ),
  );
}
