// Sprint 3 additions to SessionDao: markAllAttendance (item 3.2) and
// upsertRecitation (item 3.4).
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';

import '../../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late SessionDao sessionDao;
  late StudentDao studentDao;
  late int sessionId;
  late int student1;
  late int student2;

  setUp(() async {
    db = openTestDatabase();
    sessionDao = SessionDao(db);
    studentDao = StudentDao(db);
    student1 = await studentDao.insert(StudentsCompanion.insert(fullName: 'أحمد', age: 10, phone: '1', address: 'a'));
    student2 = await studentDao.insert(StudentsCompanion.insert(fullName: 'محمد', age: 11, phone: '2', address: 'b'));
    sessionId = await sessionDao.insert(SessionsCompanion.insert(
      sessionType: const Value('جماعي'),
      date: DateTime(2026, 3, 9),
      time: '17:00',
    ));
  });

  tearDown(() => db.close());

  group('markAllAttendance', () {
    test('يسجّل نفس الحالة لكل الطلاب المُمرَّرين', () async {
      await sessionDao.markAllAttendance(sessionId, [student1, student2], 'حاضر');

      expect((await sessionDao.getAttendance(sessionId, student1))?.attendanceStatus, 'حاضر');
      expect((await sessionDao.getAttendance(sessionId, student2))?.attendanceStatus, 'حاضر');
    });

    test('يعدّل صفاً موجوداً بدل تكراره', () async {
      await sessionDao.upsertAttendance(sessionId, student1, 'غائب');
      await sessionDao.markAllAttendance(sessionId, [student1, student2], 'حاضر');

      final all = await sessionDao.getAttendancesForSession(sessionId);
      expect(all, hasLength(2));
      expect(all.firstWhere((a) => a.studentId == student1).attendanceStatus, 'حاضر');
    });
  });

  group('upsertRecitation', () {
    test('يُنشئ صفاً جديداً بحقول التسميع لو لم يكن موجوداً', () async {
      await sessionDao.upsertRecitation(SessionAttendancesCompanion(
        sessionId: Value(sessionId),
        studentId: Value(student1),
        memorizationSurahId: const Value(2),
        memorizationFromAyah: const Value(1),
        memorizationToAyah: const Value(10),
        memorizationScore: const Value(8.5),
      ));

      final row = await sessionDao.getAttendance(sessionId, student1);
      expect(row, isNotNull);
      expect(row!.memorizationSurahId, 2);
      expect(row.memorizationFromAyah, 1);
      expect(row.memorizationToAyah, 10);
      expect(row.memorizationScore, 8.5);
    });

    test('لا يغيّر attendanceStatus أو id أو createdAt لصفّ موجود', () async {
      await sessionDao.upsertAttendance(sessionId, student1, 'متأخر');
      final before = await sessionDao.getAttendance(sessionId, student1);

      await sessionDao.upsertRecitation(SessionAttendancesCompanion(
        sessionId: Value(sessionId),
        studentId: Value(student1),
        tajweedScore: const Value(9.0),
      ));

      final after = await sessionDao.getAttendance(sessionId, student1);
      expect(after!.id, before!.id);
      expect(after.attendanceStatus, 'متأخر', reason: 'upsertRecitation يجب ألا يلمس الحضور');
      expect(after.createdAt, before.createdAt);
      expect(after.tajweedScore, 9.0);
    });

    test('استدعاءان متتاليان يحدّثان نفس الصفّ لا يُنشئان صفّاً جديداً', () async {
      await sessionDao.upsertRecitation(SessionAttendancesCompanion(
        sessionId: Value(sessionId),
        studentId: Value(student1),
        memorizationScore: const Value(5.0),
      ));
      await sessionDao.upsertRecitation(SessionAttendancesCompanion(
        sessionId: Value(sessionId),
        studentId: Value(student1),
        memorizationScore: const Value(7.0),
      ));

      final all = await sessionDao.getAttendancesForSession(sessionId);
      expect(all, hasLength(1));
      expect(all.first.memorizationScore, 7.0);
    });
  });
}
