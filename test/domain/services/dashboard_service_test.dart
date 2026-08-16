// القسم ح.3: "الجلسات القادمة" كانت تعدّ جدولات فردية بلا حدّ زمني — الآن
// تعدّ كل جلسة (فردية + مواعيد حلقات متكرّرة) خلال 7 أيام قادمة فقط،
// بإعادة استخدام WeeklyCalendarService (بند 3.6) بدل حساب منفصل.
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Group, GroupScheduleSlot;
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/data/local/database/daos/user_dao.dart';
import 'package:quran_mobile/data/repositories/group_repository_impl.dart';
import 'package:quran_mobile/data/repositories/group_schedule_repository_impl.dart';
import 'package:quran_mobile/domain/entities/group.dart';
import 'package:quran_mobile/domain/entities/group_schedule_slot.dart';
import 'package:quran_mobile/domain/services/dashboard_service.dart';
import 'package:quran_mobile/domain/services/group_session_service.dart';
import 'package:quran_mobile/domain/services/weekly_calendar_service.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DashboardService service;
  late StudentDao studentDao;
  late SessionDao sessionDao;
  late GroupDao groupDao;

  setUp(() {
    db = openTestDatabase();
    studentDao = StudentDao(db);
    sessionDao = SessionDao(db);
    groupDao = GroupDao(db);
    final groupRepo = GroupRepositoryImpl(groupDao);
    final scheduleRepo = GroupScheduleRepositoryImpl(groupDao);
    final groupSessionService = GroupSessionService(scheduleRepo, sessionDao);
    final weeklyCalendarService = WeeklyCalendarService(sessionDao, groupRepo, groupSessionService);
    service = DashboardService(
      studentDao: studentDao,
      sessionDao: sessionDao,
      userDao: UserDao(db),
      weeklyCalendarService: weeklyCalendarService,
    );
  });

  tearDown(() => db.close());

  test('جلسة فردية بعد أسبوعين لا تُحسب ضمن جلسات الأسبوع', () async {
    final studentId = await studentDao.insert(
      StudentsCompanion.insert(fullName: 'طالب', age: 10, phone: '1', address: 'a'),
    );
    final farDate = DateTime.now().add(const Duration(days: 20));
    await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(farDate.year, farDate.month, farDate.day),
      time: '17:00',
    ));

    final data = await service.getDashboardData();
    expect(data.upcomingSessions, 0);
  });

  test('جلسة فردية خلال الأسبوع القادم تُحسب', () async {
    final studentId = await studentDao.insert(
      StudentsCompanion.insert(fullName: 'طالب', age: 10, phone: '1', address: 'a'),
    );
    final soon = DateTime.now().add(const Duration(days: 2));
    await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(soon.year, soon.month, soon.day),
      time: '17:00',
    ));

    final data = await service.getDashboardData();
    expect(data.upcomingSessions, 1);
  });

  test('موعد حلقة أسبوعي (غير مادّي بعد) يُحسب ضمن جلسات الأسبوع أيضاً', () async {
    final groupRepo = GroupRepositoryImpl(groupDao);
    final scheduleRepo = GroupScheduleRepositoryImpl(groupDao);
    final group = await groupRepo.create(const Group(name: 'حلقة'));
    final now = DateTime.now();
    await scheduleRepo.createSlot(GroupScheduleSlot(
      groupId: group.id,
      weekday: now.weekday,
      fixedTime: '18:00',
      effectiveFrom: DateTime(now.year, now.month, now.day),
    ));

    final data = await service.getDashboardData();
    expect(data.upcomingSessions, greaterThanOrEqualTo(1),
        reason: 'موعد الحلقة اليوم (نفس يوم الأسبوع) يجب أن يظهر ضمن الأسبوع القادم');
  });
}
