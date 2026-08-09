// Sprint 1, item 1.9 — golden coverage for the shared widgets migrated in
// item 1.4, in both themes. Baselines were generated on this machine
// (Windows) and CI also runs on windows-latest, so font-rendering drift
// between generation and verification should be minimal — but golden
// tests are inherently sensitive to that, so a failure here first means
// "check whether this is a real visual regression," not "definitely a bug."
//
// Regenerate baselines after an intentional visual change:
//   flutter test test/widgets/shared_widgets_golden_test.dart --update-goldens
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_theme.dart';
import 'package:quran_mobile/core/widgets/empty_state.dart';
import 'package:quran_mobile/core/widgets/kpi_card.dart';
import 'package:quran_mobile/core/widgets/session_card.dart';
import 'package:quran_mobile/core/widgets/status_badge.dart';

Widget _harness(Widget child, {required Brightness brightness}) {
  return MaterialApp(
    theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
    debugShowCheckedModeBanner: false,
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

Future<void> _expectGolden(
  WidgetTester tester,
  Widget widget, {
  required String name,
  required Brightness brightness,
  Size surfaceSize = const Size(400, 200),
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(_harness(widget, brightness: brightness));
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull, reason: '$name (${brightness.name}) must not throw/overflow while laying out');
  await expectLater(
    find.byWidget(widget),
    matchesGoldenFile('goldens/${name}_${brightness.name}.png'),
  );
}

void main() {
  setUpAll(() => initializeDateFormatting('ar'));

  for (final brightness in [Brightness.light, Brightness.dark]) {
    testWidgets('KpiCard — ${brightness.name}', (tester) async {
      await _expectGolden(
        tester,
        const KpiCard(icon: AppIcons.people, title: 'الطلاب', value: '42'),
        name: 'kpi_card',
        brightness: brightness,
        surfaceSize: const Size(200, 140),
      );
    });

    testWidgets('KpiCard — عنوان طويل لا يفيض — ${brightness.name}', (tester) async {
      await _expectGolden(
        tester,
        const KpiCard(icon: AppIcons.book, title: 'الصفحات المحفوظة هذا الأسبوع بالكامل', value: '128'),
        name: 'kpi_card_long_title',
        brightness: brightness,
        surfaceSize: const Size(160, 155),
      );
    });

    testWidgets('StatusBadge.attendance — ${brightness.name}', (tester) async {
      await _expectGolden(
        tester,
        StatusBadge.attendance('حاضر'),
        name: 'status_badge_present',
        brightness: brightness,
        surfaceSize: const Size(150, 80),
      );
    });

    testWidgets('SessionCard — ${brightness.name}', (tester) async {
      await _expectGolden(
        tester,
        SessionCard(
          item: SessionCardItem(
            id: 1,
            studentId: 1,
            studentName: 'أحمد محمد عبدالرحمن',
            initials: 'أ',
            date: DateTime(2026, 8, 7),
            timeDisplay: '18:00',
            attendanceStatus: 'حاضر',
            finalScore: 9.2,
            memorizationInfo: 'حفظ: البقرة (١-٢٠)',
            revisionInfo: 'مراجعة: آل عمران (١-١٠)',
          ),
        ),
        name: 'session_card',
        brightness: brightness,
        surfaceSize: const Size(400, 160),
      );
    });

    testWidgets('EmptyState (card) — ${brightness.name}', (tester) async {
      await _expectGolden(
        tester,
        const EmptyState(
          icon: Icons.calendar_today_outlined,
          title: 'لا توجد جلسات بعد',
          description: 'ابدأ بتسجيل أول جلسة لأحد الطلاب',
          card: true,
        ),
        name: 'empty_state_card',
        brightness: brightness,
        surfaceSize: const Size(360, 260),
      );
    });
  }
}
