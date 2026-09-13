import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/users_table.dart';
import 'tables/surahs_table.dart';
import 'tables/juz_surah_ranges_table.dart';
import 'tables/students_table.dart';
import 'tables/sessions_table.dart';
import 'tables/session_memorizations_table.dart';
import 'tables/session_revisions_table.dart';
import 'tables/session_evaluations_table.dart';
import 'tables/session_attendances_table.dart';
import 'tables/schedules_table.dart';
import 'tables/goals_table.dart';
import 'tables/memorized_ranges_table.dart';
import 'tables/groups_table.dart';
import 'tables/group_members_table.dart';
import 'tables/group_schedule_slots_table.dart';
import 'tables/schedule_exceptions_table.dart';
import 'tables/juz_quarter_progress_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Surahs,
    JuzSurahRanges,
    Students,
    Sessions,
    SessionMemorizations,
    SessionRevisions,
    SessionEvaluations,
    SessionAttendances,
    Schedules,
    Goals,
    MemorizedRanges,
    Groups,
    GroupMembers,
    GroupScheduleSlots,
    ScheduleExceptions,
    JuzQuarterProgress,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test-only constructor — lets tests inject an in-memory or temp-file
  /// executor instead of the real on-disk database file.
  @visibleForTesting
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedSurahs();
      await _seedJuzRanges();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Every block below is guarded by both `from < N` (haven't reached
      // N yet) AND `to >= N` (actually migrating up to N or further) —
      // not just `from < N` alone. A real app always migrates straight to
      // `schemaVersion`, so `to` is always the latest version and this
      // never mattered in practice; but drift_dev's SchemaVerifier can
      // constrain a migration to stop at an intermediate version (e.g.
      // testing v2->v3 in isolation), and without the `to >= N` guard a
      // later block (e.g. v4's) would incorrectly also run during that
      // constrained migration, corrupting the test. See the v3->v4
      // migration test comment in test/migration_test.dart.
      if (from < 2 && to >= 2) {
        // Sprint 0 (v2): the `pending_changes` table was never wired up to
        // any real sync — drop it rather than carry dead schema forward.
        await m.deleteTable('pending_changes');

        // Sprint 0 (v2): rows referencing an already-deleted parent could
        // accumulate before foreign keys were enforced. Purge them now so
        // enabling enforcement below doesn't leave junk data behind that
        // would silently leak into aggregate counts (e.g. Dashboard).
        await _deleteOrphans();
      }
      if (from < 3 && to >= 3) {
        // Item 0.4b (v3): `juz_surah_ranges` was seeded with corrupted
        // data on every install prior to this version (juz 20-30 all
        // miscoded as juz 30; juz 3/4/5 boundaries also wrong — see the
        // comment above `_juzRangeData`). This is a reference/seed table,
        // not user data, so the fix is a full re-seed rather than a
        // row-by-row transform — wipe and re-insert from the corrected
        // `_juzRangeData`.
        await customStatement('DELETE FROM juz_surah_ranges');
        await _seedJuzRanges();
      }
      if (from < 4 && to >= 4) {
        // Item 2.1 (v4, Sprint 2): Groups feature — new tables for
        // recurring group scheduling, plus per-student attendance (a
        // group session has multiple students, each with an independent
        // status; a single `attendanceStatus` column on Sessions can no
        // longer represent that).
        //
        // 🔴 Highest-risk migration in the whole plan (see
        // docs/IMPLEMENTATION_PLAN.md القسم ب). SQLite has no
        // ALTER COLUMN, so making Sessions.studentId nullable requires a
        // full table recreation (m.alterTable/TableMigration).
        // attendanceStatus MUST be copied into session_attendances
        // BEFORE that recreation runs: the recreation rebuilds the table
        // to match the new Dart schema, which no longer declares
        // attendanceStatus at all, so the column (and its data) is gone
        // the moment the old table is dropped.
        await transaction(() async {
          await m.createTable(groups);
          await m.createTable(groupMembers);
          await m.createTable(groupScheduleSlots);
          await m.createTable(scheduleExceptions);
          await m.createTable(sessionAttendances);

          await customStatement('''
            INSERT INTO session_attendances (session_id, student_id, attendance_status, created_at)
            SELECT id, student_id, attendance_status, created_at FROM sessions
          ''');

          await m.alterTable(TableMigration(
            sessions,
            newColumns: [sessions.groupId, sessions.sessionType, sessions.occurrenceDate],
          ));
        });
      }
      // 🔴 `from >= 4` here (not just `from < 5 && to >= 5`) is load-bearing
      // — see the long comment above the v3→v4 test in test/migration_test.dart
      // for the full writeup. Short version: `m.createTable(...)` (used by
      // the v4 block above) always builds the table matching TODAY's live
      // Dart class, not the shape it historically had at v4 — so for any
      // upgrade path where `from < 4` (meaning the v4 block above runs in
      // this same pass), session_attendances is created ALREADY containing
      // these v5 columns, and re-running `addColumn` on them would crash
      // with "duplicate column name" for a real user jumping several
      // versions at once (e.g. from < 4 straight to 5). Only an existing
      // v4 database (from >= 4, this block's actual target) genuinely
      // lacks these columns and needs the ALTER.
      if (from < 5 && to >= 5 && from >= 4) {
        // Item 3.4 (v5, Sprint 3): per-student recitation fields on
        // session_attendances (see the doc comment on SessionAttendances
        // for why they live there and not on SessionMemorizations/
        // SessionRevisions/SessionEvaluations). All-nullable-or-defaulted
        // additive columns — SQLite handles these as plain
        // `ALTER TABLE ADD COLUMN`, no table recreation needed (unlike
        // v4's Sessions.studentId change).
        await m.addColumn(sessionAttendances, sessionAttendances.memorizationSurahId);
        await m.addColumn(sessionAttendances, sessionAttendances.memorizationFromAyah);
        await m.addColumn(sessionAttendances, sessionAttendances.memorizationToAyah);
        await m.addColumn(sessionAttendances, sessionAttendances.revisionSurahId);
        await m.addColumn(sessionAttendances, sessionAttendances.revisionFromAyah);
        await m.addColumn(sessionAttendances, sessionAttendances.revisionToAyah);
        await m.addColumn(sessionAttendances, sessionAttendances.memorizationScore);
        await m.addColumn(sessionAttendances, sessionAttendances.tajweedScore);
        await m.addColumn(sessionAttendances, sessionAttendances.fluencyScore);
        await m.addColumn(sessionAttendances, sessionAttendances.accuracyScore);
        await m.addColumn(sessionAttendances, sessionAttendances.notes);
      }
      if (from < 6 && to >= 6) {
        // القسم ح.2 (v6): تتبّع الحفظ اليدوي بالجزء/الربع — جدول جديد بالكامل،
        // لا تعديل على جدول قائم، فلا ينطبق هنا فخّ `createTable` (الأعمدة
        // الحيّة الحالية) الموصوف أعلاه فوق كتلة v5 — جدول جديد يُنشأ بشكله
        // الصحيح دايماً بغض النظر عن عدد الإصدارات المقفوزة في نفس الترقية.
        await m.createTable(juzQuarterProgress);
      }
      // نفس فخّ v5 بالضبط، ونفس الحارس `from >= 4`: recitationOutcome أُضيف
      // على session_attendances — الجدول اللي أنشأته كتلة v4 بـ`createTable`
      // (يعكس الشكل الحيّ الحالي دايماً). أي ترقية جمعت كتلة v4 في نفس
      // المرور (from < 4) بيبقى العمود موجود بالفعل، فكتلة addColumn هنا
      // المفروض تتخطّى تماماً زي v5 — وإلا "duplicate column name".
      if (from < 7 && to >= 7 && from >= 4) {
        // القسم ح.6 (v7): قرار المعلّم السريع بعد التسميع الجماعي — "اجتاز"
        // أو "يُعاد". عمود nullable إضافي فقط.
        await m.addColumn(sessionAttendances, sessionAttendances.recitationOutcome);
      }
      if (from < 8 && to >= 8) {
        // القسم ح.12 (v8): تقييم منفصل للمراجعة — أربعة أعمدة إضافية على
        // SessionEvaluations. هذا الجدول **لا** تُعيد أي كتلة onUpgrade
        // إنشاءه بـcreateTable (خلافاً لـsession_attendances) — كان موجوداً
        // منذ onCreate الأصلي فقط — فلا ينطبق هنا فخّ "الشكل الحيّ الحالي"،
        // ولا حاجة لحارس `from >= N` إضافي.
        //
        // 🔴 القسم ح.14 (v10) نقل هذه الأعمدة الأربعة إلى SessionRevisions
        // ثم حذفها من هنا — فـ`sessionEvaluations.revisionMemorizationScore`
        // إلخ لم تعد getters موجودة على تعريف الجدول الحيّ الحالي، ولا يصحّ
        // استخدام `m.addColumn(table, table.column)` النمطي هنا (يشير إلى
        // عمود غير موجود أصلاً في الكود). SQL خام بدلاً منه — نفس تأثير
        // ALTER TABLE ADD COLUMN الذي كان `addColumn` سيولّده، بلا اعتماد
        // على getter حيّ. كتلة v10 أدناه تحذف هذه الأعمدة بعد نقل بياناتها،
        // فأي قيمة تُكتب هنا مؤقتة داخل نفس مرور onUpgrade فقط.
        await customStatement('ALTER TABLE session_evaluations ADD COLUMN revision_memorization_score REAL NOT NULL DEFAULT 0.0');
        await customStatement('ALTER TABLE session_evaluations ADD COLUMN revision_tajweed_score REAL NOT NULL DEFAULT 0.0');
        await customStatement('ALTER TABLE session_evaluations ADD COLUMN revision_fluency_score REAL NOT NULL DEFAULT 0.0');
        await customStatement('ALTER TABLE session_evaluations ADD COLUMN revision_accuracy_score REAL NOT NULL DEFAULT 0.0');
      }
      // نفس فخّ v5/v7 بالضبط، ونفس الحارس `from >= 4`: أعمدة تقييم المراجعة
      // على session_attendances (لجلسات الحلقات) — الجدول اللي أنشأته كتلة
      // v4 بـcreateTable (يعكس الشكل الحيّ الحالي دائماً).
      if (from < 8 && to >= 8 && from >= 4) {
        await m.addColumn(sessionAttendances, sessionAttendances.revisionMemorizationScore);
        await m.addColumn(sessionAttendances, sessionAttendances.revisionTajweedScore);
        await m.addColumn(sessionAttendances, sessionAttendances.revisionFluencyScore);
        await m.addColumn(sessionAttendances, sessionAttendances.revisionAccuracyScore);
      }
      // نفس فخّ v5/v7/v8 بالضبط، ونفس الحارس `from >= 4`: group_schedule_slots
      // (خلافاً لـsession_evaluations) أنشأتها كتلة v4 بـ`createTable` —
      // فأي ترقية جمعت v4 في نفس المرور (from < 4) بيبقى الجدول بشكله
      // الحيّ الحالي (بلا الأعمدة الثلاثة أصلاً)، فمحاولة حذفها هتفشل
      // ("no such column"). فقط قاعدة v4+ فعلية تحتاج هذا الحذف.
      if (from < 9 && to >= 9 && from >= 4) {
        // القسم "امسح التوقيت المرتبط بالصلاة" (v9): حذف ميزة "مرتبط بصلاة"
        // بالكامل — anchorType/prayerName/offsetMinutes على
        // group_schedule_slots. أي موعد كان قديماً مرتبطاً بصلاة (fixedTime
        // فارغ وقتها) يُعطى توقيتاً افتراضياً معقولاً بدل أن يبقى بلا وقت
        // إطلاقاً بعد حذف بديله الوحيد لحساب الوقت.
        await customStatement(
          "UPDATE group_schedule_slots SET fixed_time = '18:00' WHERE fixed_time IS NULL",
        );
        await m.dropColumn(groupScheduleSlots, 'anchor_type');
        await m.dropColumn(groupScheduleSlots, 'prayer_name');
        await m.dropColumn(groupScheduleSlots, 'offset_minutes');
      }
      // القسم ح.14 (v10): مراجعات متعددة للجلسة الواحدة، كل واحدة بتقييمها
      // المستقلّ + خيار "السورة كاملة".
      //
      // الجداول الثلاثة هنا (session_revisions/session_memorizations/
      // session_evaluations) **لا** تُعيد أي كتلة onUpgrade إنشاءها
      // بـ`createTable` — موجودة منذ onCreate الأصلي فقط — فلا ينطبق عليها
      // فخّ "الشكل الحيّ الحالي" الموصوف فوق كتل v5/v7/v8/v9، ولا تحتاج
      // حارس `from >= N` إضافي (خلافاً لـsession_attendances و
      // group_schedule_slots). حارس `from < 10 && to >= 10` وحده كافٍ.
      if (from < 10 && to >= 10) {
        await transaction(() async {
          // 1) session_revisions: حذف قيد UNIQUE عن session_id (مراجعة
          //    واحدة لكل جلسة سابقاً) + الأعمدة الجديدة. SQLite لا يملك
          //    ALTER لحذف قيد، فالتغيير يتطلّب إعادة بناء الجدول —
          //    TableMigration تعيد بناءه على شكل تعريف Dart الحالي (بلا
          //    UNIQUE) وتنسخ الصفوف. كل الأعمدة الجديدة لها قيم افتراضية،
          //    فلا حاجة لـcolumnTransformer.
          await m.alterTable(TableMigration(
            sessionRevisions,
            newColumns: [
              sessionRevisions.label,
              sessionRevisions.isFullSurah,
              sessionRevisions.sortOrder,
              sessionRevisions.memorizationScore,
              sessionRevisions.tajweedScore,
              sessionRevisions.fluencyScore,
              sessionRevisions.accuracyScore,
            ],
          ));

          await m.addColumn(sessionMemorizations, sessionMemorizations.isFullSurah);

          // 2) نقل تقييم المراجعة من مستوى الجلسة (أعمدة v8 على
          //    session_evaluations) إلى صفّ المراجعة نفسه. العلاقة كانت
          //    واحد-لواحد قبل هذه الترقية بالضبط (session_id فريد في
          //    الجدولين)، فالاستعلام المترابط هنا يطابق صفّاً واحداً على
          //    الأكثر — بلا أي غموض في التوزيع.
          await customStatement('''
            UPDATE session_revisions SET
              memorization_score = COALESCE((SELECT e.revision_memorization_score FROM session_evaluations e WHERE e.session_id = session_revisions.session_id), 0.0),
              tajweed_score      = COALESCE((SELECT e.revision_tajweed_score      FROM session_evaluations e WHERE e.session_id = session_revisions.session_id), 0.0),
              fluency_score      = COALESCE((SELECT e.revision_fluency_score      FROM session_evaluations e WHERE e.session_id = session_revisions.session_id), 0.0),
              accuracy_score     = COALESCE((SELECT e.revision_accuracy_score     FROM session_evaluations e WHERE e.session_id = session_revisions.session_id), 0.0)
          ''');

          // 3) وبعد نقل البيانات فعلاً، تُحذف الأعمدة القديمة — لئلا يبقى
          //    مصدران للحقيقة لنفس المعنى. نظيرتها على session_attendances
          //    (جلسات الحلقات) تبقى كما هي: مسار منفصل، وما زالت مراجعة
          //    واحدة لكل طالب هناك.
          await m.dropColumn(sessionEvaluations, 'revision_memorization_score');
          await m.dropColumn(sessionEvaluations, 'revision_tajweed_score');
          await m.dropColumn(sessionEvaluations, 'revision_fluency_score');
          await m.dropColumn(sessionEvaluations, 'revision_accuracy_score');
        });
      }
    },
    beforeOpen: (details) async {
      // SQLite defaults foreign-key enforcement to OFF on every new
      // connection — this must be set on every open, not just on upgrade.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _deleteOrphans() async {
    await customStatement(
      'DELETE FROM sessions WHERE student_id NOT IN (SELECT id FROM students)',
    );
    await customStatement(
      'DELETE FROM schedules WHERE student_id NOT IN (SELECT id FROM students)',
    );
    await customStatement(
      'DELETE FROM goals WHERE student_id NOT IN (SELECT id FROM students)',
    );
    await customStatement(
      'DELETE FROM memorized_ranges WHERE student_id NOT IN (SELECT id FROM students)',
    );
    await customStatement(
      'DELETE FROM session_memorizations WHERE session_id NOT IN (SELECT id FROM sessions)',
    );
    await customStatement(
      'DELETE FROM session_revisions WHERE session_id NOT IN (SELECT id FROM sessions)',
    );
    await customStatement(
      'DELETE FROM session_evaluations WHERE session_id NOT IN (SELECT id FROM sessions)',
    );
  }

  Future<void> _seedSurahs() async {
    await batch((batch) {
      batch.insertAll(surahs, _surahData.map((d) => SurahsCompanion.insert(
        id: Value(d.id), number: d.number, name: d.name, ayahCount: d.ayahCount,
      )));
    });
  }

  Future<void> _seedJuzRanges() async {
    await batch((batch) {
      batch.insertAll(juzSurahRanges, _juzRangeData.map((d) => JuzSurahRangesCompanion.insert(
        id: Value(d.id), juzNumber: d.juzNumber, surahId: d.surahId, fromAyah: d.fromAyah, toAyah: d.toAyah,
      )));
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbDir.path, 'quran_management.db');
    return NativeDatabase(File(dbPath));
  });
}

