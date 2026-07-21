import 'package:drift/drift.dart';
import 'package:quran_mobile/data/local/database/daos/memorized_range_dao.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

class MemorizedRangeService {
  final MemorizedRangeDao _dao;

  MemorizedRangeService(this._dao);

  Future<List<MemorizedRange>> getByStudent(int studentId) async {
    final ranges = await _dao.getByStudent(studentId);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    bool needsSave = false;

    for (final r in ranges) {
      if (r.status == 'محفوظ' &&
          r.nextReviewDate != null &&
          !r.nextReviewDate!.isAfter(todayDate)) {
        await _dao.updateEntry(MemorizedRangesCompanion(
          id: Value(r.id),
          studentId: Value(r.studentId),
          surahId: Value(r.surahId),
          fromAyah: Value(r.fromAyah),
          toAyah: Value(r.toAyah),
          status: Value('يحتاج مراجعة'),
          revisionCycleDays: Value(r.revisionCycleDays),
          lastRevisedAt: Value(r.lastRevisedAt),
          nextReviewDate: Value(r.nextReviewDate),
          createdAt: Value(r.createdAt),
          updatedAt: Value(DateTime.now()),
        ));
        needsSave = true;
      }
    }

    return _dao.getByStudent(studentId);
  }

  Future<MemorizedRange?> getById(int id) => _dao.getById(id);

  Future<MemorizedRange> create(MemorizedRange range) async {
    final now = DateTime.now();
    final nextReview = DateTime(now.year, now.month, now.day).add(Duration(days: range.revisionCycleDays));
    final id = await _dao.insert(MemorizedRangesCompanion(
      studentId: Value(range.studentId),
      surahId: Value(range.surahId),
      fromAyah: Value(range.fromAyah),
      toAyah: Value(range.toAyah),
      status: Value(range.status),
      revisionCycleDays: Value(range.revisionCycleDays),
      lastRevisedAt: const Value(null),
      nextReviewDate: Value(nextReview),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
    return (await _dao.getById(id))!;
  }

  Future<MemorizedRange> update(MemorizedRange range) async {
    DateTime? nextReview;
    if (range.lastRevisedAt != null) {
      nextReview = range.lastRevisedAt!.add(Duration(days: range.revisionCycleDays));
    }
    await _dao.updateEntry(MemorizedRangesCompanion(
      id: Value(range.id),
      studentId: Value(range.studentId),
      surahId: Value(range.surahId),
      fromAyah: Value(range.fromAyah),
      toAyah: Value(range.toAyah),
      status: Value(range.status),
      revisionCycleDays: Value(range.revisionCycleDays),
      lastRevisedAt: Value(range.lastRevisedAt),
      nextReviewDate: Value(nextReview ?? range.nextReviewDate),
      createdAt: Value(range.createdAt),
      updatedAt: Value(DateTime.now()),
    ));
    return (await _dao.getById(range.id))!;
  }

  Future<void> delete(int id) => _dao.deleteById(id);

  Future<void> markRevised(int id) async {
    final range = await _dao.getById(id);
    if (range == null) return;
    final today = DateTime.now();
    final nextReview = today.add(Duration(days: range.revisionCycleDays));
    await _dao.updateEntry(MemorizedRangesCompanion(
      id: Value(range.id),
      studentId: Value(range.studentId),
      surahId: Value(range.surahId),
      fromAyah: Value(range.fromAyah),
      toAyah: Value(range.toAyah),
      status: Value('محفوظ'),
      revisionCycleDays: Value(range.revisionCycleDays),
      lastRevisedAt: Value(today),
      nextReviewDate: Value(nextReview),
      createdAt: Value(range.createdAt),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> syncFromSession(int studentId, int surahId, int fromAyah, int toAyah) async {
    final ranges = await _dao.getByStudentAndSurah(studentId, surahId);
    final existing = ranges.where((r) => r.fromAyah == fromAyah && r.toAyah == toAyah).firstOrNull;
    if (existing == null) return;

    final today = DateTime.now();
    final nextReview = today.add(Duration(days: existing.revisionCycleDays));
    await _dao.updateEntry(MemorizedRangesCompanion(
      id: Value(existing.id),
      studentId: Value(existing.studentId),
      surahId: Value(existing.surahId),
      fromAyah: Value(existing.fromAyah),
      toAyah: Value(existing.toAyah),
      status: Value('محفوظ'),
      revisionCycleDays: Value(existing.revisionCycleDays),
      lastRevisedAt: Value(today),
      nextReviewDate: Value(nextReview),
      createdAt: Value(existing.createdAt),
      updatedAt: Value(DateTime.now()),
    ));
  }
}
