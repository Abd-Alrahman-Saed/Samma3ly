// Item 3.6 smoke test — matches the precedent set by
// test/features/groups/group_screens_smoke_test.dart: no GoRouter in this
// harness, so navigation taps aren't exercised, just that the screen
// renders real data (individual + group entries) without throwing and
// week navigation works.
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Group, GroupScheduleSlot;
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/data/repositories/group_repository_impl.dart';
import 'package:quran_mobile/data/repositories/group_schedule_repository_impl.dart';
import 'package:quran_mobile/domain/entities/group.dart';
import 'package:quran_mobile/domain/entities/group_schedule_slot.dart';
import 'package:quran_mobile/features/calendar/screens/weekly_calendar_screen.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

Widget _harness(AppDatabase db) {
  return ProviderScope(
    overrides: [appDatabaseProvider.overrideWithValue(db)],
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(textDirection: TextDirection.rtl, child: WeeklyCalendarScreen()),
    ),
  );
}

void main() {
  setUpAll(() => initializeDateFormatting('ar'));

  late AppDatabase db;

  setUp(() {
    db = openTestDatabase();
  });

  tearDown(() => db.close());

  testWidgets('يعرض حالة فارغة بلا استثناءات لو الأسبوع بلا مواعيد', (tester) async {
    await tester.pumpWidget(_harness(db));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('التقويم الأسبوعي'), findsOneWidget);
    expect(find.text('لا مواعيد هذا الأسبوع'), findsOneWidget);
  });

  testWidgets('يعرض جلسة فردية وموعد حلقة حقيقيين لهذا الأسبوع', (tester) async {
    final groupDao = GroupDao(db);
    final studentDao = StudentDao(db);
    final sessionDao = SessionDao(db);
    final groupRepo = GroupRepositoryImpl(groupDao);
    final scheduleRepo = GroupScheduleRepositoryImpl(groupDao);

    final studentId = await studentDao.insert(StudentsCompanion.insert(fullName: 'أحمد', age: 10, phone: '1', address: 'a'));
    final now = DateTime.now();
    await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(now.year, now.month, now.day),
      time: '17:00',
    ));

    final group = await groupRepo.create(const Group(name: 'حلقة الفجر'));
    await scheduleRepo.createSlot(GroupScheduleSlot(
      groupId: group.id,
      weekday: now.weekday,
      fixedTime: '18:00',
      effectiveFrom: DateTime(now.year, now.month, now.day),
    ));

    await tester.pumpWidget(_harness(db));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('أحمد'), findsOneWidget);
    expect(find.text('حلقة الفجر'), findsOneWidget);
  });

  testWidgets('التنقّل بين الأسابيع (السابق/التالي) لا يرمي استثناءً', (tester) async {
    await tester.pumpWidget(_harness(db));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('nextWeek')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('previousWeek')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
