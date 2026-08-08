import 'package:drift/drift.dart';
import 'package:quran_mobile/core/enums/memorized_status.dart';
import 'package:quran_mobile/data/local/database/daos/memorized_range_dao.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

class MemorizedRangeService {
  final MemorizedRangeDao _dao;

  MemorizedRangeService(this._dao);

  Future<List<MemorizedRange>> getByStudent(int studentId) async {
    final ranges = await _dao.getByStudent(studentId);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    return ranges.map((r) => _withEffectiveStatus(r, todayDate)).toList();
  }

  /// "يحتاج مراجعة" is derived from `nextReviewDate`, not stored — a getter
  /// must never write to the database (Sprint 0, item 0.6). This computes
  /// the same apparent status the old code used to persist, without any
  /// side effect: reading a student's ranges twice in a row no longer
  /// issues surprise UPDATE statements, breaks `watch()` streams, or causes
  /// UI flicker.
  MemorizedRange _withEffectiveStatus(MemorizedRange r, DateTime today) {
    final isDueForRevision = r.status == MemorizedStatus.memorized.arabic &&
        r.nextReviewDate != null &&
        !r.nextReviewDate!.isAfter(today);
    if (!isDueForRevision) return r;
    return r.copyWith(status: MemorizedStatus.needsRevision.arabic);
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
      status: Value(MemorizedStatus.memorized.arabic),
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
      status: Value(MemorizedStatus.memorized.arabic),
      revisionCycleDays: Value(existing.revisionCycleDays),
      lastRevisedAt: Value(today),
      nextReviewDate: Value(nextReview),
      createdAt: Value(existing.createdAt),
      updatedAt: Value(DateTime.now()),
    ));
  }
}
