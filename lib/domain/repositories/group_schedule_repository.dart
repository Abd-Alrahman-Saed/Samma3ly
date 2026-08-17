import '../entities/group_schedule_slot.dart';
import '../entities/schedule_exception.dart';
import '../services/recurrence_service.dart' show RecurrenceOccurrence;

abstract class GroupScheduleRepository {
  Future<List<GroupScheduleSlot>> getSlots(int groupId);
  Future<GroupScheduleSlot> createSlot(GroupScheduleSlot slot);
  Future<GroupScheduleSlot> updateSlot(GroupScheduleSlot slot);

  /// Also removes any [ScheduleException] rows that reference this slot.
  Future<void> deleteSlot(int id);

  Future<List<ScheduleException>> getExceptions(int groupScheduleSlotId);
  Future<ScheduleException> createException(ScheduleException exception);
  Future<void> deleteException(int id);

  /// Expands every one of [groupId]'s schedule slots into concrete
  /// occurrences between [from] and [to] (via `RecurrenceService`,
  /// item 2.2), applying any recorded exceptions.
  Future<List<RecurrenceOccurrence>> expandOccurrences({
    required int groupId,
    required DateTime from,
    required DateTime to,
  });
}
