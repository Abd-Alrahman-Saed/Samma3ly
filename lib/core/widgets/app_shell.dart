import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';

/// Item 3.7 — which bottom-nav tab highlights for a given router location.
/// Pure and separate from the widget so it's testable without pumping a
/// full app: اليوم (Dashboard) / الحلقات (Groups) / الطلاب (Students) /
/// التقارير (Reports) / المزيد (everything else — Sessions, Schedules,
/// Goals, the weekly calendar, review queue, Settings). Previously these
/// secondary screens had no shared home in the nav at all; now they all
/// live under "المزيد" instead of being reachable only from a Dashboard
/// link (the "no feature buried in the Dashboard" exit gate).
int appShellTabIndex(String location) {
  if (location.startsWith('/groups')) return 1;
  if (location.startsWith('/students')) return 2;
  if (location.startsWith('/reports')) return 3;
  if (location == '/') return 0;
  return 4;
}

/// Bottom navigation shell — exact visual match to the adopted design's
/// nav bar (docs/DESIGN_SPEC.md): flat icon+label buttons, no pill
/// indicator, no elevation, `#FFFFFF` background with a 1px top border.
/// Deliberately a plain [Row] of buttons instead of Material's
/// [NavigationBar] — the design has no selection-indicator animation to
/// replicate, and forcing one in would add motion the source doesn't have.
class AppShell extends StatelessWidget {
  final Widget child;
  final String location;

  const AppShell({super.key, required this.child, required this.location});

  static const _tabs = [
    (icon: AppIcons.home, label: 'اليوم', route: 'dashboard'),
    (icon: AppIcons.people, label: 'الحلقات', route: 'groupsList'),
    (icon: AppIcons.peopleTab, label: 'الطلاب', route: 'students'),
    (icon: AppIcons.chart, label: 'التقارير', route: 'reports'),
    (icon: AppIcons.more, label: 'المزيد', route: 'more'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = appShellTabIndex(location);
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        padding: const EdgeInsets.fromLTRB(6, 8, 6, 10),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < _tabs.length; i++)
                _NavButton(
                  icon: _tabs[i].icon,
                  label: _tabs[i].label,
                  active: i == current,
                  onTap: () => context.goNamed(_tabs[i].route),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.tabInactive;
    return Semantics(
      selected: active,
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(child: AppIcon(icon, size: 21, color: color)),
              const SizedBox(height: 3),
              ExcludeSemantics(
                child: Text(
                  label,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, fontWeight: FontWeight.w700, color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
