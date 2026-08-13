// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_dao.dart';

// ignore_for_file: type=lint
mixin _$GroupDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $GroupsTable get groups => attachedDatabase.groups;
  $SurahsTable get surahs => attachedDatabase.surahs;
  $StudentsTable get students => attachedDatabase.students;
  $GroupMembersTable get groupMembers => attachedDatabase.groupMembers;
  $GroupScheduleSlotsTable get groupScheduleSlots =>
      attachedDatabase.groupScheduleSlots;
  $ScheduleExceptionsTable get scheduleExceptions =>
      attachedDatabase.scheduleExceptions;
  GroupDaoManager get managers => GroupDaoManager(this);
}

class GroupDaoManager {
  final _$GroupDaoMixin _db;
  GroupDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db.attachedDatabase, _db.groups);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db.attachedDatabase, _db.surahs);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db.attachedDatabase, _db.students);
  $$GroupMembersTableTableManager get groupMembers =>
      $$GroupMembersTableTableManager(_db.attachedDatabase, _db.groupMembers);
  $$GroupScheduleSlotsTableTableManager get groupScheduleSlots =>
      $$GroupScheduleSlotsTableTableManager(
          _db.attachedDatabase, _db.groupScheduleSlots);
  $$ScheduleExceptionsTableTableManager get scheduleExceptions =>
      $$ScheduleExceptionsTableTableManager(
          _db.attachedDatabase, _db.scheduleExceptions);
}
