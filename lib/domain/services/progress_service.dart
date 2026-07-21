import 'package:drift/drift.dart';
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

    final allSessions = await _sessionDao.getAll(studentId: studentId);
    final presentSessions = allSessions.where((s) => s.attendanceStatus == 'حاضر').toList();

    final memorizations = <SessionMemorization>[];
    for (final s in presentSessions) {
      final mem = await _sessionDao.getMemorizationBySession(s.id);
      if (mem != null) memorizations.add(mem);
    }
    memorizations.sort((a, b) {
      final cmp = a.surahId.compareTo(b.surahId);
      return cmp != 0 ? cmp : a.fromAyah.compareTo(b.fromAyah);
    });

    int? currentSurahId = memorizations.isNotEmpty ? memorizations.first.surahId : null;
    int? lastCompletedSurahId = currentSurahId;

    for (final m in memorizations) {
      final surah = await _surahDao.getById(m.surahId);
      if (surah != null && m.toAyah >= surah.ayahCount) {
        lastCompletedSurahId = m.surahId;
      }
    }

    final completedJuz = await _calculateCompletedJuz(studentId);

    final totalSessions = presentSessions.length;
    final hasProgress = totalSessions > 0;
    final hasAdvanced = completedJuz >= 5;
    final distinctSurahs = memorizations.map((m) => m.surahId).toSet().length;
    final hasMultipleSurahs = distinctSurahs >= 3;

    String level;
    if (hasMultipleSurahs && hasAdvanced) {
      level = 'متقدم';
    } else if (hasProgress) {
      level = 'متوسط';
    } else {
      level = 'مبتدئ';
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

    final allSessions = await _sessionDao.getAll(studentId: studentId);
    final presentSessions = allSessions.where((s) => s.attendanceStatus == 'حاضر').toList();

    final memorizations = <SessionMemorization>[];
    for (final s in presentSessions) {
      final mem = await _sessionDao.getMemorizationBySession(s.id);
      if (mem != null) memorizations.add(mem);
    }

    for (final goal in goals) {
      if (goal.goalType == 'سورة' && goal.targetSurahId != null) {
        final surah = await _surahDao.getById(goal.targetSurahId!);
        if (surah == null) continue;

        final mems = memorizations.where((m) => m.surahId == goal.targetSurahId).toList();
        final totalAyahs = mems.fold<int>(0, (sum, m) => sum + (m.toAyah - m.fromAyah + 1));
        final targetAyahs = surah.ayahCount;

        String status;
        if (totalAyahs <= 0) {
          status = 'لم يبدأ';
        } else if (totalAyahs >= targetAyahs) {
          status = 'مكتمل';
        } else {
          status = 'قيد التنفيذ';
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
      } else if (goal.goalType == 'جزء' && goal.targetJuzNumber != null) {
        final ranges = await _juzRangeDao.getByJuzNumber(goal.targetJuzNumber!);
        final totalTargetAyahs = ranges.fold<int>(0, (sum, r) => sum + (r.toAyah - r.fromAyah + 1));

        int doneAyahs = 0;
        for (final r in ranges) {
          doneAyahs += memorizations
              .where((m) =>
                  m.surahId == r.surahId &&
                  m.fromAyah >= r.fromAyah &&
                  m.toAyah <= r.toAyah)
              .fold<int>(0, (sum, m) => sum + (m.toAyah - m.fromAyah + 1));
        }

        String status;
        if (doneAyahs <= 0) {
          status = 'لم يبدأ';
        } else if (doneAyahs >= totalTargetAyahs) {
          status = 'مكتمل';
        } else {
          status = 'قيد التنفيذ';
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

  Future<int> _calculateCompletedJuz(int studentId) async {
    final allSessions = await _sessionDao.getAll(studentId: studentId);
    final presentSessions = allSessions.where((s) => s.attendanceStatus == 'حاضر').toList();

    final memorizations = <SessionMemorization>[];
    for (final s in presentSessions) {
      final mem = await _sessionDao.getMemorizationBySession(s.id);
      if (mem != null) memorizations.add(mem);
    }

    final juzRanges = await _juzRangeDao.getAll();
    final juzGroups = <int, List<JuzSurahRange>>{};
    for (final r in juzRanges) {
      juzGroups.putIfAbsent(r.juzNumber, () => []).add(r);
    }

    int completedJuz = 0;
    for (final entry in juzGroups.entries) {
      bool juzComplete = true;
      for (final range in entry.value) {
        final ayahCount = memorizations
            .where((m) =>
                m.surahId == range.surahId &&
                m.fromAyah >= range.fromAyah &&
                m.toAyah <= range.toAyah)
            .fold<int>(0, (sum, m) => sum + (m.toAyah - m.fromAyah + 1));

        final targetCount = range.toAyah - range.fromAyah + 1;
        if (ayahCount < targetCount) {
          juzComplete = false;
          break;
        }
      }
      if (juzComplete) completedJuz++;
    }

    return completedJuz;
  }
}
