// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memorized_range_dao.dart';

// ignore_for_file: type=lint
mixin _$MemorizedRangeDaoMixin on DatabaseAccessor<AppDatabase> {
  $SurahsTable get surahs => attachedDatabase.surahs;
  $StudentsTable get students => attachedDatabase.students;
  $MemorizedRangesTable get memorizedRanges => attachedDatabase.memorizedRanges;
  MemorizedRangeDaoManager get managers => MemorizedRangeDaoManager(this);
}

class MemorizedRangeDaoManager {
  final _$MemorizedRangeDaoMixin _db;
  MemorizedRangeDaoManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db.attachedDatabase, _db.surahs);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db.attachedDatabase, _db.students);
  $$MemorizedRangesTableTableManager get memorizedRanges =>
      $$MemorizedRangesTableTableManager(
          _db.attachedDatabase, _db.memorizedRanges);
}
