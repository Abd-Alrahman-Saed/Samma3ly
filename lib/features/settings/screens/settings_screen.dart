import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/confirm_dialog.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/features/auth/providers/auth_provider.dart';
import 'package:quran_mobile/features/dashboard/providers/dashboard_provider.dart';
import 'package:quran_mobile/features/settings/providers/notification_settings_provider.dart';
import 'package:quran_mobile/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final notificationSettings = ref.watch(notificationSettingsProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          children: [
            Text('الإعدادات', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            const _SectionLabel('الإشعارات'),
            const SizedBox(height: 8),
            _RowContainer(
              onTap: () => _showNotificationSettingsDialog(context, ref),
              child: Row(
                children: [
                  const AppIcon(AppIcons.calendarCheck, size: 17, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('توقيت التذكيرات', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text(
                          'المراجعة الساعة ${notificationSettings.reviewReminderHour.toString().padLeft(2, '0')}:${notificationSettings.reviewReminderMinute.toString().padLeft(2, '0')} · الحلقات قبلها بـ${notificationSettings.groupSessionLeadMinutes} د',
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const AppIcon(AppIcons.chevronLeft, size: 15, color: AppColors.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _SectionLabel('الملف الشخصي'),
            const SizedBox(height: 8),
            _TeacherRow(fullName: user?.fullName ?? ''),
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
                    iconColor: AppColors.primary,
                    label: 'إنشاء نسخة احتياطية',
                    enabled: true,
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
                    iconColor: AppColors.primary,
                    label: 'مشاركة نسخة احتياطية',
                    enabled: true,
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
                    iconColor: const Color(0xFFD97706),
                    label: 'استعادة نسخة احتياطية',
                    enabled: true,
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
          ],
        ),
      ),
    );
  }
}

/// Item 3.5: replaces two previously-hardcoded notification times — the
/// memorization-review reminder (was a literal 9:00) and group-session
/// reminders (didn't exist before this item; now fire `leadMinutes` before
/// the occurrence's real computed time, item 2.2/2.3).
Future<void> _showNotificationSettingsDialog(BuildContext context, WidgetRef ref) async {
  final settings = ref.read(notificationSettingsProvider);
  var reviewTime = TimeOfDay(hour: settings.reviewReminderHour, minute: settings.reviewReminderMinute);
  var leadMinutes = settings.groupSessionLeadMinutes;
  const leadOptions = [5, 10, 15, 30, 45, 60];

  await showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('توقيت التذكيرات'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تذكير مراجعة الحفظ اليومي', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            OutlinedButton(
              onPressed: () async {
                final picked = await showTimePicker(context: ctx, initialTime: reviewTime);
                if (picked != null) setState(() => reviewTime = picked);
              },
              child: Text(reviewTime.format(ctx)),
            ),
            const SizedBox(height: 14),
            const Text('تذكير الحلقات — قبل الموعد بـ', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w600)),
            DropdownButton<int>(
              value: leadMinutes,
              isExpanded: true,
              items: [for (final m in leadOptions) DropdownMenuItem(value: m, child: Text('$m دقيقة'))],
              onChanged: (v) {
                if (v != null) setState(() => leadMinutes = v);
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            onPressed: () async {
              final notifier = ref.read(notificationSettingsProvider.notifier);
              await notifier.setReviewReminderTime(hour: reviewTime.hour, minute: reviewTime.minute);
              await notifier.setGroupSessionLeadMinutes(leadMinutes);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    ),
  );
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

  const _TeacherRow({required this.fullName});

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
          Text(fullName, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
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

