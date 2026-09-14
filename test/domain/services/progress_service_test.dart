// Characterization tests for [ProgressService] — Sprint 0, item 0.1.
//
// Goal: lock in CURRENT behavior (including known bugs) before the Sprint 0
// refactor touches this file, so unrelated regressions are caught.
//
// Tests explicitly marked "BUG" document incorrect behavior on purpose.
// They are EXPECTED to change when item 0.4 (interval-union fix) and 0.4b
// (juz seed-data fix) land — update the assertion at that point, don't
// delete the test. See docs/IMPLEMENTATION_PLAN.md.
//
// Juz-related fixtures deliberately stay within juz 1–2: at the time this
// suite was written, the seed data for juz 3–30 was itself corrupted (task
// 0.4b) and mixing that bug into these characterization tests would have
// made them meaningless once 0.4b was fixed. 0.4b is now fixed (seed
// rebuilt from verified sources — see the comment above `_juzRangeData` in
// app_database.dart, and test/data/local/database/juz_range_seed_test.dart
// for the regression guard); these fixtures were never widened since juz
// 1–2 already exercise the logic being characterized here.
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/goal_dao.dart';
import 'package:quran_mobile/data/local/database/daos/juz_surah_range_dao.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/data/local/database/daos/surah_dao.dart';
import 'package:quran_mobile/domain/services/progress_service.dart';

import '../../helpers/query_counter.dart';
import '../../helpers/test_database.dart';

