import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:quran_mobile/data/local/database/daos/user_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/schedule_dao.dart';
import 'package:quran_mobile/data/local/database/daos/goal_dao.dart';
import 'package:quran_mobile/data/local/database/daos/memorized_range_dao.dart';
import 'package:quran_mobile/data/local/database/daos/surah_dao.dart';
import 'package:quran_mobile/data/local/database/daos/juz_surah_range_dao.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

class BackupService {
  final AppDatabase _db;
  final UserDao _userDao;
  final StudentDao _studentDao;
  final SessionDao _sessionDao;
  final ScheduleDao _scheduleDao;
  final GoalDao _goalDao;
  final MemorizedRangeDao _memRangeDao;
  final SurahDao _surahDao;
  final JuzSurahRangeDao _juzRangeDao;

  BackupService({
    required AppDatabase db,
    required UserDao userDao,
    required StudentDao studentDao,
    required SessionDao sessionDao,
    required ScheduleDao scheduleDao,
    required GoalDao goalDao,
    required MemorizedRangeDao memRangeDao,
    required SurahDao surahDao,
    required JuzSurahRangeDao juzRangeDao,
  })  : _db = db,
        _userDao = userDao,
        _studentDao = studentDao,
        _sessionDao = sessionDao,
        _scheduleDao = scheduleDao,
        _goalDao = goalDao,
        _memRangeDao = memRangeDao,
        _surahDao = surahDao,
        _juzRangeDao = juzRangeDao;

  Future<void> backup(String filePath) async {
    final data = BackupData(
      users: await _userDao.getAll(),
      surahs: await _surahDao.getAll(),
      juzRanges: await _juzRangeDao.getAll(),
      students: await _studentDao.getAll(),
      sessions: await _sessionDao.getAll(),
      memorizations: await _getAllMemorizations(),
      revisions: await _getAllRevisions(),
      evaluations: await _getAllEvaluations(),
      schedules: await _scheduleDao.getUpcoming(),
      goals: await _goalDao.getAll(),
      memorizedRanges: await _memRangeDao.getByStudent(0),
    );

    final json = jsonEncode(data.toJson());
    final file = File(filePath);
    await file.writeAsString(json);
  }

