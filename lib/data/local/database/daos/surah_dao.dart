import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/surahs_table.dart';

part 'surah_dao.g.dart';

@DriftAccessor(tables: [Surahs])
class SurahDao extends DatabaseAccessor<AppDatabase> with _$SurahDaoMixin {
  SurahDao(AppDatabase db) : super(db);

  Future<List<Surah>> getAll() => select(surahs).get();

  Future<Surah?> getById(int id) => (select(surahs)..where((t) => t.id.equals(id))).getSingleOrNull();
}
