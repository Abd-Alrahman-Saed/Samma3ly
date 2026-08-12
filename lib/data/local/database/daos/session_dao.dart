import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sessions_table.dart';
import '../tables/session_memorizations_table.dart';
import '../tables/session_revisions_table.dart';
import '../tables/session_evaluations_table.dart';
import '../tables/session_attendances_table.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions, SessionMemorizations, SessionRevisions, SessionEvaluations, SessionAttendances])
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  SessionDao(AppDatabase db) : super(db);

  Future<List<Session>> getAll({int? studentId, DateTime? from, DateTime? to}) {
    var query = select(sessions)..orderBy([(t) => OrderingTerm.desc(t.date)]);
    if (studentId != null) query.where((t) => t.studentId.equals(studentId));
    if (from != null) query.where((t) => t.date.isBiggerOrEqualValue(from));
    if (to != null) query.where((t) => t.date.isSmallerOrEqualValue(to));
    return query.get();
  }

  Future<Session?> getById(int id) => (select(sessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insert(SessionsCompanion entry) => into(sessions).insert(entry);

  Future<bool> updateEntry(SessionsCompanion entry) => update(sessions).replace(entry);

  Future<int> deleteById(int id) => (delete(sessions)..where((t) => t.id.equals(id))).go();

  Future<int> countByDate(DateTime date) =>
      (select(sessions)..where((t) => t.date.equals(date))).get().then((list) => list.length);

  Future<List<Session>> getByDateRange(DateTime from, DateTime to) {
    return (select(sessions)
      ..where((t) => t.date.isBiggerOrEqualValue(from) & t.date.isSmallerOrEqualValue(to))
      ..orderBy([(t) => OrderingTerm.asc(t.date)])
    ).get();
  }

  /// Count of [studentId]'s sessions whose attendance (in
  /// `SessionAttendances`, since v4/Sprint 2) matches [attendanceStatus].
  Future<int> countByStudentAndAttendance(int studentId, String attendanceStatus) {
    final query = select(sessions).join([
      innerJoin(
        sessionAttendances,
        sessionAttendances.sessionId.equalsExp(sessions.id) & sessionAttendances.studentId.equals(studentId),
      ),
    ])
      ..where(sessions.studentId.equals(studentId))
      ..where(sessionAttendances.attendanceStatus.equals(attendanceStatus));
    return query.get().then((rows) => rows.length);
  }

  // Memorization
  Future<SessionMemorization?> getMemorizationBySession(int sessionId) =>
      (select(sessionMemorizations)..where((t) => t.sessionId.equals(sessionId))).getSingleOrNull();

  Future<int> insertMemorization(SessionMemorizationsCompanion entry) =>
      into(sessionMemorizations).insert(entry);

  Future<bool> updateMemorization(SessionMemorizationsCompanion entry) =>
      update(sessionMemorizations).replace(entry);

  Future<int> deleteMemorization(int sessionId) =>
      (delete(sessionMemorizations)..where((t) => t.sessionId.equals(sessionId))).go();

  Future<List<SessionMemorization>> getAllMemorizationsForStudent(int studentId) async {
    final sessionsList = await (select(sessions)..where((t) => t.studentId.equals(studentId))).get();
    final ids = sessionsList.map((s) => s.id).toList();
    if (ids.isEmpty) return [];
    return (select(sessionMemorizations)..where((t) => t.sessionId.isIn(ids))).get();
  }

  /// Same result as calling [getAll] + [getMemorizationBySession] per
  /// session, but as a single joined query — avoids the N+1 pattern that
  /// used to live in `ProgressService` (Sprint 0, item 0.5).
  ///
  /// Pass [attendanceStatus] to filter sessions by attendance (e.g. only
  /// present sessions), matching what `ProgressService` needs. Since v4
  /// (Sprint 2), attendance lives in `SessionAttendances` — filtered here
  /// via `(sessionId, studentId)` so a group session's other attendees
  /// can't leak into this student's filter.
  Future<List<SessionMemorization>> getMemorizationsForStudent(
    int studentId, {
    String? attendanceStatus,
  }) {
    final query = select(sessionMemorizations).join([
      innerJoin(sessions, sessions.id.equalsExp(sessionMemorizations.sessionId)),
      if (attendanceStatus != null)
        innerJoin(
          sessionAttendances,
          sessionAttendances.sessionId.equalsExp(sessions.id) & sessionAttendances.studentId.equals(studentId),
        ),
    ]);
    query.where(sessions.studentId.equals(studentId));
    if (attendanceStatus != null) {
      query.where(sessionAttendances.attendanceStatus.equals(attendanceStatus));
    }
    return query.map((row) => row.readTable(sessionMemorizations)).get();
  }

  // Attendance (SessionAttendances) — one row per (session, student).
  // Sprint 2 (v4): moved off Sessions.attendanceStatus so a group session
  // can carry an independent status per attendee.
  Future<SessionAttendance?> getAttendance(int sessionId, int studentId) =>
      (select(sessionAttendances)
            ..where((t) => t.sessionId.equals(sessionId) & t.studentId.equals(studentId)))
          .getSingleOrNull();

  Future<List<SessionAttendance>> getAttendancesForSession(int sessionId) =>
      (select(sessionAttendances)..where((t) => t.sessionId.equals(sessionId))).get();

  /// All attendance rows — used by [BackupService] to round-trip attendance
  /// data (Sessions no longer carries it directly).
  Future<List<SessionAttendance>> getAllAttendances() => select(sessionAttendances).get();

  Future<int> insertAttendance(SessionAttendancesCompanion entry) =>
      into(sessionAttendances).insert(entry);

  Future<bool> updateAttendance(SessionAttendancesCompanion entry) =>
      update(sessionAttendances).replace(entry);

  Future<void> upsertAttendance(int sessionId, int studentId, String attendanceStatus) async {
    final existing = await getAttendance(sessionId, studentId);
    if (existing != null) {
      await updateAttendance(SessionAttendancesCompanion(
        id: Value(existing.id),
        sessionId: Value(sessionId),
        studentId: Value(studentId),
        attendanceStatus: Value(attendanceStatus),
        createdAt: Value(existing.createdAt),
      ));
    } else {
      await insertAttendance(SessionAttendancesCompanion.insert(
        sessionId: sessionId,
        studentId: studentId,
        attendanceStatus: Value(attendanceStatus),
      ));
    }
  }

  // Revision
  Future<SessionRevision?> getRevisionBySession(int sessionId) =>
      (select(sessionRevisions)..where((t) => t.sessionId.equals(sessionId))).getSingleOrNull();

  Future<int> insertRevision(SessionRevisionsCompanion entry) =>
      into(sessionRevisions).insert(entry);

  Future<bool> updateRevision(SessionRevisionsCompanion entry) =>
      update(sessionRevisions).replace(entry);

  Future<int> deleteRevision(int sessionId) =>
      (delete(sessionRevisions)..where((t) => t.sessionId.equals(sessionId))).go();

  // Evaluation
  Future<SessionEvaluation?> getEvaluationBySession(int sessionId) =>
      (select(sessionEvaluations)..where((t) => t.sessionId.equals(sessionId))).getSingleOrNull();

  Future<int> insertEvaluation(SessionEvaluationsCompanion entry) =>
      into(sessionEvaluations).insert(entry);

  Future<bool> updateEvaluation(SessionEvaluationsCompanion entry) =>
      update(sessionEvaluations).replace(entry);

  Future<int> deleteEvaluation(int sessionId) =>
      (delete(sessionEvaluations)..where((t) => t.sessionId.equals(sessionId))).go();

  // Upsert helpers (insert or update)
  Future<void> upsertMemorization(SessionMemorizationsCompanion entry) async {
    final existing = await getMemorizationBySession(entry.sessionId.value);
    if (existing != null) {
      await updateMemorization(entry.copyWith(id: Value(existing.id)));
    } else {
      await insertMemorization(entry);
    }
  }

  Future<void> upsertRevision(SessionRevisionsCompanion entry) async {
    final existing = await getRevisionBySession(entry.sessionId.value);
    if (existing != null) {
      await updateRevision(entry.copyWith(id: Value(existing.id)));
    } else {
      await insertRevision(entry);
    }
  }

  Future<void> upsertEvaluation(SessionEvaluationsCompanion entry) async {
    final existing = await getEvaluationBySession(entry.sessionId.value);
    if (existing != null) {
      await updateEvaluation(entry.copyWith(id: Value(existing.id)));
    } else {
      await insertEvaluation(entry);
    }
  }
}
