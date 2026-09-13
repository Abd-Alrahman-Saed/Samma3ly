// القسم ح.12 — "معلومات الجلسة الخارجية": بطاقة الجلسة (تُستخدم في كل قائمة
// جلسات — الداشبورد، شاشة الجلسات، جلسات الطالب، تقرير الطالب) لازم تعرض
// قرار المعلّم السريع (اجتاز/يُعاد) ودرجة تقييم المراجعة المنفصلة بدون فتح
// الجلسة. هذا الاختبار يثبّت أن SessionCard فعلاً تعرضهما، وتخفيهما لو
// غير موجودين (الحالة الافتراضية قبل هذا البند).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_mobile/core/widgets/session_card.dart';

Widget _harness(Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(textDirection: TextDirection.rtl, child: Scaffold(body: child)),
    );

void main() {
  setUpAll(() => initializeDateFormatting('ar'));

  SessionCardItem baseItem({String? recitationOutcome, List<SessionRevisionCardInfo> revisions = const []}) => SessionCardItem(
        id: 1,
        studentId: 1,
        studentName: 'أحمد',
        initials: 'أ',
        date: DateTime(2026, 3, 9),
        timeDisplay: '17:00',
        attendanceStatus: 'حاضر',
        finalScore: 8,
        recitationOutcome: recitationOutcome,
        revisions: revisions,
      );

  testWidgets('بلا recitationOutcome أو revisionFinalScore: لا شارة ولا شريحة مراجعة', (tester) async {
    await tester.pumpWidget(_harness(SessionCard(item: baseItem())));

    expect(find.text('اجتاز'), findsNothing);
    expect(find.text('يُعاد'), findsNothing);
    expect(find.text('مراجعة'), findsNothing);
  });

  testWidgets('recitationOutcome == "اجتاز": تظهر شارة "اجتاز"', (tester) async {
    await tester.pumpWidget(_harness(SessionCard(item: baseItem(recitationOutcome: 'اجتاز'))));

    expect(find.text('اجتاز'), findsOneWidget);
    expect(find.text('يُعاد'), findsNothing);
  });

  testWidgets('recitationOutcome == "يُعاد": تظهر شارة "يُعاد" — يعرف المعلّم أن الجلسة تحتاج إعادة', (tester) async {
    await tester.pumpWidget(_harness(SessionCard(item: baseItem(recitationOutcome: 'يُعاد'))));

    expect(find.text('يُعاد'), findsOneWidget);
    expect(find.text('اجتاز'), findsNothing);
  });

  testWidgets('مراجعة واحدة مُقيَّمة: تظهر شريحة "مراجعة" منفصلة عن درجة الحفظ', (tester) async {
    await tester.pumpWidget(_harness(SessionCard(
      item: baseItem(revisions: const [SessionRevisionCardInfo(info: 'قريبة: الفاتحة (كاملة)', finalScore: 7.5)]),
    )));

    expect(find.text('مراجعة'), findsOneWidget);
  });

  testWidgets('القسم ح.14: أكثر من مراجعة مُقيَّمة تُجمَع في شريحة واحدة بعدّاد ومتوسط', (tester) async {
    await tester.pumpWidget(_harness(SessionCard(
      item: baseItem(revisions: const [
        SessionRevisionCardInfo(info: 'قريبة: الفاتحة (كاملة)', finalScore: 8),
        SessionRevisionCardInfo(info: 'بعيدة: البقرة (1-10)', finalScore: 6),
      ]),
    )));

    expect(find.text('مراجعة ×2'), findsOneWidget);
    expect(find.text('مراجعة'), findsNothing, reason: 'مراجعتان فأكثر تُعرَضان بشريحة العدّاد لا بعنوان "مراجعة" المفرد');
  });
}
