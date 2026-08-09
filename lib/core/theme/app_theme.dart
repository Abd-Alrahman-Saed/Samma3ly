import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Light theme matches docs/DESIGN_SPEC.md exactly (literal values from
/// the adopted Claude Design source). Dark theme is NOT specified by the
/// design source — it's derived automatically from the same seed via
/// [ColorScheme.fromSeed] so the light/dark/system switch in Settings
/// (which the design DOES show, just without dark values) stays
/// functional. See IMPLEMENTATION_PLAN.md Sprint 1.5 note.
class AppTheme {
  const AppTheme._();

  static ThemeData get light => _light();
  static ThemeData get dark => _derivedDark();

  static ThemeData _light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      secondary: AppColors.accent,
      surface: AppColors.appBackground,
      error: const Color(0xFFC0392B),
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      surface: AppColors.appBackground,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outlineVariant: AppColors.cardBorder,
      outline: AppColors.inputBorder,
    );

    return _build(colorScheme, Brightness.light);
  }

  static ThemeData _derivedDark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      secondary: AppColors.accent,
    );
    return _build(colorScheme, Brightness.dark);
  }

  static ThemeData _build(ColorScheme colorScheme, Brightness brightness) {
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
        color: brightness == Brightness.light ? AppColors.cardBg : colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14), // نصف قطر البطاقات في التصميم المعتمد
          side: BorderSide(
            color: brightness == Brightness.light ? AppColors.cardBorder : colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light ? AppColors.inputBg : colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: brightness == Brightness.light ? AppColors.inputBorder : colorScheme.outlineVariant,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: brightness == Brightness.light ? AppColors.inputBorder : colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // زر أساسي
          textStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 14.5, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          textStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: brightness == Brightness.light ? AppColors.dividerLight : colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      // توست سفلي بيضاوي داكن (توست/Snackbar) — نفس الشكل في التصميم
      // المعتمد لكل الحالات (نجاح/خطأ/معلومة)؛ اللون لا يتغير حسب النوع.
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.onPrimary),
        actionTextColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: StadiumBorder(),
        insetPadding: EdgeInsets.fromLTRB(40, 8, 40, 90),
      ),
      // نافذة تأكيد مركزية (رسالة تأكيد الحذف/الخروج/الاستعادة) — بطاقة
      // بيضاء نصف قطرها 16، مطابقة للتصميم المعتمد.
      dialogTheme: DialogThemeData(
        backgroundColor: brightness == Brightness.light ? Colors.white : colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
        contentTextStyle: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: colorScheme.onSurfaceVariant, height: 1.6),
      ),
      // لا navigationBarTheme هنا عمداً — AppShell يبني الشريط السفلي يدوياً
      // (Row من أزرار مسطّحة) بدل NavigationBar، مطابقةً للتصميم المعتمد.
    );
  }

  /// Reem Kufi for headlines/titles, Cairo everywhere else — see
  /// docs/DESIGN_SPEC.md §2. Sizes match the design source's literal
  /// pixel values (translated 1:1 to logical sp — no additional scaling).
  static TextTheme _textTheme(ColorScheme cs) {
    const body = 'Cairo';
    const display = 'Reem Kufi';
    return TextTheme(
      // شعار شاشة الدخول
      displaySmall: TextStyle(fontFamily: display, fontSize: 25, color: cs.onSurface),
      // عناوين الشاشات الرئيسية (تحية Dashboard، "الطلاب"، "الإعدادات"…)
      headlineSmall: TextStyle(fontFamily: display, fontSize: 21, color: cs.onSurface),
      // عناوين شاشات فرعية (اسم الطالب في التفاصيل، "جدولة جلسة"…)
      titleLarge: TextStyle(fontFamily: display, fontSize: 17, color: cs.onSurface),
      // "الإعداد الأولي"
      titleMedium: TextStyle(fontFamily: display, fontSize: 20, color: cs.onSurface),
      // عناوين بطاقات (١٤/١٣.٥px، Cairo وزن 700)
      titleSmall: TextStyle(fontFamily: body, fontSize: 14, fontWeight: FontWeight.w700, color: cs.onSurface),
      // نص الأزرار الأساسية والحقول
      bodyLarge: TextStyle(fontFamily: body, fontSize: 14.5, color: cs.onSurface),
      // نص عادي
      bodyMedium: TextStyle(fontFamily: body, fontSize: 13.5, color: cs.onSurface),
      // نص ثانوي/وصفي
      bodySmall: TextStyle(fontFamily: body, fontSize: 12, color: cs.onSurfaceVariant),
      // تسميات الحقول
      labelLarge: TextStyle(fontFamily: body, fontSize: 12.5, fontWeight: FontWeight.w600, color: cs.onSurfaceVariant),
      // شارات صغيرة
      labelMedium: TextStyle(fontFamily: body, fontSize: 11, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant),
      labelSmall: TextStyle(fontFamily: body, fontSize: 10.5, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant),
    );
  }
}