  Future<void> restore(String filePath) async {
    final file = File(filePath);
    final json = await file.readAsString();
    final data = BackupData.fromJson(jsonDecode(json));

    // Clear all data (respect FK constraints - delete in reverse dependency order)
    await _db.delete(_db.pendingChanges).go();
    await _db.delete(_db.sessionEvaluations).go();
    await _db.delete(_db.sessionRevisions).go();
    await _db.delete(_db.sessionMemorizations).go();
    await _db.delete(_db.memorizedRanges).go();
    await _db.delete(_db.goals).go();
    await _db.delete(_db.schedules).go();
    await _db.delete(_db.sessions).go();
    await _db.delete(_db.students).go();
    await _db.delete(_db.juzSurahRanges).go();
    await _db.delete(_db.surahs).go();
    await _db.delete(_db.users).go();

    // Restore in order (respect FKs)
    for (final u in data.users) {
      await _db.into(_db.users).insert(UsersCompanion(
        id: Value(u.id),
        username: Value(u.username),
        passwordHash: Value(u.passwordHash),
        fullName: Value(u.fullName),
        role: Value(u.role),
        createdAt: Value(u.createdAt),
      ));
    }
    for (final s in data.surahs) {
      await _db.into(_db.surahs).insert(SurahsCompanion(
        id: Value(s.id),
        number: Value(s.number),
        name: Value(s.name),
        ayahCount: Value(s.ayahCount),
      ));
    }
    for (final r in data.juzRanges) {
      await _db.into(_db.juzSurahRanges).insert(JuzSurahRangesCompanion(
        id: Value(r.id),
        juzNumber: Value(r.juzNumber),
        surahId: Value(r.surahId),
        fromAyah: Value(r.fromAyah),
        toAyah: Value(r.toAyah),
      ));
    }
    for (final s in data.students) {
      await _db.into(_db.students).insert(StudentsCompanion(
        id: Value(s.id),
        fullName: Value(s.fullName),
        age: Value(s.age),
        phone: Value(s.phone),
        address: Value(s.address),
        parentName: Value(s.parentName),
        parentPhone: Value(s.parentPhone),
        currentSurahId: Value(s.currentSurahId),
        lastCompletedSurahId: Value(s.lastCompletedSurahId),
        totalCompletedJuz: Value(s.totalCompletedJuz),
        level: Value(s.level),
        createdAt: Value(s.createdAt),
      ));
    }
    for (final s in data.sessions) {
      await _db.into(_db.sessions).insert(SessionsCompanion(
        id: Value(s.id),
        studentId: Value(s.studentId),
        date: Value(s.date),
        time: Value(s.time),
        attendanceStatus: Value(s.attendanceStatus),
        notes: Value(s.notes),
        createdAt: Value(s.createdAt),
      ));
    }
    for (final m in data.memorizations) {
      await _db.into(_db.sessionMemorizations).insert(SessionMemorizationsCompanion(
        id: Value(m.id),
        sessionId: Value(m.sessionId),
        surahId: Value(m.surahId),
        fromAyah: Value(m.fromAyah),
        toAyah: Value(m.toAyah),
      ));
    }
    for (final r in data.revisions) {
      await _db.into(_db.sessionRevisions).insert(SessionRevisionsCompanion(
        id: Value(r.id),
        sessionId: Value(r.sessionId),
        surahId: Value(r.surahId),
        fromAyah: Value(r.fromAyah),
        toAyah: Value(r.toAyah),
      ));
    }
    for (final e in data.evaluations) {
      await _db.into(_db.sessionEvaluations).insert(SessionEvaluationsCompanion(
        id: Value(e.id),
        sessionId: Value(e.sessionId),
        memorizationScore: Value(e.memorizationScore),
        tajweedScore: Value(e.tajweedScore),
        fluencyScore: Value(e.fluencyScore),
        accuracyScore: Value(e.accuracyScore),
      ));
    }
    for (final s in data.schedules) {
      await _db.into(_db.schedules).insert(SchedulesCompanion(
        id: Value(s.id),
        studentId: Value(s.studentId),
        date: Value(s.date),
        time: Value(s.time),
        memorizationSurahId: Value(s.memorizationSurahId),
        memorizationFromAyah: Value(s.memorizationFromAyah),
        memorizationToAyah: Value(s.memorizationToAyah),
        revisionSurahId: Value(s.revisionSurahId),
        revisionFromAyah: Value(s.revisionFromAyah),
        revisionToAyah: Value(s.revisionToAyah),
        isCompleted: Value(s.isCompleted),
        createdAt: Value(s.createdAt),
      ));
    }
    for (final g in data.goals) {
      await _db.into(_db.goals).insert(GoalsCompanion(
        id: Value(g.id),
        studentId: Value(g.studentId),
        title: Value(g.title),
        goalType: Value(g.goalType),
        targetSurahId: Value(g.targetSurahId),
        targetJuzNumber: Value(g.targetJuzNumber),
        startDate: Value(g.startDate),
        targetDate: Value(g.targetDate),
        status: Value(g.status),
        createdAt: Value(g.createdAt),
      ));
    }
    for (final r in data.memorizedRanges) {
      await _db.into(_db.memorizedRanges).insert(MemorizedRangesCompanion(
        id: Value(r.id),
        studentId: Value(r.studentId),
        surahId: Value(r.surahId),
        fromAyah: Value(r.fromAyah),
        toAyah: Value(r.toAyah),
        status: Value(r.status),
        revisionCycleDays: Value(r.revisionCycleDays),
        lastRevisedAt: Value(r.lastRevisedAt),
        nextReviewDate: Value(r.nextReviewDate),
        createdAt: Value(r.createdAt),
        updatedAt: Value(r.updatedAt),
      ));
    }
  }

  Future<List<SessionMemorization>> _getAllMemorizations() async {
    final sessions = await _sessionDao.getAll();
    final result = <SessionMemorization>[];
    for (final s in sessions) {
      final mem = await _sessionDao.getMemorizationBySession(s.id);
      if (mem != null) result.add(mem);
    }
    return result;
  }

  Future<List<SessionRevision>> _getAllRevisions() async {
    final sessions = await _sessionDao.getAll();
    final result = <SessionRevision>[];
    for (final s in sessions) {
      final rev = await _sessionDao.getRevisionBySession(s.id);
      if (rev != null) result.add(rev);
    }
    return result;
  }

