import 'package:quran_mobile/domain/entities/memorized_range.dart';
import 'package:quran_mobile/domain/repositories/memorized_range_repository.dart';
import 'package:quran_mobile/domain/services/memorized_range_service.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' as db;

MemorizedRange _toEntity(dynamic r) => MemorizedRange(
      id: r.id,
      studentId: r.studentId,
      surahId: r.surahId,
      fromAyah: r.fromAyah,
      toAyah: r.toAyah,
      status: r.status,
      revisionCycleDays: r.revisionCycleDays,
      lastRevisedAt: r.lastRevisedAt,
      nextReviewDate: r.nextReviewDate,
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
    );

db.MemorizedRange _toDrift(MemorizedRange r) => db.MemorizedRange(
      id: r.id,
      studentId: r.studentId,
      surahId: r.surahId,
      fromAyah: r.fromAyah,
      toAyah: r.toAyah,
      status: r.status,
      revisionCycleDays: r.revisionCycleDays,
      lastRevisedAt: r.lastRevisedAt,
      nextReviewDate: r.nextReviewDate,
      createdAt: r.createdAt ?? DateTime.now(),
      updatedAt: r.updatedAt ?? DateTime.now(),
    );

class MemorizedRangeRepositoryImpl implements MemorizedRangeRepository {
  final MemorizedRangeService _service;

  MemorizedRangeRepositoryImpl(this._service);

  @override
  Future<List<MemorizedRange>> getByStudent(int studentId) async {
    return (await _service.getByStudent(studentId)).map(_toEntity).toList();
  }

  @override
  Future<MemorizedRange?> getById(int id) async {
    final r = await _service.getById(id);
    return r == null ? null : _toEntity(r);
  }

  @override
  Future<MemorizedRange> create(MemorizedRange range) async {
    return _toEntity(await _service.create(_toDrift(range)));
  }

  @override
  Future<MemorizedRange> update(MemorizedRange range) async {
    return _toEntity(await _service.update(_toDrift(range)));
  }

  @override
  Future<void> delete(int id) => _service.delete(id);

  @override
  Future<void> markRevised(int id) => _service.markRevised(id);
}
