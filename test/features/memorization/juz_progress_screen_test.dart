import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/juz_quarter_progress_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/features/memorization/screens/juz_progress_screen.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

Widget _harness(AppDatabase db, int studentId) {
  return ProviderScope(
    overrides: [appDatabaseProvider.overrideWithValue(db)],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(textDirection: TextDirection.rtl, child: JuzProgressScreen(studentId: studentId)),
    ),
  );
}

void main() {
  late AppDatabase db;
  late int studentId;

  setUp(() async {
    db = openTestDatabase();
    studentId = await StudentDao(db).insert(
      StudentsCompanion.insert(fullName: 'أحمد', age: 10, phone: '0100000000', address: 'عنوان'),
    );
  });

  tearDown(() => db.close());

  testWidgets('طالب جديد: الجزء الأول ظاهر بنسبة 0/8، والنسبة الكلية 0%، والقائمة تصل للجزء الأخير', (tester) async {
    await tester.pumpWidget(_harness(db, studentId));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('جزء 1'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
    expect(find.text('0/8'), findsWidgets);

    // ListView.builder كسول — الجزء الثلاثون خارج الشاشة ابتداءً، لازم نمرّر
    // له عشان يُبنى فعلياً قبل التحقق من وجوده.
    await tester.dragUntilVisible(find.text('جزء 30'), find.byType(Scrollable).first, const Offset(0, -300));
    expect(find.text('جزء 30'), findsOneWidget);
  });

  testWidgets('تعليم أرباع مسبقاً يظهر في شريط تقدّم الجزء والنسبة الكلية', (tester) async {
    final dao = JuzQuarterProgressDao(db);
    await dao.setQuarterCompleted(studentId, 5, 1, true);
    await dao.setQuarterCompleted(studentId, 5, 2, true);
    await dao.setQuarterCompleted(studentId, 5, 3, true);
    await dao.setQuarterCompleted(studentId, 5, 4, true);

    await tester.pumpWidget(_harness(db, studentId));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('4/8'), findsOneWidget);
    // 4 من 240 = ١٫٦٧٪ يُقرَّب لـ2%.
    expect(find.text('2%'), findsOneWidget);
  });

  testWidgets('جزء مكتمل بالكامل (8/8) يظهر كمكتمل', (tester) async {
    final dao = JuzQuarterProgressDao(db);
    for (var q = 1; q <= 8; q++) {
      await dao.setQuarterCompleted(studentId, 12, q, true);
    }

    await tester.pumpWidget(_harness(db, studentId));
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(find.text('جزء 12'), find.byType(Scrollable).first, const Offset(0, -300));

    expect(tester.takeException(), isNull);
    expect(find.text('8/8'), findsOneWidget);
  });
}