  Future<List<SessionEvaluation>> _getAllEvaluations() async {
    final sessions = await _sessionDao.getAll();
    final result = <SessionEvaluation>[];
    for (final s in sessions) {
      final eval = await _sessionDao.getEvaluationBySession(s.id);
      if (eval != null) result.add(eval);
    }
    return result;
  }
}

class BackupData {
  final List<User> users;
  final List<Surah> surahs;
  final List<JuzSurahRange> juzRanges;
  final List<Student> students;
  final List<Session> sessions;
  final List<SessionMemorization> memorizations;
  final List<SessionRevision> revisions;
  final List<SessionEvaluation> evaluations;
  final List<Schedule> schedules;
  final List<Goal> goals;
  final List<MemorizedRange> memorizedRanges;

  BackupData({
    required this.users,
    required this.surahs,
    required this.juzRanges,
    required this.students,
    required this.sessions,
    required this.memorizations,
    required this.revisions,
    required this.evaluations,
    required this.schedules,
    required this.goals,
    required this.memorizedRanges,
  });

  Map<String, dynamic> toJson() => {
        'users': users.map((e) => _userToJson(e)).toList(),
        'surahs': surahs.map((e) => _surahToJson(e)).toList(),
        'juzRanges': juzRanges.map((e) => _juzRangeToJson(e)).toList(),
        'students': students.map((e) => _studentToJson(e)).toList(),
        'sessions': sessions.map((e) => _sessionToJson(e)).toList(),
        'memorizations': memorizations.map((e) => _memorizationToJson(e)).toList(),
        'revisions': revisions.map((e) => _revisionToJson(e)).toList(),
        'evaluations': evaluations.map((e) => _evaluationToJson(e)).toList(),
        'schedules': schedules.map((e) => _scheduleToJson(e)).toList(),
        'goals': goals.map((e) => _goalToJson(e)).toList(),
        'memorizedRanges': memorizedRanges.map((e) => _memRangeToJson(e)).toList(),
      };

  factory BackupData.fromJson(Map<String, dynamic> json) => BackupData(
        users: (json['users'] as List).map((e) => _userFromJson(e)).toList(),
        surahs: (json['surahs'] as List).map((e) => _surahFromJson(e)).toList(),
        juzRanges:
            (json['juzRanges'] as List).map((e) => _juzRangeFromJson(e)).toList(),
        students:
            (json['students'] as List).map((e) => _studentFromJson(e)).toList(),
        sessions:
            (json['sessions'] as List).map((e) => _sessionFromJson(e)).toList(),
        memorizations: (json['memorizations'] as List)
            .map((e) => _memorizationFromJson(e))
            .toList(),
        revisions: (json['revisions'] as List)
            .map((e) => _revisionFromJson(e))
            .toList(),
        evaluations: (json['evaluations'] as List)
            .map((e) => _evaluationFromJson(e))
            .toList(),
        schedules:
            (json['schedules'] as List).map((e) => _scheduleFromJson(e)).toList(),
        goals: (json['goals'] as List).map((e) => _goalFromJson(e)).toList(),
        memorizedRanges: (json['memorizedRanges'] as List)
            .map((e) => _memRangeFromJson(e))
            .toList(),
      );

  // ---- Users ----
  static Map<String, dynamic> _userToJson(User e) => {
        'id': e.id,
        'username': e.username,
        'passwordHash': e.passwordHash,
        'fullName': e.fullName,
        'role': e.role,
        'createdAt': e.createdAt.toIso8601String(),
      };
  static User _userFromJson(Map<String, dynamic> m) => User(
        id: m['id'] as int,
        username: m['username'] as String,
        passwordHash: m['passwordHash'] as String,
        fullName: m['fullName'] as String,
        role: m['role'] as String,
        createdAt: DateTime.parse(m['createdAt'] as String),
      );

  // ---- Surahs ----
  static Map<String, dynamic> _surahToJson(Surah e) => {
        'id': e.id,
        'number': e.number,
        'name': e.name,
        'ayahCount': e.ayahCount,
      };
  static Surah _surahFromJson(Map<String, dynamic> m) => Surah(
        id: m['id'] as int,
        number: m['number'] as int,
        name: m['name'] as String,
        ayahCount: m['ayahCount'] as int,
      );

