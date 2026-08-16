// طلب المستخدم: هدف جديد بنوع "سورة" يظهر قائمة اختيار سورة، وبنوع "جزء"
// يظهر قائمة اختيار جزء بأسماء عربية ترتيبية (الأول، الثاني، ...) بدل
// إدخال رقم يدوياً.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/goal_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/features/goals/screens/goal_form_sheet.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

Future<void> openSheet(WidgetTester tester, AppDatabase db, {required int studentId}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => GoalFormSheet.show(context, studentId: studentId),
                child: const Text('فتح'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('فتح'));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('ar'));

  late AppDatabase db;
  late int studentId;

  setUp(() async {
    db = openTestDatabase();
    studentId = await StudentDao(db).insert(
      StudentsCompanion.insert(fullName: 'هبة', age: 9, phone: '1', address: 'a'),
    );
  });

  tearDown(() => db.close());

  testWidgets('النوع الافتراضي "سورة" يعرض قائمة اختيار سورة لا حقل رقم', (tester) async {
    await openSheet(tester, db, studentId: studentId);

    expect(tester.takeException(), isNull);
    expect(find.text('اختر السورة'), findsOneWidget);
    expect(find.text('رقم السورة المستهدفة'), findsNothing);
  });

  testWidgets('اختيار نوع "جزء" يعرض قائمة أجزاء بأسماء عربية ترتيبية', (tester) async {
    await openSheet(tester, db, studentId: studentId);

    await tester.tap(find.text('جزء'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('اختر الجزء'), findsOneWidget);

    await tester.tap(find.text('اختر الجزء'));
    await tester.pumpAndSettle();

    // القائمة المنسدلة نفسها كسولة (لا تبني كل الـ30 عنصراً دفعة واحدة) —
    // وجود الأول يكفي لإثبات أن التسمية الترتيبية العربية تعمل فعلاً؛
    // الاختيار الفعلي (والتحقّق من صحّة الرقم المحفوظ) في الاختبار التالي.
    expect(find.text('الجزء الأول'), findsOneWidget);
  });

  testWidgets('حفظ هدف بنوع "جزء" يخزّن رقم الجزء الصحيح', (tester) async {
    await openSheet(tester, db, studentId: studentId);

    await tester.enterText(find.byType(TextFormField).first, 'حفظ الجزء الأول');
    await tester.tap(find.text('جزء'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('اختر الجزء'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('الجزء الأول').last);
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(find.text('حفظ الهدف'), find.byType(Scrollable).first, const Offset(0, -300));
    await tester.tap(find.text('حفظ الهدف'));
    await tester.pumpAndSettle();

    final goals = await GoalDao(db).getByStudent(studentId);
    expect(goals, hasLength(1));
    expect(goals.first.targetJuzNumber, 1);
    expect(goals.first.targetSurahId, isNull);
  });

  testWidgets('حفظ هدف بنوع "سورة" يخزّن معرّف السورة الصحيح', (tester) async {
    await openSheet(tester, db, studentId: studentId);

    await tester.enterText(find.byType(TextFormField).first, 'حفظ سورة البقرة');
    await tester.tap(find.text('اختر السورة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2. البقرة').last);
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(find.text('حفظ الهدف'), find.byType(Scrollable).first, const Offset(0, -300));
    await tester.tap(find.text('حفظ الهدف'));
    await tester.pumpAndSettle();

    final goals = await GoalDao(db).getByStudent(studentId);
    expect(goals, hasLength(1));
    expect(goals.first.targetSurahId, 2);
    expect(goals.first.targetJuzNumber, isNull);
  });
}
