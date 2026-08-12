import 'package:drift/drift.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/core/enums/goal_status.dart';
import 'package:quran_mobile/core/enums/goal_type.dart';
import 'package:quran_mobile/core/enums/student_level.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/data/local/database/daos/goal_dao.dart';
import 'package:quran_mobile/data/local/database/daos/juz_surah_range_dao.dart';
import 'package:quran_mobile/data/local/database/daos/surah_dao.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

class ProgressService {
  final StudentDao _studentDao;
  final SessionDao _sessionDao;
  final GoalDao _goalDao;
  final JuzSurahRangeDao _juzRangeDao;
  final SurahDao _surahDao;

  ProgressService({
    required StudentDao studentDao,
    required SessionDao sessionDao,
    required GoalDao goalDao,
    required JuzSurahRangeDao juzRangeDao,
    required SurahDao surahDao,
  })  : _studentDao = studentDao,
        _sessionDao = sessionDao,
        _goalDao = goalDao,
        _juzRangeDao = juzRangeDao,
        _surahDao = surahDao;

  Future<void> syncStudentProgress(int studentId) async {
    final student = await _studentDao.getById(studentId);
    if (student == null) return;

    // Attendance moved off Sessions in v4 (Sprint 2) — count via
    // SessionAttendances directly instead of filtering raw Session rows.
    final presentSessionsCount = await _sessionDao.countByStudentAndAttendance(
      studentId,
      AttendanceStatus.present.arabic,
    );

    // Single joined query instead of one getMemorizationBySession() call per
    // session (Sprint 0, item 0.5 — was the main N+1 offender here).
    final memorizations = await _sessionDao.getMemorizationsForStudent(
      studentId,
      attendanceStatus: AttendanceStatus.present.arabic,
    );
    final sortedMemorizations = [...memorizations]..sort((a, b) {
        final cmp = a.surahId.compareTo(b.surahId);
        return cmp != 0 ? cmp : a.fromAyah.compareTo(b.fromAyah);
      });

    int? currentSurahId = sortedMemorizations.isNotEmpty ? sortedMemorizations.first.surahId : null;
    int? lastCompletedSurahId = currentSurahId;

    // Batch-fetch every surah once instead of one surahDao.getById() call
    // per memorization row (the surahs table is a tiny, static 114-row
    // reference table — safe to load in full).
    final surahById = {for (final s in await _surahDao.getAll()) s.id: s};
    for (final m in sortedMemorizations) {
      final surah = surahById[m.surahId];
      if (surah != null && m.toAyah >= surah.ayahCount) {
        lastCompletedSurahId = m.surahId;
      }
    }

    final completedJuz = await _calculateCompletedJuz(memorizations);

    final totalSessions = presentSessionsCount;
    final hasProgress = totalSessions > 0;
    final hasAdvanced = completedJuz >= 5;
    final distinctSurahs = memorizations.map((m) => m.surahId).toSet().length;
    final hasMultipleSurahs = distinctSurahs >= 3;

    String level;
    if (hasMultipleSurahs && hasAdvanced) {
      level = StudentLevel.advanced.arabic;
    } else if (hasProgress) {
      level = StudentLevel.intermediate.arabic;
    } else {
      level = StudentLevel.beginner.arabic;
    }

    await _studentDao.updateEntry(StudentsCompanion(
      id: Value(student.id),
      fullName: Value(student.fullName),
      age: Value(student.age),
      phone: Value(student.phone),
      address: Value(student.address),
      parentName: Value(student.parentName),
      parentPhone: Value(student.parentPhone),
      currentSurahId: Value(currentSurahId),
      lastCompletedSurahId: Value(lastCompletedSurahId),
      totalCompletedJuz: Value(completedJuz),
      level: Value(level),
      createdAt: Value(student.createdAt),
    ));
  }

