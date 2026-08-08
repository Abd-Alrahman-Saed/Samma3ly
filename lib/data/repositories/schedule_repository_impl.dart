import 'package:drift/drift.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/data/local/database/daos/schedule_dao.dart';
import 'package:quran_mobile/domain/entities/session.dart';
import 'package:quran_mobile/domain/entities/schedule.dart';
import 'package:quran_mobile/domain/repositories/schedule_repository.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Schedule, Session;
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';

Schedule _toScheduleEntity(dynamic s) => Schedule(
      id: s.id,
      studentId: s.studentId,
      date: s.date,
      time: s.time,
      memorizationSurahId: s.memorizationSurahId,
      memorizationFromAyah: s.memorizationFromAyah,
      memorizationToAyah: s.memorizationToAyah,
      revisionSurahId: s.revisionSurahId,
      revisionFromAyah: s.revisionFromAyah,
      revisionToAyah: s.revisionToAyah,
      isCompleted: s.isCompleted,
      createdAt: s.createdAt,
    );

Session _toSessionEntity(dynamic s) => Session(
      id: s.id,
      studentId: s.studentId,
      date: s.date,
      time: s.time,
      attendanceStatus: s.attendanceStatus,
      notes: s.notes,
      createdAt: s.createdAt,
    );

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleDao _dao;
  final SessionDao _sessionDao;

  ScheduleRepositoryImpl(this._dao, this._sessionDao);

  @override
  Future<List<Schedule>> getUpcoming({int? studentId}) async {
    return (await _dao.getUpcoming(studentId: studentId)).map(_toScheduleEntity).toList();
  }

  @override
  Future<Schedule?> getById(int id) async {
    final s = await _dao.getById(id);
    return s == null ? null : _toScheduleEntity(s);
  }

  @override
  Future<Schedule> create(Schedule schedule) async {
    final id = await _dao.insert(SchedulesCompanion(
      studentId: Value(schedule.studentId),
      date: Value(schedule.date),
      time: Value(schedule.time),
      memorizationSurahId: Value(schedule.memorizationSurahId),
      memorizationFromAyah: Value(schedule.memorizationFromAyah),
      memorizationToAyah: Value(schedule.memorizationToAyah),
      revisionSurahId: Value(schedule.revisionSurahId),
      revisionFromAyah: Value(schedule.revisionFromAyah),
      revisionToAyah: Value(schedule.revisionToAyah),
      isCompleted: const Value(false),
      createdAt: Value(DateTime.now()),
    ));
    return _toScheduleEntity((await _dao.getById(id))!);
  }

  @override
  Future<Schedule> update(Schedule schedule) async {
    await _dao.updateEntry(SchedulesCompanion(
      id: Value(schedule.id),
      studentId: Value(schedule.studentId),
      date: Value(schedule.date),
      time: Value(schedule.time),
      memorizationSurahId: Value(schedule.memorizationSurahId),
      memorizationFromAyah: Value(schedule.memorizationFromAyah),
      memorizationToAyah: Value(schedule.memorizationToAyah),
      revisionSurahId: Value(schedule.revisionSurahId),
      revisionFromAyah: Value(schedule.revisionFromAyah),
      revisionToAyah: Value(schedule.revisionToAyah),
      isCompleted: Value(schedule.isCompleted),
      createdAt: Value(schedule.createdAt ?? DateTime.now()),
    ));
    return _toScheduleEntity((await _dao.getById(schedule.id))!);
  }

  @override
  Future<void> delete(int id) => _dao.deleteById(id);

  Future<Session> convertToSession(int scheduleId) async {
    final schedule = await _dao.getById(scheduleId);
    if (schedule == null) throw Exception('الجدولة غير موجودة');

    final sessionId = await _sessionDao.insert(SessionsCompanion(
      studentId: Value(schedule.studentId),
      date: Value(schedule.date),
      time: Value(schedule.time),
      attendanceStatus: Value(AttendanceStatus.present.arabic),
      notes: const Value(null),
      createdAt: Value(DateTime.now()),
    ));

    if (schedule.memorizationSurahId != null) {
      await _sessionDao.insertMemorization(SessionMemorizationsCompanion(
        sessionId: Value(sessionId),
        surahId: Value(schedule.memorizationSurahId!),
        fromAyah: Value(schedule.memorizationFromAyah ?? 1),
        toAyah: Value(schedule.memorizationToAyah ?? 1),
      ));
    }
    if (schedule.revisionSurahId != null) {
      await _sessionDao.insertRevision(SessionRevisionsCompanion(
        sessionId: Value(sessionId),
        surahId: Value(schedule.revisionSurahId!),
        fromAyah: Value(schedule.revisionFromAyah ?? 1),
        toAyah: Value(schedule.revisionToAyah ?? 1),
      ));
    }

    await _dao.updateEntry(SchedulesCompanion(
      id: Value(schedule.id),
      studentId: Value(schedule.studentId),
      date: Value(schedule.date),
      time: Value(schedule.time),
      memorizationSurahId: Value(schedule.memorizationSurahId),
      memorizationFromAyah: Value(schedule.memorizationFromAyah),
      memorizationToAyah: Value(schedule.memorizationToAyah),
      revisionSurahId: Value(schedule.revisionSurahId),
      revisionFromAyah: Value(schedule.revisionFromAyah),
      revisionToAyah: Value(schedule.revisionToAyah),
      isCompleted: const Value(true),
      createdAt: Value(schedule.createdAt ?? DateTime.now()),
    ));

    return _toSessionEntity((await _sessionDao.getById(sessionId))!);
  }
}
