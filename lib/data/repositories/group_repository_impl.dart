import 'package:drift/drift.dart';
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/domain/entities/group.dart';
import 'package:quran_mobile/domain/entities/group_member.dart';
import 'package:quran_mobile/domain/repositories/group_repository.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Group, GroupMember;

Group _toEntity(dynamic g) => Group(
      id: g.id,
      name: g.name,
      teacherId: g.teacherId,
      createdAt: g.createdAt,
    );

GroupMember _memberToEntity(dynamic m) => GroupMember(
      id: m.id,
      groupId: m.groupId,
      studentId: m.studentId,
      joinedAt: m.joinedAt,
    );

class GroupRepositoryImpl implements GroupRepository {
  final GroupDao _dao;

  GroupRepositoryImpl(this._dao);

  @override
  Future<List<Group>> getAll() async => (await _dao.getAll()).map(_toEntity).toList();

  @override
  Future<Group?> getById(int id) async {
    final g = await _dao.getById(id);
    return g == null ? null : _toEntity(g);
  }

  @override
  Future<Group> create(Group group) async {
    final id = await _dao.insert(GroupsCompanion(
      name: Value(group.name),
      teacherId: Value(group.teacherId),
      createdAt: Value(DateTime.now()),
    ));
    return _toEntity((await _dao.getById(id))!);
  }

  @override
  Future<Group> update(Group group) async {
    await _dao.updateEntry(GroupsCompanion(
      id: Value(group.id),
      name: Value(group.name),
      teacherId: Value(group.teacherId),
      createdAt: Value(group.createdAt ?? DateTime.now()),
    ));
    return _toEntity((await _dao.getById(group.id))!);
  }

  @override
  Future<void> delete(int id) async {
    // FK order: exceptions -> slots -> members -> the group itself.
    final slots = await _dao.getSlots(id);
    final slotIds = slots.map((s) => s.id).toList();
    final exceptions = await _dao.getExceptionsForSlots(slotIds);
    for (final e in exceptions) {
      await _dao.deleteException(e.id);
    }
    for (final slotId in slotIds) {
      await _dao.deleteSlot(slotId);
    }
    await _dao.removeAllMembers(id);
    await _dao.deleteById(id);
  }

  @override
  Future<List<GroupMember>> getMembers(int groupId) async =>
      (await _dao.getMembers(groupId)).map(_memberToEntity).toList();

  @override
  Future<void> addMember(int groupId, int studentId) async {
    final existing = await _dao.getMember(groupId, studentId);
    if (existing != null) return; // already a member — no-op, not an error
    await _dao.addMember(GroupMembersCompanion(
      groupId: Value(groupId),
      studentId: Value(studentId),
      joinedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> removeMember(int groupId, int studentId) => _dao.removeMember(groupId, studentId);
}
