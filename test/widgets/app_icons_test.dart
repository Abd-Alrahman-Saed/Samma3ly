// Smoke test: every AppIcons entry must parse as valid SVG and render
// without throwing. Cheap insurance before building screens on top of
// hand-copied SVG markup (see docs/DESIGN_SPEC.md §4).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';

void main() {
  final icons = <String, String>{
    'book': AppIcons.book,
    'person': AppIcons.person,
    'people': AppIcons.people,
    'peopleTab': AppIcons.peopleTab,
    'calendar': AppIcons.calendar,
    'calendarCheck': AppIcons.calendarCheck,
    'clock': AppIcons.clock,
    'checkCircle': AppIcons.checkCircle,
    'star': AppIcons.star,
    'flag': AppIcons.flag,
    'chevronLeft': AppIcons.chevronLeft,
    'chevronRight': AppIcons.chevronRight,
    'chevronDown': AppIcons.chevronDown,
    'close': AppIcons.close,
    'plus': AppIcons.plus,
    'search': AppIcons.search,
    'eye': AppIcons.eye,
    'trash': AppIcons.trash,
    'edit': AppIcons.edit,
    'phone': AppIcons.phone,
    'backup': AppIcons.backup,
    'restore': AppIcons.restore,
    'share': AppIcons.share,
    'logout': AppIcons.logout,
    'home': AppIcons.home,
    'chart': AppIcons.chart,
    'settings': AppIcons.settings,
    'admin': AppIcons.admin,
    'more': AppIcons.more,
  };

  testWidgets('كل أيقونة في AppIcons تُرسم بلا استثناءات', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Wrap(
            children: icons.entries
                .map((e) => AppIcon(e.value, color: const Color(0xFF1B5E4A), size: 24))
                .toList(),
          ),
        ),
      ),
    );
    // ينتظر تحميل SVGs (SvgPicture غير متزامن داخلياً حتى لو كان string ثابت).
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(SizedBox), findsWidgets); // flutter_svg يلف الرسم بحاوية بحجم ثابت
  });
}
