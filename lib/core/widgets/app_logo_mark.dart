import 'package:flutter/material.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';

/// The app's logo mark — a rounded square in brand green holding an icon,
/// with an optional small gold "+" badge overlapping the top-left corner
/// (used on the login screen; the setup screen uses the plain form with
/// [showBadge] false and a different icon/size). See docs/DESIGN_SPEC.md.
class AppLogoMark extends StatelessWidget {
  final double size;
  final double radius;
  final String icon;
  final double iconSize;
  final bool showBadge;

  const AppLogoMark({
    super.key,
    this.size = 60,
    this.radius = 16,
    this.icon = AppIcons.book,
    this.iconSize = 30,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    const badgeSize = 15.0;
    final boxSize = size + badgeSize / 2;
    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: badgeSize / 2,
            left: badgeSize / 2,
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(radius)),
              child: AppIcon(icon, size: iconSize, color: AppColors.onPrimary),
            ),
          ),
          if (showBadge)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: badgeSize,
                height: badgeSize,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                child: AppIcon(AppIcons.plus, size: 8, color: AppColors.onPrimary),
              ),
            ),
        ],
      ),
    );
  }
}
