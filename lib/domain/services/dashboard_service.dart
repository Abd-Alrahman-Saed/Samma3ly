import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/core/enums/user_role.dart';
import 'package:quran_mobile/domain/entities/dashboard_data.dart';
import 'package:quran_mobile/domain/services/weekly_calendar_service.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/user_dao.dart';

class DashboardService {
  final StudentDao _studentDao;
  final SessionDao _sessionDao;
  final UserDao _userDao;
  final WeeklyCalendarService _weeklyCalendarService;

  DashboardService({
    required StudentDao studentDao,
    required SessionDao sessionDao,
    required UserDao userDao,
    required WeeklyCalendarService weeklyCalendarService,
  })  : _studentDao = studentDao,
        _sessionDao = sessionDao,
        _userDao = userDao,
        _weeklyCalendarService = weeklyCalendarService;

  Future<DashboardData> getDashboardData() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final totalStudents = await _studentDao.count();
    final todaySessions = await _sessionDao.countByDate(today);

    // القسم ح.3 — "الجلسات القادمة" كانت تعدّ جدولات فردية فقط (Schedules)
    // بلا حدّ زمني (كل المستقبل). المطلوب الآن: عدد الجلسات (فردية + مواعيد
    // الحلقات المتكرّرة) خلال الأسبوع القادم فقط — بإعادة استخدام نفس
    // WeeklyCalendarService اللي بيغذّي شاشة "التقويم الأسبوعي" (بند 3.6)،
    // فالعدد هنا يطابق حرفياً ما سيراه المعلّم لو ضغط على البطاقة. resolver
    // مواقيت الصلاة غير لازم هنا — بيغيّر توقيت العرض فقط، لا وجود/عدد
    // المواعيد نفسها.
    final weekEntries = await _weeklyCalendarService.getEntries(
      from: today,
      to: today.add(const Duration(days: 7)),
    );
    final upcomingSessions = weekEntries.length;

    final allSessions = await _sessionDao.getAll();
    final allSessionsCount = allSessions.length;

    // Attendance moved off Sessions in v4 (Sprint 2) — fetch every
    // attendance row once and look sessions up in memory (an individual
    // session has exactly one row) rather than querying per-session,
    // matching the no-N+1 discipline established in Sprint 0 (0.5/0.6).
    final attendanceBySessionId = <int, String>{
      for (final a in await _sessionDao.getAllAttendances()) a.sessionId: a.attendanceStatus,
    };
    bool isPresent(dynamic s) => attendanceBySessionId[s.id] == AttendanceStatus.present.arabic;

    final presentSessions = allSessions.where(isPresent).length;
    final avgAttendance = allSessionsCount > 0
        ? (presentSessions / allSessionsCount * 100).toStringAsFixed(1)
        : '0.0';

    // Pages memorized (total ayahs / 20)
    int totalAyahs = 0;
    for (final s in allSessions) {
      if (isPresent(s)) {
        final mem = await _sessionDao.getMemorizationBySession(s.id);
        if (mem != null) {
          totalAyahs += (mem.toAyah - mem.fromAyah + 1);
        }
      }
    }
    final totalPagesMemorized = totalAyahs ~/ 20;

    final totalSurahsCompleted = await _studentDao.countWithCompletedSurah();
    final totalTeachers = await _userDao.countByRole(UserRole.admin.value) +
        await _userDao.countByRole(UserRole.teacher.value);

    // Top 5 students by average evaluation score
    final studentScores = <int, List<double>>{};
    for (final s in allSessions) {
      if (isPresent(s) && s.studentId != null) {
        final eval = await _sessionDao.getEvaluationBySession(s.id);
        if (eval != null) {
          final score =
              (eval.memorizationScore + eval.tajweedScore + eval.fluencyScore) /
                  3;
          studentScores.putIfAbsent(s.studentId as int, () => []).add(score);
        }
      }
    }
    final avgScores =
        studentScores.map((k, v) => MapEntry(k, v.reduce((a, b) => a + b) / v.length));
    final topStudentIds = avgScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topStudentEntries = topStudentIds.take(5).toList();

    final topStudents = <DashboardTopStudent>[];
    for (final entry in topStudentEntries) {
      final student = await _studentDao.getById(entry.key);
      if (student != null) {
        topStudents.add(DashboardTopStudent(
          studentId: student.id,
          studentName: student.fullName,
          averageScore: double.parse(entry.value.toStringAsFixed(1)),
        ));
      }
    }

    // Weekly attendance (last 7 days)
    final weekStart = today.subtract(const Duration(days: 6));
    final weeklyStats = await _sessionDao.getByDateRange(weekStart, today);

    final weeklyAttendance = <WeeklyAttendanceData>[];
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final daySessions = weeklyStats.where((s) =>
          s.date.year == day.year &&
          s.date.month == day.month &&
          s.date.day == day.day).toList();
      final present = daySessions.where(isPresent).length;
      final total = daySessions.length;
      final pct =
          total > 0 ? double.parse((present / total * 100).toStringAsFixed(1)) : 0.0;
      weeklyAttendance.add(WeeklyAttendanceData(date: day, percent: pct));
    }

    return DashboardData(
      totalStudents: totalStudents,
      todaySessions: todaySessions,
      upcomingSessions: upcomingSessions,
      averageAttendance: double.parse(avgAttendance),
      totalPagesMemorized: totalPagesMemorized,
      totalSurahsCompleted: totalSurahsCompleted,
      totalSessionsEver: allSessionsCount,
      totalTeachers: totalTeachers,
      topStudents: topStudents,
      weeklyAttendance: weeklyAttendance,
    );
  }
}
