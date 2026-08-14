import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Hand-drawn line icon set — exact markup copied from the adopted
/// design (`Quran Mobile Redesign.dc.html`, see docs/DESIGN_SPEC.md §4).
/// Deliberately NOT Material Icons: the design's icon language is a
/// distinct, consistent stroke style (round caps/joins, ~1.8–2.2 stroke
/// width, mostly unfilled) and using Material glyphs instead would break
/// visual fidelity to the source everywhere at once.
///
/// Each entry is the verbatim inner-SVG markup from the source (kept as
/// `<circle>`/`<path>` elements, not force-converted to path-only data —
/// less error-prone than re-deriving arc syntax by hand). [AppIcon] tints
/// the whole rendered icon via `colorFilter`, so the literal stroke/fill
/// colors in the markup below don't matter — they're always overridden.
class AppIcons {
  const AppIcons._();

  // مصحف مفتوح — الشعار، الأفاتار الافتراضي
  static const book =
      '<path d="M3 5.2c2.2-1.6 5.6-1.6 8 0v14c-2.4-1.6-5.8-1.6-8 0z" fill="none" stroke="#000" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>'
      '<path d="M21 5.2c-2.2-1.6-5.6-1.6-8 0v14c2.4-1.6 5.8-1.6 8 0z" fill="none" stroke="#000" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>';

  // شخص واحد — نموذج الإعداد
  static const person =
      '<circle cx="12" cy="8" r="3.4" fill="none" stroke="#000" stroke-width="1.8"/>'
      '<path d="M4.5 20a7.5 7.5 0 0 1 15 0" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>';

  // شخصان — أيقونة "الطلاب" (كروت/إجراءات)
  static const people =
      '<circle cx="9" cy="8" r="3.2" fill="none" stroke="#000" stroke-width="1.8"/>'
      '<path d="M2.5 20v-1.2A5 5 0 0 1 7.5 13.8h3A5 5 0 0 1 15.5 18.8V20" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>';

  // شخصان — تبويب "الطلاب" في الشريط السفلي (بشخص إضافي أصغر)
  static const peopleTab =
      '$people'
      '<circle cx="17.2" cy="9" r="2.4" fill="none" stroke="#000" stroke-width="1.9"/>'
      '<path d="M15.6 13.6c2.6.2 4.4 2 4.4 4.3V20" fill="none" stroke="#000" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"/>';

  // تقويم بسيط — "جلسات اليوم"
  static const calendar =
      '<rect x="3.5" y="5" width="17" height="16" rx="2.5" fill="none" stroke="#000" stroke-width="1.8"/>'
      '<path d="M3.5 9.5h17M8 3v4M16 3v4" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round"/>';

  // تقويم بعلامة صح — إجراء "جلسة جديدة"
  static const calendarCheck =
      '$calendar'
      '<path d="M8.5 14.5l2 2 4.5-4.5" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>';

  // ساعة — الجداول/المواعيد
  static const clock =
      '<circle cx="12" cy="12" r="8.5" fill="none" stroke="#000" stroke-width="1.8"/>'
      '<path d="M12 7.5V12l3.2 2" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>';

  // دائرة بعلامة صح — نسبة الحضور، حالة "حاضر"
  static const checkCircle =
      '<circle cx="12" cy="12" r="9" fill="none" stroke="#000" stroke-width="2.2"/>'
      '<path d="M8 12.5l2.5 2.5L16 9.5" fill="none" stroke="#000" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>';

  // دائرة بعلامة X — حالة "غائب" في زر الحضور
  static const circleX =
      '<circle cx="12" cy="12" r="9" fill="none" stroke="#000" stroke-width="2.2"/>'
      '<path d="M9 9l6 6M15 9l-6 6" fill="none" stroke="#000" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>';

  // دائرة بخط أفقي — حالة "مستأذن" في زر الحضور
  static const circleDash =
      '<circle cx="12" cy="12" r="9" fill="none" stroke="#000" stroke-width="2.2"/>'
      '<path d="M8.5 12h7" fill="none" stroke="#000" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>';

  // نجمة مملوءة — أفضل طالب / السور المكتملة (ذهبي دائماً)
  static const star = '<path d="M12 2.5l3 6.5 7 .7-5.3 4.7 1.6 7-6.3-3.9-6.3 3.9 1.6-7L1 9.7l7-.7z" fill="#000"/>';

  // علم — الأهداف
  static const flag =
      '<path d="M6 21V4" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round"/>'
      '<path d="M6 4.5c2-1 4.5-1 6.5.5s4.5 1.5 6.5.5v9c-2 1-4.5 1-6.5-.5s-4.5-1.5-6.5-.5" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>';

  // شيفرون — رجوع (RTL) وسهم "المزيد" في صفوف القوائم
  static const chevronLeft = '<path d="M15 5l-7 7 7 7" fill="none" stroke="#000" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>';
  static const chevronRight = '<path d="M9 5l7 7-7 7" fill="none" stroke="#000" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>';
  static const chevronDown = '<path d="M6 9l6 6 6-6" fill="none" stroke="#000" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>';

