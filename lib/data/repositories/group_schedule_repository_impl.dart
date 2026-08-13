import 'package:drift/drift.dart';
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/domain/entities/group_schedule_slot.dart' as entity;
import 'package:quran_mobile/domain/entities/schedule_exception.dart' as entity;
import 'package:quran_mobile/domain/repositories/group_schedule_repository.dart';
import 'package:quran_mobile/domain/services/recurrence_service.dart';
import 'package:quran_mobile/data/local/database/app_database.dart'
    hide GroupScheduleSlot, ScheduleException;
import 'package:quran_mobile/data/local/database/app_database.dart' as db;

entity.GroupScheduleSlot _slotToEntity(db.GroupScheduleSlot s) => entity.GroupScheduleSlot(
      id: s.id,
      groupId: s.groupId,
      weekday: s.weekday,
      anchorType: s.anchorType,
      fixedTime: s.fixedTime,
      prayerName: s.prayerName,
      offsetMinutes: s.offsetMinutes,
      effectiveFrom: s.effectiveFrom,
      effectiveTo: s.effectiveTo,
      createdAt: s.createdAt,
    );

entity.ScheduleException _exceptionToEntity(db.ScheduleException e) => entity.ScheduleException(
      id: e.id,
      groupScheduleSlotId: e.groupScheduleSlotId,
      occurrenceDate: e.occurrenceDate,
      exceptionType: e.exceptionType,
      newDate: e.newDate,
      newTime: e.newTime,
      createdAt: e.createdAt,
    );

class GroupScheduleRepositoryImpl implements GroupScheduleRepository {
  final GroupDao _dao;
  final RecurrenceService _recurrenceService;

  GroupScheduleRepositoryImpl(this._dao, [RecurrenceService? recurrenceService])
      : _recurrenceService = recurrenceService ?? RecurrenceService();

  @override
  Future<List<entity.GroupScheduleSlot>> getSlots(int groupId) async =>
      (await _dao.getSlots(groupId)).map(_slotToEntity).toList();

  @override
  Future<entity.GroupScheduleSlot> createSlot(entity.GroupScheduleSlot slot) async {
    final id = await _dao.insertSlot(GroupScheduleSlotsCompanion(
      groupId: Value(slot.groupId),
      weekday: Value(slot.weekday),
      anchorType: Value(slot.anchorType),
      fixedTime: Value(slot.fixedTime),
      prayerName: Value(slot.prayerName),
      offsetMinutes: Value(slot.offsetMinutes),
      effectiveFrom: Value(slot.effectiveFrom),
      effectiveTo: Value(slot.effectiveTo),
      createdAt: Value(DateTime.now()),
    ));
    return _slotToEntity((await _dao.getSlotById(id))!);
  }

  @override
  Future<entity.GroupScheduleSlot> updateSlot(entity.GroupScheduleSlot slot) async {
    await _dao.updateSlot(GroupScheduleSlotsCompanion(
      id: Value(slot.id),
      groupId: Value(slot.groupId),
      weekday: Value(slot.weekday),
      anchorType: Value(slot.anchorType),
      fixedTime: Value(slot.fixedTime),
      prayerName: Value(slot.prayerName),
      offsetMinutes: Value(slot.offsetMinutes),
      effectiveFrom: Value(slot.effectiveFrom),
      effectiveTo: Value(slot.effectiveTo),
      createdAt: Value(slot.createdAt ?? DateTime.now()),
    ));
    return _slotToEntity((await _dao.getSlotById(slot.id))!);
  }

  @override
  Future<void> deleteSlot(int id) async {
    final exceptions = await _dao.getExceptions(id);
    for (final e in exceptions) {
      await _dao.deleteException(e.id);
    }
    await _dao.deleteSlot(id);
  }

  @override
  Future<List<entity.ScheduleException>> getExceptions(int groupScheduleSlotId) async =>
      (await _dao.getExceptions(groupScheduleSlotId)).map(_exceptionToEntity).toList();

  @override
  Future<entity.ScheduleException> createException(entity.ScheduleException exception) async {
    final id = await _dao.insertException(ScheduleExceptionsCompanion(
      groupScheduleSlotId: Value(exception.groupScheduleSlotId),
      occurrenceDate: Value(exception.occurrenceDate),
      exceptionType: Value(exception.exceptionType),
      newDate: Value(exception.newDate),
      newTime: Value(exception.newTime),
      createdAt: Value(DateTime.now()),
    ));
    return _exceptionToEntity((await _dao.getExceptionById(id))!);
  }

  @override
  Future<void> deleteException(int id) => _dao.deleteException(id);

  @override
  Future<List<RecurrenceOccurrence>> expandOccurrences({
    required int groupId,
    required DateTime from,
    required DateTime to,
    PrayerTimeResolver? prayerTimeResolver,
  }) async {
    final slots = await _dao.getSlots(groupId);
    if (slots.isEmpty) return const [];
    final slotIds = slots.map((s) => s.id).toList();
    final exceptions = await _dao.getExceptionsForSlots(slotIds);

    return _recurrenceService.expandAll(
      slots: slots,
      exceptions: exceptions,
      rangeStart: from,
      rangeEnd: to,
      prayerTimeResolver: prayerTimeResolver,
    );
  }
}