const _surahData = [
  (id: 1, number: 1, name: 'الفاتحة', ayahCount: 7),
  (id: 2, number: 2, name: 'البقرة', ayahCount: 286),
  (id: 3, number: 3, name: 'آل عمران', ayahCount: 200),
  (id: 4, number: 4, name: 'النساء', ayahCount: 176),
  (id: 5, number: 5, name: 'المائدة', ayahCount: 120),
  (id: 6, number: 6, name: 'الأنعام', ayahCount: 165),
  (id: 7, number: 7, name: 'الأعراف', ayahCount: 206),
  (id: 8, number: 8, name: 'الأنفال', ayahCount: 75),
  (id: 9, number: 9, name: 'التوبة', ayahCount: 129),
  (id: 10, number: 10, name: 'يونس', ayahCount: 109),
  (id: 11, number: 11, name: 'هود', ayahCount: 123),
  (id: 12, number: 12, name: 'يوسف', ayahCount: 111),
  (id: 13, number: 13, name: 'الرعد', ayahCount: 43),
  (id: 14, number: 14, name: 'إبراهيم', ayahCount: 52),
  (id: 15, number: 15, name: 'الحجر', ayahCount: 99),
  (id: 16, number: 16, name: 'النحل', ayahCount: 128),
  (id: 17, number: 17, name: 'الإسراء', ayahCount: 111),
  (id: 18, number: 18, name: 'الكهف', ayahCount: 110),
  (id: 19, number: 19, name: 'مريم', ayahCount: 98),
  (id: 20, number: 20, name: 'طه', ayahCount: 135),
  (id: 21, number: 21, name: 'الأنبياء', ayahCount: 112),
  (id: 22, number: 22, name: 'الحج', ayahCount: 78),
  (id: 23, number: 23, name: 'المؤمنون', ayahCount: 118),
  (id: 24, number: 24, name: 'النور', ayahCount: 64),
  (id: 25, number: 25, name: 'الفرقان', ayahCount: 77),
  (id: 26, number: 26, name: 'الشعراء', ayahCount: 227),
  (id: 27, number: 27, name: 'النمل', ayahCount: 93),
  (id: 28, number: 28, name: 'القصص', ayahCount: 88),
  (id: 29, number: 29, name: 'العنكبوت', ayahCount: 69),
  (id: 30, number: 30, name: 'الروم', ayahCount: 60),
  (id: 31, number: 31, name: 'لقمان', ayahCount: 34),
  (id: 32, number: 32, name: 'السجدة', ayahCount: 30),
  (id: 33, number: 33, name: 'الأحزاب', ayahCount: 73),
  (id: 34, number: 34, name: 'سبأ', ayahCount: 54),
  (id: 35, number: 35, name: 'فاطر', ayahCount: 45),
  (id: 36, number: 36, name: 'يس', ayahCount: 83),
  (id: 37, number: 37, name: 'الصافات', ayahCount: 182),
  (id: 38, number: 38, name: 'ص', ayahCount: 88),
  (id: 39, number: 39, name: 'الزمر', ayahCount: 75),
  (id: 40, number: 40, name: 'غافر', ayahCount: 85),
  (id: 41, number: 41, name: 'فصلت', ayahCount: 54),
  (id: 42, number: 42, name: 'الشورى', ayahCount: 53),
  (id: 43, number: 43, name: 'الزخرف', ayahCount: 89),
  (id: 44, number: 44, name: 'الدخان', ayahCount: 59),
  (id: 45, number: 45, name: 'الجاثية', ayahCount: 37),
  (id: 46, number: 46, name: 'الأحقاف', ayahCount: 35),
  (id: 47, number: 47, name: 'محمد', ayahCount: 38),
  (id: 48, number: 48, name: 'الفتح', ayahCount: 29),
  (id: 49, number: 49, name: 'الحجرات', ayahCount: 18),
  (id: 50, number: 50, name: 'ق', ayahCount: 45),
  (id: 51, number: 51, name: 'الذاريات', ayahCount: 60),
  (id: 52, number: 52, name: 'الطور', ayahCount: 49),
  (id: 53, number: 53, name: 'النجم', ayahCount: 62),
  (id: 54, number: 54, name: 'القمر', ayahCount: 55),
  (id: 55, number: 55, name: 'الرحمن', ayahCount: 78),
  (id: 56, number: 56, name: 'الواقعة', ayahCount: 96),
  (id: 57, number: 57, name: 'الحديد', ayahCount: 29),
  (id: 58, number: 58, name: 'المجادلة', ayahCount: 22),
  (id: 59, number: 59, name: 'الحشر', ayahCount: 24),
  (id: 60, number: 60, name: 'الممتحنة', ayahCount: 13),
  (id: 61, number: 61, name: 'الصف', ayahCount: 14),
  (id: 62, number: 62, name: 'الجمعة', ayahCount: 11),
  (id: 63, number: 63, name: 'المنافقون', ayahCount: 11),
  (id: 64, number: 64, name: 'التغابن', ayahCount: 18),
  (id: 65, number: 65, name: 'الطلاق', ayahCount: 12),
  (id: 66, number: 66, name: 'التحريم', ayahCount: 12),
  (id: 67, number: 67, name: 'الملك', ayahCount: 30),
  (id: 68, number: 68, name: 'القلم', ayahCount: 52),
  (id: 69, number: 69, name: 'الحاقة', ayahCount: 52),
  (id: 70, number: 70, name: 'المعارج', ayahCount: 44),
  (id: 71, number: 71, name: 'نوح', ayahCount: 28),
  (id: 72, number: 72, name: 'الجن', ayahCount: 28),
  (id: 73, number: 73, name: 'المزمل', ayahCount: 20),
  (id: 74, number: 74, name: 'المدثر', ayahCount: 56),
  (id: 75, number: 75, name: 'القيامة', ayahCount: 40),
  (id: 76, number: 76, name: 'الإنسان', ayahCount: 31),
  (id: 77, number: 77, name: 'المرسلات', ayahCount: 50),
  (id: 78, number: 78, name: 'النبأ', ayahCount: 40),
  (id: 79, number: 79, name: 'النازعات', ayahCount: 46),
  (id: 80, number: 80, name: 'عبس', ayahCount: 42),
  (id: 81, number: 81, name: 'التكوير', ayahCount: 29),
  (id: 82, number: 82, name: 'الانفطار', ayahCount: 19),
  (id: 83, number: 83, name: 'المطففين', ayahCount: 36),
  (id: 84, number: 84, name: 'الانشقاق', ayahCount: 25),
  (id: 85, number: 85, name: 'البروج', ayahCount: 22),
  (id: 86, number: 86, name: 'الطارق', ayahCount: 17),
  (id: 87, number: 87, name: 'الأعلى', ayahCount: 19),
  (id: 88, number: 88, name: 'الغاشية', ayahCount: 26),
  (id: 89, number: 89, name: 'الفجر', ayahCount: 30),
  (id: 90, number: 90, name: 'البلد', ayahCount: 20),
  (id: 91, number: 91, name: 'الشمس', ayahCount: 15),
  (id: 92, number: 92, name: 'الليل', ayahCount: 21),
  (id: 93, number: 93, name: 'الضحى', ayahCount: 11),
  (id: 94, number: 94, name: 'الشرح', ayahCount: 8),
  (id: 95, number: 95, name: 'التين', ayahCount: 8),
  (id: 96, number: 96, name: 'العلق', ayahCount: 19),
  (id: 97, number: 97, name: 'القدر', ayahCount: 5),
  (id: 98, number: 98, name: 'البينة', ayahCount: 8),
  (id: 99, number: 99, name: 'الزلزلة', ayahCount: 8),
  (id: 100, number: 100, name: 'العاديات', ayahCount: 11),
  (id: 101, number: 101, name: 'القارعة', ayahCount: 11),
  (id: 102, number: 102, name: 'التكاثر', ayahCount: 8),
  (id: 103, number: 103, name: 'العصر', ayahCount: 3),
  (id: 104, number: 104, name: 'الهمزة', ayahCount: 9),
  (id: 105, number: 105, name: 'الفيل', ayahCount: 5),
  (id: 106, number: 106, name: 'قريش', ayahCount: 4),
  (id: 107, number: 107, name: 'الماعون', ayahCount: 7),
  (id: 108, number: 108, name: 'الكوثر', ayahCount: 3),
  (id: 109, number: 109, name: 'الكافرون', ayahCount: 6),
  (id: 110, number: 110, name: 'النصر', ayahCount: 3),
  (id: 111, number: 111, name: 'المسد', ayahCount: 5),
  (id: 112, number: 112, name: 'الإخلاص', ayahCount: 4),
  (id: 113, number: 113, name: 'الفلق', ayahCount: 5),
  (id: 114, number: 114, name: 'الناس', ayahCount: 6),
];

