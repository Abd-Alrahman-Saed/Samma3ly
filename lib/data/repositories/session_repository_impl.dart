import 'package:drift/drift.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/domain/entities/session.dart';
import 'package:quran_mobile/domain/repositories/session_repository.dart';
import 'package:quran_mobile/data/local/database/app_database.dart'
    hide Session, SessionMemorization, SessionRevision, SessionEvaluation;
import 'package:quran_mobile/data/local/database/app_database.dart' as db;

Session _toEntity(dynamic s) => Session(
      id: s.id,
      studentId: s.studentId,
      groupId: s.groupId,
      sessionType: s.sessionType,
      occurrenceDate: s.occurrenceDate,
      date: s.date,
      time: s.time,
      notes: s.notes,
      createdAt: s.createdAt,
    );

SessionMemorization _memorizationToEntity(db.SessionMemorization m) =>
    SessionMemorization(
      id: m.id,
      sessionId: m.sessionId,
      surahId: m.surahId,
      fromAyah: m.fromAyah,
      toAyah: m.toAyah,
    );

SessionRevision _revisionToEntity(db.SessionRevision r) => SessionRevision(
      id: r.id,
      sessionId: r.sessionId,
      surahId: r.surahId,
      fromAyah: r.fromAyah,
      toAyah: r.toAyah,
    );

SessionEvaluation _evaluationToEntity(db.SessionEvaluation e) =>
    SessionEvaluation(
      id: e.id,
      sessionId: e.sessionId,
      memorizationScore: e.memorizationScore,
      tajweedScore: e.tajweedScore,
      fluencyScore: e.fluencyScore,
      accuracyScore: e.accuracyScore,
    );

class SessionRepositoryImpl implements SessionRepository {
  final SessionDao _dao;

  SessionRepositoryImpl(this._dao);

  /// Attendance moved to `SessionAttendances` in v4 (Sprint 2) — a group
  /// session needs an independent status per attendee, so it's no longer a
  /// plain column on Sessions. For the common individual-session case
  /// (exactly one attendee: `session.studentId`), this hydrates the
  /// domain entity's `attendanceStatus` convenience field so every
  /// existing caller (screens, dashboard/progress services) keeps working
  /// against `session.attendanceStatus` unchanged.
  Future<Session> _hydrate(Session session) async {
    final memorization = await _dao.getMemorizationBySession(session.id);
    final revision = await _dao.getRevisionBySession(session.id);
    final evaluation = await _dao.getEvaluationBySession(session.id);
    String attendanceStatus = 'حاضر';
    if (session.studentId != null) {
      final attendance = await _dao.getAttendance(session.id, session.studentId!);
      if (attendance != null) attendanceStatus = attendance.attendanceStatus;
    }
    return session.copyWith(
      attendanceStatus: attendanceStatus,
      memorization: memorization == null ? null : _memorizationToEntity(memorization),
      revision: revision == null ? null : _revisionToEntity(revision),
      evaluation: evaluation == null ? null : _evaluationToEntity(evaluation),
    );
  }

  @override
  Future<List<Session>> getAll({int? studentId, DateTime? from, DateTime? to}) async {
    final rows = await _dao.getAll(studentId: studentId, from: from, to: to);
    // القسم ح.4: هذا المستودع يمثّل الجلسات الفردية (كل صف له طالب واحد
    // بالضبط). جلسات الحلقات (sessionType == 'جماعي', studentId == null)
    // مفهوم مختلف تماماً — طلاب متعددون لكل جلسة — وتُعرض عبر
    // GroupRepository/GroupSessionService بدل هذا المسار. استبعادها هنا
    // (بدل الاعتماد على كل مستدعٍ لاحق ليتذكّر تجاهلها) يمنع أي شاشة تعرض
    // نتيجة هذا الاستدعاء (شاشة الجلسات، "آخر الجلسات" في الداشبورد،
    // التقارير) من الانهيار على `session.studentId!` بمجرد وجود بيانات
    // حلقات حقيقية — وهو العطل الفعلي المُبلَّغ عنه ("null check operator").
    final individualRows = rows.where((r) => r.studentId != null);
    return Future.wait(individualRows.map(_toEntity).map(_hydrate));
  }

  @override
  Future<Session?> getById(int id) async {
    final s = await _dao.getById(id);
    return s == null ? null : _hydrate(_toEntity(s));
  }

