// القسم ح.4: نفس عطل "null check operator" (session.studentId!) كان يظهر
// في شاشة "الجلسات" (SessionListScreen) بمجرد وجود جلسة حلقة واحدة —
// أُصلح عند المصدر (SessionRepositoryImpl.getAll())، هذا اختبار انحدار
// يثبّت أن الشاشة لا تنهار ولا تعرض جلسة الحلقة (لا "طالب واحد" لها).
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
import 'package:quran_mobile/features/sessions/screens/session_list_screen.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ar'));

  late AppDatabase db;

  setUp(() {
    db = openTestDatabase();
  });

  tearDown(() => db.close());

  testWidgets('وجود جلسة حلقة حقيقية بجانب جلسة فردية لا يُسقط شاشة الجلسات', (tester) async {
    final studentDao = StudentDao(db);
    final sessionDao = SessionDao(db);
    final studentId = await studentDao.insert(
      StudentsCompanion.insert(fullName: 'محمد', age: 12, phone: '1', address: 'a'),
    );
    final groupId = await GroupDao(db).insert(GroupsCompanion.insert(name: 'حلقة'));
    await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(2026, 1, 1),
      time: '17:00',
    ));
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
          home: Directionality(textDirection: TextDirection.rtl, child: SessionListScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('محمد'), findsOneWidget);
  });
}
