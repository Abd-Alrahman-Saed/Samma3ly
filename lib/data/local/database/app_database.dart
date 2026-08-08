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
import 'tables/schedules_table.dart';
import 'tables/goals_table.dart';
import 'tables/memorized_ranges_table.dart';

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
    Schedules,
    Goals,
    MemorizedRanges,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test-only constructor — lets tests inject an in-memory or temp-file
  /// executor instead of the real on-disk database file.
  @visibleForTesting
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedSurahs();
      await _seedJuzRanges();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Sprint 0 (v2): the `pending_changes` table was never wired up to
        // any real sync — drop it rather than carry dead schema forward.
        await m.deleteTable('pending_changes');

        // Sprint 0 (v2): rows referencing an already-deleted parent could
        // accumulate before foreign keys were enforced. Purge them now so
        // enabling enforcement below doesn't leave junk data behind that
        // would silently leak into aggregate counts (e.g. Dashboard).
        await _deleteOrphans();
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

const _juzRangeData = [
  (id: 1, juzNumber: 1, surahId: 1, fromAyah: 1, toAyah: 7),
  (id: 2, juzNumber: 1, surahId: 2, fromAyah: 1, toAyah: 141),
  (id: 3, juzNumber: 2, surahId: 2, fromAyah: 142, toAyah: 252),
  (id: 4, juzNumber: 3, surahId: 2, fromAyah: 253, toAyah: 286),
  (id: 5, juzNumber: 4, surahId: 3, fromAyah: 1, toAyah: 92),
  (id: 6, juzNumber: 5, surahId: 3, fromAyah: 93, toAyah: 200),
  (id: 7, juzNumber: 6, surahId: 4, fromAyah: 1, toAyah: 87),
  (id: 8, juzNumber: 7, surahId: 4, fromAyah: 88, toAyah: 176),
  (id: 9, juzNumber: 8, surahId: 5, fromAyah: 1, toAyah: 81),
  (id: 10, juzNumber: 9, surahId: 5, fromAyah: 82, toAyah: 120),
  (id: 11, juzNumber: 9, surahId: 6, fromAyah: 1, toAyah: 110),
  (id: 12, juzNumber: 10, surahId: 6, fromAyah: 111, toAyah: 165),
  (id: 13, juzNumber: 11, surahId: 7, fromAyah: 1, toAyah: 87),
  (id: 14, juzNumber: 12, surahId: 7, fromAyah: 88, toAyah: 170),
  (id: 15, juzNumber: 13, surahId: 7, fromAyah: 171, toAyah: 206),
  (id: 16, juzNumber: 14, surahId: 8, fromAyah: 1, toAyah: 75),
  (id: 17, juzNumber: 14, surahId: 9, fromAyah: 1, toAyah: 92),
  (id: 18, juzNumber: 15, surahId: 9, fromAyah: 93, toAyah: 129),
  (id: 19, juzNumber: 16, surahId: 10, fromAyah: 1, toAyah: 109),
  (id: 20, juzNumber: 16, surahId: 11, fromAyah: 1, toAyah: 5),
  (id: 21, juzNumber: 17, surahId: 11, fromAyah: 6, toAyah: 123),
  (id: 22, juzNumber: 18, surahId: 12, fromAyah: 1, toAyah: 111),
  (id: 23, juzNumber: 19, surahId: 13, fromAyah: 1, toAyah: 43),
  (id: 24, juzNumber: 19, surahId: 14, fromAyah: 1, toAyah: 52),
  (id: 25, juzNumber: 20, surahId: 15, fromAyah: 1, toAyah: 99),
  (id: 26, juzNumber: 21, surahId: 16, fromAyah: 1, toAyah: 128),
  (id: 27, juzNumber: 22, surahId: 17, fromAyah: 1, toAyah: 111),
  (id: 28, juzNumber: 23, surahId: 18, fromAyah: 1, toAyah: 110),
  (id: 29, juzNumber: 24, surahId: 19, fromAyah: 1, toAyah: 98),
  (id: 30, juzNumber: 24, surahId: 20, fromAyah: 1, toAyah: 135),
  (id: 31, juzNumber: 25, surahId: 21, fromAyah: 1, toAyah: 112),
  (id: 32, juzNumber: 26, surahId: 22, fromAyah: 1, toAyah: 78),
  (id: 33, juzNumber: 27, surahId: 23, fromAyah: 1, toAyah: 118),
  (id: 34, juzNumber: 28, surahId: 24, fromAyah: 1, toAyah: 64),
  (id: 35, juzNumber: 29, surahId: 25, fromAyah: 1, toAyah: 77),
  (id: 36, juzNumber: 29, surahId: 26, fromAyah: 1, toAyah: 227),
  (id: 37, juzNumber: 30, surahId: 27, fromAyah: 1, toAyah: 93),
  (id: 38, juzNumber: 30, surahId: 28, fromAyah: 1, toAyah: 88),
  (id: 39, juzNumber: 30, surahId: 29, fromAyah: 1, toAyah: 69),
  (id: 40, juzNumber: 30, surahId: 30, fromAyah: 1, toAyah: 60),
  (id: 41, juzNumber: 30, surahId: 31, fromAyah: 1, toAyah: 34),
  (id: 42, juzNumber: 30, surahId: 32, fromAyah: 1, toAyah: 30),
  (id: 43, juzNumber: 30, surahId: 33, fromAyah: 1, toAyah: 73),
  (id: 44, juzNumber: 30, surahId: 34, fromAyah: 1, toAyah: 54),
  (id: 45, juzNumber: 30, surahId: 35, fromAyah: 1, toAyah: 45),
  (id: 46, juzNumber: 30, surahId: 36, fromAyah: 1, toAyah: 83),
  (id: 47, juzNumber: 30, surahId: 37, fromAyah: 1, toAyah: 182),
  (id: 48, juzNumber: 30, surahId: 38, fromAyah: 1, toAyah: 88),
  (id: 49, juzNumber: 30, surahId: 39, fromAyah: 1, toAyah: 75),
  (id: 50, juzNumber: 30, surahId: 40, fromAyah: 1, toAyah: 85),
  (id: 51, juzNumber: 30, surahId: 41, fromAyah: 1, toAyah: 54),
  (id: 52, juzNumber: 30, surahId: 42, fromAyah: 1, toAyah: 53),
  (id: 53, juzNumber: 30, surahId: 43, fromAyah: 1, toAyah: 89),
  (id: 54, juzNumber: 30, surahId: 44, fromAyah: 1, toAyah: 59),
  (id: 55, juzNumber: 30, surahId: 45, fromAyah: 1, toAyah: 37),
  (id: 56, juzNumber: 30, surahId: 46, fromAyah: 1, toAyah: 35),
  (id: 57, juzNumber: 30, surahId: 47, fromAyah: 1, toAyah: 38),
  (id: 58, juzNumber: 30, surahId: 48, fromAyah: 1, toAyah: 29),
  (id: 59, juzNumber: 30, surahId: 49, fromAyah: 1, toAyah: 18),
  (id: 60, juzNumber: 30, surahId: 50, fromAyah: 1, toAyah: 45),
  (id: 61, juzNumber: 30, surahId: 51, fromAyah: 1, toAyah: 60),
  (id: 62, juzNumber: 30, surahId: 52, fromAyah: 1, toAyah: 49),
  (id: 63, juzNumber: 30, surahId: 53, fromAyah: 1, toAyah: 62),
  (id: 64, juzNumber: 30, surahId: 54, fromAyah: 1, toAyah: 55),
  (id: 65, juzNumber: 30, surahId: 55, fromAyah: 1, toAyah: 78),
  (id: 66, juzNumber: 30, surahId: 56, fromAyah: 1, toAyah: 96),
  (id: 67, juzNumber: 30, surahId: 57, fromAyah: 1, toAyah: 29),
  (id: 68, juzNumber: 30, surahId: 58, fromAyah: 1, toAyah: 22),
  (id: 69, juzNumber: 30, surahId: 59, fromAyah: 1, toAyah: 24),
  (id: 70, juzNumber: 30, surahId: 60, fromAyah: 1, toAyah: 13),
  (id: 71, juzNumber: 30, surahId: 61, fromAyah: 1, toAyah: 14),
  (id: 72, juzNumber: 30, surahId: 62, fromAyah: 1, toAyah: 11),
  (id: 73, juzNumber: 30, surahId: 63, fromAyah: 1, toAyah: 11),
  (id: 74, juzNumber: 30, surahId: 64, fromAyah: 1, toAyah: 18),
  (id: 75, juzNumber: 30, surahId: 65, fromAyah: 1, toAyah: 12),
  (id: 76, juzNumber: 30, surahId: 66, fromAyah: 1, toAyah: 12),
  (id: 77, juzNumber: 30, surahId: 67, fromAyah: 1, toAyah: 30),
  (id: 78, juzNumber: 30, surahId: 68, fromAyah: 1, toAyah: 52),
  (id: 79, juzNumber: 30, surahId: 69, fromAyah: 1, toAyah: 52),
  (id: 80, juzNumber: 30, surahId: 70, fromAyah: 1, toAyah: 44),
  (id: 81, juzNumber: 30, surahId: 71, fromAyah: 1, toAyah: 28),
  (id: 82, juzNumber: 30, surahId: 72, fromAyah: 1, toAyah: 28),
  (id: 83, juzNumber: 30, surahId: 73, fromAyah: 1, toAyah: 20),
  (id: 84, juzNumber: 30, surahId: 74, fromAyah: 1, toAyah: 56),
  (id: 85, juzNumber: 30, surahId: 75, fromAyah: 1, toAyah: 40),
  (id: 86, juzNumber: 30, surahId: 76, fromAyah: 1, toAyah: 31),
  (id: 87, juzNumber: 30, surahId: 77, fromAyah: 1, toAyah: 50),
  (id: 88, juzNumber: 30, surahId: 78, fromAyah: 1, toAyah: 40),
  (id: 89, juzNumber: 30, surahId: 79, fromAyah: 1, toAyah: 46),
  (id: 90, juzNumber: 30, surahId: 80, fromAyah: 1, toAyah: 42),
  (id: 91, juzNumber: 30, surahId: 81, fromAyah: 1, toAyah: 29),
  (id: 92, juzNumber: 30, surahId: 82, fromAyah: 1, toAyah: 19),
  (id: 93, juzNumber: 30, surahId: 83, fromAyah: 1, toAyah: 36),
  (id: 94, juzNumber: 30, surahId: 84, fromAyah: 1, toAyah: 25),
  (id: 95, juzNumber: 30, surahId: 85, fromAyah: 1, toAyah: 22),
  (id: 96, juzNumber: 30, surahId: 86, fromAyah: 1, toAyah: 17),
  (id: 97, juzNumber: 30, surahId: 87, fromAyah: 1, toAyah: 19),
  (id: 98, juzNumber: 30, surahId: 88, fromAyah: 1, toAyah: 26),
  (id: 99, juzNumber: 30, surahId: 89, fromAyah: 1, toAyah: 30),
  (id: 100, juzNumber: 30, surahId: 90, fromAyah: 1, toAyah: 20),
  (id: 101, juzNumber: 30, surahId: 91, fromAyah: 1, toAyah: 15),
  (id: 102, juzNumber: 30, surahId: 92, fromAyah: 1, toAyah: 21),
  (id: 103, juzNumber: 30, surahId: 93, fromAyah: 1, toAyah: 11),
  (id: 104, juzNumber: 30, surahId: 94, fromAyah: 1, toAyah: 8),
  (id: 105, juzNumber: 30, surahId: 95, fromAyah: 1, toAyah: 8),
  (id: 106, juzNumber: 30, surahId: 96, fromAyah: 1, toAyah: 19),
  (id: 107, juzNumber: 30, surahId: 97, fromAyah: 1, toAyah: 5),
  (id: 108, juzNumber: 30, surahId: 98, fromAyah: 1, toAyah: 8),
  (id: 109, juzNumber: 30, surahId: 99, fromAyah: 1, toAyah: 8),
  (id: 110, juzNumber: 30, surahId: 100, fromAyah: 1, toAyah: 11),
  (id: 111, juzNumber: 30, surahId: 101, fromAyah: 1, toAyah: 11),
  (id: 112, juzNumber: 30, surahId: 102, fromAyah: 1, toAyah: 8),
  (id: 113, juzNumber: 30, surahId: 103, fromAyah: 1, toAyah: 3),
  (id: 114, juzNumber: 30, surahId: 104, fromAyah: 1, toAyah: 9),
  (id: 115, juzNumber: 30, surahId: 105, fromAyah: 1, toAyah: 5),
  (id: 116, juzNumber: 30, surahId: 106, fromAyah: 1, toAyah: 4),
  (id: 117, juzNumber: 30, surahId: 107, fromAyah: 1, toAyah: 7),
  (id: 118, juzNumber: 30, surahId: 108, fromAyah: 1, toAyah: 3),
  (id: 119, juzNumber: 30, surahId: 109, fromAyah: 1, toAyah: 6),
  (id: 120, juzNumber: 30, surahId: 110, fromAyah: 1, toAyah: 3),
  (id: 121, juzNumber: 30, surahId: 111, fromAyah: 1, toAyah: 5),
  (id: 122, juzNumber: 30, surahId: 112, fromAyah: 1, toAyah: 4),
  (id: 123, juzNumber: 30, surahId: 113, fromAyah: 1, toAyah: 5),
  (id: 124, juzNumber: 30, surahId: 114, fromAyah: 1, toAyah: 6),
];
