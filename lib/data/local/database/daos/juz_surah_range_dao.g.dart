// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz_surah_range_dao.dart';

// ignore_for_file: type=lint
mixin _$JuzSurahRangeDaoMixin on DatabaseAccessor<AppDatabase> {
  $SurahsTable get surahs => attachedDatabase.surahs;
  $JuzSurahRangesTable get juzSurahRanges => attachedDatabase.juzSurahRanges;
  JuzSurahRangeDaoManager get managers => JuzSurahRangeDaoManager(this);
}

class JuzSurahRangeDaoManager {
  final _$JuzSurahRangeDaoMixin _db;
  JuzSurahRangeDaoManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db.attachedDatabase, _db.surahs);
  $$JuzSurahRangesTableTableManager get juzSurahRanges =>
      $$JuzSurahRangesTableTableManager(
          _db.attachedDatabase, _db.juzSurahRanges);
}
