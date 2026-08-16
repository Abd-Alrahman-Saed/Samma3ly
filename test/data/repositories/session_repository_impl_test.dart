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

  test('getAll(studentId: ...) لطالب محدد لم تتأثر — لم تكن تُرجع جلسات حلقات أصلاً', () async {
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
}
