import 'package:flutter/material.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';

/// KPI stat card — exact layout from the adopted design: bare icon (no
/// colored container) on top, large bold value below it, small muted
/// title at the bottom. See docs/DESIGN_SPEC.md.
class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String icon; // AppIcons markup string
  final Color? iconColor;

  /// Optional — when set, the whole card becomes a tap target (e.g. the
  /// dashboard's "week's sessions" card opening the weekly calendar).
  final VoidCallback? onTap;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(13),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon(icon, size: 18, color: iconColor ?? AppColors.primary),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 21, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 1),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );

    return Card(
      margin: EdgeInsets.zero,
      // Only wrapped in InkWell when actually tappable — keeps the static
      // (non-tappable) rendering pixel-identical to before for every other
      // caller, so the existing golden tests don't need re-baselining.
      clipBehavior: onTap == null ? Clip.none : Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}
