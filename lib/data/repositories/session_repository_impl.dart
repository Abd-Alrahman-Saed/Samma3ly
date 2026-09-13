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
      isFullSurah: m.isFullSurah,
    );

SessionRevision _revisionToEntity(db.SessionRevision r) => SessionRevision(
      id: r.id,
      sessionId: r.sessionId,
      surahId: r.surahId,
      fromAyah: r.fromAyah,
      toAyah: r.toAyah,
      label: r.label,
      isFullSurah: r.isFullSurah,
      sortOrder: r.sortOrder,
      memorizationScore: r.memorizationScore,
      tajweedScore: r.tajweedScore,
      fluencyScore: r.fluencyScore,
      accuracyScore: r.accuracyScore,
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

/// القسم ح.10 — تحويل جلسة حلقة + صفّ حضور طالب واحد فيها إلى `Session`
/// بنفس شكل جلسة فردية، عشان تظهر في "جلسات الطالب" العادية. المصدر هنا
/// عمداً `SessionAttendances` نفسها (لا `SessionMemorizations`/
/// `SessionRevisions`/`SessionEvaluations` المشترَكة على مستوى الجلسة كلها
/// — تلك خاطئة هنا، لأن كل طالب في الحلقة له تسميع مستقلّ. راجع تعليق v5
/// على `SessionAttendances` للسبب الكامل.
Session _groupAttendanceToSession(db.Session groupSession, db.SessionAttendance attendance) {
  final hasMemEvaluation = attendance.memorizationScore > 0 ||
      attendance.tajweedScore > 0 ||
      attendance.fluencyScore > 0 ||
      attendance.accuracyScore > 0;
  return Session(
    id: groupSession.id,
    studentId: attendance.studentId,
    groupId: groupSession.groupId,
    sessionType: groupSession.sessionType,
    occurrenceDate: groupSession.occurrenceDate,
    date: groupSession.date,
    time: groupSession.time,
    notes: attendance.notes,
    createdAt: groupSession.createdAt,
    attendanceStatus: attendance.attendanceStatus,
    recitationOutcome: attendance.recitationOutcome,
    memorization: attendance.memorizationSurahId == null
        ? null
        : SessionMemorization(
            sessionId: groupSession.id,
            surahId: attendance.memorizationSurahId!,
            fromAyah: attendance.memorizationFromAyah ?? 1,
            toAyah: attendance.memorizationToAyah ?? 1,
          ),
    // القسم ح.14: جلسات الحلقات لسه بمراجعة واحدة بالضبط (مصدرها
    // SessionAttendances، لا SessionRevisions) — قائمة بعنصر واحد على
    // الأكثر، لا مراجعات متعددة (تلك ميزة خاصة بالجلسات الفردية فقط).
    revisions: attendance.revisionSurahId == null
        ? const []
        : [
            SessionRevision(
              sessionId: groupSession.id,
              surahId: attendance.revisionSurahId!,
              fromAyah: attendance.revisionFromAyah ?? 1,
              toAyah: attendance.revisionToAyah ?? 1,
              memorizationScore: attendance.revisionMemorizationScore,
              tajweedScore: attendance.revisionTajweedScore,
              fluencyScore: attendance.revisionFluencyScore,
              accuracyScore: attendance.revisionAccuracyScore,
            ),
          ],
    evaluation: !hasMemEvaluation
        ? null
        : SessionEvaluation(
            sessionId: groupSession.id,
            memorizationScore: attendance.memorizationScore,
            tajweedScore: attendance.tajweedScore,
            fluencyScore: attendance.fluencyScore,
            accuracyScore: attendance.accuracyScore,
          ),
  );
}

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
    final revisions = await _dao.getRevisionsBySession(session.id);
    final evaluation = await _dao.getEvaluationBySession(session.id);
    String attendanceStatus = 'حاضر';
    String? recitationOutcome;
    if (session.studentId != null) {
      final attendance = await _dao.getAttendance(session.id, session.studentId!);
      if (attendance != null) {
        attendanceStatus = attendance.attendanceStatus;
        recitationOutcome = attendance.recitationOutcome;
      }
    }
    return session.copyWith(
      attendanceStatus: attendanceStatus,
      recitationOutcome: recitationOutcome,
      memorization: memorization == null ? null : _memorizationToEntity(memorization),
      revisions: revisions.map(_revisionToEntity).toList(),
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
    final individualSessions = await Future.wait(individualRows.map(_toEntity).map(_hydrate));

    if (studentId == null) return individualSessions;

    // القسم ح.10: "الجلسات بتاعة الحلقات تتحفظ في جلسات الطالب عادي" —
    // مشاركات هذا الطالب في جلسات الحلقات تُدمَج هنا فقط (عند تحديد
    // studentId)، لا في القائمة العامة غير المفلترة أعلاه (تلك تمثّل
    // الجلسات الفردية حصراً، وتبقى كما هي لكل مستهلكيها الحاليين).
    final groupRows = await _dao.getGroupSessionsForStudent(studentId, from: from, to: to);
    final groupSessions = [for (final (session, attendance) in groupRows) _groupAttendanceToSession(session, attendance)];

    return [...individualSessions, ...groupSessions]..sort((a, b) => b.date.compareTo(a.date));
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
        isFullSurah: Value(session.memorization!.isFullSurah),
      ));
    }
    for (var i = 0; i < session.revisions.length; i++) {
      final r = session.revisions[i];
      await _dao.insertRevision(SessionRevisionsCompanion(
        sessionId: Value(sessionId),
        surahId: Value(r.surahId),
        fromAyah: Value(r.fromAyah),
        toAyah: Value(r.toAyah),
        label: Value(r.label),
        isFullSurah: Value(r.isFullSurah),
        sortOrder: Value(i),
        memorizationScore: Value(r.memorizationScore),
        tajweedScore: Value(r.tajweedScore),
        fluencyScore: Value(r.fluencyScore),
        accuracyScore: Value(r.accuracyScore),
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
          isFullSurah: Value(session.memorization!.isFullSurah),
        ));
      } else {
        await _dao.insertMemorization(SessionMemorizationsCompanion(
          sessionId: Value(session.id),
          surahId: Value(session.memorization!.surahId),
          fromAyah: Value(session.memorization!.fromAyah),
          toAyah: Value(session.memorization!.toAyah),
          isFullSurah: Value(session.memorization!.isFullSurah),
        ));
      }
    } else {
      await _dao.deleteMemorization(session.id);
    }

    // القسم ح.14: استبدال كل مراجعات الجلسة دفعة واحدة أبسط من مطابقة كل
    // صفّ قديم بجديد لتحديد أيها تغيّر/أُضيف/حُذف — وحجم البيانات هنا
    // (بضع مراجعات على الأكثر) لا يبرّر التعقيد الإضافي.
    await _dao.replaceRevisions(session.id, [
      for (var i = 0; i < session.revisions.length; i++)
        SessionRevisionsCompanion(
          sessionId: Value(session.id),
          surahId: Value(session.revisions[i].surahId),
          fromAyah: Value(session.revisions[i].fromAyah),
          toAyah: Value(session.revisions[i].toAyah),
          label: Value(session.revisions[i].label),
          isFullSurah: Value(session.revisions[i].isFullSurah),
          sortOrder: Value(i),
          memorizationScore: Value(session.revisions[i].memorizationScore),
          tajweedScore: Value(session.revisions[i].tajweedScore),
          fluencyScore: Value(session.revisions[i].fluencyScore),
          accuracyScore: Value(session.revisions[i].accuracyScore),
        ),
    ]);

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
