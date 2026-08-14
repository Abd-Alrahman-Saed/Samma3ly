// Replaces the default Flutter counter smoke test (which referenced a
// counter this app has never had, and was already failing before Sprint 0).
// This one actually exercises the app: boot QuranApp against an in-memory
// database with zero users, and confirm the router lands on the initial
// setup screen — the real first-run path.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/app.dart';
import 'package:quran_mobile/providers.dart';

import 'helpers/test_database.dart';

void main() {
  testWidgets('يقلع التطبيق ويوجّه لشاشة الإعداد الأولي عند عدم وجود مستخدمين', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(openTestDatabase())],
        child: const QuranApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('مرحباً بك'), findsOneWidget);
  });
}
