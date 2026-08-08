import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Sprint 1, items 1.2/1.3 — light + dark themes generated from a single
/// seed via [ColorScheme.fromSeed], plus a dark-mode-aware [TextTheme]
/// (replaces the old `AppTextStyles` constants that baked in a fixed
/// light-mode color — see app_text_styles.dart).
class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      secondary: AppColors.accent,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: 'Cairo',
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: _textTheme(colorScheme),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // كان `Colors.white` ثابتاً — بيكسر الوضع الداكن (بند 1.4). الأصح
        // سطح M3 القياسي للحقول المملوءة.
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  /// Mirrors the old `AppTextStyles` names via Material's semantic slots,
  /// but every color here comes from [colorScheme] — the whole point of
  /// this table existing is that it responds to dark mode, unlike the old
  /// `const TextStyle(color: AppColors.textPrimary)` constants.
  static TextTheme _textTheme(ColorScheme cs) {
    const family = 'Cairo';
    return TextTheme(
      // AppTextStyles.pageHeader
      headlineSmall: TextStyle(
        fontFamily: family,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: cs.onSurface,
      ),
      // AppTextStyles.sectionTitle
      titleMedium: TextStyle(
        fontFamily: family,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      // AppTextStyles.cardTitle
      titleSmall: TextStyle(
        fontFamily: family,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      // AppTextStyles.body — raised 14→16 (readable-font-size)
      bodyLarge: TextStyle(
        fontFamily: family,
        fontSize: 16,
        height: 1.6,
        color: cs.onSurface,
      ),
      // AppTextStyles.infoValue
      bodyMedium: TextStyle(
        fontFamily: family,
        fontSize: 14,
        height: 1.5,
        color: cs.onSurface,
      ),
      // AppTextStyles.small / muted — raised 12→13
      bodySmall: TextStyle(
        fontFamily: family,
        fontSize: 13,
        height: 1.5,
        color: cs.onSurfaceVariant,
      ),
      // AppTextStyles.infoLabel
      labelMedium: TextStyle(
        fontFamily: family,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: cs.onSurfaceVariant,
      ),
      // AppTextStyles.badge / score — raised 11→12
      labelSmall: TextStyle(
        fontFamily: family,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}
