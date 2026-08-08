// Sprint 0, item 0.2 — verifies the real v1→v2 migration (schemaVersion
// bump, PendingChanges drop, orphan cleanup, foreign_keys enforcement)
// against drift's schema-verification tooling, not just "it compiles".
//
// drift_schemas/ + test/generated_migrations/ are produced by:
//   dart run drift_dev schema dump lib/data/local/database/app_database.dart drift_schemas/
//   dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
// Re-run both whenever schemaVersion changes.
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

import 'generated_migrations/schema.dart';
import 'generated_migrations/schema_v1.dart' as v1;

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('كل خطوات الترقية المُسجَّلة (v1→v2→…) صحيحة ومتتابعة', () async {
    for (var from = 1; from < GeneratedHelper.versions.last; from++) {
      final schema = await verifier.schemaAt(from);
      final db = AppDatabase.forTesting(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, from + 1);
    }
  });

  test('ترقية v1→v2: تنظّف الصفوف اليتيمة، تحذف pending_changes، وتفعّل FK', () async {
    // قاعدة واحدة في الذاكرة، وثلاث "نوافذ" عليها بإصدارات مختلفة —
    // بالضبط آلية testWithDataIntegrity الداخلية في drift_dev، لكن هنا
    // بـSQL خام عشان جداول v1 الخام (schema_v1.dart) ما فيهاش Companion classes.
    final schema = await verifier.schemaAt(1);

    // ١) نزرع بيانات على شكل قاعدة v1 قديمة: طالب حقيقي + جلسة حقيقية +
    //    جلسة يتيمة تشير لطالب غير موجود (٩٩٩) — الحالة اللي بند 0.3 مفروض ينظّفها.
    final oldDb = v1.DatabaseAtV1(schema.newConnection());
    await oldDb.customStatement('''
      INSERT INTO students (id, full_name, age, phone, address)
      VALUES (1, 'طالب حقيقي', 10, '0100000000', 'عنوان')
    ''');
    await oldDb.customStatement('''
      INSERT INTO sessions (id, student_id, date, time, attendance_status)
      VALUES (1, 1, ${DateTime(2026, 1, 1).millisecondsSinceEpoch}, '18:00', 'حاضر')
    ''');
    await oldDb.customStatement('''
      INSERT INTO sessions (id, student_id, date, time, attendance_status)
      VALUES (2, 999, ${DateTime(2026, 1, 2).millisecondsSinceEpoch}, '18:00', 'حاضر')
    ''');
    await oldDb.customStatement('''
      INSERT INTO pending_changes (id, entity_type, entity_local_id, operation, payload)
      VALUES (1, 'session', 1, 'create', '{}')
    ''');
    await oldDb.close();

    // ٢) نفتح نفس القاعدة بالمُنشئ الحقيقي لـAppDatabase (schemaVersion=2) —
    //    ده اللي بيشغّل الـmigration الفعلية (v1→v2) تلقائياً.
    final migratedDb = AppDatabase.forTesting(schema.newConnection());
    addTearDown(migratedDb.close);

    final allSessions = await migratedDb.select(migratedDb.sessions).get();
    expect(allSessions.map((s) => s.id), contains(1));
    expect(allSessions.map((s) => s.id), isNot(contains(2)),
        reason: 'الجلسة اليتيمة (طالب ٩٩٩ غير موجود) لازم تُحذف أثناء الترقية لـv2');

    final allStudents = await migratedDb.select(migratedDb.students).get();
    expect(allStudents, hasLength(1));

    final fkStatus = await migratedDb.customSelect('PRAGMA foreign_keys').getSingle();
    expect(fkStatus.data['foreign_keys'], 1, reason: 'PRAGMA foreign_keys يجب أن يكون مفعّلاً بعد v2');

    // pending_changes اتحذف من الـschema فعلياً — أي محاولة قراءة منه بعد
    // الترقية المفروض تفشل لأن الجدول ما عادش موجود.
    expect(
      () => migratedDb.customSelect('SELECT * FROM pending_changes').get(),
      throwsA(anything),
      reason: 'جدول pending_changes يجب أن يكون محذوفاً تماماً بعد الترقية',
    );
  });
}
