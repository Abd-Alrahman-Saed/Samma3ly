// القسم ح.10 — "جلسة جديدة" الفردية بقت نفس شاشة تسميع الحلقة بالظبط:
// تقييم بأربعة معايير (حفظ/تجويد/طلاقة/تشكيل) بدل ثلاثة، وحفظ نهائي
// بزرَّين "اجتاز"/"يُعاد" بدل زر "حفظ الجلسة" الواحد.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide SessionEvaluation, SessionRevision, Session;
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

  testWidgets(
    'تعرض 4 معايير تقييم بعد اختيار سورة حفظ (القسم ح.14: لا تظهر قبل ذلك)، '
    'وزرَّي اجتاز/يُعاد، بلا زر "حفظ الجلسة"',
    (tester) async {
      await openScreen(tester, db, studentId: studentId);

      expect(tester.takeException(), isNull);
      expect(find.text('اجتاز'), findsOneWidget);
      expect(find.text('يُعاد'), findsOneWidget);
      expect(find.text('حفظ الجلسة'), findsNothing);
      // القسم ح.1: تقييم الحفظ لا يظهر قبل اختيار سورة حفظ فعلياً.
      expect(find.text('الحفظ'), findsNothing);

      final surahs = await db.select(db.surahs).get();
      final memSurah = surahs.firstWhere((s) => s.id == 1);
      final memDropdown = find.byType(DropdownButtonFormField<int?>).first;
      await tester.dragUntilVisible(memDropdown, find.byType(Scrollable).first, const Offset(0, -300));
      await tester.tap(memDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('${memSurah.number}. ${memSurah.name}').last);
      await tester.pumpAndSettle();

      expect(find.text('الحفظ'), findsOneWidget);
      expect(find.text('التجويد'), findsOneWidget);
      expect(find.text('الطلاقة'), findsOneWidget);
      expect(find.text('التشكيل'), findsOneWidget);
    },
  );

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

  test(
    'القسم ح.14: SessionRevision.finalScore مستقلّ لكل مراجعة، و'
    'Session.overallScore يشمل الحفظ وكل مراجعة معاً — أو المراجعة وحدها لو لا حفظ',
    () {
      const revision = SessionRevision(surahId: 2, memorizationScore: 10, tajweedScore: 10, fluencyScore: 10, accuracyScore: 0);
      expect(revision.finalScore, 7.5);
      expect(revision.hasEvaluation, isTrue);
      expect(const SessionRevision(surahId: 2).hasEvaluation, isFalse);

      final withMemAndRevision = Session(
        date: DateTime(2026, 1, 1),
        evaluation: const SessionEvaluation(memorizationScore: 8, tajweedScore: 8, fluencyScore: 8, accuracyScore: 8),
        revisions: const [revision],
      );
      // متوسط 8.0 (الحفظ) و7.5 (المراجعة) = 7.75 → 7.8 بعد التقريب لمنزلة واحدة.
      expect(withMemAndRevision.overallScore, 7.8);

      // القسم ح.1: جلسة مراجعة فقط بلا حفظ — overallScore = درجة المراجعة
      // وحدها، لا صفر وهمي من غياب تقييم حفظ.
      final revisionOnly = Session(date: DateTime(2026, 1, 1), revisions: const [revision]);
      expect(revisionOnly.overallScore, 7.5);

      // جلسة بلا أي تقييم إطلاقاً: null، لا صفر.
      final untouched = Session(date: DateTime(2026, 1, 1));
      expect(untouched.overallScore, isNull);
    },
  );

  testWidgets(
    'إضافة مراجعة (بلا حفظ جديد) تُظهر قسم "تقييم هذه المراجعة" مستقلاً، والحفظ '
    'يخزّنه على صفّ session_revisions نفسه، دون إنشاء صفّ session_evaluations وهمي '
    '(القسم ح.1/ح.14 — مراجعة فقط بلا حفظ)',
    (tester) async {
      await openScreen(tester, db, studentId: studentId);

      expect(find.text('تقييم هذه المراجعة'), findsNothing);

      await tester.dragUntilVisible(find.text('إضافة مراجعة'), find.byType(Scrollable).first, const Offset(0, -300));
      await tester.tap(find.text('إضافة مراجعة'));
      await tester.pumpAndSettle();

      final surahs = await db.select(db.surahs).get();
      final revSurah = surahs.firstWhere((s) => s.id == 2);

      // الدروب-داون index 0 هو دائماً سورة "الحفظ الجديد" (ظاهر دوماً طالما
      // الطالب حاضر)؛ index 1 هو سورة أول مراجعة، ظهر للتوّ بعد الضغط أعلاه.
      final revisionDropdown = find.byType(DropdownButtonFormField<int?>).at(1);
      await tester.dragUntilVisible(revisionDropdown, find.byType(Scrollable).first, const Offset(0, -300));
      await tester.tap(revisionDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('${revSurah.number}. ${revSurah.name}').last);
      await tester.pumpAndSettle();

      expect(find.text('تقييم هذه المراجعة'), findsOneWidget);

      // 4 سلايدرات فقط (تقييم المراجعة) — لا تقييم حفظ ظاهر أصلاً بما أن
      // لا سورة حفظ اختيرت.
      final sliders = find.byType(Slider);
      expect(sliders, findsNWidgets(4));
      await tester.dragUntilVisible(sliders.at(3), find.byType(Scrollable).first, const Offset(0, -300));
      await tester.drag(sliders.at(3), const Offset(300, 0));
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(find.text('اجتاز'), find.byType(Scrollable).first, const Offset(0, -300));
      await tester.tap(find.text('اجتاز'));
      await tester.pumpAndSettle();

      final sessionDao = SessionDao(db);
      final sessions = await sessionDao.getAll(studentId: studentId);
      expect(sessions, hasLength(1));

      final evaluation = await sessionDao.getEvaluationBySession(sessions.first.id);
      expect(evaluation, isNull, reason: 'لا تقييم حفظ جديد — لم تُختَر سورة حفظ ولا تحرّكت شرائحه');

      final revisions = await sessionDao.getRevisionsBySession(sessions.first.id);
      expect(revisions, hasLength(1));
      expect(revisions.first.surahId, revSurah.id);
      expect(revisions.first.accuracyScore, greaterThan(0));
    },
  );
}
