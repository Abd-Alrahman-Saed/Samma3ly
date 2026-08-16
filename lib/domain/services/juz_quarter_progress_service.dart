import 'package:quran_mobile/data/local/database/daos/juz_quarter_progress_dao.dart';

/// تتبّع الحفظ اليدوي بالجزء/الربع (القسم ح.2، docs/IMPLEMENTATION_PLAN.md).
/// المعلّم هو اللي يعلّم كل ربع لما يخلصه — لا حساب تلقائي من بيانات الجلسات.
class JuzQuarterProgressService {
  final JuzQuarterProgressDao _dao;

  JuzQuarterProgressService(this._dao);

  static const int juzCount = 30;
  static const int quartersPerJuz = 8;
  static const int totalQuarters = juzCount * quartersPerJuz;

  Future<Set<(int juz, int quarter)>> getCompleted(int studentId) => _dao.getCompletedByStudent(studentId);

  Future<void> setQuarterCompleted(int studentId, int juzNumber, int quarterIndex, bool completed) =>
      _dao.setQuarterCompleted(studentId, juzNumber, quarterIndex, completed);

  /// النسبة الكلية عبر كل الأجزاء الثلاثين (0..100).
  static double overallPercentage(Set<(int, int)> completed) => completed.length / totalQuarters * 100;

  /// عدد الأرباع المحفوظة داخل جزء واحد (0..8).
  static int completedQuartersInJuz(Set<(int, int)> completed, int juzNumber) =>
      completed.where((c) => c.$1 == juzNumber).length;

  /// نسبة جزء واحد (0..100)، بناءً على كام ربع من الثمانية محفوظ.
  static double juzPercentage(Set<(int, int)> completed, int juzNumber) =>
      completedQuartersInJuz(completed, juzNumber) / quartersPerJuz * 100;
}
