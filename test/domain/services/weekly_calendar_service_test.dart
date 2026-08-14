import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Group, GroupScheduleSlot;
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/data/repositories/group_repository_impl.dart';
import 'package:quran_mobile/data/repositories/group_schedule_repository_impl.dart';
import 'package:quran_mobile/domain/entities/group.dart';
import 'package:quran_mobile/domain/entities/group_schedule_slot.dart';
import 'package:quran_mobile/domain/services/group_session_service.dart';
import 'package:quran_mobile/domain/services/weekly_calendar_service.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late SessionDao sessionDao;
  late StudentDao studentDao;
  late GroupDao groupDao;
  late GroupRepositoryImpl groupRepo;
  late WeeklyCalendarService service;
  late int studentId;

  setUp(() async {
    db = openTestDatabase();
    sessionDao = SessionDao(db);
    studentDao = StudentDao(db);
    groupDao = GroupDao(db);
    groupRepo = GroupRepositoryImpl(groupDao);
    final scheduleRepo = GroupScheduleRepositoryImpl(groupDao);
    final groupSessionService = GroupSessionService(scheduleRepo, sessionDao);
    service = WeeklyCalendarService(sessionDao, groupRepo, groupSessionService);

    studentId = await studentDao.insert(StudentsCompanion.insert(fullName: 'أحمد', age: 10, phone: '1', address: 'a'));
  });

  tearDown(() => db.close());

  test('يعيد جلسة فردية ضمن النطاق الزمني', () async {
    await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(2026, 3, 9),
      time: '17:00',
    ));

    final entries = await service.getEntries(from: DateTime(2026, 3, 1), to: DateTime(2026, 3, 31));

    expect(entries, hasLength(1));
    expect(entries.first.isGroup, isFalse);
    expect(entries.first.studentId, studentId);
    expect(entries.first.dateTime, DateTime(2026, 3, 9, 17, 0));
  });

  test('يعيد مواعيد المجموعات مدمجة مع الجلسات الفردية، مرتّبة زمنياً', () async {
    await sessionDao.insert(SessionsCompanion.insert(
      studentId: Value(studentId),
      date: DateTime(2026, 3, 10),
      time: '20:00',
    ));

    final group = await groupRepo.create(const Group(name: 'حلقة'));
    final scheduleRepo = GroupScheduleRepositoryImpl(groupDao);
    await scheduleRepo.createSlot(GroupScheduleSlot(
      groupId: group.id,
      weekday: DateTime.tuesday, // March 10, 2026 is a Tuesday
      fixedTime: '17:00',
      effectiveFrom: DateTime(2026, 3, 1),
    ));

    final entries = await service.getEntries(from: DateTime(2026, 3, 10), to: DateTime(2026, 3, 10));

    expect(entries, hasLength(2));
    // Sorted chronologically: the 17:00 group occurrence before the 20:00
    // individual session on the same day.
    expect(entries[0].isGroup, isTrue);
    expect(entries[0].dateTime, DateTime(2026, 3, 10, 17, 0));
    expect(entries[1].isGroup, isFalse);
    expect(entries[1].dateTime, DateTime(2026, 3, 10, 20, 0));
  });

  test('جلسة جماعية مُسجَّلة فعلياً في sessions لا تُحسَب مرّتين', () async {
    final group = await groupRepo.create(const Group(name: 'حلقة'));
    final scheduleRepo = GroupScheduleRepositoryImpl(groupDao);
    await scheduleRepo.createSlot(GroupScheduleSlot(
      groupId: group.id,
      weekday: DateTime.tuesday,
      fixedTime: '17:00',
      effectiveFrom: DateTime(2026, 3, 1),
    ));
    final groupSessionService = GroupSessionService(scheduleRepo, sessionDao);
    await groupSessionService.materializeOccurrence(
      groupId: group.id,
      occurrenceDate: DateTime(2026, 3, 10),
      dateTime: DateTime(2026, 3, 10, 17, 0),
    );

    final entries = await service.getEntries(from: DateTime(2026, 3, 10), to: DateTime(2026, 3, 10));

    expect(entries, hasLength(1));
    expect(entries.first.isGroup, isTrue);
    expect(entries.first.isMaterialized, isTrue);
    expect(entries.first.sessionId, isNotNull);
  });

  test('نطاق بلا أي جلسات أو مواعيد يعيد قائمة فارغة', () async {
    final entries = await service.getEntries(from: DateTime(2026, 3, 1), to: DateTime(2026, 3, 31));
    expect(entries, isEmpty);
  });
}
