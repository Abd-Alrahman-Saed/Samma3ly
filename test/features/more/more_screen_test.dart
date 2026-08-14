import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/features/more/screens/more_screen.dart';

void main() {
  testWidgets('يعرض كل روابط المزيد بلا استثناءات', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(textDirection: TextDirection.rtl, child: MoreScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('الجلسات'), findsOneWidget);
    expect(find.text('الجداول'), findsOneWidget);
    expect(find.text('الأهداف'), findsOneWidget);
    expect(find.text('التقويم الأسبوعي'), findsOneWidget);
    expect(find.text('قائمة المراجعة'), findsOneWidget);
    expect(find.text('الإعدادات'), findsOneWidget);
  });
}