  static const close = '<path d="M6 6l12 12M18 6L6 18" fill="none" stroke="#000" stroke-width="2" stroke-linecap="round"/>';
  static const plus = '<path d="M12 5v14M5 12h14" fill="none" stroke="#000" stroke-width="2.3" stroke-linecap="round"/>';

  static const search =
      '<circle cx="10.5" cy="10.5" r="6.5" fill="none" stroke="#000" stroke-width="1.9"/>'
      '<path d="M20 20l-4.5-4.5" fill="none" stroke="#000" stroke-width="1.9" stroke-linecap="round"/>';

  // عين — إظهار/إخفاء كلمة المرور
  static const eye =
      '<path d="M2 12s3.8-6.5 10-6.5S22 12 22 12s-3.8 6.5-10 6.5S2 12 2 12z" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>'
      '<circle cx="12" cy="12" r="2.6" fill="none" stroke="#000" stroke-width="1.8"/>';

  static const trash = '<path d="M4 7h16M9 7V4.5h6V7M6 7l1 13.5h10L18 7" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>';
  static const edit = '<path d="M4 20h4L20 8l-4-4L4 16v4z" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>';

  static const phone =
      '<path d="M6.5 3.5c1 0 2.7 1.7 3 3s-1 2.3-1 3 2 4 3.5 5.5 4.5 4.5 5.5 3.5 2-1 3-1 3 2 3 3-2 3.5-4 3.5C15.5 21 3 8.5 3 5.5S5.5 3.5 6.5 3.5z" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>';

  // نسخة احتياطية (سحابة + سهم للأعلى)
  static const backup =
      '<path d="M7 18a4.5 4.5 0 0 1-.6-8.9A5.5 5.5 0 0 1 17 8.5a4 4 0 0 1-.5 8" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>'
      '<path d="M12 20v-7M9 15.5L12 12.5l3 3" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>';

  // استعادة (سحابة + سهم للأسفل)
  static const restore =
      '<path d="M7 18a4.5 4.5 0 0 1-.6-8.9A5.5 5.5 0 0 1 17 8.5a4 4 0 0 1-.5 8" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>'
      '<path d="M12 13v7M9 17.5L12 20.5l3-3" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>';

  // مشاركة (ثلاث دوائر متصلة)
  static const share =
      '<circle cx="6" cy="12" r="2.3" fill="none" stroke="#000" stroke-width="1.8"/>'
      '<circle cx="18" cy="5.5" r="2.3" fill="none" stroke="#000" stroke-width="1.8"/>'
      '<circle cx="18" cy="18.5" r="2.3" fill="none" stroke="#000" stroke-width="1.8"/>'
      '<path d="M8.1 10.8l7.8-4.4M8.1 13.2l7.8 4.4" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round"/>';

  static const logout =
      '<path d="M9 4H5.5A1.5 1.5 0 0 0 4 5.5v13A1.5 1.5 0 0 0 5.5 20H9" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>'
      '<path d="M20 12H10.5M16 8l4 4-4 4" fill="none" stroke="#000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>';

  // قبّة مسجد — تبويب "الرئيسية" (بديل مقصود عن أيقونة "منزل" تقليدية)
  static const home = '<path d="M4 21h16M6 21V10a6 6 0 1 1 12 0v11M9 21v-5a3 3 0 0 1 6 0v5" fill="none" stroke="#000" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"/>';

  // رسم بياني عمودي — تبويب "التقارير"
  static const chart = '<path d="M4 20V11M11 20V4M18 20v-7" fill="none" stroke="#000" stroke-width="1.9" stroke-linecap="round"/><path d="M2.5 20h19" fill="none" stroke="#000" stroke-width="1.9" stroke-linecap="round"/>';

  // منزلقات — تبويب "الإعدادات"
  static const settings =
      '<path d="M4 6h9M17 6h3M4 12h3M11 12h9M4 18h13" fill="none" stroke="#000" stroke-width="1.9" stroke-linecap="round"/>'
      '<circle cx="15" cy="6" r="2" fill="none" stroke="#000" stroke-width="1.9"/>'
      '<circle cx="7" cy="12" r="2" fill="none" stroke="#000" stroke-width="1.9"/>'
      '<circle cx="17" cy="18" r="2" fill="none" stroke="#000" stroke-width="1.9"/>';

  static const admin = person; // نفس أيقونة الشخص — شاشة الإعداد الأولي

  // ثلاث نقاط أفقية — تبويب "المزيد" في الشريط السفلي (بند 3.7)
  static const more =
      '<circle cx="5" cy="12" r="1.9" fill="#000"/>'
      '<circle cx="12" cy="12" r="1.9" fill="#000"/>'
      '<circle cx="19" cy="12" r="1.9" fill="#000"/>';
}

/// Renders an [AppIcons] markup constant, tinted to [color] regardless of
/// the literal colors embedded in the markup (via `BlendMode.srcIn`).
class AppIcon extends StatelessWidget {
  final String markup;
  final double size;
  final Color color;

  const AppIcon(this.markup, {super.key, this.size = 20, required this.color});

  @override
  Widget build(BuildContext context) {
    final svg = '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">$markup</svg>';
    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
