import 'package:drift/drift.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/domain/entities/session.dart';
import 'package:quran_mobile/domain/repositories/session_repository.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Session;

Session _toEntity(dynamic s) => Session(
      id: s.id,
      studentId: s.studentId,
      date: s.date,
      time: s.time,
      attendanceStatus: s.attendanceStatus,
      notes: s.notes,
      createdAt: s.createdAt,
    );

class SessionRepositoryImpl implements SessionRepository {
  final SessionDao _dao;

  SessionRepositoryImpl(this._dao);

  @override
  Future<List<Session>> getAll({int? studentId, DateTime? from, DateTime? to}) async {
    return (await _dao.getAll(studentId: studentId, from: from, to: to)).map(_toEntity).toList();
  }

  @override
  Future<Session?> getById(int id) async {
    final s = await _dao.getById(id);
    return s == null ? null : _toEntity(s);
  }

  @override
  Future<Session> create(Session session) async {
    final now = DateTime.now();
    final sessionId = await _dao.insert(SessionsCompanion(
      studentId: Value(session.studentId),
      date: Value(session.date),
      time: Value(session.time),
      attendanceStatus: Value(session.attendanceStatus),
      notes: Value(session.notes),
      createdAt: Value(now),
    ));

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

    return _toEntity((await _dao.getById(sessionId))!);
  }

  @override
  Future<Session> update(Session session) async {
    await _dao.updateEntry(SessionsCompanion(
      id: Value(session.id),
      studentId: Value(session.studentId),
      date: Value(session.date),
      time: Value(session.time),
      attendanceStatus: Value(session.attendanceStatus),
      notes: Value(session.notes),
      createdAt: Value(session.createdAt ?? DateTime.now()),
    ));

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

    return _toEntity((await _dao.getById(session.id))!);
  }

  @override
  Future<void> delete(int id) => _dao.deleteById(id);

  @override
  Future<int> countByDate(DateTime date) => _dao.countByDate(date);

  @override
  Future<List<Session>> getByDateRange(DateTime from, DateTime to) async {
    return (await _dao.getByDateRange(from, to)).map(_toEntity).toList();
  }
}
