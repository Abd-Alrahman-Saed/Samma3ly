import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/memorized_ranges_table.dart';

part 'memorized_range_dao.g.dart';

@DriftAccessor(tables: [MemorizedRanges])
class MemorizedRangeDao extends DatabaseAccessor<AppDatabase> with _$MemorizedRangeDaoMixin {
  MemorizedRangeDao(AppDatabase db) : super(db);

  Future<List<MemorizedRange>> getByStudent(int studentId) =>
      (select(memorizedRanges)..where((t) => t.studentId.equals(studentId))).get();

  Future<MemorizedRange?> getById(int id) =>
      (select(memorizedRanges)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insert(MemorizedRangesCompanion entry) => into(memorizedRanges).insert(entry);

  Future<bool> updateEntry(MemorizedRangesCompanion entry) => (update(memorizedRanges)..where((t) => t.id.equals(entry.id.value))).replace(entry);

  Future<int> deleteById(int id) => (delete(memorizedRanges)..where((t) => t.id.equals(id))).go();

  Future<List<MemorizedRange>> getByStudentAndSurah(int studentId, int surahId) =>
      (select(memorizedRanges)
        ..where((t) => t.studentId.equals(studentId) & t.surahId.equals(surahId))
      ).get();
}