  // ---- JuzSurahRange ----
  static Map<String, dynamic> _juzRangeToJson(JuzSurahRange e) => {
        'id': e.id,
        'juzNumber': e.juzNumber,
        'surahId': e.surahId,
        'fromAyah': e.fromAyah,
        'toAyah': e.toAyah,
      };
  static JuzSurahRange _juzRangeFromJson(Map<String, dynamic> m) => JuzSurahRange(
        id: m['id'] as int,
        juzNumber: m['juzNumber'] as int,
        surahId: m['surahId'] as int,
        fromAyah: m['fromAyah'] as int,
        toAyah: m['toAyah'] as int,
      );

  // ---- Student ----
  static Map<String, dynamic> _studentToJson(Student e) => {
        'id': e.id,
        'fullName': e.fullName,
        'age': e.age,
        'phone': e.phone,
        'address': e.address,
        'parentName': e.parentName,
        'parentPhone': e.parentPhone,
        'currentSurahId': e.currentSurahId,
        'lastCompletedSurahId': e.lastCompletedSurahId,
        'totalCompletedJuz': e.totalCompletedJuz,
        'level': e.level,
        'createdAt': e.createdAt.toIso8601String(),
      };
  static Student _studentFromJson(Map<String, dynamic> m) => Student(
        id: m['id'] as int,
        fullName: m['fullName'] as String,
        age: m['age'] as int,
        phone: m['phone'] as String,
        address: m['address'] as String,
        parentName: m['parentName'] as String?,
        parentPhone: m['parentPhone'] as String?,
        currentSurahId: m['currentSurahId'] as int?,
        lastCompletedSurahId: m['lastCompletedSurahId'] as int?,
        totalCompletedJuz: m['totalCompletedJuz'] as int,
        level: m['level'] as String,
        createdAt: DateTime.parse(m['createdAt'] as String),
      );

  // ---- Session ----
  static Map<String, dynamic> _sessionToJson(Session e) => {
        'id': e.id,
        'studentId': e.studentId,
        'date': e.date.toIso8601String(),
        'time': e.time,
        'attendanceStatus': e.attendanceStatus,
        'notes': e.notes,
        'createdAt': e.createdAt.toIso8601String(),
      };
  static Session _sessionFromJson(Map<String, dynamic> m) => Session(
        id: m['id'] as int,
        studentId: m['studentId'] as int,
        date: DateTime.parse(m['date'] as String),
        time: m['time'] as String,
        attendanceStatus: m['attendanceStatus'] as String,
        notes: m['notes'] as String?,
        createdAt: DateTime.parse(m['createdAt'] as String),
      );

  // ---- SessionMemorization ----
  static Map<String, dynamic> _memorizationToJson(SessionMemorization e) => {
        'id': e.id,
        'sessionId': e.sessionId,
        'surahId': e.surahId,
        'fromAyah': e.fromAyah,
        'toAyah': e.toAyah,
      };
  static SessionMemorization _memorizationFromJson(Map<String, dynamic> m) =>
      SessionMemorization(
        id: m['id'] as int,
        sessionId: m['sessionId'] as int,
        surahId: m['surahId'] as int,
        fromAyah: m['fromAyah'] as int,
        toAyah: m['toAyah'] as int,
      );

  // ---- SessionRevision ----
  static Map<String, dynamic> _revisionToJson(SessionRevision e) => {
        'id': e.id,
        'sessionId': e.sessionId,
        'surahId': e.surahId,
        'fromAyah': e.fromAyah,
        'toAyah': e.toAyah,
      };
  static SessionRevision _revisionFromJson(Map<String, dynamic> m) =>
      SessionRevision(
        id: m['id'] as int,
        sessionId: m['sessionId'] as int,
        surahId: m['surahId'] as int,
        fromAyah: m['fromAyah'] as int,
        toAyah: m['toAyah'] as int,
      );

  // ---- SessionEvaluation ----
  static Map<String, dynamic> _evaluationToJson(SessionEvaluation e) => {
        'id': e.id,
        'sessionId': e.sessionId,
        'memorizationScore': e.memorizationScore,
        'tajweedScore': e.tajweedScore,
        'fluencyScore': e.fluencyScore,
        'accuracyScore': e.accuracyScore,
      };
  static SessionEvaluation _evaluationFromJson(Map<String, dynamic> m) =>
      SessionEvaluation(
        id: m['id'] as int,
        sessionId: m['sessionId'] as int,
        memorizationScore: (m['memorizationScore'] as num).toDouble(),
        tajweedScore: (m['tajweedScore'] as num).toDouble(),
        fluencyScore: (m['fluencyScore'] as num).toDouble(),
        accuracyScore: (m['accuracyScore'] as num).toDouble(),
      );

