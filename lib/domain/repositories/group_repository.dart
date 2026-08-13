import '../entities/group.dart';
import '../entities/group_member.dart';

abstract class GroupRepository {
  Future<List<Group>> getAll();
  Future<Group?> getById(int id);
  Future<Group> create(Group group);
  Future<Group> update(Group group);

  /// Also removes the group's members, schedule slots, and any schedule
  /// exceptions on those slots (in that order, to satisfy FKs) — a group
  /// has no meaning without them.
  Future<void> delete(int id);

  Future<List<GroupMember>> getMembers(int groupId);
  Future<void> addMember(int groupId, int studentId);
  Future<void> removeMember(int groupId, int studentId);
}
