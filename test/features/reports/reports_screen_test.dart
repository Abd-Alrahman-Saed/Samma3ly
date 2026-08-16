// القسم ح.5: بطاقات KPI في شاشة التقارير كانت بنسبة عرض/ارتفاع (1.7) أضيق
// من نفس الودجت في الداشبورد (1.5)، تُسبّب فيض نص فعلي. هذا الاختبار يزرع
// بيانات حقيقية (قيم غير صفرية لكل رقم) ويتحقق من عدم وجود أي استثناء —
// كان هذا يفشل قبل تصحيح النسبة. كذلك يتحقق من قسم "تقرير طالب" الجديد:
// اختيار طالب من القائمة يعرض إحصاءاته وجلساته.
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/features/reports/screens/reports_screen.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

Widget _harness(AppDatabase db) {
  return ProviderScope(
    overrides: [appDatabaseProvider.overrideWithValue(db)],
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(textDirection: TextDirection.rtl, child: ReportsScreen()),
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

  testWidgets('بطاقات KPI تُعرض بلا أي فيض في التخطيط (تحقّق نسبة العرض/الارتفاع)', (tester) async {
    final studentDao = StudentDao(db);
    final sessionDao = SessionDao(db);
    final studentId = await studentDao.insert(
      StudentsCompanion.insert(fullName: 'سارة', age: 11, phone: '1', address: 'a'),
    );
    final sessionId = await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(2026, 1, 1),
      time: '17:00',
    ));
    await sessionDao.upsertAttendance(sessionId, studentId, AttendanceStatus.present.arabic);

    await tester.pumpWidget(_harness(db));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('إجمالي الطلاب'), findsOneWidget);
    expect(find.text('الجلسات'), findsOneWidget);
    expect(find.text('نسبة الحضور'), findsOneWidget);
    expect(find.text('الصفحات المحفوظة'), findsOneWidget);
  });

  testWidgets('قسم "تقرير طالب" يعرض دعوة الاختيار ابتداءً', (tester) async {
    await tester.pumpWidget(_harness(db));
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(find.text('اختر طالباً لعرض تقريره'), find.byType(Scrollable).first, const Offset(0, -300));
    expect(find.text('اختر طالباً لعرض تقريره'), findsOneWidget);
  });

  testWidgets('اختيار طالب من القائمة يعرض إحصاءاته وجلساته', (tester) async {
    final studentDao = StudentDao(db);
    final sessionDao = SessionDao(db);
    final studentId = await studentDao.insert(
      StudentsCompanion.insert(fullName: 'يوسف', age: 9, phone: '1', address: 'a'),
    );
    final sessionId = await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(2026, 1, 1),
      time: '17:00',
    ));
    await sessionDao.upsertAttendance(sessionId, studentId, AttendanceStatus.present.arabic);

    await tester.pumpWidget(_harness(db));
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(find.text('اختر طالباً لعرض تقريره'), find.byType(Scrollable).first, const Offset(0, -300));
    await tester.tap(find.text('اختر طالباً لعرض تقريره'));
    await tester.pumpAndSettle();

    expect(find.text('اختر طالباً'), findsOneWidget);
    await tester.tap(find.text('يوسف').last);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.dragUntilVisible(find.text('الحضور'), find.byType(Scrollable).first, const Offset(0, -300));
    expect(find.text('الحضور'), findsOneWidget);
    // "100%" ممكن تتكرّر (بطاقة نسبة الحضور الإجمالية بالأعلى بنفس القيمة
    // مصادفةً) — findsWidgets بدل findsOneWidget يتجنّب هشاشة الاختبار.
    expect(find.text('100%'), findsWidgets, reason: 'حضر الجلسة الوحيدة — 100% حضور');

    // القسم ح.7: زر مشاركة تقرير الطالب — لا نضغطه (SharePlus يحتاج قناة
    // منصّة غير متاحة في اختبارات الودجت)، نتحقق فقط من وجوده.
    expect(find.byTooltip('مشاركة تقرير الطالب'), findsOneWidget);
  });
}