  @override
  Future<Session> create(Session session) async {
    final now = DateTime.now();
    final sessionId = await _dao.insert(SessionsCompanion(
      studentId: Value(session.studentId),
      groupId: Value(session.groupId),
      sessionType: Value(session.sessionType),
      occurrenceDate: Value(session.occurrenceDate),
      date: Value(session.date),
      time: Value(session.time),
      notes: Value(session.notes),
      createdAt: Value(now),
    ));

    if (session.studentId != null) {
      await _dao.upsertAttendance(sessionId, session.studentId!, session.attendanceStatus);
    }

    if (session.memorization != null) {
      await _dao.insertMemorization(SessionMemorizationsCompanion(
        sessionId: Value(sessionId),
        surahId: Value(session.memorization!.surahId),
        fromAyah: Value(session.memorization!.fromAyah),
        toAyah: Value(session.memorization!.toAyah),
      ));
    }
    if (session.revision != null) {
      await _dao.insertRevision(SessionRevisionsCompanion(
        sessionId: Value(sessionId),
        surahId: Value(session.revision!.surahId),
        fromAyah: Value(session.revision!.fromAyah),
        toAyah: Value(session.revision!.toAyah),
      ));
    }
    if (session.evaluation != null) {
      await _dao.insertEvaluation(SessionEvaluationsCompanion(
        sessionId: Value(sessionId),
        memorizationScore: Value(session.evaluation!.memorizationScore),
        tajweedScore: Value(session.evaluation!.tajweedScore),
        fluencyScore: Value(session.evaluation!.fluencyScore),
        accuracyScore: Value(session.evaluation!.accuracyScore),
      ));
    }

    return _hydrate(_toEntity((await _dao.getById(sessionId))!));
  }

  @override
  Future<Session> update(Session session) async {
    await _dao.updateEntry(SessionsCompanion(
      id: Value(session.id),
      studentId: Value(session.studentId),
      groupId: Value(session.groupId),
      sessionType: Value(session.sessionType),
      occurrenceDate: Value(session.occurrenceDate),
      date: Value(session.date),
      time: Value(session.time),
      notes: Value(session.notes),
      createdAt: Value(session.createdAt ?? DateTime.now()),
    ));

    if (session.studentId != null) {
      await _dao.upsertAttendance(session.id, session.studentId!, session.attendanceStatus);
    }

    if (session.memorization != null) {
      final existing = await _dao.getMemorizationBySession(session.id);
      if (existing != null) {
        await _dao.updateMemorization(SessionMemorizationsCompanion(
          id: Value(existing.id),
          sessionId: Value(session.id),
          surahId: Value(session.memorization!.surahId),
          fromAyah: Value(session.memorization!.fromAyah),
          toAyah: Value(session.memorization!.toAyah),
        ));
      } else {
        await _dao.insertMemorization(SessionMemorizationsCompanion(
          sessionId: Value(session.id),
          surahId: Value(session.memorization!.surahId),
          fromAyah: Value(session.memorization!.fromAyah),
          toAyah: Value(session.memorization!.toAyah),
        ));
      }
    } else {
      await _dao.deleteMemorization(session.id);
    }

    if (session.revision != null) {
      final existing = await _dao.getRevisionBySession(session.id);
      if (existing != null) {
        await _dao.updateRevision(SessionRevisionsCompanion(
          id: Value(existing.id),
          sessionId: Value(session.id),
          surahId: Value(session.revision!.surahId),
          fromAyah: Value(session.revision!.fromAyah),
          toAyah: Value(session.revision!.toAyah),
        ));
      } else {
        await _dao.insertRevision(SessionRevisionsCompanion(
          sessionId: Value(session.id),
          surahId: Value(session.revision!.surahId),
          fromAyah: Value(session.revision!.fromAyah),
          toAyah: Value(session.revision!.toAyah),
        ));
      }
    } else {
      await _dao.deleteRevision(session.id);
    }

    if (session.evaluation != null) {
      final existing = await _dao.getEvaluationBySession(session.id);
      if (existing != null) {
        await _dao.updateEvaluation(SessionEvaluationsCompanion(
          id: Value(existing.id),
          sessionId: Value(session.id),
          memorizationScore: Value(session.evaluation!.memorizationScore),
          tajweedScore: Value(session.evaluation!.tajweedScore),
          fluencyScore: Value(session.evaluation!.fluencyScore),
          accuracyScore: Value(session.evaluation!.accuracyScore),
        ));
      } else {
        await _dao.insertEvaluation(SessionEvaluationsCompanion(
          sessionId: Value(session.id),
          memorizationScore: Value(session.evaluation!.memorizationScore),
          tajweedScore: Value(session.evaluation!.tajweedScore),
          fluencyScore: Value(session.evaluation!.fluencyScore),
          accuracyScore: Value(session.evaluation!.accuracyScore),
        ));
      }
    } else {
      await _dao.deleteEvaluation(session.id);
    }

    return _hydrate(_toEntity((await _dao.getById(session.id))!));
  }

  @override
  Future<void> delete(int id) => _dao.deleteById(id);

  @override
  Future<int> countByDate(DateTime date) => _dao.countByDate(date);

  @override
  Future<List<Session>> getByDateRange(DateTime from, DateTime to) async {
    final rows = await _dao.getByDateRange(from, to);
    return Future.wait(rows.map(_toEntity).map(_hydrate));
  }
}