// Item 0.4b (Sprint 0): this table was previously corrupted — every juz
// from 20 through 30 was miscoded as `juzNumber: 30` (and juz 3/4/5's
// boundaries were also off by one surah-split). It was hand-typed
// originally with no cited source, so it was fully rebuilt here instead
// of patched, from two independent, cross-checked sources rather than
// from memory:
//   - api.quran.com/api/v4/juzs (verse_mapping per juz)
//   - api.alquran.cloud/v1/meta (juz start surah/ayah)
// Verified programmatically before use: both sources agree on all 30
// juz start points; every juz boundary is contiguous across the whole
// mushaf (no gaps/overlaps between juz N's last ayah and juz N+1's
// first); every (surah, ayah) pair is in-range against the ayah counts
// in `_surahData` above; juz 1 starts at 1:1 and juz 30 ends at 114:6.
const _juzRangeData = [
  (id: 1, juzNumber: 1, surahId: 1, fromAyah: 1, toAyah: 7),
  (id: 2, juzNumber: 1, surahId: 2, fromAyah: 1, toAyah: 141),
  (id: 3, juzNumber: 2, surahId: 2, fromAyah: 142, toAyah: 252),
  (id: 4, juzNumber: 3, surahId: 2, fromAyah: 253, toAyah: 286),
  (id: 5, juzNumber: 3, surahId: 3, fromAyah: 1, toAyah: 92),
  (id: 6, juzNumber: 4, surahId: 3, fromAyah: 93, toAyah: 200),
  (id: 7, juzNumber: 4, surahId: 4, fromAyah: 1, toAyah: 23),
  (id: 8, juzNumber: 5, surahId: 4, fromAyah: 24, toAyah: 147),
  (id: 9, juzNumber: 6, surahId: 4, fromAyah: 148, toAyah: 176),
  (id: 10, juzNumber: 6, surahId: 5, fromAyah: 1, toAyah: 81),
  (id: 11, juzNumber: 7, surahId: 5, fromAyah: 82, toAyah: 120),
  (id: 12, juzNumber: 7, surahId: 6, fromAyah: 1, toAyah: 110),
  (id: 13, juzNumber: 8, surahId: 6, fromAyah: 111, toAyah: 165),
  (id: 14, juzNumber: 8, surahId: 7, fromAyah: 1, toAyah: 87),
  (id: 15, juzNumber: 9, surahId: 7, fromAyah: 88, toAyah: 206),
  (id: 16, juzNumber: 9, surahId: 8, fromAyah: 1, toAyah: 40),
  (id: 17, juzNumber: 10, surahId: 8, fromAyah: 41, toAyah: 75),
  (id: 18, juzNumber: 10, surahId: 9, fromAyah: 1, toAyah: 92),
  (id: 19, juzNumber: 11, surahId: 9, fromAyah: 93, toAyah: 129),
  (id: 20, juzNumber: 11, surahId: 10, fromAyah: 1, toAyah: 109),
  (id: 21, juzNumber: 11, surahId: 11, fromAyah: 1, toAyah: 5),
  (id: 22, juzNumber: 12, surahId: 11, fromAyah: 6, toAyah: 123),
  (id: 23, juzNumber: 12, surahId: 12, fromAyah: 1, toAyah: 52),
  (id: 24, juzNumber: 13, surahId: 12, fromAyah: 53, toAyah: 111),
  (id: 25, juzNumber: 13, surahId: 13, fromAyah: 1, toAyah: 43),
  (id: 26, juzNumber: 13, surahId: 14, fromAyah: 1, toAyah: 52),
  (id: 27, juzNumber: 14, surahId: 15, fromAyah: 1, toAyah: 99),
  (id: 28, juzNumber: 14, surahId: 16, fromAyah: 1, toAyah: 128),
  (id: 29, juzNumber: 15, surahId: 17, fromAyah: 1, toAyah: 111),
  (id: 30, juzNumber: 15, surahId: 18, fromAyah: 1, toAyah: 74),
  (id: 31, juzNumber: 16, surahId: 18, fromAyah: 75, toAyah: 110),
  (id: 32, juzNumber: 16, surahId: 19, fromAyah: 1, toAyah: 98),
  (id: 33, juzNumber: 16, surahId: 20, fromAyah: 1, toAyah: 135),
  (id: 34, juzNumber: 17, surahId: 21, fromAyah: 1, toAyah: 112),
  (id: 35, juzNumber: 17, surahId: 22, fromAyah: 1, toAyah: 78),
  (id: 36, juzNumber: 18, surahId: 23, fromAyah: 1, toAyah: 118),
  (id: 37, juzNumber: 18, surahId: 24, fromAyah: 1, toAyah: 64),
  (id: 38, juzNumber: 18, surahId: 25, fromAyah: 1, toAyah: 20),
  (id: 39, juzNumber: 19, surahId: 25, fromAyah: 21, toAyah: 77),
  (id: 40, juzNumber: 19, surahId: 26, fromAyah: 1, toAyah: 227),
  (id: 41, juzNumber: 19, surahId: 27, fromAyah: 1, toAyah: 55),
  (id: 42, juzNumber: 20, surahId: 27, fromAyah: 56, toAyah: 93),
  (id: 43, juzNumber: 20, surahId: 28, fromAyah: 1, toAyah: 88),
  (id: 44, juzNumber: 20, surahId: 29, fromAyah: 1, toAyah: 45),
  (id: 45, juzNumber: 21, surahId: 29, fromAyah: 46, toAyah: 69),
  (id: 46, juzNumber: 21, surahId: 30, fromAyah: 1, toAyah: 60),
  (id: 47, juzNumber: 21, surahId: 31, fromAyah: 1, toAyah: 34),
  (id: 48, juzNumber: 21, surahId: 32, fromAyah: 1, toAyah: 30),
  (id: 49, juzNumber: 21, surahId: 33, fromAyah: 1, toAyah: 30),
  (id: 50, juzNumber: 22, surahId: 33, fromAyah: 31, toAyah: 73),
  (id: 51, juzNumber: 22, surahId: 34, fromAyah: 1, toAyah: 54),
  (id: 52, juzNumber: 22, surahId: 35, fromAyah: 1, toAyah: 45),
  (id: 53, juzNumber: 22, surahId: 36, fromAyah: 1, toAyah: 27),
  (id: 54, juzNumber: 23, surahId: 36, fromAyah: 28, toAyah: 83),
  (id: 55, juzNumber: 23, surahId: 37, fromAyah: 1, toAyah: 182),
  (id: 56, juzNumber: 23, surahId: 38, fromAyah: 1, toAyah: 88),
  (id: 57, juzNumber: 23, surahId: 39, fromAyah: 1, toAyah: 31),
  (id: 58, juzNumber: 24, surahId: 39, fromAyah: 32, toAyah: 75),
  (id: 59, juzNumber: 24, surahId: 40, fromAyah: 1, toAyah: 85),
  (id: 60, juzNumber: 24, surahId: 41, fromAyah: 1, toAyah: 46),
  (id: 61, juzNumber: 25, surahId: 41, fromAyah: 47, toAyah: 54),
  (id: 62, juzNumber: 25, surahId: 42, fromAyah: 1, toAyah: 53),
  (id: 63, juzNumber: 25, surahId: 43, fromAyah: 1, toAyah: 89),
  (id: 64, juzNumber: 25, surahId: 44, fromAyah: 1, toAyah: 59),
  (id: 65, juzNumber: 25, surahId: 45, fromAyah: 1, toAyah: 37),
  (id: 66, juzNumber: 26, surahId: 46, fromAyah: 1, toAyah: 35),
  (id: 67, juzNumber: 26, surahId: 47, fromAyah: 1, toAyah: 38),
  (id: 68, juzNumber: 26, surahId: 48, fromAyah: 1, toAyah: 29),
  (id: 69, juzNumber: 26, surahId: 49, fromAyah: 1, toAyah: 18),
  (id: 70, juzNumber: 26, surahId: 50, fromAyah: 1, toAyah: 45),
  (id: 71, juzNumber: 26, surahId: 51, fromAyah: 1, toAyah: 30),
  (id: 72, juzNumber: 27, surahId: 51, fromAyah: 31, toAyah: 60),
  (id: 73, juzNumber: 27, surahId: 52, fromAyah: 1, toAyah: 49),
  (id: 74, juzNumber: 27, surahId: 53, fromAyah: 1, toAyah: 62),
  (id: 75, juzNumber: 27, surahId: 54, fromAyah: 1, toAyah: 55),
  (id: 76, juzNumber: 27, surahId: 55, fromAyah: 1, toAyah: 78),
  (id: 77, juzNumber: 27, surahId: 56, fromAyah: 1, toAyah: 96),
  (id: 78, juzNumber: 27, surahId: 57, fromAyah: 1, toAyah: 29),
  (id: 79, juzNumber: 28, surahId: 58, fromAyah: 1, toAyah: 22),
  (id: 80, juzNumber: 28, surahId: 59, fromAyah: 1, toAyah: 24),
  (id: 81, juzNumber: 28, surahId: 60, fromAyah: 1, toAyah: 13),
  (id: 82, juzNumber: 28, surahId: 61, fromAyah: 1, toAyah: 14),
  (id: 83, juzNumber: 28, surahId: 62, fromAyah: 1, toAyah: 11),
  (id: 84, juzNumber: 28, surahId: 63, fromAyah: 1, toAyah: 11),
  (id: 85, juzNumber: 28, surahId: 64, fromAyah: 1, toAyah: 18),
  (id: 86, juzNumber: 28, surahId: 65, fromAyah: 1, toAyah: 12),
  (id: 87, juzNumber: 28, surahId: 66, fromAyah: 1, toAyah: 12),
  (id: 88, juzNumber: 29, surahId: 67, fromAyah: 1, toAyah: 30),
  (id: 89, juzNumber: 29, surahId: 68, fromAyah: 1, toAyah: 52),
  (id: 90, juzNumber: 29, surahId: 69, fromAyah: 1, toAyah: 52),
  (id: 91, juzNumber: 29, surahId: 70, fromAyah: 1, toAyah: 44),
  (id: 92, juzNumber: 29, surahId: 71, fromAyah: 1, toAyah: 28),
  (id: 93, juzNumber: 29, surahId: 72, fromAyah: 1, toAyah: 28),
  (id: 94, juzNumber: 29, surahId: 73, fromAyah: 1, toAyah: 20),
  (id: 95, juzNumber: 29, surahId: 74, fromAyah: 1, toAyah: 56),
  (id: 96, juzNumber: 29, surahId: 75, fromAyah: 1, toAyah: 40),
  (id: 97, juzNumber: 29, surahId: 76, fromAyah: 1, toAyah: 31),
  (id: 98, juzNumber: 29, surahId: 77, fromAyah: 1, toAyah: 50),
  (id: 99, juzNumber: 30, surahId: 78, fromAyah: 1, toAyah: 40),
  (id: 100, juzNumber: 30, surahId: 79, fromAyah: 1, toAyah: 46),
  (id: 101, juzNumber: 30, surahId: 80, fromAyah: 1, toAyah: 42),
  (id: 102, juzNumber: 30, surahId: 81, fromAyah: 1, toAyah: 29),
  (id: 103, juzNumber: 30, surahId: 82, fromAyah: 1, toAyah: 19),
  (id: 104, juzNumber: 30, surahId: 83, fromAyah: 1, toAyah: 36),
  (id: 105, juzNumber: 30, surahId: 84, fromAyah: 1, toAyah: 25),
  (id: 106, juzNumber: 30, surahId: 85, fromAyah: 1, toAyah: 22),
  (id: 107, juzNumber: 30, surahId: 86, fromAyah: 1, toAyah: 17),
  (id: 108, juzNumber: 30, surahId: 87, fromAyah: 1, toAyah: 19),
  (id: 109, juzNumber: 30, surahId: 88, fromAyah: 1, toAyah: 26),
  (id: 110, juzNumber: 30, surahId: 89, fromAyah: 1, toAyah: 30),
  (id: 111, juzNumber: 30, surahId: 90, fromAyah: 1, toAyah: 20),
  (id: 112, juzNumber: 30, surahId: 91, fromAyah: 1, toAyah: 15),
  (id: 113, juzNumber: 30, surahId: 92, fromAyah: 1, toAyah: 21),
  (id: 114, juzNumber: 30, surahId: 93, fromAyah: 1, toAyah: 11),
  (id: 115, juzNumber: 30, surahId: 94, fromAyah: 1, toAyah: 8),
  (id: 116, juzNumber: 30, surahId: 95, fromAyah: 1, toAyah: 8),
  (id: 117, juzNumber: 30, surahId: 96, fromAyah: 1, toAyah: 19),
  (id: 118, juzNumber: 30, surahId: 97, fromAyah: 1, toAyah: 5),
  (id: 119, juzNumber: 30, surahId: 98, fromAyah: 1, toAyah: 8),
  (id: 120, juzNumber: 30, surahId: 99, fromAyah: 1, toAyah: 8),
  (id: 121, juzNumber: 30, surahId: 100, fromAyah: 1, toAyah: 11),
  (id: 122, juzNumber: 30, surahId: 101, fromAyah: 1, toAyah: 11),
  (id: 123, juzNumber: 30, surahId: 102, fromAyah: 1, toAyah: 8),
  (id: 124, juzNumber: 30, surahId: 103, fromAyah: 1, toAyah: 3),
  (id: 125, juzNumber: 30, surahId: 104, fromAyah: 1, toAyah: 9),
  (id: 126, juzNumber: 30, surahId: 105, fromAyah: 1, toAyah: 5),
  (id: 127, juzNumber: 30, surahId: 106, fromAyah: 1, toAyah: 4),
  (id: 128, juzNumber: 30, surahId: 107, fromAyah: 1, toAyah: 7),
  (id: 129, juzNumber: 30, surahId: 108, fromAyah: 1, toAyah: 3),
  (id: 130, juzNumber: 30, surahId: 109, fromAyah: 1, toAyah: 6),
  (id: 131, juzNumber: 30, surahId: 110, fromAyah: 1, toAyah: 3),
  (id: 132, juzNumber: 30, surahId: 111, fromAyah: 1, toAyah: 5),
  (id: 133, juzNumber: 30, surahId: 112, fromAyah: 1, toAyah: 4),
  (id: 134, juzNumber: 30, surahId: 113, fromAyah: 1, toAyah: 5),
  (id: 135, juzNumber: 30, surahId: 114, fromAyah: 1, toAyah: 6),
];
