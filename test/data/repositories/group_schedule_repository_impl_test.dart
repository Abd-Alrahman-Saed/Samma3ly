import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart'
    hide Group, GroupScheduleSlot, ScheduleException;
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/data/repositories/group_repository_impl.dart';
import 'package:quran_mobile/data/repositories/group_schedule_repository_impl.dart';
import 'package:quran_mobile/domain/entities/group.dart';
import 'package:quran_mobile/domain/entities/group_schedule_slot.dart';
import 'package:quran_mobile/domain/entities/schedule_exception.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late GroupDao dao;
  late GroupRepositoryImpl groupRepo;
  late GroupScheduleRepositoryImpl repo;

  setUp(() {
    db = openTestDatabase();
    dao = GroupDao(db);
    groupRepo = GroupRepositoryImpl(dao);
    repo = GroupScheduleRepositoryImpl(dao);
  });

  tearDown(() => db.close());

  Future<int> createGroup() async => (await groupRepo.create(const Group(name: 'حلقة'))).id;

  group('GroupScheduleRepositoryImpl — مواعيد الحلقة (Slots)', () {
    test('createSlot() ثم getSlots() يعيد نفس الموعد', () async {
      final groupId = await createGroup();
      final created = await repo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 1, 1),
      ));

      expect(created.id, greaterThan(0));
      final slots = await repo.getSlots(groupId);
      expect(slots, hasLength(1));
      expect(slots.first.fixedTime, '17:00');
      expect(slots.first.weekday, DateTime.monday);
    });

    test('updateSlot() يعدّل بيانات الموعد', () async {
      final groupId = await createGroup();
      final created = await repo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 1, 1),
      ));

      final updated = await repo.updateSlot(created.copyWith(fixedTime: '18:30'));
      expect(updated.fixedTime, '18:30');
      expect((await repo.getSlots(groupId)).single.fixedTime, '18:30');
    });

    test('deleteSlot() يحذف الموعد واستثناءاته', () async {
      final groupId = await createGroup();
      final slot = await repo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 1, 1),
      ));
      await repo.createException(ScheduleException(
        groupScheduleSlotId: slot.id,
        occurrenceDate: DateTime(2026, 1, 5),
        exceptionType: 'إلغاء',
      ));

      await repo.deleteSlot(slot.id);

      expect(await repo.getSlots(groupId), isEmpty);
      expect(await repo.getExceptions(slot.id), isEmpty);
    });
  });

  group('GroupScheduleRepositoryImpl — الاستثناءات', () {
    test('createException() ثم getExceptions() يعيد الاستثناء', () async {
      final groupId = await createGroup();
      final slot = await repo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 1, 1),
      ));

      final exception = await repo.createException(ScheduleException(
        groupScheduleSlotId: slot.id,
        occurrenceDate: DateTime(2026, 1, 5),
        exceptionType: 'إلغاء',
      ));

      expect(exception.id, greaterThan(0));
      final all = await repo.getExceptions(slot.id);
      expect(all, hasLength(1));
      expect(all.first.exceptionType, 'إلغاء');
    });

    test('deleteException() يحذف استثناءً واحداً دون التأثير على الموعد', () async {
      final groupId = await createGroup();
      final slot = await repo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 1, 1),
      ));
      final exception = await repo.createException(ScheduleException(
        groupScheduleSlotId: slot.id,
        occurrenceDate: DateTime(2026, 1, 5),
        exceptionType: 'إلغاء',
      ));

      await repo.deleteException(exception.id);

      expect(await repo.getExceptions(slot.id), isEmpty);
      expect(await repo.getSlots(groupId), hasLength(1));
    });
  });

  group('GroupScheduleRepositoryImpl — expandOccurrences (تكامل مع RecurrenceService)', () {
    test('يوسّع مواعيد ثابتة الوقت من قاعدة البيانات الحقيقية', () async {
      final groupId = await createGroup();
      await repo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 3, 1),
      ));

      final occurrences = await repo.expandOccurrences(
        groupId: groupId,
        from: DateTime(2026, 3, 1),
        to: DateTime(2026, 3, 31),
      );

      expect(occurrences, hasLength(5)); // Mondays: 2, 9, 16, 23, 30
      for (final o in occurrences) {
        expect(o.dateTime.hour, 17);
      }
    });

    test('يطبّق الاستثناءات المحفوظة أثناء التوسيع', () async {
      final groupId = await createGroup();
      final slot = await repo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 3, 1),
      ));
      await repo.createException(ScheduleException(
        groupScheduleSlotId: slot.id,
        occurrenceDate: DateTime(2026, 3, 16),
        exceptionType: 'إلغاء',
      ));

      final occurrences = await repo.expandOccurrences(
        groupId: groupId,
        from: DateTime(2026, 3, 1),
        to: DateTime(2026, 3, 31),
      );

      expect(occurrences.map((o) => o.date), isNot(contains(DateTime(2026, 3, 16))));
      expect(occurrences, hasLength(4)); // 2, 9, 23, 30 (16th skipped)
    });

    test('يدمج مواعيد أكثر من حلقة أسبوعية واحدة مرتّبة زمنياً', () async {
      final groupId = await createGroup();
      await repo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.monday,
        fixedTime: '16:00',
        effectiveFrom: DateTime(2026, 3, 1),
      ));
      await repo.createSlot(GroupScheduleSlot(
        groupId: groupId,
        weekday: DateTime.wednesday,
        fixedTime: '17:00',
        effectiveFrom: DateTime(2026, 3, 1),
      ));

      final occurrences = await repo.expandOccurrences(
        groupId: groupId,
        from: DateTime(2026, 3, 1),
        to: DateTime(2026, 3, 15),
      );

      expect(occurrences, hasLength(4)); // 2 Mondays + 2 Wednesdays
      for (var i = 1; i < occurrences.length; i++) {
        expect(occurrences[i].dateTime.isAfter(occurrences[i - 1].dateTime), isTrue);
      }
    });

    test('مجموعة بلا مواعيد تعيد قائمة فارغة دون استثناء', () async {
      final groupId = await createGroup();
      expect(
        await repo.expandOccurrences(groupId: groupId, from: DateTime(2026, 3, 1), to: DateTime(2026, 3, 31)),
        isEmpty,
      );
    });
  });
}
