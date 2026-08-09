import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          children: [
            Text('الإعدادات', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            const _SectionLabel('المظهر'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('وضع العرض', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  _ThemeSegmentedControl(
                    value: themeMode,
                    onChanged: (v) => ref.read(themeModeProvider.notifier).setThemeMode(v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _SectionLabel('المستخدمون'),
            const SizedBox(height: 8),
            if (!isAdmin)
              const _RowContainer(
                child: Row(
                  children: [
                    AppIcon(AppIcons.person, size: 17, color: AppColors.textMuted),
                    SizedBox(width: 12),
                    Text('قائمة المستخدمين متاحة للمشرف فقط', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textMuted)),
                  ],
                ),
              )
            else
              usersAsync.when(
                loading: () => const LoadingOverlay(),
                error: (e, _) => ErrorBanner(message: e.toString()),
                data: (users) => Column(
                  children: [
                    for (var i = 0; i < users.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: i == users.length - 1 ? 0 : 8),
                        child: _TeacherRow(fullName: users[i].fullName, roleLabel: users[i].role == 'Admin' ? 'مشرف' : 'معلم'),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            const _SectionLabel('النسخ الاحتياطي'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _ActionRow(
                    icon: AppIcons.backup,
                    iconColor: isAdmin ? AppColors.primary : AppColors.textMuted,
                    label: 'إنشاء نسخة احتياطية',
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
                        if (context.mounted) AppSnackbar.error(context, e);
                      }
                    },
                  ),
                  const Divider(height: 1),
                  _ActionRow(
                    icon: AppIcons.share,
                    iconColor: isAdmin ? AppColors.primary : AppColors.textMuted,
                    label: 'مشاركة نسخة احتياطية',
                    enabled: isAdmin,
                    onTap: () async {
                      final dir = Directory('${Directory.current.path}/backups');
                      final picked = await _pickBackupFile(context, dir);
                      if (picked == null) return;
                      await _shareBackup(picked);
                    },
                  ),
                  const Divider(height: 1),
                  _ActionRow(
                    icon: AppIcons.restore,
                    iconColor: isAdmin ? const Color(0xFFD97706) : AppColors.textMuted,
                    label: 'استعادة نسخة احتياطية',
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
                          if (context.mounted) AppSnackbar.error(context, e);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _SectionLabel('المساعدة'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
              clipBehavior: Clip.antiAlias,
              child: _ActionRow(
                icon: AppIcons.book,
                iconColor: AppColors.primary,
                label: 'دليل الاستخدام',
                enabled: true,
                onTap: () => context.goNamed('onboarding', queryParameters: {'next': 'dashboard'}),
              ),
            ),
            const SizedBox(height: 20),
            const _SectionLabel('الحساب'),
            const SizedBox(height: 8),
            _RowContainer(
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
              child: const Row(
                children: [
                  AppIcon(AppIcons.logout, size: 17, color: Color(0xFFC0392B)),
                  SizedBox(width: 12),
                  Text('تسجيل الخروج', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFC0392B))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _shareBackup(File file) async {
  await SharePlus.instance.share(
    ShareParams(files: [XFile(file.path)], subject: 'نسخة احتياطية - نظام إدارة وتحفيظ القرآن الكريم'),
  );
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

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary));
  }
}

class _RowContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _RowContainer({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
          child: child,
        ),
      ),
    );
  }
}

class _TeacherRow extends StatelessWidget {
  final String fullName;
  final String roleLabel;

  const _TeacherRow({required this.fullName, required this.roleLabel});

  @override
  Widget build(BuildContext context) {
    return _RowContainer(
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.dividerLight, shape: BoxShape.circle),
            child: const AppIcon(AppIcons.person, size: 17, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fullName, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 1),
              Text(roleLabel, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionRow({required this.icon, required this.iconColor, required this.label, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            AppIcon(icon, size: 17, color: iconColor),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600, color: enabled ? AppColors.textPrimary : AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _ThemeSegmentedControl extends StatelessWidget {
  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeSegmentedControl({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: AppColors.dividerLight, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _segment('فاتح', ThemeMode.light),
          _segment('تلقائي', ThemeMode.system),
          _segment('داكن', ThemeMode.dark),
        ],
      ),
    );
  }

  Widget _segment(String label, ThemeMode mode) {
    final selected = value == mode;
    return InkWell(
      onTap: () => onChanged(mode),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: selected ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(999)),
        child: Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, fontWeight: FontWeight.w700, color: selected ? AppColors.onPrimary : AppColors.textSecondary)),
      ),
    );
  }
}