  Future<void> syncGoalProgress(int studentId) async {
    final goals = await _goalDao.getByStudent(studentId);
    if (goals.isEmpty) return;

    final memorizations = await _sessionDao.getMemorizationsForStudent(
      studentId,
      attendanceStatus: AttendanceStatus.present.arabic,
    );

    for (final goal in goals) {
      if (goal.goalType == GoalType.surah.arabic && goal.targetSurahId != null) {
        final surah = await _surahDao.getById(goal.targetSurahId!);
        if (surah == null) continue;

        final intervals =
            memorizations.where((m) => m.surahId == goal.targetSurahId).map((m) => (m.fromAyah, m.toAyah));
        final totalAyahs = _coveredAyahsWithin(intervals, 1, surah.ayahCount);
        final targetAyahs = surah.ayahCount;

        String status;
        if (totalAyahs <= 0) {
          status = GoalStatus.notStarted.arabic;
        } else if (totalAyahs >= targetAyahs) {
          status = GoalStatus.completed.arabic;
        } else {
          status = GoalStatus.inProgress.arabic;
        }

        await _goalDao.updateEntry(GoalsCompanion(
          id: Value(goal.id),
          studentId: Value(goal.studentId),
          title: Value(goal.title),
          goalType: Value(goal.goalType),
          targetSurahId: Value(goal.targetSurahId),
          targetJuzNumber: Value(goal.targetJuzNumber),
          startDate: Value(goal.startDate),
          targetDate: Value(goal.targetDate),
          status: Value(status),
          createdAt: Value(goal.createdAt),
        ));
      } else if (goal.goalType == GoalType.juz.arabic && goal.targetJuzNumber != null) {
        final ranges = await _juzRangeDao.getByJuzNumber(goal.targetJuzNumber!);
        final totalTargetAyahs = ranges.fold<int>(0, (sum, r) => sum + (r.toAyah - r.fromAyah + 1));

        int doneAyahs = 0;
        for (final r in ranges) {
          final intervals = memorizations.where((m) => m.surahId == r.surahId).map((m) => (m.fromAyah, m.toAyah));
          doneAyahs += _coveredAyahsWithin(intervals, r.fromAyah, r.toAyah);
        }

        String status;
        if (doneAyahs <= 0) {
          status = GoalStatus.notStarted.arabic;
        } else if (doneAyahs >= totalTargetAyahs) {
          status = GoalStatus.completed.arabic;
        } else {
          status = GoalStatus.inProgress.arabic;
        }

        await _goalDao.updateEntry(GoalsCompanion(
          id: Value(goal.id),
          studentId: Value(goal.studentId),
          title: Value(goal.title),
          goalType: Value(goal.goalType),
          targetSurahId: Value(goal.targetSurahId),
          targetJuzNumber: Value(goal.targetJuzNumber),
          startDate: Value(goal.startDate),
          targetDate: Value(goal.targetDate),
          status: Value(status),
          createdAt: Value(goal.createdAt),
        ));
      }
    }
  }

  Future<int> _calculateCompletedJuz(List<SessionMemorization> memorizations) async {
    final juzRanges = await _juzRangeDao.getAll();
    final juzGroups = <int, List<JuzSurahRange>>{};
    for (final r in juzRanges) {
      juzGroups.putIfAbsent(r.juzNumber, () => []).add(r);
    }

    int completedJuz = 0;
    for (final entry in juzGroups.entries) {
      bool juzComplete = true;
      for (final range in entry.value) {
        final intervals =
            memorizations.where((m) => m.surahId == range.surahId).map((m) => (m.fromAyah, m.toAyah));
        final covered = _coveredAyahsWithin(intervals, range.fromAyah, range.toAyah);

        final targetCount = range.toAyah - range.fromAyah + 1;
        if (covered < targetCount) {
          juzComplete = false;
          break;
        }
      }
      if (juzComplete) completedJuz++;
    }

    return completedJuz;
  }

  /// How many DISTINCT ayahs within [rangeFrom]..[rangeTo] are covered by
  /// [memorized] intervals (Sprint 0, item 0.4).
  ///
  /// Replaces the old "containment filter + naive sum" logic, which had two
  /// bugs: a recitation crossing the range boundary contributed nothing at
  /// all (containment, not intersection), and overlapping/duplicate
  /// recitations were summed rather than unioned, inflating the count.
  ///
  /// Each interval is first clipped to the target range (intersection),
  /// then overlapping/adjacent clipped intervals are merged before summing
  /// — so neither boundary-crossing recitations nor duplicates skew the
  /// result.
  static int _coveredAyahsWithin(Iterable<(int from, int to)> memorized, int rangeFrom, int rangeTo) {
    final clipped = <(int, int)>[];
    for (final (from, to) in memorized) {
      final clippedFrom = from > rangeFrom ? from : rangeFrom;
      final clippedTo = to < rangeTo ? to : rangeTo;
      if (clippedFrom <= clippedTo) clipped.add((clippedFrom, clippedTo));
    }
    if (clipped.isEmpty) return 0;

    clipped.sort((a, b) => a.$1.compareTo(b.$1));
    var total = 0;
    var curFrom = clipped.first.$1;
    var curTo = clipped.first.$2;
    for (final (from, to) in clipped.skip(1)) {
      if (from <= curTo + 1) {
        if (to > curTo) curTo = to;
      } else {
        total += curTo - curFrom + 1;
        curFrom = from;
        curTo = to;
      }
    }
    total += curTo - curFrom + 1;
    return total;
  }
}
