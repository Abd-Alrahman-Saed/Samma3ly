// القسم ح.3: بطاقتا "الصفحات المحفوظة" و"السور المكتملة" أُزيلتا من لوحة
// التحكم (تبقيان موجودتين في شاشة التقارير — خارج نطاق هذا التعديل)،
// و"الجلسات القادمة" بقت "جلسات الأسبوع" (قابلة للضغط، القيمة بيانها
// المُفصَّل في dashboard_service_test.dart).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/features/dashboard/screens/dashboard_screen.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

void main() {
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
}
