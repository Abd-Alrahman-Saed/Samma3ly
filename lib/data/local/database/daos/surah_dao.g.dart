// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_dao.dart';

// ignore_for_file: type=lint
mixin _$SurahDaoMixin on DatabaseAccessor<AppDatabase> {
  $SurahsTable get surahs => attachedDatabase.surahs;
  SurahDaoManager get managers => SurahDaoManager(this);
}

class SurahDaoManager {
  final _$SurahDaoMixin _db;
  SurahDaoManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db.attachedDatabase, _db.surahs);
}
