import 'package:flutter/material.dart';

/// Sprint 1, item 1.3/1.6 (resolves plan conflict C6 + raises body sizes).
///
/// Previously every style here baked in a fixed `color: AppColors.x` —
/// since these are `const` values evaluated at compile time, that color
/// could never respond to dark mode. New code should read
/// `Theme.of(context).textTheme` instead (built in `app_theme.dart`,
/// dark-mode aware). These are kept, color-less, so screens not yet
/// migrated keep compiling and pick up a sensible default text color from
/// the ambient `DefaultTextStyle` (which Material widgets already theme
/// correctly) instead of a hardcoded light-mode value.
///
/// Sizes were raised per the `readable-font-size` rule (16sp minimum body
/// text on mobile): body 14→16, small/muted 12→13, badge 11→12.
///
/// Marked `@Deprecated`: Dart's `deprecated_member_use_from_same_package`
/// lint is off by default (confirmed against this project's
/// `flutter_lints`-based analysis_options.yaml), so this doesn't trip
/// `flutter analyze --fatal-infos` in CI — it only shows up as a
/// strikethrough/tooltip in IDEs, which is exactly the "quietly guide new
/// code away from this" effect wanted here. Core/shared widgets (KpiCard,
/// SessionCard, StatusBadge, EmptyState, ErrorBanner, …) already use
/// `Theme.of(context).textTheme` instead; ~15 feature screens still use
/// this class and are tracked as Sprint 1 follow-up.
@Deprecated('Use Theme.of(context).textTheme instead — see class doc')
class AppTextStyles {
  const AppTextStyles._();

  static const String _fontFamily = 'Cairo';

  static const TextStyle pageHeader = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    height: 1.6,
  );

  static const TextStyle small = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    height: 1.5,
  );

  static const TextStyle muted = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    height: 1.5,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle score = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle infoLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle infoValue = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
  );
}
