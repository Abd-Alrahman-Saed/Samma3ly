// القسم ح.6 — الشاشة الجديدة اللي حلّت محل GroupRecitationSheet (ورقة
// سفلية). بنفس تخطيط SessionCreateScreen: حضور + ملاحظات + حفظ + مراجعة +
// تقييم (حفظ/تجويد/طلاقة/تشكيل)، وحفظ نهائي بزرَّين "ممتاز"/"يُعاد" بدل زر
// حفظ واحد — كلاهما يكتب على SessionAttendances (بما فيها recitationOutcome
// الجديد، v7) ويرجع للخلف.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/features/groups/screens/group_student_recitation_screen.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ar'));

  late AppDatabase db;
  late GroupDao groupDao;
  late StudentDao studentDao;
  late SessionDao sessionDao;
  late int groupId;
  late int studentId;
  late int sessionId;

  setUp(() async {
    db = openTestDatabase();
    groupDao = GroupDao(db);
    studentDao = StudentDao(db);
    sessionDao = SessionDao(db);

    groupId = await groupDao.insert(GroupsCompanion.insert(name: 'حلقة تجريبية'));
    studentId = await studentDao.insert(StudentsCompanion.insert(fullName: 'سالم', age: 10, phone: '1', address: 'a'));
    await groupDao.addMember(GroupMembersCompanion.insert(groupId: groupId, studentId: studentId));

    sessionId = await sessionDao.insert(SessionsCompanion.insert(
      groupId: Value(groupId),
      sessionType: const Value('جماعي'),
      occurrenceDate: Value(DateTime(2026, 3, 9)),
      date: DateTime(2026, 3, 9),
      time: '17:00',
    ));
  });

  tearDown(() => db.close());

  Future<void> openScreen(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/start',
      routes: [
        GoRoute(path: '/start', builder: (_, __) => const Scaffold(body: Text('البداية'))),
        GoRoute(
          path: '/recitation',
          builder: (_, __) => GroupStudentRecitationScreen(groupId: groupId, sessionId: sessionId, studentId: studentId),
        ),
      ],
    );
    await tester.pumpWidget(ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
    ));
    await tester.pumpAndSettle();
    router.push('/recitation');
    await tester.pumpAndSettle();
  }

  testWidgets('تعرض اسم الطالب وتاريخ الجلسة وحالة "حاضر" مبدئياً بلا استثناءات', (tester) async {
    await openScreen(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('سالم'), findsOneWidget);
    expect(find.textContaining('17:00'), findsOneWidget);
    expect(find.text('ممتاز'), findsOneWidget);
    expect(find.text('يُعاد'), findsOneWidget);
  });

  testWidgets('الضغط على "ممتاز" يحفظ التقييم ونتيجة "ممتاز" في SessionAttendances', (tester) async {
    await openScreen(tester);

    await tester.enterText(find.byType(TextFormField).first, 'ملاحظة تجريبية');
    await tester.dragUntilVisible(find.text('ممتاز'), find.byType(Scrollable).first, const Offset(0, -300));
    await tester.tap(find.text('ممتاز'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final saved = await sessionDao.getAttendance(sessionId, studentId);
    expect(saved, isNotNull);
    expect(saved!.recitationOutcome, 'ممتاز');
    expect(saved.notes, 'ملاحظة تجريبية');
    expect(saved.attendanceStatus, AttendanceStatus.present.arabic);

    // رجعت لشاشة البداية (الحفظ ينهي الشاشة).
    expect(find.text('البداية'), findsOneWidget);
  });

  testWidgets('الضغط على "يُعاد" يحفظ نتيجة "يُعاد"', (tester) async {
    await openScreen(tester);

    await tester.dragUntilVisible(find.text('يُعاد'), find.byType(Scrollable).first, const Offset(0, -300));
    await tester.tap(find.text('يُعاد'));
    await tester.pumpAndSettle();

    final saved = await sessionDao.getAttendance(sessionId, studentId);
    expect(saved!.recitationOutcome, 'يُعاد');
  });

  testWidgets('تعليم الطالب غائباً يخفي قسمَي الحفظ والتقييم، ويحفظ بلا درجات', (tester) async {
    await openScreen(tester);

    await tester.tap(find.text(AttendanceStatus.absent.arabic));
    await tester.pumpAndSettle();

    expect(find.text('الحفظ الجديد'), findsNothing);
    expect(find.text('التقييم'), findsNothing);

    await tester.dragUntilVisible(find.text('ممتاز'), find.byType(Scrollable).first, const Offset(0, -300));
    await tester.tap(find.text('ممتاز'));
    await tester.pumpAndSettle();

    final saved = await sessionDao.getAttendance(sessionId, studentId);
    expect(saved!.attendanceStatus, AttendanceStatus.absent.arabic);
    expect(saved.memorizationSurahId, isNull);
    expect(saved.memorizationScore, 0);
  });

  testWidgets('إعادة فتح الشاشة بعد حفظ سابق يُحمِّل البيانات المحفوظة', (tester) async {
    await sessionDao.upsertRecitation(SessionAttendancesCompanion(
      sessionId: Value(sessionId),
      studentId: Value(studentId),
      memorizationSurahId: const Value(2),
      memorizationFromAyah: const Value(1),
      memorizationToAyah: const Value(10),
      memorizationScore: const Value(8),
      tajweedScore: const Value(7),
      fluencyScore: const Value(9),
      accuracyScore: const Value(6),
      recitationOutcome: const Value('يُعاد'),
    ));

    await openScreen(tester);

    expect(find.text('8.0'), findsOneWidget);
    expect(find.text('7.0'), findsOneWidget);
    expect(find.text('9.0'), findsOneWidget);
    expect(find.text('6.0'), findsOneWidget);
  });
}