  // ---- Schedule ----
  static Map<String, dynamic> _scheduleToJson(Schedule e) => {
        'id': e.id,
        'studentId': e.studentId,
        'date': e.date.toIso8601String(),
        'time': e.time,
        'memorizationSurahId': e.memorizationSurahId,
        'memorizationFromAyah': e.memorizationFromAyah,
        'memorizationToAyah': e.memorizationToAyah,
        'revisionSurahId': e.revisionSurahId,
        'revisionFromAyah': e.revisionFromAyah,
        'revisionToAyah': e.revisionToAyah,
        'isCompleted': e.isCompleted,
        'createdAt': e.createdAt.toIso8601String(),
      };
  static Schedule _scheduleFromJson(Map<String, dynamic> m) => Schedule(
        id: m['id'] as int,
        studentId: m['studentId'] as int,
        date: DateTime.parse(m['date'] as String),
        time: m['time'] as String,
        memorizationSurahId: m['memorizationSurahId'] as int?,
        memorizationFromAyah: m['memorizationFromAyah'] as int?,
        memorizationToAyah: m['memorizationToAyah'] as int?,
        revisionSurahId: m['revisionSurahId'] as int?,
        revisionFromAyah: m['revisionFromAyah'] as int?,
        revisionToAyah: m['revisionToAyah'] as int?,
        isCompleted: m['isCompleted'] as bool,
        createdAt: DateTime.parse(m['createdAt'] as String),
      );

  // ---- Goal ----
  static Map<String, dynamic> _goalToJson(Goal e) => {
        'id': e.id,
        'studentId': e.studentId,
        'title': e.title,
        'goalType': e.goalType,
        'targetSurahId': e.targetSurahId,
        'targetJuzNumber': e.targetJuzNumber,
        'startDate': e.startDate.toIso8601String(),
        'targetDate': e.targetDate?.toIso8601String(),
        'status': e.status,
        'createdAt': e.createdAt.toIso8601String(),
      };
  static Goal _goalFromJson(Map<String, dynamic> m) => Goal(
        id: m['id'] as int,
        studentId: m['studentId'] as int,
        title: m['title'] as String,
        goalType: m['goalType'] as String,
        targetSurahId: m['targetSurahId'] as int?,
        targetJuzNumber: m['targetJuzNumber'] as int?,
        startDate: DateTime.parse(m['startDate'] as String),
        targetDate: m['targetDate'] != null
            ? DateTime.parse(m['targetDate'] as String)
            : null,
        status: m['status'] as String,
        createdAt: DateTime.parse(m['createdAt'] as String),
      );

  // ---- MemorizedRange ----
  static Map<String, dynamic> _memRangeToJson(MemorizedRange e) => {
        'id': e.id,
        'studentId': e.studentId,
        'surahId': e.surahId,
        'fromAyah': e.fromAyah,
        'toAyah': e.toAyah,
        'status': e.status,
        'revisionCycleDays': e.revisionCycleDays,
        'lastRevisedAt': e.lastRevisedAt?.toIso8601String(),
        'nextReviewDate': e.nextReviewDate?.toIso8601String(),
        'createdAt': e.createdAt.toIso8601String(),
        'updatedAt': e.updatedAt.toIso8601String(),
      };
  static MemorizedRange _memRangeFromJson(Map<String, dynamic> m) =>
      MemorizedRange(
        id: m['id'] as int,
        studentId: m['studentId'] as int,
        surahId: m['surahId'] as int,
        fromAyah: m['fromAyah'] as int,
        toAyah: m['toAyah'] as int,
        status: m['status'] as String,
        revisionCycleDays: m['revisionCycleDays'] as int,
        lastRevisedAt: m['lastRevisedAt'] != null
            ? DateTime.parse(m['lastRevisedAt'] as String)
            : null,
        nextReviewDate: m['nextReviewDate'] != null
            ? DateTime.parse(m['nextReviewDate'] as String)
            : null,
        createdAt: DateTime.parse(m['createdAt'] as String),
        updatedAt: DateTime.parse(m['updatedAt'] as String),
      );
}
