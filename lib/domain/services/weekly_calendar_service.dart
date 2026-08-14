import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/domain/repositories/group_repository.dart';
import 'package:quran_mobile/domain/services/group_session_service.dart';
import 'package:quran_mobile/domain/services/recurrence_service.dart' show PrayerTimeResolver;

/// One row in the weekly calendar (item 3.6) — either a real individual
/// `Sessions` row, or a group occurrence (virtual or materialized, exactly
/// what [GroupOccurrence] — items 2.6/2.7 — already represents).
class CalendarEntry {
  final DateTime dateTime;
  final bool isGroup;

  /// The real `Sessions.id`, when there is one — always set for an
  /// individual entry; only set for a group entry once it's materialized.
  final int? sessionId;

  final int? studentId; // individual entries only
  final int? groupId; // group entries only
  final bool isRescheduled; // group entries only

  const CalendarEntry({
    required this.dateTime,
    required this.isGroup,
    required this.sessionId,
    this.studentId,
    this.groupId,
    this.isRescheduled = false,
  });

  bool get isMaterialized => isGroup ? sessionId != null : true;
}

/// Combines individual sessions and every group's occurrences (items
/// 2.6/2.7, including prayer-anchored ones from 2.3) into one
/// chronologically-sorted list for a date range — the data behind the
/// weekly calendar screen. A pure read: never materializes a group
/// occurrence itself (same "no write in read" discipline as
/// `GroupSessionService.upcomingOccurrences`).
class WeeklyCalendarService {
  final SessionDao _sessionDao;
  final GroupRepository _groupRepository;
  final GroupSessionService _groupSessionService;

  WeeklyCalendarService(this._sessionDao, this._groupRepository, this._groupSessionService);

  DateTime _combine(DateTime date, String hhmm) {
    final parts = hhmm.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  Future<List<CalendarEntry>> getEntries({
    required DateTime from,
    required DateTime to,
    PrayerTimeResolver? prayerTimeResolver,
  }) async {
    final entries = <CalendarEntry>[];

    final sessions = await _sessionDao.getByDateRange(from, to);
    for (final s in sessions) {
      if (s.sessionType == 'جماعي') continue; // covered by the group loop below
      entries.add(CalendarEntry(
        dateTime: _combine(s.date, s.time),
        isGroup: false,
        sessionId: s.id,
        studentId: s.studentId,
      ));
    }

    final groups = await _groupRepository.getAll();
    for (final group in groups) {
      final occurrences = await _groupSessionService.upcomingOccurrences(
        groupId: group.id,
        from: from,
        to: to,
        prayerTimeResolver: prayerTimeResolver,
      );
      for (final o in occurrences) {
        entries.add(CalendarEntry(
          dateTime: o.dateTime,
          isGroup: true,
          sessionId: o.sessionId,
          groupId: group.id,
          isRescheduled: o.isRescheduled,
        ));
      }
    }

    entries.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return entries;
  }
}
