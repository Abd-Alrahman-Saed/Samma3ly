import '../entities/memorized_range.dart';

abstract class MemorizedRangeRepository {
  Future<List<MemorizedRange>> getByStudent(int studentId);
  Future<MemorizedRange?> getById(int id);
  Future<MemorizedRange> create(MemorizedRange range);
  Future<MemorizedRange> update(MemorizedRange range);
  Future<void> delete(int id);
  Future<void> markRevised(int id);
}
