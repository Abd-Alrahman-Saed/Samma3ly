// القسم ح.10 — "جلسة جديدة" الفردية بقت نفس شاشة تسميع الحلقة بالظبط:
// تقييم بأربعة معايير (حفظ/تجويد/طلاقة/تشكيل) بدل ثلاثة، وحفظ نهائي
// بزرَّين "اجتاز"/"يُعاد" بدل زر "حفظ الجلسة" الواحد.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide SessionEvaluation;
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/domain/entities/session.dart';
import 'package:quran_mobile/features/sessions/screens/session_create_screen.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

Future<void> openScreen(WidgetTester tester, AppDatabase db, {required int studentId}) async {
  final router = GoRouter(
    initialLocation: '/start',
    routes: [
      GoRoute(path: '/start', builder: (_, __) => const Scaffold(body: Text('البداية'))),
      GoRoute(path: '/create', builder: (_, __) => SessionCreateScreen(studentId: studentId)),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
    ),
  );
  await tester.pumpAndSettle();
  router.push('/create');
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('ar'));

  late AppDatabase db;
  late int studentId;

  setUp(() async {
    db = openTestDatabase();
    studentId = await StudentDao(db).insert(
      StudentsCompanion.insert(fullName: 'زياد', age: 10, phone: '1', address: 'a'),
    );
  });

  tearDown(() => db.close());

  testWidgets('تعرض 4 معايير تقييم وزرَّي اجتاز/يُعاد، بلا زر "حفظ الجلسة"', (tester) async {
    await openScreen(tester, db, studentId: studentId);

    expect(tester.takeException(), isNull);
    expect(find.text('الحفظ'), findsOneWidget);
    expect(find.text('التجويد'), findsOneWidget);
    expect(find.text('الطلاقة'), findsOneWidget);
    expect(find.text('التشكيل'), findsOneWidget);
    expect(find.text('اجتاز'), findsOneWidget);
    expect(find.text('يُعاد'), findsOneWidget);
    expect(find.text('حفظ الجلسة'), findsNothing);
  });

  testWidgets('الضغط على "اجتاز" يحفظ الجلسة بالدرجات الأربع ونتيجة "اجتاز"', (tester) async {
    await openScreen(tester, db, studentId: studentId);

    await tester.dragUntilVisible(find.text('اجتاز'), find.byType(Scrollable).first, const Offset(0, -300));
    await tester.tap(find.text('اجتاز'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final sessionDao = SessionDao(db);
    final sessions = await sessionDao.getAll(studentId: studentId);
    expect(sessions, hasLength(1));

    final attendance = await sessionDao.getAttendance(sessions.first.id, studentId);
    expect(attendance!.attendanceStatus, AttendanceStatus.present.arabic);
    expect(attendance.recitationOutcome, 'اجتاز');

    // رجعت لشاشة البداية (الحفظ ينهي الشاشة).
    expect(find.text('البداية'), findsOneWidget);
  });

  testWidgets('عدم إدخال أي درجة لا يُنشئ صفّ تقييم وهمياً بصفر', (tester) async {
    await openScreen(tester, db, studentId: studentId);

    await tester.dragUntilVisible(find.text('اجتاز'), find.byType(Scrollable).first, const Offset(0, -300));
    await tester.tap(find.text('اجتاز'));
    await tester.pumpAndSettle();

    final sessionDao = SessionDao(db);
    final sessions = await sessionDao.getAll(studentId: studentId);
    final evaluation = await sessionDao.getEvaluationBySession(sessions.first.id);
    expect(evaluation, isNull);
  });

  test('القسم ح.10: SessionEvaluation.finalScore يُحسب على متوسط 4 معايير لا 3', () {
    const evenScores = SessionEvaluation(memorizationScore: 8, tajweedScore: 8, fluencyScore: 8, accuracyScore: 8);
    expect(evenScores.finalScore, 8.0);

    // لو كان الحساب لا يزال على 3 (القديم)، (10+10+10+0)/3 = 10.0. على 4
    // (الجديد) = 7.5 — يثبّت أن التشكيل بقى معياراً فعلياً في المتوسط.
    const skewedScores = SessionEvaluation(memorizationScore: 10, tajweedScore: 10, fluencyScore: 10, accuracyScore: 0);
    expect(skewedScores.finalScore, 7.5);
  });

  test('القسم ح.12: revisionFinalScore مستقلّ تماماً عن finalScore، وhasRevisionEvaluation يميّز الحالتين', () {
    const noRevision = SessionEvaluation(memorizationScore: 9, tajweedScore: 9, fluencyScore: 9, accuracyScore: 9);
    expect(noRevision.revisionFinalScore, 0.0);
    expect(noRevision.hasRevisionEvaluation, isFalse);

    const withRevision = SessionEvaluation(
      revisionMemorizationScore: 10,
      revisionTajweedScore: 10,
      revisionFluencyScore: 10,
      revisionAccuracyScore: 0,
    );
    expect(withRevision.revisionFinalScore, 7.5, reason: 'نفس حساب finalScore لكن على درجات المراجعة');
    expect(withRevision.finalScore, 0.0, reason: 'درجات الحفظ الجديد لم تتأثر إطلاقاً');
    expect(withRevision.hasRevisionEvaluation, isTrue);
  });

  testWidgets(
    'اختيار سورة مراجعة يُظهر قسم "تقييم المراجعة" منفصلاً، والحفظ يخزّنه في '
    'SessionEvaluations دون المساس بتقييم الحفظ الجديد',
    (tester) async {
      await openScreen(tester, db, studentId: studentId);

      expect(find.text('تقييم المراجعة'), findsNothing);

      final surahs = await db.select(db.surahs).get();
      final revSurah = surahs.firstWhere((s) => s.id == 2);

      final revisionDropdown = find.byType(DropdownButtonFormField<int?>).at(1);
      await tester.dragUntilVisible(revisionDropdown, find.byType(Scrollable).first, const Offset(0, -300));
      await tester.tap(revisionDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('${revSurah.number}. ${revSurah.name}').last);
      await tester.pumpAndSettle();

      expect(find.text('تقييم المراجعة'), findsOneWidget);

      final sliders = find.byType(Slider);
      expect(sliders, findsNWidgets(8));
      await tester.dragUntilVisible(sliders.at(7), find.byType(Scrollable).first, const Offset(0, -300));
      await tester.drag(sliders.at(7), const Offset(300, 0));
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(find.text('اجتاز'), find.byType(Scrollable).first, const Offset(0, -300));
      await tester.tap(find.text('اجتاز'));
      await tester.pumpAndSettle();

      final sessionDao = SessionDao(db);
      final sessions = await sessionDao.getAll(studentId: studentId);
      expect(sessions, hasLength(1));
      final evaluation = await sessionDao.getEvaluationBySession(sessions.first.id);
      expect(evaluation, isNotNull);
      expect(evaluation!.revisionAccuracyScore, greaterThan(0));
      expect(evaluation.memorizationScore, 0);
      expect(evaluation.tajweedScore, 0);
      expect(evaluation.fluencyScore, 0);
      expect(evaluation.accuracyScore, 0);

      final revision = await sessionDao.getRevisionBySession(sessions.first.id);
      expect(revision!.surahId, revSurah.id);
    },
  );
}
