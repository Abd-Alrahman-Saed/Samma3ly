import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/juz_surah_ranges_table.dart';

part 'juz_surah_range_dao.g.dart';

@DriftAccessor(tables: [JuzSurahRanges])
class JuzSurahRangeDao extends DatabaseAccessor<AppDatabase> with _$JuzSurahRangeDaoMixin {
  JuzSurahRangeDao(AppDatabase db) : super(db);

  Future<List<JuzSurahRange>> getAll() => select(juzSurahRanges).get();

  Future<List<JuzSurahRange>> getByJuzNumber(int juzNumber) =>
      (select(juzSurahRanges)..where((t) => t.juzNumber.equals(juzNumber))).get();
}
