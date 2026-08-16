import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/juz_quarter_progress_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/features/memorization/screens/juz_quarters_screen.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

Widget _harness(AppDatabase db, int studentId, int juzNumber) {
  return ProviderScope(
    overrides: [appDatabaseProvider.overrideWithValue(db)],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: JuzQuartersScreen(studentId: studentId, juzNumber: juzNumber),
      ),
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

  testWidgets('يعرض الأرباع الثمانية كلها بلا أي منها محفوظاً ابتداءً', (tester) async {
    await tester.pumpWidget(_harness(db, studentId, 5));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    for (var q = 1; q <= 8; q++) {
      expect(find.text('الربع $q'), findsOneWidget);
    }
    expect(find.text('0/8 أرباع محفوظة'), findsOneWidget);
  });

  testWidgets('الضغط على ربع يعلّمه محفوظاً فوراً ويحدّث شريط التقدّم', (tester) async {
    await tester.pumpWidget(_harness(db, studentId, 5));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('quarterRow-3')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('1/8 أرباع محفوظة'), findsOneWidget);

    final completed = await JuzQuarterProgressDao(db).getCompletedByStudent(studentId);
    expect(completed, contains((5, 3)));
  });

  testWidgets('الضغط على ربع محفوظ بالفعل يلغي تعليمه', (tester) async {
    await JuzQuarterProgressDao(db).setQuarterCompleted(studentId, 5, 2, true);

    await tester.pumpWidget(_harness(db, studentId, 5));
    await tester.pumpAndSettle();
    expect(find.text('1/8 أرباع محفوظة'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('quarterRow-2')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('0/8 أرباع محفوظة'), findsOneWidget);
    expect(await JuzQuarterProgressDao(db).getCompletedByStudent(studentId), isEmpty);
  });
}
