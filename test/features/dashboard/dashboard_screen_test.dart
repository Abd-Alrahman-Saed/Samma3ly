// القسم ح.3: بطاقتا "الصفحات المحفوظة" و"السور المكتملة" أُزيلتا من لوحة
// التحكم (تبقيان موجودتين في شاشة التقارير — خارج نطاق هذا التعديل)،
// و"الجلسات القادمة" بقت "جلسات الأسبوع" (قابلة للضغط، القيمة بيانها
// المُفصَّل في dashboard_service_test.dart).
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_mobile/core/enums/session_type.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/features/dashboard/screens/dashboard_screen.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ar'));

  late AppDatabase db;

  setUp(() {
    db = openTestDatabase();
  });

  tearDown(() => db.close());

  testWidgets('لوحة التحكم تعرض 4 بطاقات فقط، بلا الصفحات المحفوظة أو السور المكتملة', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Directionality(textDirection: TextDirection.rtl, child: DashboardScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('الطلاب'), findsOneWidget);
    expect(find.text('جلسات اليوم'), findsOneWidget);
    expect(find.text('جلسات الأسبوع'), findsOneWidget);
    expect(find.text('نسبة الحضور'), findsOneWidget);
    expect(find.text('الصفحات المحفوظة'), findsNothing);
    expect(find.text('السور المكتملة'), findsNothing);
    expect(find.text('الجلسات القادمة'), findsNothing);
  });

  testWidgets('القسم ح.4: وجود جلسة حلقة حقيقية بين "آخر الجلسات" لا يُسقط الشاشة', (tester) async {
    final studentDao = StudentDao(db);
    final sessionDao = SessionDao(db);
    final studentId = await studentDao.insert(
      StudentsCompanion.insert(fullName: 'أحمد', age: 10, phone: '1', address: 'a'),
    );
    final groupId = await GroupDao(db).insert(GroupsCompanion.insert(name: 'حلقة'));
    await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(2026, 1, 1),
      time: '17:00',
    ));
    // جلسة حلقة حقيقية — بلا studentId. قبل الإصلاح كانت تُسقط هذا القسم
    // بعطل "null check operator used on a null value".
    await sessionDao.insert(SessionsCompanion.insert(
      date: DateTime(2026, 1, 2),
      time: '18:00',
      groupId: Value(groupId),
      sessionType: Value(SessionType.group.arabic),
      occurrenceDate: Value(DateTime(2026, 1, 2)),
    ));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Directionality(textDirection: TextDirection.rtl, child: DashboardScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // "آخر الجلسات" تحت الطيّة افتراضياً (تحت البطاقات وأفضل 5 طلاب) — لازم
    // نمرّر لها قبل التحقق من وجودها، وإلا الشاشة كسولة وما بنتش القسم أصلاً.
    await tester.dragUntilVisible(find.text('أحمد'), find.byType(Scrollable).first, const Offset(0, -300));
    expect(find.text('أحمد'), findsOneWidget);
  });
}
