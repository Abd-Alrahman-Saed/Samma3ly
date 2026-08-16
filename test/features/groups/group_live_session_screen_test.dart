// Item 3.1's exit gate is explicit: "مختبَر في RTL — الاتجاهات صحيحة" (the
// swipe row must be tested in RTL, not just assumed correct). This suite
// pumps the real screen (not a fake) in an RTL Directionality and performs
// actual drag gestures, then asserts the resulting attendance write in a
// real in-memory database — proving `DismissDirection.startToEnd` really is
// a LEFTWARD drag here (the C3 trap: naively assuming "swipe right = start"
// like an LTR app would get this backwards) and that `confirmDismiss`
// returning false never removes the row (item 3, C3 resolution).
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/features/groups/screens/group_live_session_screen.dart';
import 'package:quran_mobile/features/groups/screens/group_student_recitation_screen.dart';
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

/// نسخة موجَّهة بـGoRouter حقيقي — بند ح.6: الضغط على الصف بقى ينقل عبر
/// `context.goNamed('groupStudentRecitation', ...)` بدل فتح ورقة سفلية، فلا
/// بد من GoRouter حقيقي في هذا الاختبار تحديداً (النمط المتّبع في بقية
/// الشاشات لا يحتاج هذا لأنه لا يفحص التنقّل نفسه).
Widget _routedHarness(AppDatabase db, {required int groupId, required int sessionId}) {
  final router = GoRouter(
    initialLocation: '/groups/$groupId/session/$sessionId',
    routes: [
      GoRoute(
        path: '/groups/:id/session/:sessionId',
        name: 'groupLiveSession',
        builder: (_, state) => GroupLiveSessionScreen(
          groupId: int.parse(state.pathParameters['id']!),
          sessionId: int.parse(state.pathParameters['sessionId']!),
        ),
        routes: [
          GoRoute(
            path: 'student/:studentId',
            name: 'groupStudentRecitation',
            builder: (_, state) => GroupStudentRecitationScreen(
              groupId: int.parse(state.pathParameters['id']!),
              sessionId: int.parse(state.pathParameters['sessionId']!),
              studentId: int.parse(state.pathParameters['studentId']!),
            ),
          ),
        ],
      ),
    ],
  );
  return ProviderScope(
    overrides: [appDatabaseProvider.overrideWithValue(db)],
    child: MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
    ),
  );
}

void main() {
  setUpAll(() => initializeDateFormatting('ar'));

  late AppDatabase db;
  late GroupDao groupDao;
  late StudentDao studentDao;
  late SessionDao sessionDao;
  late int groupId;
  late int student1;
  late int student2;
  late int sessionId;

  setUp(() async {
    db = openTestDatabase();
    groupDao = GroupDao(db);
    studentDao = StudentDao(db);
    sessionDao = SessionDao(db);

    groupId = await groupDao.insert(GroupsCompanion.insert(name: 'حلقة تجريبية'));
    student1 = await studentDao.insert(StudentsCompanion.insert(fullName: 'أحمد', age: 10, phone: '01000000001', address: 'القاهرة'));
    student2 = await studentDao.insert(StudentsCompanion.insert(fullName: 'محمد', age: 11, phone: '01000000002', address: 'القاهرة'));
    await groupDao.addMember(GroupMembersCompanion.insert(groupId: groupId, studentId: student1));
    await groupDao.addMember(GroupMembersCompanion.insert(groupId: groupId, studentId: student2));

    sessionId = await sessionDao.insert(SessionsCompanion.insert(
      groupId: Value(groupId),
      sessionType: Value('جماعي'),
      occurrenceDate: Value(DateTime(2026, 3, 9)),
      date: DateTime(2026, 3, 9),
      time: '17:00',
    ));
  });

  tearDown(() => db.close());

  testWidgets('يعرض الأعضاء بحالة "لم يُسجَّل" وعدّاد 0/عدد الأعضاء ابتداءً', (tester) async {
    await tester.pumpWidget(_harness(db, GroupLiveSessionScreen(groupId: groupId, sessionId: sessionId)));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('أحمد'), findsOneWidget);
    expect(find.text('محمد'), findsOneWidget);
    expect(find.text('0/2 حاضر'), findsOneWidget);
    expect(find.text('لم يُسجَّل'), findsNWidgets(2));
  });

  testWidgets('السحب لليسار (startToEnd في RTL) يسجّل "حاضر" — والصف يبقى موجوداً', (tester) async {
    await tester.pumpWidget(_harness(db, GroupLiveSessionScreen(groupId: groupId, sessionId: sessionId)));
    await tester.pumpAndSettle();

    // A leftward drag (negative dx) in an RTL Directionality IS
    // DismissDirection.startToEnd, since "start" is the right edge here.
    await tester.drag(find.byKey(ValueKey(student1)), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final attendance = await sessionDao.getAttendance(sessionId, student1);
    expect(attendance?.attendanceStatus, 'حاضر');
    // confirmDismiss always returns false — the row must still be there.
    expect(find.text('أحمد'), findsOneWidget);
    expect(find.text('حاضر'), findsOneWidget);
  });

  testWidgets('السحب لليمين (endToStart في RTL) يسجّل "غائب"', (tester) async {
    await tester.pumpWidget(_harness(db, GroupLiveSessionScreen(groupId: groupId, sessionId: sessionId)));
    await tester.pumpAndSettle();

    await tester.drag(find.byKey(ValueKey(student2)), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final attendance = await sessionDao.getAttendance(sessionId, student2);
    expect(attendance?.attendanceStatus, 'غائب');
    expect(find.text('محمد'), findsOneWidget);
  });

  testWidgets('"تحضير الكل" يسجّل الجميع حاضرين ويحدّث العدّاد', (tester) async {
    await tester.pumpWidget(_harness(db, GroupLiveSessionScreen(groupId: groupId, sessionId: sessionId)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('تحضير الكل'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('2/2 حاضر'), findsOneWidget);
    expect((await sessionDao.getAttendance(sessionId, student1))?.attendanceStatus, 'حاضر');
    expect((await sessionDao.getAttendance(sessionId, student2))?.attendanceStatus, 'حاضر');
  });

  testWidgets('الضغط على شريحة الحالة يفتح منتقي الحالات، واختيار "مستأذن" يسجّله', (tester) async {
    await tester.pumpWidget(_harness(db, GroupLiveSessionScreen(groupId: groupId, sessionId: sessionId)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(ValueKey('statusChip-$student1')));
    await tester.pumpAndSettle();

    expect(find.text('حالة الحضور'), findsOneWidget);
    // "مستأذن" appears once as a picker option (attendance status text).
    await tester.tap(find.text('مستأذن').last);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final attendance = await sessionDao.getAttendance(sessionId, student1);
    expect(attendance?.attendanceStatus, 'مستأذن');
  });

  testWidgets('الضغط على صف الطالب (بعيداً عن شريحة الحالة) يفتح شاشة تسميع الطالب الكاملة', (tester) async {
    await tester.pumpWidget(_routedHarness(db, groupId: groupId, sessionId: sessionId));
    await tester.pumpAndSettle();

    await tester.tap(find.text('أحمد'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    // القسم ح.6: بقت شاشة كاملة بنفس تخطيط SessionCreateScreen، لا ورقة
    // سفلية — الزرّان "ممتاز"/"يُعاد" فريدان لهذه الشاشة تحديداً.
    expect(find.text('ممتاز'), findsOneWidget);
    expect(find.text('يُعاد'), findsOneWidget);
  });
}
