import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';

/// Item 3.7 (nav restructure) — the "المزيد" tab: everything that doesn't
/// get one of the 4 primary tabs (اليوم/الحلقات/الطلاب/التقارير). None of
/// these screens are new here — they already existed with their own
/// routes; this just gives them a shared, always-reachable home in the
/// nav instead of only being linked from wherever a Dashboard quick-link
/// happened to point.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          children: [
            Text('المزيد', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _MoreRow(icon: AppIcons.calendarCheck, label: 'الجلسات', onTap: () => context.goNamed('sessionsList')),
            const SizedBox(height: 8),
            _MoreRow(icon: AppIcons.clock, label: 'الجداول', onTap: () => context.goNamed('schedulesList')),
            const SizedBox(height: 8),
            _MoreRow(icon: AppIcons.flag, label: 'الأهداف', onTap: () => context.goNamed('goalsList')),
            const SizedBox(height: 8),
            _MoreRow(icon: AppIcons.calendar, label: 'التقويم الأسبوعي', onTap: () => context.goNamed('weeklyCalendar')),
            const SizedBox(height: 8),
            _MoreRow(icon: AppIcons.checkCircle, label: 'قائمة المراجعة', onTap: () => context.goNamed('reviewQueue')),
            const SizedBox(height: 8),
            _MoreRow(icon: AppIcons.settings, label: 'الإعدادات', onTap: () => context.goNamed('settings')),
          ],
        ),
      ),
    );
  }
}

class _MoreRow extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _MoreRow({required this.icon, required this.label, required this.onTap});

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
          child: Row(
            children: [
              AppIcon(icon, size: 17, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
              const AppIcon(AppIcons.chevronLeft, size: 15, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
