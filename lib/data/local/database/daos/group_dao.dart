import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/groups_table.dart';
import '../tables/group_members_table.dart';
import '../tables/group_schedule_slots_table.dart';
import '../tables/schedule_exceptions_table.dart';

part 'group_dao.g.dart';

@DriftAccessor(tables: [Groups, GroupMembers, GroupScheduleSlots, ScheduleExceptions])
class GroupDao extends DatabaseAccessor<AppDatabase> with _$GroupDaoMixin {
  GroupDao(super.db);

  // Groups
  Future<List<Group>> getAll() => select(groups).get();

  Future<Group?> getById(int id) => (select(groups)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insert(GroupsCompanion entry) => into(groups).insert(entry);

  Future<bool> updateEntry(GroupsCompanion entry) => update(groups).replace(entry);

  Future<int> deleteById(int id) => (delete(groups)..where((t) => t.id.equals(id))).go();

  // GroupMembers
  Future<List<GroupMember>> getMembers(int groupId) =>
      (select(groupMembers)..where((t) => t.groupId.equals(groupId))).get();

  /// Batch — avoids the N+1 pattern (Sprint 0, item 0.5) when listing
  /// several groups' member counts/rosters at once.
  Future<List<GroupMember>> getMembersForGroups(List<int> groupIds) {
    if (groupIds.isEmpty) return Future.value(const []);
    return (select(groupMembers)..where((t) => t.groupId.isIn(groupIds))).get();
  }

  Future<GroupMember?> getMember(int groupId, int studentId) =>
      (select(groupMembers)..where((t) => t.groupId.equals(groupId) & t.studentId.equals(studentId)))
          .getSingleOrNull();

  Future<int> addMember(GroupMembersCompanion entry) => into(groupMembers).insert(entry);

  Future<int> removeMember(int groupId, int studentId) =>
      (delete(groupMembers)..where((t) => t.groupId.equals(groupId) & t.studentId.equals(studentId))).go();

  Future<int> removeAllMembers(int groupId) =>
      (delete(groupMembers)..where((t) => t.groupId.equals(groupId))).go();

  // GroupScheduleSlots
  Future<List<GroupScheduleSlot>> getSlots(int groupId) =>
      (select(groupScheduleSlots)..where((t) => t.groupId.equals(groupId))).get();

  Future<List<GroupScheduleSlot>> getSlotsForGroups(List<int> groupIds) {
    if (groupIds.isEmpty) return Future.value(const []);
    return (select(groupScheduleSlots)..where((t) => t.groupId.isIn(groupIds))).get();
  }

  Future<GroupScheduleSlot?> getSlotById(int id) =>
      (select(groupScheduleSlots)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertSlot(GroupScheduleSlotsCompanion entry) => into(groupScheduleSlots).insert(entry);

  Future<bool> updateSlot(GroupScheduleSlotsCompanion entry) => update(groupScheduleSlots).replace(entry);

  Future<int> deleteSlot(int id) => (delete(groupScheduleSlots)..where((t) => t.id.equals(id))).go();

  // ScheduleExceptions
  Future<ScheduleException?> getExceptionById(int id) =>
      (select(scheduleExceptions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<ScheduleException>> getExceptions(int groupScheduleSlotId) =>
      (select(scheduleExceptions)..where((t) => t.groupScheduleSlotId.equals(groupScheduleSlotId))).get();

  /// Batch — one query for every slot in a group instead of one per slot,
  /// matching [getSlotsForGroups]'s N+1 avoidance.
  Future<List<ScheduleException>> getExceptionsForSlots(List<int> groupScheduleSlotIds) {
    if (groupScheduleSlotIds.isEmpty) return Future.value(const []);
    return (select(scheduleExceptions)..where((t) => t.groupScheduleSlotId.isIn(groupScheduleSlotIds))).get();
  }

  Future<int> insertException(ScheduleExceptionsCompanion entry) => into(scheduleExceptions).insert(entry);

  Future<bool> updateException(ScheduleExceptionsCompanion entry) => update(scheduleExceptions).replace(entry);

  Future<int> deleteException(int id) => (delete(scheduleExceptions)..where((t) => t.id.equals(id))).go();
}