void main() {
  // This suite's N+1 test opens a second, separate in-memory AppDatabase
  // instance alongside `db` — drift warns about that pattern in case of
  // accidental sharing. These two never touch the same executor.
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  late AppDatabase db;
  late StudentDao studentDao;
  late SessionDao sessionDao;
  late GoalDao goalDao;
  late ProgressService service;

  setUp(() {
    db = openTestDatabase();
    studentDao = StudentDao(db);
    sessionDao = SessionDao(db);
    goalDao = GoalDao(db);
    service = ProgressService(
      studentDao: studentDao,
      sessionDao: sessionDao,
      goalDao: goalDao,
      juzRangeDao: JuzSurahRangeDao(db),
      surahDao: SurahDao(db),
    );
  });

  tearDown(() => db.close());

  Future<int> insertStudent({String name = 'طالب تجريبي'}) {
    return db.into(db.students).insert(StudentsCompanion(
          fullName: Value(name),
          age: const Value(10),
          phone: const Value('0100000000'),
          address: const Value('عنوان تجريبي'),
        ));
  }

  Future<int> insertSession({
    required int studentId,
    DateTime? date,
    String attendanceStatus = 'حاضر',
  }) async {
    final sessionId = await db.into(db.sessions).insert(SessionsCompanion(
          studentId: Value(studentId),
          date: Value(date ?? DateTime(2026, 1, 1)),
          time: const Value('18:00'),
        ));
    await db.into(db.sessionAttendances).insert(SessionAttendancesCompanion(
          sessionId: Value(sessionId),
          studentId: Value(studentId),
          attendanceStatus: Value(attendanceStatus),
        ));
    return sessionId;
  }

  Future<void> insertMemorization({
    required int sessionId,
    required int surahId,
    required int fromAyah,
    required int toAyah,
  }) {
    return db.into(db.sessionMemorizations).insert(SessionMemorizationsCompanion(
          sessionId: Value(sessionId),
          surahId: Value(surahId),
          fromAyah: Value(fromAyah),
          toAyah: Value(toAyah),
        ));
  }

  Future<int> insertGoal({
    required int studentId,
    required String goalType,
    int? targetSurahId,
    int? targetJuzNumber,
  }) {
    return db.into(db.goals).insert(GoalsCompanion(
          studentId: Value(studentId),
          title: const Value('هدف تجريبي'),
          goalType: Value(goalType),
          targetSurahId: Value(targetSurahId),
          targetJuzNumber: Value(targetJuzNumber),
          startDate: Value(DateTime(2026, 1, 1)),
        ));
  }

  group('syncStudentProgress — المستوى وسورة الحفظ الحالية', () {
    test('طالب بدون جلسات يبقى في مستوى مبتدئ بلا سورة حالية', () async {
      final id = await insertStudent();

      await service.syncStudentProgress(id);
      final student = await studentDao.getById(id);

      expect(student!.level, 'مبتدئ');
      expect(student.currentSurahId, isNull);
      expect(student.lastCompletedSurahId, isNull);
      expect(student.totalCompletedJuz, 0);
    });

    test('يتجاهل تماماً الجلسات الغائبة عند حساب السورة الحالية والمستوى', () async {
      final id = await insertStudent();
      final absentSession = await insertSession(studentId: id, attendanceStatus: 'غائب');
      await insertMemorization(sessionId: absentSession, surahId: 1, fromAyah: 1, toAyah: 7);

      await service.syncStudentProgress(id);
      final student = await studentDao.getById(id);

      expect(student!.currentSurahId, isNull);
      expect(student.level, 'مبتدئ');
    });

    test(
      'حالة خاصة موثّقة: جلسة حاضرة بلا أي تسميع ترفع المستوى لمتوسط '
      '(hasProgress يعتمد على عدد الجلسات الحاضرة لا على وجود تسميع)',
      () async {
        final id = await insertStudent();
        await insertSession(studentId: id); // حاضر، بلا SessionMemorization

        await service.syncStudentProgress(id);
        final student = await studentDao.getById(id);

        expect(student!.level, 'متوسط');
      },
    );

    test('يحدد السورة الحالية بأصغر رقم سورة محفوظة، لا بأحدث جلسة', () async {
      final id = await insertStudent();
      final earlier = await insertSession(studentId: id, date: DateTime(2026, 1, 1));
      await insertMemorization(sessionId: earlier, surahId: 5, fromAyah: 1, toAyah: 10);
      final later = await insertSession(studentId: id, date: DateTime(2026, 1, 5));
      await insertMemorization(sessionId: later, surahId: 2, fromAyah: 1, toAyah: 10);

      await service.syncStudentProgress(id);
      final student = await studentDao.getById(id);

      expect(student!.currentSurahId, 2);
    });

    test(
      'حالة خاصة موثّقة: تسجيل جزء من سورة (من غير آية ١) بتوصيله لآخر آية '
      'يُحتسب "مكتملاً" — fromAyah لا يُتحقّق منه في lastCompletedSurahId',
      () async {
        final id = await insertStudent();
        final s = await insertSession(studentId: id);
        // النساء ١٧٦ آية — نسجّل ١٥٠-١٧٦ فقط (٢٦ آية) لا السورة كاملة
        await insertMemorization(sessionId: s, surahId: 4, fromAyah: 150, toAyah: 176);

        await service.syncStudentProgress(id);
        final student = await studentDao.getById(id);

        expect(student!.lastCompletedSurahId, 4,
            reason: 'يوثّق سلوكاً حالياً غير مقصود على الأرجح — خارج نطاق Sprint 0 صراحةً');
      },
    );

    test('يترقّى إلى متقدّم فقط عند اكتمال ٥ أجزاء و٣ سور مختلفة على الأقل', () async {
      final id = await insertStudent();
      // نغطي جزء ١ (الفاتحة + البقرة ١-١٤١) وجزء ٢ (البقرة ١٤٢-٢٥٢) فقط: جزءان لا ٥.
      final s1 = await insertSession(studentId: id, date: DateTime(2026, 1, 1));
      await insertMemorization(sessionId: s1, surahId: 1, fromAyah: 1, toAyah: 7);
      final s2 = await insertSession(studentId: id, date: DateTime(2026, 1, 2));
      await insertMemorization(sessionId: s2, surahId: 2, fromAyah: 1, toAyah: 141);
      final s3 = await insertSession(studentId: id, date: DateTime(2026, 1, 3));
      await insertMemorization(sessionId: s3, surahId: 2, fromAyah: 142, toAyah: 252);

      await service.syncStudentProgress(id);
      final student = await studentDao.getById(id);

      expect(student!.totalCompletedJuz, 2);
      expect(student.level, 'متوسط', reason: 'أقل من ٥ أجزاء مكتملة → لا يترقّى لمتقدّم');
    });
  });

  group('_calculateCompletedJuz (عبر totalCompletedJuz) — نطاق جزء ١', () {
    test('جزء مكتمل يُحتسب عند تغطية كل نطاقاته بدقّة', () async {
      final id = await insertStudent();
      final s1 = await insertSession(studentId: id, date: DateTime(2026, 1, 1));
      await insertMemorization(sessionId: s1, surahId: 1, fromAyah: 1, toAyah: 7);
      final s2 = await insertSession(studentId: id, date: DateTime(2026, 1, 2));
      await insertMemorization(sessionId: s2, surahId: 2, fromAyah: 1, toAyah: 141);

      await service.syncStudentProgress(id);
      final student = await studentDao.getById(id);

      expect(student!.totalCompletedJuz, 1);
    });

    test(
      '✅ (أُصلح في 0.4): حفظ يتخطّى حدّ الجزء بآيات قليلة يُحتسب مكتملاً — '
      'التقاطع لا الاحتواء',
      () async {
        final id = await insertStudent();
        final s1 = await insertSession(studentId: id, date: DateTime(2026, 1, 1));
        await insertMemorization(sessionId: s1, surahId: 1, fromAyah: 1, toAyah: 7);
        final s2 = await insertSession(studentId: id, date: DateTime(2026, 1, 2));
        // البقرة ١-١٥٠ بدل ١-١٤١: يتخطى حدّ الجزء ١ بتسع آيات فقط
        await insertMemorization(sessionId: s2, surahId: 2, fromAyah: 1, toAyah: 150);

        await service.syncStudentProgress(id);
        final student = await studentDao.getById(id);

        // الطالب غطّى الجزء ١ بالكامل وزيادة → يُحتسب مكتملاً الآن (تقاطع مع حدّ
        // النطاق، لا اشتراط احتواء المحفوظ بالكامل داخله).
        expect(student!.totalCompletedJuz, 1);
      },
    );
  });

  group('syncGoalProgress — هدف من نوع سورة', () {
    test('الهدف "لم يبدأ" عند عدم وجود أي حفظ للسورة المستهدفة', () async {
      final id = await insertStudent();
      final goalId = await insertGoal(studentId: id, goalType: 'سورة', targetSurahId: 112);

      await service.syncGoalProgress(id);
      final goal = await goalDao.getById(goalId);

      expect(goal!.status, 'لم يبدأ');
    });

    test('الهدف "قيد التنفيذ" عند حفظ جزئي صحيح غير متداخل', () async {
      final id = await insertStudent();
      // سورة الإخلاص (١١٢) — ٤ آيات
      final goalId = await insertGoal(studentId: id, goalType: 'سورة', targetSurahId: 112);
      final s = await insertSession(studentId: id);
      await insertMemorization(sessionId: s, surahId: 112, fromAyah: 1, toAyah: 2);

      await service.syncGoalProgress(id);
      final goal = await goalDao.getById(goalId);

      expect(goal!.status, 'قيد التنفيذ');
    });

    test('الهدف "مكتمل" عند تغطية السورة بالكامل', () async {
      final id = await insertStudent();
      final goalId = await insertGoal(studentId: id, goalType: 'سورة', targetSurahId: 112);
      final s = await insertSession(studentId: id);
      await insertMemorization(sessionId: s, surahId: 112, fromAyah: 1, toAyah: 4);

      await service.syncGoalProgress(id);
      final goal = await goalDao.getById(goalId);

      expect(goal!.status, 'مكتمل');
    });

    test(
      '✅ (أُصلح في 0.4): تكرار تسميع نفس النصف في جلستين لا يُضاعف العدّ — '
      'الهدف يبقى قيد التنفيذ',
      () async {
        final id = await insertStudent();
        final goalId = await insertGoal(studentId: id, goalType: 'سورة', targetSurahId: 112); // ٤ آيات
        final s1 = await insertSession(studentId: id, date: DateTime(2026, 1, 1));
        await insertMemorization(sessionId: s1, surahId: 112, fromAyah: 1, toAyah: 2);
        final s2 = await insertSession(studentId: id, date: DateTime(2026, 1, 2));
        await insertMemorization(sessionId: s2, surahId: 112, fromAyah: 1, toAyah: 2); // نفس النطاق مكرر

        await service.syncGoalProgress(id);
        final goal = await goalDao.getById(goalId);

        // اتحاد الفترات: التكرار لا يُحتسب مرتين — لا يزال ٢ آية فقط من ٤ مغطاة.
        expect(goal!.status, 'قيد التنفيذ');
      },
    );

    test('يتجاهل الجلسات الغائبة عند حساب تقدّم الهدف', () async {
      final id = await insertStudent();
      final goalId = await insertGoal(studentId: id, goalType: 'سورة', targetSurahId: 112);
      final s = await insertSession(studentId: id, attendanceStatus: 'غائب');
      await insertMemorization(sessionId: s, surahId: 112, fromAyah: 1, toAyah: 4);

      await service.syncGoalProgress(id);
      final goal = await goalDao.getById(goalId);

      expect(goal!.status, 'لم يبدأ');
    });
  });

  group('syncGoalProgress — هدف من نوع جزء (نطاق جزء ١)', () {
    test('هدف الجزء يكتمل عند تغطية كل نطاقاته بدقّة', () async {
      final id = await insertStudent();
      final goalId = await insertGoal(studentId: id, goalType: 'جزء', targetJuzNumber: 1);
      final s1 = await insertSession(studentId: id, date: DateTime(2026, 1, 1));
      await insertMemorization(sessionId: s1, surahId: 1, fromAyah: 1, toAyah: 7);
      final s2 = await insertSession(studentId: id, date: DateTime(2026, 1, 2));
      await insertMemorization(sessionId: s2, surahId: 2, fromAyah: 1, toAyah: 141);

      await service.syncGoalProgress(id);
      final goal = await goalDao.getById(goalId);

      expect(goal!.status, 'مكتمل');
    });

    test(
      '✅ (أُصلح في 0.4): حفظ يتخطّى حدّ الجزء بآيات قليلة يُحتسب مكتملاً بدل تصفيره',
      () async {
        final id = await insertStudent();
        final goalId = await insertGoal(studentId: id, goalType: 'جزء', targetJuzNumber: 1);
        final s1 = await insertSession(studentId: id, date: DateTime(2026, 1, 1));
        await insertMemorization(sessionId: s1, surahId: 1, fromAyah: 1, toAyah: 7);
        final s2 = await insertSession(studentId: id, date: DateTime(2026, 1, 2));
        await insertMemorization(sessionId: s2, surahId: 2, fromAyah: 1, toAyah: 150);

        await service.syncGoalProgress(id);
        final goal = await goalDao.getById(goalId);

        // الفاتحة (٧) + البقرة مقطوعة عند حدّ الجزء (١٤١) = ١٤٨ = الهدف بالكامل.
        expect(goal!.status, 'مكتمل');
      },
    );
  });

  group('أداء الاستعلامات — أُصلحت مشكلة N+1 في 0.5', () {
    test(
      '✅ عدد استعلامات SELECT مقيّد بثابت بغضّ النظر عن عدد الجلسات',
      () async {
        final interceptor = QueryCountInterceptor();
        final countedDb = openCountedTestDatabase(interceptor);
        addTearDown(countedDb.close);

        final countedStudentDao = StudentDao(countedDb);
        final countedSessionDao = SessionDao(countedDb);
        final countedService = ProgressService(
          studentDao: countedStudentDao,
          sessionDao: countedSessionDao,
          goalDao: GoalDao(countedDb),
          juzRangeDao: JuzSurahRangeDao(countedDb),
          surahDao: SurahDao(countedDb),
        );

        final id = await countedDb.into(countedDb.students).insert(const StudentsCompanion(
              fullName: Value('طالب أداء'),
              age: Value(10),
              phone: Value('0100000000'),
              address: Value('عنوان'),
            ));

        const sessionCount = 12;
        for (var i = 0; i < sessionCount; i++) {
          final sessionId = await countedDb.into(countedDb.sessions).insert(SessionsCompanion(
                studentId: Value(id),
                date: Value(DateTime(2026, 1, 1 + i)),
                time: const Value('18:00'),
              ));
          await countedDb.into(countedDb.sessionAttendances).insert(SessionAttendancesCompanion(
                sessionId: Value(sessionId),
                studentId: Value(id),
                attendanceStatus: const Value('حاضر'),
              ));
          await countedDb.into(countedDb.sessionMemorizations).insert(SessionMemorizationsCompanion(
                sessionId: Value(sessionId),
                surahId: const Value(114),
                fromAyah: const Value(1),
                toAyah: Value(1 + (i % 6)),
              ));
        }

        interceptor.selectCount = 0; // نتجاهل استعلامات الإعداد أعلاه
        await countedService.syncStudentProgress(id);

        // بعد 0.5: خمسة استعلامات بالضبط بغضّ النظر عن sessionCount —
        // getById(الطالب) + getAll(الجلسات) + getMemorizationsForStudent
        // (join واحد بدل حلقة) + surahDao.getAll() (دفعة واحدة) +
        // juzRangeDao.getAll() داخل _calculateCompletedJuz. قبل 0.5 كان
        // العدد ينمو خطياً مع sessionCount (كان ~٢٩ مع ١٢ جلسة).
        expect(interceptor.selectCount, lessThanOrEqualTo(8),
            reason: 'العدد يجب أن يبقى مقيّداً بثابت حتى لو زاد sessionCount بكثير');
      },
    );

    test('العدد يبقى نفسه تقريباً حتى مع عدد جلسات أكبر بكثير (يثبت الاستقلال عن N)', () async {
      final interceptor = QueryCountInterceptor();
      final countedDb = openCountedTestDatabase(interceptor);
      addTearDown(countedDb.close);

      final countedService = ProgressService(
        studentDao: StudentDao(countedDb),
        sessionDao: SessionDao(countedDb),
        goalDao: GoalDao(countedDb),
        juzRangeDao: JuzSurahRangeDao(countedDb),
        surahDao: SurahDao(countedDb),
      );

      final id = await countedDb.into(countedDb.students).insert(const StudentsCompanion(
            fullName: Value('طالب أداء ٢'),
            age: Value(10),
            phone: Value('0100000000'),
            address: Value('عنوان'),
          ));

      const sessionCount = 40; // أكبر بكثير من الاختبار السابق (١٢)
      for (var i = 0; i < sessionCount; i++) {
        final sessionId = await countedDb.into(countedDb.sessions).insert(SessionsCompanion(
              studentId: Value(id),
              date: Value(DateTime(2026, 1, 1 + i)),
              time: const Value('18:00'),
            ));
        await countedDb.into(countedDb.sessionAttendances).insert(SessionAttendancesCompanion(
              sessionId: Value(sessionId),
              studentId: Value(id),
              attendanceStatus: const Value('حاضر'),
            ));
        await countedDb.into(countedDb.sessionMemorizations).insert(SessionMemorizationsCompanion(
              sessionId: Value(sessionId),
              surahId: const Value(114),
              fromAyah: const Value(1),
              toAyah: Value(1 + (i % 6)),
            ));
      }

      interceptor.selectCount = 0;
      await countedService.syncStudentProgress(id);

      // نفس العدد تقريباً رغم إن sessionCount زاد من ١٢ لـ٤٠ — يثبت إن الاستعلامات
      // بقت مستقلة عن عدد الجلسات، لا متناسبة معه.
      expect(interceptor.selectCount, lessThanOrEqualTo(8));
    });
  });
}
