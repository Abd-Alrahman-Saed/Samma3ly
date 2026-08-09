import 'package:flutter/material.dart';

/// Exact palette from the adopted design (Claude Design project
/// "Quran Mobile Redesign.dc.html") — see docs/DESIGN_SPEC.md §1.
///
/// These are literal hex values from the design source, not a derived
/// seed palette. Widgets should prefer `Theme.of(context).colorScheme`
/// where Flutter's own semantics apply (e.g. `error`, `surface`), but for
/// anything the design specifies as an exact standalone color (status
/// pairs, level badges, borders), use these directly — that's what keeps
/// the app pixel-faithful to the source.
class AppColors {
  const AppColors._();

  // ── Brand / surfaces ───────────────────────────────────
  static const primary = Color(0xFF1B5E4A);
  static const onPrimary = Color(0xFFFAF8F3);
  static const accent = Color(0xFFC9A227); // ذهبي — النجوم والزخرفة فقط
  static const appBackground = Color(0xFFFAF8F3);
  static const cardBg = Colors.white;
  static const cardBorder = Color(0xFFEEE8DA);
  static const inputBg = Color(0xFFFBFAF6); // شاشات الدخول/الإعداد/نموذج طالب
  static const inputBgOnCard = Colors.white; // داخل الشرائح السفلية
  static const inputBorder = Color(0xFFE7E1D3);
  static const skeletonBg = Color(0xFFEEE8DA);
  static const dividerLight = Color(0xFFF1EFE9);

  // ── Text ────────────────────────────────────────────────
  static const textPrimary = Color(0xFF1E2A24);
  static const textSecondary = Color(0xFF6B7568);
  static const textMuted = Color(0xFF8A8478);
  static const textDisabled = Color(0xFFB9B2A0);
  static const tabInactive = Color(0xFFB0AA98);
  static const deleteIcon = Color(0xFFC9BBA0);

  // ── Streak badge (دافئ ذهبي) ────────────────────────────
  static const streakBg = Color(0xFFFBF3DD);
  static const streakBorder = Color(0xFFF0E2B8);
  static const streakFg = Color(0xFF7A5D14);
  static const streakIconFg = Color(0xFF96731A);

  // ── Legacy bridge (Sprint 1 field names, pre-design-adoption) ──
  // Temporary: screens not yet re-skinned to docs/DESIGN_SPEC.md
  // (tracked in IMPLEMENTATION_PLAN.md Sprint 1.5, items D.7–D.11)
  // still reference these names. Remove this whole block once every
  // screen is migrated — do not add new call sites against it.
  @Deprecated('Use StatusColors.absent.fg')
  static const error = Color(0xFFC0392B);
  @Deprecated('Use StatusColors.present.fg')
  static const success = Color(0xFF2F8F5B);
  @Deprecated('Use StatusColors.attendanceLate.fg')
  static const warning = Color(0xFFD97706);
  @Deprecated('Use StatusColors.absent.fg')
  static const danger = error;
  @Deprecated('Use StatusColors.present.bg')
  static const successBg = Color(0xFFE9F5EE);
  @Deprecated('Use StatusColors.attendanceLate.bg')
  static const warningBg = Color(0xFFFDF3E3);
  @Deprecated('Use StatusColors.needsRevision.fg (٩٦٧٣١أ — نفس القيمة)')
  static const orange = Color(0xFF96731A);
  @Deprecated('Use dividerLight')
  static const badgeGray = dividerLight;
  @Deprecated('Use cardBorder (بين البطاقات) أو dividerLight (داخل البطاقة)')
  static const divider = dividerLight;
  @Deprecated('Use StatusColors.needsRevision.fg — نفس القيمة المستخدمة لنص المراجعة في الملف المصدر')
  static const secondary = Color(0xFF96731A);
  @Deprecated('Use StatusColors.memorized.bg')
  static const primaryLight = Color(0xFFE9F3EF);
}

/// Status → (foreground, background) pairs, exact from the design source.
/// Always pair with an icon/text label too — never color alone.
class StatusColors {
  const StatusColors._();

  static const present = (fg: Color(0xFF2F8F5B), bg: Color(0xFFE9F5EE));
  static const attendanceLate = (fg: Color(0xFFD97706), bg: Color(0xFFFDF3E3));
  static const absent = (fg: Color(0xFFC0392B), bg: Color(0xFFFBEAE7));
  static const excused = (fg: Color(0xFF8A8478), bg: Color(0xFFF1EFE9));

  static const memorized = (fg: Color(0xFF1B5E4A), bg: Color(0xFFE9F3EF));
  static const needsRevision = (fg: Color(0xFF96731A), bg: Color(0xFFFBF3DD));
  static const notMemorized = (fg: Color(0xFF8A8478), bg: Color(0xFFF1EFE9));

  static const goalActive = (fg: Color(0xFF1B5E4A), bg: Color(0xFFE9F3EF));
  static const goalCompleted = (fg: Color(0xFF96731A), bg: Color(0xFFFBF3DD));
  static const goalLate = (fg: Color(0xFFC0392B), bg: Color(0xFFFBEAE7));

  static const levelBeginner = (fg: Color(0xFF8A8478), bg: Color(0xFFF1EFE9));
  static const levelIntermediate = (fg: Color(0xFF96731A), bg: Color(0xFFFBF3DD));
  static const levelAdvanced = (fg: Color(0xFF1B5E4A), bg: Color(0xFFE9F3EF));

  /// Maps the Arabic attendance-status literal (as stored/displayed) to
  /// its (fg, bg) pair. Falls back to [excused] for an unrecognized value.
  static ({Color fg, Color bg}) forAttendance(String status) => switch (status) {
        'حاضر' => present,
        'متأخر' => attendanceLate,
        'غائب' => absent,
        _ => excused,
      };

  static ({Color fg, Color bg}) forMemorization(String status) => switch (status) {
        'محفوظ' => memorized,
        'يحتاج مراجعة' => needsRevision,
        _ => notMemorized,
      };

  static ({Color fg, Color bg}) forGoal(String status) => switch (status) {
        'نشط' => goalActive,
        'مكتمل' => goalCompleted,
        'متأخر' => goalLate,
        _ => goalActive,
      };

  static ({Color fg, Color bg}) forLevel(String level) => switch (level) {
        'مبتدئ' => levelBeginner,
        'متوسط' => levelIntermediate,
        'متقدم' => levelAdvanced,
        _ => levelBeginner,
      };
}
