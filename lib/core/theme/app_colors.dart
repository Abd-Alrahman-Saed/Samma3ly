import 'package:flutter/material.dart';

/// Brand + semantic color layer — Sprint 1, item 1.1 (resolves plan
/// conflict C1: one class named `AppColors`, no `AppPalette`, no `late`
/// as an identifier since it's a Dart reserved word).
///
/// These are raw brand values used to seed [ColorScheme.fromSeed] in
/// `app_theme.dart` and by [StatusColors] below. Prefer
/// `Theme.of(context).colorScheme` in widgets for anything that must adapt
/// between light and dark; the fields below marked `@Deprecated` are
/// light-mode-only constants kept so screens not yet migrated to the new
/// theme keep compiling and looking correct in light mode. They render
/// wrong in dark mode until migrated — tracked as Sprint 1 follow-up.
class AppColors {
  const AppColors._();

  // ── Brand ──────────────────────────────────────────────
  static const primary = Color(0xFF1B5E4A); // أخضر زيتوني عميق
  static const primaryDark = Color(0xFF0F3D30);
  static const primaryLight = Color(0xFFE6F2EE);
  static const accent = Color(0xFFC9A227); // ذهبي — الإنجازات والشهادات فقط
  static const accentLight = Color(0xFFFBF3D9);

  // ── Semantic (general-purpose, theme-invariant) ────────
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFD97706);
  static const danger = Color(0xFFDC2626);
  static const neutral = Color(0xFF64748B);

  // ── Surfaces ────────────────────────────────────────────
  static const surfaceCream = Color(0xFFFAF8F3); // ورق المصحف — light mode
  static const surfaceRaised = Colors.white;

  // ── Legacy light-only constants (pre-Sprint-1) ─────────
  // Kept for screens not yet migrated to Theme.of(context).colorScheme /
  // TextTheme. Do not use these in new code — read from the theme instead.
  @Deprecated('Use Theme.of(context).colorScheme.error, or StatusColors.absent')
  static const error = danger;
  @Deprecated('Use a Theme-aware container color instead')
  static const errorBg = Color(0xFFFEE2E2);
  @Deprecated('Use Theme.of(context).colorScheme.secondary')
  static const secondary = Color(0xFF8B5CF6);
  @Deprecated('Use a Theme-aware container color instead')
  static const successBg = Color(0xFFDCFCE7);
  @Deprecated('Use a Theme-aware container color instead')
  static const warningBg = Color(0xFFFEF9C3);
  @Deprecated('Use StatusColors.attendanceLate or a Theme-aware color')
  static const orange = Color(0xFFEA580C);
  @Deprecated('Use a Theme-aware container color instead')
  static const orangeBg = Color(0xFFFFEDD5);
  @Deprecated('Use Theme.of(context).colorScheme.surface')
  static const surface = Color(0xFFF8FAFC);
  @Deprecated('Use Theme.of(context).colorScheme.onSurface')
  static const textPrimary = Color(0xFF0F172A);
  @Deprecated('Use Theme.of(context).colorScheme.onSurfaceVariant')
  static const textSecondary = Color(0xFF64748B);
  @Deprecated('Use Theme.of(context).colorScheme.onSurfaceVariant')
  static const textMuted = Color(0xFF64748B);
  @Deprecated('Use Theme.of(context).dividerColor')
  static const divider = Color(0xFFE2E8F0);
  @Deprecated('Use Theme.of(context).colorScheme.surfaceContainerHighest')
  static const badgeGray = Color(0xFFF1F5F9);
}

/// Status → color mapping, kept separate from [AppColors] so a status
/// (`present`, `needsRevision`, …) is never a made-up color name on its
/// own — it always resolves through the shared semantic palette.
///
/// Per the accessibility rule in docs/UI_DESIGN_SYSTEM.md §2.2: color is
/// never the only indicator of a status in the UI — always pair with an
/// icon and/or text (see StatusBadge).
class StatusColors {
  const StatusColors._();

  // حضور
  static const present = AppColors.success;
  static const attendanceLate = AppColors.warning; // "late" اسم محجوز في Dart
  static const absent = AppColors.danger;
  static const excused = AppColors.neutral;

  // حفظ
  static const memorized = AppColors.success;
  static const needsRevision = AppColors.warning;
  static const notMemorized = AppColors.neutral;

  // أهداف
  static const goalCompleted = AppColors.success;
  static const goalInProgress = AppColors.warning;
  static const goalNotStarted = AppColors.neutral;
}
