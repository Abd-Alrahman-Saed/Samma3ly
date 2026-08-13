import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Group, GroupScheduleSlot;
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/repositories/group_repository_impl.dart';
import 'package:quran_mobile/data/repositories/group_schedule_repository_impl.dart';
import 'package:quran_mobile/domain/entities/group.dart';
import 'package:quran_mobile/domain/entities/group_schedule_slot.dart';
import 'package:quran_mobile/domain/services/group_session_service.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late GroupDao groupDao;
  late SessionDao sessionDao;
  late GroupRepositoryImpl groupRepo;
  late GroupScheduleRepositoryImpl scheduleRepo;
  late GroupSessionService service;

  setUp(() {
    db = openTestDatabase();
    groupDao = GroupDao(db);
    sessionDao = SessionDao(db);
    groupRepo = GroupRepositoryImpl(groupDao);
    scheduleRepo = GroupScheduleRepositoryImpl(groupDao);
    service = GroupSessionService(scheduleRepo, sessionDao);
  });

  tearDown(() => db.close());

  Future<int> createGroup() async => (await groupRepo.create(const Group(name: 'حلقة'))).id;

  group('بند 2.7 — Materialize-on-write', () {
    test('عرض المواعيد القادمة (upcomingOccurrences) لا يُنشئ أي صف Session', () async {
      final groupId = await createGroup();
      await scheduleRepo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 3, 1),
      ));

      final occurrences = await service.upcomingOccurrences(
        groupId: groupId,
        from: DateTime(2026, 3, 1),
        to: DateTime(2026, 3, 31),
      );

      expect(occurrences, isNotEmpty);
      expect(occurrences.every((o) => !o.isMaterialized), isTrue);
      expect(await sessionDao.getMaterializedByGroup(groupId, DateTime(2026, 3, 1), DateTime(2026, 3, 31)), isEmpty);
    });

    test('materializeOccurrence ينشئ صف Session فعلياً بالتاريخ والوقت الصحيحين', () async {
      final groupId = await createGroup();
      final sessionId = await service.materializeOccurrence(
        groupId: groupId,
        occurrenceDate: DateTime(2026, 3, 9),
        dateTime: DateTime(2026, 3, 9, 17, 0),
      );

      final session = await sessionDao.getById(sessionId);
      expect(session, isNotNull);
      expect(session!.groupId, groupId);
      expect(session.sessionType, 'جماعي');
      expect(session.occurrenceDate, DateTime(2026, 3, 9));
      expect(session.time, '17:00');
      expect(session.studentId, isNull);
    });

    test('استدعاء materializeOccurrence مرتين لنفس المناسبة لا يُنشئ صفاً مكرَّراً (idempotent)', () async {
      final groupId = await createGroup();
      final firstId = await service.materializeOccurrence(
        groupId: groupId,
        occurrenceDate: DateTime(2026, 3, 9),
        dateTime: DateTime(2026, 3, 9, 17, 0),
      );
      final secondId = await service.materializeOccurrence(
        groupId: groupId,
        occurrenceDate: DateTime(2026, 3, 9),
        dateTime: DateTime(2026, 3, 9, 18, 30), // even with a different time
      );

      expect(secondId, firstId);
      final all = await sessionDao.getMaterializedByGroup(groupId, DateTime(2026, 3, 1), DateTime(2026, 3, 31));
      expect(all, hasLength(1));
      // The original materialized time is preserved — a second "start" call
      // does not silently move an already-recorded session.
      expect(all.first.time, '17:00');
    });

    test('upcomingOccurrences يُظهر المواعيد المُسجَّلة (materialized) بعلامة isMaterialized', () async {
      final groupId = await createGroup();
      await scheduleRepo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 3, 1),
      ));
      await service.materializeOccurrence(
        groupId: groupId,
        occurrenceDate: DateTime(2026, 3, 9),
        dateTime: DateTime(2026, 3, 9, 17, 0),
      );

      final occurrences = await service.upcomingOccurrences(
        groupId: groupId,
        from: DateTime(2026, 3, 1),
        to: DateTime(2026, 3, 31),
      );

      final materialized = occurrences.where((o) => o.isMaterialized).toList();
      expect(materialized, hasLength(1));
      expect(materialized.first.date, DateTime(2026, 3, 9));
      expect(materialized.first.sessionId, isNotNull);
    });
  });

  group('بند 2.6 — تعديل الموعد لا يغيّر جلسات ماضية', () {
    test('تعديل fixedTime بعد تسجيل جلسة يبقي وقت الجلسة المُسجَّلة كما هو، ويغيّر المواعيد غير المُسجَّلة فقط', () async {
      final groupId = await createGroup();
      final slot = await scheduleRepo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 3, 1),
      ));

      // Record (materialize) the March 9th occurrence at the original time.
      await service.materializeOccurrence(
        groupId: groupId,
        occurrenceDate: DateTime(2026, 3, 9),
        dateTime: DateTime(2026, 3, 9, 17, 0),
      );

      // Teacher edits the slot's time going forward.
      await scheduleRepo.updateSlot(slot.copyWith(fixedTime: '19:30'));

      final occurrences = await service.upcomingOccurrences(
        groupId: groupId,
        from: DateTime(2026, 3, 1),
        to: DateTime(2026, 3, 31),
      );

      final march9 = occurrences.firstWhere((o) => o.date == DateTime(2026, 3, 9));
      expect(march9.isMaterialized, isTrue);
      expect(march9.dateTime, DateTime(2026, 3, 9, 17, 0), reason: 'recorded session must not move when the slot is edited later');

      final march16 = occurrences.firstWhere((o) => o.date == DateTime(2026, 3, 16));
      expect(march16.isMaterialized, isFalse);
      expect(march16.dateTime, DateTime(2026, 3, 16, 19, 30), reason: 'not-yet-recorded occurrences follow the new slot time');
    });

    test('تضييق effectiveFrom بعد تسجيل جلسة لا يُخفي الجلسة المُسجَّلة من القائمة', () async {
      final groupId = await createGroup();
      final slot = await scheduleRepo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 3, 1),
      ));

      await service.materializeOccurrence(
        groupId: groupId,
        occurrenceDate: DateTime(2026, 3, 9),
        dateTime: DateTime(2026, 3, 9, 17, 0),
      );

      // Now the slot's effective window no longer covers March 9th at all.
      await scheduleRepo.updateSlot(slot.copyWith(effectiveFrom: DateTime(2026, 3, 20)));

      final occurrences = await service.upcomingOccurrences(
        groupId: groupId,
        from: DateTime(2026, 3, 1),
        to: DateTime(2026, 3, 31),
      );

      final march9 = occurrences.where((o) => o.date == DateTime(2026, 3, 9));
      expect(march9, hasLength(1));
      expect(march9.first.isMaterialized, isTrue);
    });

    test('حذف الموعد الأسبوعي كلياً لا يحذف الجلسات المُسجَّلة سابقاً', () async {
      final groupId = await createGroup();
      final slot = await scheduleRepo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 3, 1),
      ));
      final sessionId = await service.materializeOccurrence(
        groupId: groupId,
        occurrenceDate: DateTime(2026, 3, 9),
        dateTime: DateTime(2026, 3, 9, 17, 0),
      );

      await scheduleRepo.deleteSlot(slot.id);

      final session = await sessionDao.getById(sessionId);
      expect(session, isNotNull, reason: 'deleting the recurrence rule must not delete history');
    });
  });
}
