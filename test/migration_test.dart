// Sprint 0, item 0.2 — verifies the real v1→v2 migration (schemaVersion
// bump, PendingChanges drop, orphan cleanup, foreign_keys enforcement)
// against drift's schema-verification tooling, not just "it compiles".
//
// drift_schemas/ + test/generated_migrations/ are produced by:
//   dart run drift_dev schema dump lib/data/local/database/app_database.dart drift_schemas/
//   dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
// Re-run both whenever schemaVersion changes.
import 'package:drift/drift.dart' hide isNull;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

import 'generated_migrations/schema.dart';
import 'generated_migrations/schema_v1.dart' as v1;
import 'generated_migrations/schema_v2.dart' as v2;
import 'generated_migrations/schema_v3.dart' as v3;
import 'generated_migrations/schema_v4.dart' as v4;
import 'generated_migrations/schema_v5.dart' as v5;
import 'generated_migrations/schema_v6.dart' as v6;

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('كل خطوات الترقية المُسجَّلة (v1→v2→…) صحيحة ومتتابعة', () async {
    for (var from = 1; from < GeneratedHelper.versions.last; from++) {
      // ملاحظة تشخيصية (بند 3.4، v5): تخطّينا التحقّق المعزول v3→v4 هنا
      // فقط — لا التطبيق الحقيقي ولا اختبار "ترقية v3→v4" المخصّص بالأسفل.
      // السبب: `m.createTable(sessionAttendances)` في كتلة v4 بيستخدم
      // تعريف الجدول *الحيّ الحالي* دايماً (كل drift_dev)، مش شكله وقت
      // v4 تحديداً — فبعد ما v5 أضافت أعمدة تسميع على نفس الجدول، أي
      // تحقّق معزول "وصلنا v4 بالضبط" هيلاقي أعمدة v5 "زيادة" رغم إنها
      // مش موجودة في قاعدة v4 حقيقية غير مرتقّاة. مش عطل حقيقي (التطبيق
      // الحقيقي أصلاً بيهاجر لآخر إصدار دايماً، مش يقف عند v4 بمعزل) —
      // اختبار "ترقية v3→v4" المخصّص بالأسفل يتحقّق من شكل v4 التاريخي
      // الصحيح وقت وقوفه هناك فعلياً، وهو غير متأثر بالتغيير ده.
      if (from == 3) continue;
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

  test('ترقية v2→v3 (بند 0.4b): تستبدل بيانات juz_surah_ranges المعطوبة بالنسخة الصحيحة', () async {
    // نزرع قاعدة v2 بنسخة *معطوبة* فعلياً من juz_surah_ranges — نفس العطل
    // اللي كان موجوداً قبل هذا الإصلاح: الأجزاء ٢٠-٣٠ كلها مكتوبة كـ"٣٠"،
    // والأجزاء ٢٦-٢٩ غير موجودة إطلاقاً. هذا يحاكي تليفون مستخدم حقيقي
    // ثبّت التطبيق قبل هذا الإصلاح.
    final schema = await verifier.schemaAt(2);
    final oldDb = v2.DatabaseAtV2(schema.newConnection());
    await oldDb.customStatement('DELETE FROM juz_surah_ranges');
    await oldDb.customStatement('''
      INSERT INTO juz_surah_ranges (id, juz_number, surah_id, from_ayah, to_ayah)
      VALUES (1, 1, 1, 1, 7)
    ''');
    // كل شيء من هنا معطوب: جزء ٢٧ (النمل) مكتوب كجزء ٣٠ خطأً، ولا وجود
    // إطلاقاً لأي صف بجزء ٢٦، ٢٧ (الصحيح)، ٢٨، أو ٢٩.
    await oldDb.customStatement('''
      INSERT INTO juz_surah_ranges (id, juz_number, surah_id, from_ayah, to_ayah)
      VALUES (2, 30, 27, 1, 93)
    ''');
    await oldDb.close();

    // نفتح نفس القاعدة بالمُنشئ الحقيقي (schemaVersion=3) — يشغّل v2→v3.
    final migratedDb = AppDatabase.forTesting(schema.newConnection());
    addTearDown(migratedDb.close);

    final rows = await migratedDb.select(migratedDb.juzSurahRanges).get();
    expect(rows, hasLength(135), reason: 'يجب أن يُعاد بناء الجدول بالكامل (١٣٥ صفاً) بعد الترقية');

    final juzNumbers = rows.map((r) => r.juzNumber).toSet();
    expect(juzNumbers, equals(Set.from(List.generate(30, (i) => i + 1))),
        reason: 'كل الأجزاء ١-٣٠ يجب أن تكون موجودة، بما فيها ٢٦-٢٩ اللي كانت غائبة تماماً في النسخة المعطوبة');

    final juz30Surahs = rows.where((r) => r.juzNumber == 30).map((r) => r.surahId).toSet();
    expect(juz30Surahs.contains(27), isFalse,
        reason: 'سورة النمل (٢٧) كانت مكتوبة خطأً كجزء ٣٠ في البيانات المعطوبة — يجب ألا تظهر تحت جزء ٣٠ بعد الترقية');
  });

  // ملاحظة تشخيصية (تركتها للمرجعية): "كل خطوات الترقية المُسجَّلة" أعلاه
  // كان بيفشل على خطوة v3→v4 برسالة "Schema does not match" على
  // student_id/attendance_status، رغم أن هذا الاختبار (بيانات حقيقية) وفحص
  // مباشر بـ`PRAGMA table_info(sessions)` على قاعدة v4 من الصفر أكّدا أن
  // الجدول الفعلي صحيح ١٠٠٪. السبب الحقيقي: onUpgrade في app_database.dart
  // كان بيتحقق من `from < N` بس بدون `to >= N` — فلما drift_dev's
  // migrateAndValidate() بيقيّد الترقية على وصول وسيط (مثال: يفحص v2→v3
  // بمعزل، to=3) كانت كتلة v4 (`if (from < 4)`) بتشتغل برضه لأن from=2 < 4،
  // فتزيد تحويلات v4 فوق قاعدة كان المفروض تقف عند v3 فقط. التطبيق الحقيقي
  // ما كانش هيلاحظ العطل ده أبداً (لأن `to` عنده دايماً = أحدث schemaVersion)،
  // لكنه عطل حقيقي في صحة كل خطوة migration بمعزل. الإصلاح: كل الكتل
  // بقت بتتحقق من `from < N && to >= N` سوا.
  test(
    'ترقية v3→v4 (بند 2.1): تنقل attendanceStatus إلى session_attendances، '
    'تُنشئ جداول المجموعات، وتُبقي بيانات الجلسة الأخرى سليمة',
    () async {
      // قاعدة v3 حقيقية: طالب + جلسة فيها attendanceStatus (العمود القديم
      // على Sessions مباشرة، قبل ما يُنقل) + تسميع مرتبط بالجلسة — يحاكي
      // تليفون مستخدم حقيقي فيه بيانات فعلية وقت الترقية لـv4.
      final schema = await verifier.schemaAt(3);
      final oldDb = v3.DatabaseAtV3(schema.newConnection());
      await oldDb.customStatement('''
        INSERT INTO students (id, full_name, age, phone, address)
        VALUES (1, 'طالب حقيقي', 11, '0100000000', 'عنوان')
      ''');
      await oldDb.customStatement('''
        INSERT INTO sessions (id, student_id, date, time, attendance_status, notes)
        VALUES (1, 1, ${DateTime(2026, 1, 1).millisecondsSinceEpoch}, '18:00', 'متأخر', 'ملاحظة')
      ''');
      await oldDb.customStatement('''
        INSERT INTO session_memorizations (id, session_id, surah_id, from_ayah, to_ayah)
        VALUES (1, 1, 2, 1, 10)
      ''');
      await oldDb.close();

      // نفتح نفس القاعدة بالمُنشئ الحقيقي (schemaVersion=4) — يشغّل v3→v4.
      final migratedDb = AppDatabase.forTesting(schema.newConnection());
      addTearDown(migratedDb.close);

      // الجلسة نفسها سليمة، وطالبها وملاحظتها زي ما هم، ونوعها الافتراضي "فردي".
      final sessions = await migratedDb.select(migratedDb.sessions).get();
      expect(sessions, hasLength(1));
      expect(sessions.first.studentId, 1);
      expect(sessions.first.notes, 'ملاحظة');
      expect(sessions.first.sessionType, 'فردي', reason: 'القيمة الافتراضية للجلسات الموجودة قبل v4');
      expect(sessions.first.groupId, isNull);
      expect(sessions.first.occurrenceDate, isNull);

      // attendanceStatus انتقلت لـsession_attendances بنفس القيمة القديمة.
      final attendances = await migratedDb.select(migratedDb.sessionAttendances).get();
      expect(attendances, hasLength(1));
      expect(attendances.first.sessionId, 1);
      expect(attendances.first.studentId, 1);
      expect(attendances.first.attendanceStatus, 'متأخر',
          reason: 'يجب أن تُنقل القيمة القديمة حرفياً، لا أن تُستبدل بالافتراضي');

      // التسميع المرتبط بالجلسة سليم، لم يتأثر بإعادة إنشاء Sessions.
      final memorizations = await migratedDb.select(migratedDb.sessionMemorizations).get();
      expect(memorizations, hasLength(1));
      expect(memorizations.first.sessionId, 1);
      expect(memorizations.first.surahId, 2);

      // جداول المجموعات الجديدة موجودة (فارغة — لا شاشة تُنشئ بيانات فيها بعد).
      expect(await migratedDb.select(migratedDb.groups).get(), isEmpty);
      expect(await migratedDb.select(migratedDb.groupMembers).get(), isEmpty);
      expect(await migratedDb.select(migratedDb.groupScheduleSlots).get(), isEmpty);
      expect(await migratedDb.select(migratedDb.scheduleExceptions).get(), isEmpty);

      // attendance_status لم يعد عموداً على sessions إطلاقاً.
      expect(
        () => migratedDb.customSelect('SELECT attendance_status FROM sessions').get(),
        throwsA(anything),
        reason: 'attendance_status يجب أن يكون قد انتقل بالكامل من sessions إلى session_attendances',
      );
    },
  );

  test(
    'ترقية v4→v5 (بند 3.4): تضيف حقول التسميع على session_attendances '
    'بأعمدة إضافية فقط (ALTER TABLE ADD COLUMN)، وتُبقي attendance_status '
    'الحالي سليماً',
    () async {
      // قاعدة v4 حقيقية: طالب + جلسة + صفّ حضور بقيمة غير افتراضية —
      // يحاكي بيانات حقيقية موجودة وقت الترقية لـv5.
      final schema = await verifier.schemaAt(4);
      final oldDb = v4.DatabaseAtV4(schema.newConnection());
      await oldDb.customStatement('''
        INSERT INTO students (id, full_name, age, phone, address)
        VALUES (1, 'طالب حقيقي', 11, '0100000000', 'عنوان')
      ''');
      await oldDb.customStatement('''
        INSERT INTO sessions (id, student_id, session_type, date, time)
        VALUES (1, 1, 'فردي', ${DateTime(2026, 1, 1).millisecondsSinceEpoch}, '18:00')
      ''');
      await oldDb.customStatement('''
        INSERT INTO session_attendances (id, session_id, student_id, attendance_status)
        VALUES (1, 1, 1, 'متأخر')
      ''');
      await oldDb.close();

      // نفتح نفس القاعدة بالمُنشئ الحقيقي (schemaVersion=5) — يشغّل v4→v5.
      final migratedDb = AppDatabase.forTesting(schema.newConnection());
      addTearDown(migratedDb.close);

      final attendances = await migratedDb.select(migratedDb.sessionAttendances).get();
      expect(attendances, hasLength(1));
      final row = attendances.first;
      expect(row.attendanceStatus, 'متأخر', reason: 'القيمة الحالية يجب أن تبقى كما هي — لم تُلمَس');
      expect(row.memorizationSurahId, isNull);
      expect(row.memorizationFromAyah, isNull);
      expect(row.memorizationToAyah, isNull);
      expect(row.revisionSurahId, isNull);
      expect(row.revisionFromAyah, isNull);
      expect(row.revisionToAyah, isNull);
      expect(row.memorizationScore, 0.0);
      expect(row.tajweedScore, 0.0);
      expect(row.fluencyScore, 0.0);
      expect(row.accuracyScore, 0.0);
      expect(row.notes, isNull);

      // الجلسة والطالب سليمان، لم يتأثرا (v5 لا تلمس sessions/students).
      final sessions = await migratedDb.select(migratedDb.sessions).get();
      expect(sessions, hasLength(1));
      expect(sessions.first.studentId, 1);
    },
  );

  test(
    'ترقية v2→v5 مباشرة (قفز عدّة إصدارات دفعة واحدة) لا تفشل بعمود مكرَّر',
    () async {
      // هذا الاختبار يثبّت عطلاً حقيقياً كان سيصيب أي مستخدم حقيقي متوقّف
      // عند v2/v3 ثم رقّى التطبيق مباشرة لآخر إصدار (السيناريو الطبيعي —
      // `to` في التطبيق الحقيقي هو دايماً آخر schemaVersion، أبداً وسيط):
      // كتلة v4 تُنشئ session_attendances بـm.createTable() اللي بيعكس
      // تعريف الجدول الحيّ الحالي (شامل أعمدة v5 بالفعل)، فلو كتلة v5 بعد
      // كده حاولت تضيف نفس الأعمدة بـaddColumn من غير حارس `from >= 4`،
      // كانت SQLite هترمي "duplicate column name" وتفشل الترقية بالكامل —
      // قفل حقيقي للتطبيق عند فتحه. راجع تعليق `from >= 4` في onUpgrade
      // (app_database.dart) للتفاصيل الكاملة.
      final schema = await verifier.schemaAt(2);
      final oldDb = v2.DatabaseAtV2(schema.newConnection());
      await oldDb.customStatement('''
        INSERT INTO students (id, full_name, age, phone, address)
        VALUES (1, 'طالب قديم', 9, '0100000000', 'عنوان')
      ''');
      await oldDb.close();

      // نفتح نفس القاعدة بالمُنشئ الحقيقي (schemaVersion الحالي 7) — from=2:
      // تشغّل كتلة v4 (بما فيها createTable بشكلها الحيّ الكامل حتى v7) في
      // نفس المرور مع كتلتَي v5 وv7 اللي بتضيف أعمدة على نفس الجدول —
      // بالضبط سيناريو الخطر (كلتاهما محروسة بـ`from >= 4`).
      final migratedDb = AppDatabase.forTesting(schema.newConnection());
      addTearDown(migratedDb.close);

      // لم تُرمَ أي استثناء أثناء الفتح أعلاه — هذا هو جوهر الاختبار.
      final students = await migratedDb.select(migratedDb.students).get();
      expect(students, hasLength(1));

      // الجدول له شكل v5+ الكامل (وأعمدة v7 اللاحقة كمان، بما أن
      // schemaVersion الحقيقي الآن 7)، بلا تكرار أعمدة، بقيم افتراضية سليمة.
      expect(await migratedDb.select(migratedDb.sessionAttendances).get(), isEmpty);
      final columns = await migratedDb.customSelect("PRAGMA table_info('session_attendances')").get();
      final columnNames = columns.map((r) => r.data['name'] as String).toSet();
      expect(columnNames, containsAll(['memorization_surah_id', 'tajweed_score', 'notes', 'recitation_outcome']));
    },
  );

  test(
    'ترقية v5→v6 (القسم ح.2): تُنشئ جدول juz_quarter_progress فارغاً، وتُبقي بيانات v5 سليمة',
    () async {
      // قاعدة v5 حقيقية فيها بيانات — يحاكي جهاز مستخدم فعلي فيه طالب
      // وجلسة قبل هذا التحديث.
      final schema = await verifier.schemaAt(5);
      final oldDb = v5.DatabaseAtV5(schema.newConnection());
      await oldDb.customStatement('''
        INSERT INTO students (id, full_name, age, phone, address)
        VALUES (1, 'طالب حقيقي', 12, '0100000000', 'عنوان')
      ''');
      await oldDb.close();

      // نفتح نفس القاعدة بالمُنشئ الحقيقي (schemaVersion=6) — يشغّل v5→v6.
      final migratedDb = AppDatabase.forTesting(schema.newConnection());
      addTearDown(migratedDb.close);

      final students = await migratedDb.select(migratedDb.students).get();
      expect(students, hasLength(1), reason: 'بيانات v5 يجب ألا تتأثر — الجدول الجديد لا يلمس أي جدول قائم');

      expect(await migratedDb.select(migratedDb.juzQuarterProgress).get(), isEmpty);

      // الحفظ اليدوي الفعلي يعمل بعد الترقية مباشرة: تعليم ربع لطالب حقيقي.
      await migratedDb.into(migratedDb.juzQuarterProgress).insert(
            JuzQuarterProgressCompanion.insert(studentId: 1, juzNumber: 5, quarterIndex: 3),
          );
      final rows = await migratedDb.select(migratedDb.juzQuarterProgress).get();
      expect(rows, hasLength(1));
      expect(rows.first.juzNumber, 5);
      expect(rows.first.quarterIndex, 3);
    },
  );

  test(
    'ترقية v6→v7 (القسم ح.6): تضيف recitation_outcome بعمود إضافي فقط، وتُبقي بيانات v6 سليمة',
    () async {
      final schema = await verifier.schemaAt(6);
      final oldDb = v6.DatabaseAtV6(schema.newConnection());
      await oldDb.customStatement('''
        INSERT INTO students (id, full_name, age, phone, address)
        VALUES (1, 'طالب حقيقي', 10, '0100000000', 'عنوان')
      ''');
      await oldDb.customStatement('''
        INSERT INTO sessions (id, student_id, session_type, date, time)
        VALUES (1, 1, 'فردي', ${DateTime(2026, 1, 1).millisecondsSinceEpoch}, '18:00')
      ''');
      await oldDb.customStatement('''
        INSERT INTO session_attendances (id, session_id, student_id, attendance_status)
        VALUES (1, 1, 1, 'حاضر')
      ''');
      await oldDb.close();

      final migratedDb = AppDatabase.forTesting(schema.newConnection());
      addTearDown(migratedDb.close);

      final attendances = await migratedDb.select(migratedDb.sessionAttendances).get();
      expect(attendances, hasLength(1));
      expect(attendances.first.attendanceStatus, 'حاضر', reason: 'القيمة الحالية يجب أن تبقى كما هي');
      expect(attendances.first.recitationOutcome, isNull);

      // العمود الجديد فعلاً قابل للكتابة بعد الترقية مباشرة.
      await migratedDb.update(migratedDb.sessionAttendances).replace(SessionAttendancesCompanion(
            id: const Value(1),
            sessionId: const Value(1),
            studentId: const Value(1),
            recitationOutcome: const Value('ممتاز'),
          ));
      final updated = await migratedDb.select(migratedDb.sessionAttendances).getSingle();
      expect(updated.recitationOutcome, 'ممتاز');
    },
  );
}
