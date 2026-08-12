// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_dao.dart';

// ignore_for_file: type=lint
mixin _$SessionDaoMixin on DatabaseAccessor<AppDatabase> {
  $SurahsTable get surahs => attachedDatabase.surahs;
  $StudentsTable get students => attachedDatabase.students;
  $UsersTable get users => attachedDatabase.users;
  $GroupsTable get groups => attachedDatabase.groups;
  $SessionsTable get sessions => attachedDatabase.sessions;
  $SessionMemorizationsTable get sessionMemorizations =>
      attachedDatabase.sessionMemorizations;
  $SessionRevisionsTable get sessionRevisions =>
      attachedDatabase.sessionRevisions;
  $SessionEvaluationsTable get sessionEvaluations =>
      attachedDatabase.sessionEvaluations;
  $SessionAttendancesTable get sessionAttendances =>
      attachedDatabase.sessionAttendances;
  SessionDaoManager get managers => SessionDaoManager(this);
}

class SessionDaoManager {
  final _$SessionDaoMixin _db;
  SessionDaoManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db.attachedDatabase, _db.surahs);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db.attachedDatabase, _db.students);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db.attachedDatabase, _db.groups);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
  $$SessionMemorizationsTableTableManager get sessionMemorizations =>
      $$SessionMemorizationsTableTableManager(
          _db.attachedDatabase, _db.sessionMemorizations);
  $$SessionRevisionsTableTableManager get sessionRevisions =>
      $$SessionRevisionsTableTableManager(
          _db.attachedDatabase, _db.sessionRevisions);
  $$SessionEvaluationsTableTableManager get sessionEvaluations =>
      $$SessionEvaluationsTableTableManager(
          _db.attachedDatabase, _db.sessionEvaluations);
  $$SessionAttendancesTableTableManager get sessionAttendances =>
      $$SessionAttendancesTableTableManager(
          _db.attachedDatabase, _db.sessionAttendances);
}
