// القسم ح.9 — معلّم واحد فقط في التطبيق: إنشاء حلقة جديدة يُعيِّن المعلّم
// الحالي تلقائياً لـ`Group.teacherId` بلا أي اختيار من قائمة (القائمة نفسها
// أُزيلت من الواجهة تماماً).
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/data/local/database/daos/user_dao.dart';
import 'package:quran_mobile/features/groups/screens/group_create_screen.dart';
import 'package:quran_mobile/providers.dart';

import '../../helpers/test_database.dart';

Future<void> _openScreen(WidgetTester tester, AppDatabase db) async {
  final router = GoRouter(
    initialLocation: '/start',
    routes: [
      GoRoute(path: '/start', builder: (_, __) => const Scaffold(body: Text('البداية'))),
      GoRoute(path: '/create', builder: (_, __) => const GroupCreateScreen()),
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
  late AppDatabase db;

  setUp(() {
    db = openTestDatabase();
  });

  tearDown(() => db.close());

  testWidgets('لا توجد قائمة اختيار معلّم في شاشة إنشاء الحلقة', (tester) async {
    await _openScreen(tester, db);

    expect(tester.takeException(), isNull);
    expect(find.textContaining('المعلم المسؤول'), findsNothing);
  });

  testWidgets('إنشاء حلقة جديدة يُعيِّن المعلّم الحالي تلقائياً لـteacherId', (tester) async {
    final teacherId = await UserDao(db).insert(UsersCompanion.insert(
      username: 'teacher',
      passwordHash: 'x',
      fullName: 'المعلّم',
      role: const Value('Admin'),
    ));

    await _openScreen(tester, db);

    await tester.enterText(find.byType(TextFormField).first, 'حلقة الفجر');
    await tester.tap(find.text('إنشاء الحلقة'));
    await tester.pumpAndSettle();

    final groups = await GroupDao(db).getAll();
    expect(groups, hasLength(1));
    expect(groups.first.teacherId, teacherId);
  });
}
