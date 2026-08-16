// القسم ح.4: عطل حقيقي — "null check operator used on a null value" كان
// يحدث في شاشة "الجلسات" وقسم "آخر الجلسات" بالداشبورد بمجرد وجود جلسة
// حلقة حقيقية واحدة (studentId == null)، لأن الشاشتين تفترضان أن كل جلسة
// عائدة من sessionRepositoryProvider.getAll() لها طالب واحد وتستخدمان
// `session.studentId!` بلا حراسة. الإصلاح: SessionRepositoryImpl.getAll()
// يستبعد جلسات الحلقات من الأصل — هذا الاختبار يثبّت العقد الجديد.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/enums/session_type.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Session, Group;
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/data/repositories/session_repository_impl.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late SessionDao sessionDao;
  late SessionRepositoryImpl repo;
  late int studentId;
  late int groupId;

  setUp(() async {
    db = openTestDatabase();
    sessionDao = SessionDao(db);
    repo = SessionRepositoryImpl(sessionDao);
    studentId = await StudentDao(db).insert(
      StudentsCompanion.insert(fullName: 'طالب', age: 10, phone: '1', address: 'a'),
    );
    groupId = await GroupDao(db).insert(GroupsCompanion.insert(name: 'حلقة تجريبية'));
  });

  tearDown(() => db.close());

  test('getAll() غير المُفلترة تستبعد جلسات الحلقات (studentId == null)', () async {
    await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(2026, 1, 1),
      time: '17:00',
    ));
    // جلسة حلقة حقيقية — بلا طالب واحد، بيانات نموذجية مثل ما تُنشئها
    // GroupSessionService.materializeOccurrence فعلياً.
    await sessionDao.insert(SessionsCompanion.insert(
      date: DateTime(2026, 1, 1),
      time: '18:00',
      groupId: Value(groupId),
      sessionType: Value(SessionType.group.arabic),
      occurrenceDate: Value(DateTime(2026, 1, 1)),
    ));

    final sessions = await repo.getAll();

    expect(sessions, hasLength(1), reason: 'جلسة الحلقة يجب ألا تظهر — لا "طالب واحد" لها');
    expect(sessions.first.studentId, studentId);
  });

  test('getAll(studentId: ...) لطالب بلا جلسات حلقات — السلوك سليم كما هو', () async {
    await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(2026, 1, 1),
      time: '17:00',
    ));

    final sessions = await repo.getAll(studentId: studentId);
    expect(sessions, hasLength(1));
  });

  test('طالب بلا أي جلسات حلقات — السلوك القديم سليم كما هو', () async {
    await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(2026, 1, 1),
      time: '17:00',
    ));
    await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(2026, 1, 2),
      time: '17:00',
    ));

    final sessions = await repo.getAll();
    expect(sessions, hasLength(2));
  });

  group('القسم ح.10 — مشاركات الحلقات ضمن getAll(studentId:)', () {
    test('جلسة حلقة حضرها الطالب فعلاً (له صفّ SessionAttendances) تظهر في جلساته', () async {
      final groupSessionId = await sessionDao.insert(SessionsCompanion.insert(
        date: DateTime(2026, 1, 5),
        time: '18:00',
        groupId: Value(groupId),
        sessionType: Value(SessionType.group.arabic),
        occurrenceDate: Value(DateTime(2026, 1, 5)),
      ));
      await sessionDao.upsertAttendance(groupSessionId, studentId, 'حاضر');

      final sessions = await repo.getAll(studentId: studentId);

      expect(sessions, hasLength(1));
      expect(sessions.first.id, groupSessionId);
      expect(sessions.first.groupId, groupId);
      expect(sessions.first.studentId, studentId, reason: 'يُستبدَل بمعرّف الطالب — الصفّ الخام لا طالب واحد له');
      expect(sessions.first.attendanceStatus, 'حاضر');
    });

    test('جلسة حلقة لم يحضرها الطالب (بلا صفّ حضور له) لا تظهر', () async {
      final groupSessionId = await sessionDao.insert(SessionsCompanion.insert(
        date: DateTime(2026, 1, 5),
        time: '18:00',
        groupId: Value(groupId),
        sessionType: Value(SessionType.group.arabic),
        occurrenceDate: Value(DateTime(2026, 1, 5)),
      ));
      final otherStudent = await StudentDao(db).insert(
        StudentsCompanion.insert(fullName: 'طالب آخر', age: 9, phone: '2', address: 'b'),
      );
      await sessionDao.upsertAttendance(groupSessionId, otherStudent, 'حاضر');

      final sessions = await repo.getAll(studentId: studentId);
      expect(sessions, isEmpty);
    });

    test('تسميع الحلقة (حفظ/تقييم) الخاص بهذا الطالب يظهر مصدره SessionAttendances لا جدول مشترَك', () async {
      final groupSessionId = await sessionDao.insert(SessionsCompanion.insert(
        date: DateTime(2026, 1, 5),
        time: '18:00',
        groupId: Value(groupId),
        sessionType: Value(SessionType.group.arabic),
        occurrenceDate: Value(DateTime(2026, 1, 5)),
      ));
      await sessionDao.upsertRecitation(SessionAttendancesCompanion.insert(
        sessionId: groupSessionId,
        studentId: studentId,
        memorizationSurahId: const Value(2),
        memorizationFromAyah: const Value(1),
        memorizationToAyah: const Value(5),
        memorizationScore: const Value(8),
        tajweedScore: const Value(7),
        fluencyScore: const Value(9),
        accuracyScore: const Value(6),
      ));

      final sessions = await repo.getAll(studentId: studentId);

      expect(sessions, hasLength(1));
      expect(sessions.first.memorization?.surahId, 2);
      expect(sessions.first.memorization?.toAyah, 5);
      expect(sessions.first.evaluation?.memorizationScore, 8);
      expect(sessions.first.evaluation?.finalScore, 7.5, reason: '(8+7+9+6)/4 = 7.5');
    });

    test('جلسات فردية وجلسات حلقات مدموجة ومرتَّبة تنازلياً بالتاريخ', () async {
      await sessionDao.insert(SessionsCompanion.insert(
        studentId: Value(studentId),
        date: DateTime(2026, 1, 3),
        time: '17:00',
      ));
      final groupSessionId = await sessionDao.insert(SessionsCompanion.insert(
        date: DateTime(2026, 1, 10),
        time: '18:00',
        groupId: Value(groupId),
        sessionType: Value(SessionType.group.arabic),
        occurrenceDate: Value(DateTime(2026, 1, 10)),
      ));
      await sessionDao.upsertAttendance(groupSessionId, studentId, 'حاضر');

      final sessions = await repo.getAll(studentId: studentId);

      expect(sessions, hasLength(2));
      expect(sessions.first.groupId, groupId, reason: 'الأحدث تاريخاً (10 يناير) أولاً');
      expect(sessions.last.groupId, isNull);
    });
  });
}
