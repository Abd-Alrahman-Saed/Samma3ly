// Smoke coverage for item 2.5's screens — this project doesn't otherwise
// widget-test full screens (services/repositories/migrations carry the
// real test weight; see docs/IMPLEMENTATION_PLAN.md Sprint 0/2 notes), but
// the Group screens wire together several new providers (2.4) for the
// first time in one place, so a cheap "does it render without throwing"
// check is worth having. Navigation taps (context.goNamed/pop) are
// deliberately NOT exercised here — there is no GoRouter in this harness,
// only a bare MaterialApp, so tapping them would throw for a reason
// unrelated to the screens themselves.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/features/groups/screens/group_detail_screen.dart';
import 'package:quran_mobile/features/groups/screens/group_list_screen.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

Widget _harness(AppDatabase db, Widget child) {
  return ProviderScope(
    overrides: [appDatabaseProvider.overrideWithValue(db)],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(textDirection: TextDirection.rtl, child: child),
    ),
  );
}

void main() {
  setUpAll(() => initializeDateFormatting('ar'));

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('GroupListScreen يعرض الحالة الفارغة بلا استثناءات عند عدم وجود حلقات', (tester) async {
    final db = openTestDatabase();
    addTearDown(db.close);

    await tester.pumpWidget(_harness(db, const GroupListScreen()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('الحلقات الجماعية'), findsOneWidget);
    expect(find.text('لا توجد حلقات جماعية'), findsOneWidget);
  });

  testWidgets('GroupListScreen يعرض الحلقات الموجودة', (tester) async {
    final db = openTestDatabase();
    addTearDown(db.close);
    final dao = GroupDao(db);
    await dao.insert(GroupsCompanion.insert(name: 'حلقة الفجر'));

    await tester.pumpWidget(_harness(db, const GroupListScreen()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('حلقة الفجر'), findsOneWidget);
  });

  testWidgets('GroupDetailScreen يعرض التبويبات الأربعة ويسمح بالتنقل بينها بلا استثناءات', (tester) async {
    final db = openTestDatabase();
    addTearDown(db.close);
    final dao = GroupDao(db);
    final groupId = await dao.insert(GroupsCompanion.insert(name: 'حلقة تجريبية'));

    await tester.pumpWidget(_harness(db, GroupDetailScreen(groupId: groupId)));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('حلقة تجريبية'), findsOneWidget);
    expect(find.text('الأعضاء'), findsOneWidget);
    expect(find.text('الجدول الأسبوعي'), findsOneWidget);
    expect(find.text('المواعيد القادمة'), findsOneWidget);
    expect(find.text('الإعدادات'), findsOneWidget);
    // Empty-members state renders under the first (default) tab.
    expect(find.text('لا يوجد طلاب في هذه الحلقة بعد'), findsOneWidget);

    await tester.tap(find.text('الجدول الأسبوعي'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('لا توجد مواعيد أسبوعية بعد'), findsOneWidget);

    await tester.tap(find.text('المواعيد القادمة'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('لا مواعيد قادمة خلال الثلاثين يوماً القادمة'), findsOneWidget);

    await tester.tap(find.text('الإعدادات'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('حلقة تجريبية'), findsWidgets); // header + settings-tab card
  });

  testWidgets('GroupDetailScreen لحلقة غير موجودة يعرض رسالة بدل استثناء', (tester) async {
    final db = openTestDatabase();
    addTearDown(db.close);

    await tester.pumpWidget(_harness(db, const GroupDetailScreen(groupId: 999)));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('الحلقة غير موجودة'), findsOneWidget);
  });
}
