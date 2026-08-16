// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz_quarter_progress_dao.dart';

// ignore_for_file: type=lint
mixin _$JuzQuarterProgressDaoMixin on DatabaseAccessor<AppDatabase> {
  $SurahsTable get surahs => attachedDatabase.surahs;
  $StudentsTable get students => attachedDatabase.students;
  $JuzQuarterProgressTable get juzQuarterProgress =>
      attachedDatabase.juzQuarterProgress;
  JuzQuarterProgressDaoManager get managers =>
      JuzQuarterProgressDaoManager(this);
}

class JuzQuarterProgressDaoManager {
  final _$JuzQuarterProgressDaoMixin _db;
  JuzQuarterProgressDaoManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db.attachedDatabase, _db.surahs);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db.attachedDatabase, _db.students);
  $$JuzQuarterProgressTableTableManager get juzQuarterProgress =>
      $$JuzQuarterProgressTableTableManager(
          _db.attachedDatabase, _db.juzQuarterProgress);
}
