// Item 3.7 — the nav-highlight decision logic, tested in isolation from
// the widget tree.
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/widgets/app_shell.dart';

void main() {
  group('appShellTabIndex', () {
    test('المسار الجذري "/" يفعّل تبويب اليوم (0)', () {
      expect(appShellTabIndex('/'), 0);
    });

    test('مسارات الحلقات (بما فيها الفرعية) تفعّل تبويب الحلقات (1)', () {
      expect(appShellTabIndex('/groups'), 1);
      expect(appShellTabIndex('/groups/5'), 1);
      expect(appShellTabIndex('/groups/5/session/9'), 1);
      expect(appShellTabIndex('/groups/create'), 1);
    });

    test('مسارات الطلاب تفعّل تبويب الطلاب (2)', () {
      expect(appShellTabIndex('/students'), 2);
      expect(appShellTabIndex('/students/3'), 2);
      expect(appShellTabIndex('/students/3/sessions/create'), 2);
    });

    test('مسار التقارير يفعّل تبويب التقارير (3)', () {
      expect(appShellTabIndex('/reports'), 3);
    });

    test('كل المسارات الثانوية (الجلسات/الجداول/الأهداف/التقويم/المراجعة/الإعدادات/المزيد) تفعّل تبويب المزيد (4)', () {
      expect(appShellTabIndex('/sessions'), 4);
      expect(appShellTabIndex('/sessions/create'), 4);
      expect(appShellTabIndex('/schedules'), 4);
      expect(appShellTabIndex('/goals'), 4);
      expect(appShellTabIndex('/calendar'), 4);
      expect(appShellTabIndex('/review-queue'), 4);
      expect(appShellTabIndex('/settings'), 4);
      expect(appShellTabIndex('/more'), 4);
    });
  });
}
