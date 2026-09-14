import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/surahs_table.dart';

part 'surah_dao.g.dart';

@DriftAccessor(tables: [Surahs])
class SurahDao extends DatabaseAccessor<AppDatabase> with _$SurahDaoMixin {
  SurahDao(super.db);

  Future<List<Surah>> getAll() =>
      (select(surahs)..orderBy([(t) => OrderingTerm.asc(t.number)])).get();

  Future<Surah?> getById(int id) => (select(surahs)..where((t) => t.id.equals(id))).getSingleOrNull();
}
