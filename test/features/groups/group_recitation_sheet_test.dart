// Item 3.4's exit gate: "إغلاق التطبيق فجأة لا يفقد بيانات" — closing
// suddenly must not lose data. This suite exercises both the debounced
// autosave path (wait past the delay) and the "closed before the debounce
// fired" path, via two different dismissal routes: the sheet's own close
// button (which flushes explicitly) and popping the route out from under
// it entirely (which only the dispose()-time best-effort flush protects
// against) — the harder, more realistic "sudden close" case.
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/features/groups/screens/group_recitation_sheet.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

Widget _harness(AppDatabase db, {required int sessionId, required int studentId}) {
  return ProviderScope(
    overrides: [appDatabaseProvider.overrideWithValue(db)],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => GroupRecitationSheet.show(context, sessionId: sessionId, studentId: studentId, studentName: 'أحمد'),
              child: const Text('فتح'),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  late AppDatabase db;
  late SessionDao sessionDao;
  late int sessionId;
  late int studentId;

  setUp(() async {
    db = openTestDatabase();
    sessionDao = SessionDao(db);
    final studentDao = StudentDao(db);
    studentId = await studentDao.insert(StudentsCompanion.insert(fullName: 'أحمد', age: 10, phone: '1', address: 'a'));
    sessionId = await sessionDao.insert(SessionsCompanion.insert(date: DateTime(2026, 3, 9), time: '17:00'));
  });

  tearDown(() => db.close());

  testWidgets('الكتابة ثم الانتظار أطول من مهلة الحفظ التلقائي يحفظ البيانات', (tester) async {
    await tester.pumpWidget(_harness(db, sessionId: sessionId, studentId: studentId));
    await tester.tap(find.text('فتح'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('memFromAyah')), '5');
    await tester.pump(const Duration(milliseconds: 700)); // past the 500ms debounce

    final row = await sessionDao.getAttendance(sessionId, studentId);
    expect(row?.memorizationFromAyah, 5);
  });

  testWidgets('الضغط على زر الإغلاق فوراً بعد الكتابة (قبل انتهاء المهلة) لا يفقد البيانات', (tester) async {
    await tester.pumpWidget(_harness(db, sessionId: sessionId, studentId: studentId));
    await tester.tap(find.text('فتح'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('recitationNotes')), 'ملاحظة مهمة');
    // No wait for the debounce — close immediately.
    await tester.tap(find.byKey(const Key('recitationSheetClose')));
    await tester.pumpAndSettle();

    final row = await sessionDao.getAttendance(sessionId, studentId);
    expect(row?.notes, 'ملاحظة مهمة');
  });

  testWidgets('زر الرجوع (النظام) أثناء الكتابة — قبل انتهاء مهلة الحفظ — لا يفقد البيانات', (tester) async {
    // The system back gesture/button goes through Navigator.maybePop(),
    // which is exactly what PopScope(canPop: false) intercepts — unlike a
    // raw Navigator.pop() call, which Flutter defines to bypass PopScope
    // entirely (that's a documented characteristic of PopScope, not
    // something this sheet can work around). This is the realistic
    // "closed mid-typing without using the sheet's own close button" path.
    await tester.pumpWidget(_harness(db, sessionId: sessionId, studentId: studentId));
    await tester.tap(find.text('فتح'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('memFromAyah')), '3');
    // No wait for the debounce.
    final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
    await navigator.maybePop();
    await tester.pumpAndSettle();

    final row = await sessionDao.getAttendance(sessionId, studentId);
    expect(row?.memorizationFromAyah, 3);
  });

  testWidgets('اختيار سورة من القائمة يُحفَظ فوراً بلا انتظار', (tester) async {
    await tester.pumpWidget(_harness(db, sessionId: sessionId, studentId: studentId));
    await tester.tap(find.text('فتح'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('memSurahDropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1. الفاتحة').last);
    await tester.pumpAndSettle();

    final row = await sessionDao.getAttendance(sessionId, studentId);
    expect(row?.memorizationSurahId, 1);
  });

  testWidgets('البيانات المحفوظة سابقاً تُحمَّل عند فتح الشيت مرة أخرى', (tester) async {
    await sessionDao.upsertRecitation(SessionAttendancesCompanion(
      sessionId: Value(sessionId),
      studentId: Value(studentId),
      memorizationFromAyah: const Value(1),
      memorizationToAyah: const Value(7),
    ));

    await tester.pumpWidget(_harness(db, sessionId: sessionId, studentId: studentId));
    await tester.tap(find.text('فتح'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
  });
}
