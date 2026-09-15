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
  SessionDao(super.db);

  Future<List<Session>> getAll({int? studentId, DateTime? from, DateTime? to}) {
    var query = select(sessions)..orderBy([(t) => OrderingTerm.desc(t.date)]);
    if (studentId != null) query.where((t) => t.studentId.equals(studentId));
    if (from != null) query.where((t) => t.date.isBiggerOrEqualValue(from));
    if (to != null) query.where((t) => t.date.isSmallerOrEqualValue(to));
    return query.get();
  }

  /// القسم ح.10 — جلسات الحلقات (`sessionType == 'جماعي'`) اللي حضرها
  /// [studentId] فعلاً (له صفّ `SessionAttendances`)، مع صفّ الحضور نفسه —
  /// المصدر الوحيد لتسميع هذا الطالب داخل جلسة جماعية (راجع تعليق v5 على
  /// `SessionAttendances`). يُستخدَم في `SessionRepositoryImpl.getAll()`
  /// لدمج مشاركات الحلقات ضمن "جلسات الطالب" العادية.
  Future<List<(Session session, SessionAttendance attendance)>> getGroupSessionsForStudent(
    int studentId, {
    DateTime? from,
    DateTime? to,
  }) {
    final query = select(sessions).join([
      innerJoin(
        sessionAttendances,
        sessionAttendances.sessionId.equalsExp(sessions.id) & sessionAttendances.studentId.equals(studentId),
      ),
    ])
      ..where(sessions.sessionType.equals('جماعي'));
    if (from != null) query.where(sessions.date.isBiggerOrEqualValue(from));
    if (to != null) query.where(sessions.date.isSmallerOrEqualValue(to));
    return query.get().then((rows) => [
          for (final r in rows) (r.readTable(sessions), r.readTable(sessionAttendances)),
        ]);
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

  /// The already-materialized session for one recurring occurrence, if any
  /// — used by materialize-on-write (item 2.7) to check before inserting,
  /// so re-opening the same occurrence twice never creates a duplicate row.
  Future<Session?> getByGroupAndOccurrenceDate(int groupId, DateTime occurrenceDate) =>
      (select(sessions)
            ..where((t) => t.groupId.equals(groupId) & t.occurrenceDate.equals(occurrenceDate)))
          .getSingleOrNull();

  /// Batch variant of [getByGroupAndOccurrenceDate] — one query for every
  /// materialized session of a group in a date range, instead of one query
  /// per occurrence (N+1 avoidance, Sprint 0 item 0.5). Used to tell which
  /// of a group's *virtual* recurring occurrences already have a real row.
  Future<List<Session>> getMaterializedByGroup(int groupId, DateTime from, DateTime to) {
    return (select(sessions)
      ..where((t) =>
          t.groupId.equals(groupId) &
          t.occurrenceDate.isNotNull() &
          t.occurrenceDate.isBiggerOrEqualValue(from) &
          t.occurrenceDate.isSmallerOrEqualValue(to))
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

  /// Sets [attendanceStatus] for every one of [studentIds] in one
  /// transaction — item 3.2's "تحضير الكل" (mark-all) button. One DB round
  /// trip per student is still N queries, but wrapping them in a single
  /// transaction avoids N separate disk syncs, which is what actually
  /// matters for the "<30s for 20 students" exit gate (mostly human tap
  /// time, but this keeps the write itself instant).
  Future<void> markAllAttendance(int sessionId, List<int> studentIds, String attendanceStatus) async {
    await transaction(() async {
      for (final studentId in studentIds) {
        await upsertAttendance(sessionId, studentId, attendanceStatus);
      }
    });
  }

  /// Item 3.4 — per-student recitation fields (memorization/revision/
  /// evaluation) inside `session_attendances`, added in v5. [entry] must
  /// set `sessionId`/`studentId`; any recitation field left absent is
  /// simply not touched. Never overwrites `attendanceStatus`, `id`, or
  /// `createdAt` — those stay [upsertAttendance]'s and the original
  /// insert's job respectively, so autosaving recitation fields can never
  /// accidentally revert an attendance mark or reset the row's identity.
  Future<void> upsertRecitation(SessionAttendancesCompanion entry) async {
    final sessionId = entry.sessionId.value;
    final studentId = entry.studentId.value;
    final existing = await getAttendance(sessionId, studentId);
    if (existing != null) {
      await updateAttendance(entry.copyWith(
        id: Value(existing.id),
        attendanceStatus: Value(existing.attendanceStatus),
        createdAt: Value(existing.createdAt),
      ));
    } else {
      await insertAttendance(entry);
    }
  }

  // Revision
  // القسم ح.14 (v10): مراجعات متعددة لكل جلسة — كل الاستعلامات هنا بقت
  // تتعامل مع قائمة بدل صفّ واحد.
  Future<List<SessionRevision>> getRevisionsBySession(int sessionId) =>
      (select(sessionRevisions)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder), (t) => OrderingTerm.asc(t.id)]))
          .get();

  Future<int> insertRevision(SessionRevisionsCompanion entry) =>
      into(sessionRevisions).insert(entry);

  Future<bool> updateRevision(SessionRevisionsCompanion entry) =>
      update(sessionRevisions).replace(entry);

  Future<int> deleteRevisionById(int id) =>
      (delete(sessionRevisions)..where((t) => t.id.equals(id))).go();

  /// يحذف كل مراجعات الجلسة دفعة واحدة — يُستخدَم عند إزالة كل المراجعات
  /// (أو حذف الجلسة نفسها) بدل حذف كل صفّ على حدة.
  Future<int> deleteRevisions(int sessionId) =>
      (delete(sessionRevisions)..where((t) => t.sessionId.equals(sessionId))).go();

  /// يستبدل كل مراجعات [sessionId] بالقائمة الجديدة [entries] في معاملة
  /// واحدة — أبسط من مطابقة كل صفّ قديم بجديد لتحديد أيها تغيّر/أُضيف/
  /// حُذف، ومطابق لحجم البيانات الفعلي هنا (بضع مراجعات على الأكثر لكل
  /// جلسة).
  Future<void> replaceRevisions(int sessionId, List<SessionRevisionsCompanion> entries) async {
    await transaction(() async {
      await deleteRevisions(sessionId);
      for (final entry in entries) {
        await insertRevision(entry);
      }
    });
  }

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

  Future<void> upsertEvaluation(SessionEvaluationsCompanion entry) async {
    final existing = await getEvaluationBySession(entry.sessionId.value);
    if (existing != null) {
      await updateEvaluation(entry.copyWith(id: Value(existing.id)));
    } else {
      await insertEvaluation(entry);
    }
  }
}
