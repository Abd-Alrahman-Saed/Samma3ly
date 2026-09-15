import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/juz_quarter_progress_table.dart';

part 'juz_quarter_progress_dao.g.dart';

@DriftAccessor(tables: [JuzQuarterProgress])
class JuzQuarterProgressDao extends DatabaseAccessor<AppDatabase> with _$JuzQuarterProgressDaoMixin {
  JuzQuarterProgressDao(super.db);

  /// كل الأرباع المحفوظة لطالب، كأزواج (رقم الجزء، رقم الربع).
  Future<Set<(int juz, int quarter)>> getCompletedByStudent(int studentId) async {
    final rows = await (select(juzQuarterProgress)..where((t) => t.studentId.equals(studentId))).get();
    return {for (final r in rows) (r.juzNumber, r.quarterIndex)};
  }

  /// وجود الصفّ = محفوظ؛ تعليمه "غير محفوظ" يحذف الصفّ بدل تحديث علم
  /// (انظر تعليق الجدول). عملية idempotent: تكرار نفس التعليم لا يضيف شيئاً.
  Future<void> setQuarterCompleted(int studentId, int juzNumber, int quarterIndex, bool completed) async {
    final existing = await (select(juzQuarterProgress)
          ..where((t) =>
              t.studentId.equals(studentId) & t.juzNumber.equals(juzNumber) & t.quarterIndex.equals(quarterIndex)))
        .getSingleOrNull();

    if (completed) {
      if (existing == null) {
        await into(juzQuarterProgress).insert(JuzQuarterProgressCompanion.insert(
          studentId: studentId,
          juzNumber: juzNumber,
          quarterIndex: quarterIndex,
        ));
      }
    } else if (existing != null) {
      await (delete(juzQuarterProgress)..where((t) => t.id.equals(existing.id))).go();
    }
  }
}
