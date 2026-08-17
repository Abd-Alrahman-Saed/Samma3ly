import 'package:drift/drift.dart';
import 'package:quran_mobile/core/enums/session_type.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/domain/repositories/group_schedule_repository.dart';

/// One occurrence of a group's recurring schedule, merged with whatever
/// `Sessions` row (if any) has already been materialized for it.
///
/// This is the piece that makes item 2.6's invariant hold ("editing a
/// slot must not retroactively change past sessions"): [RecurrenceService]
/// always recomputes occurrences from the *current* [GroupScheduleSlot]
/// rule, so if a teacher edits a slot's time, every not-yet-materialized
/// occurrence legitimately moves — but a materialized occurrence's
/// [dateTime]/[sessionId] here come from the frozen `Sessions` row instead,
/// so it stays exactly where it was recorded regardless of later slot
/// edits.
class GroupOccurrence {
  final DateTime date;
  final DateTime dateTime;
  final bool isRescheduled;
  final int? sessionId;

  const GroupOccurrence({
    required this.date,
    required this.dateTime,
    required this.isRescheduled,
    required this.sessionId,
  });

  bool get isMaterialized => sessionId != null;
}

/// Bridges [GroupScheduleRepository]'s pure recurrence expansion with the
/// real `Sessions` table — item 2.7 (materialize-on-write).
///
/// A recurring occurrence is *virtual* until something explicit happens
/// (recording attendance, adding notes, ...) — merely listing/viewing the
/// upcoming schedule (`upcomingOccurrences`) never inserts a row. Only
/// [materializeOccurrence] does, and it is idempotent: calling it twice
/// for the same (groupId, occurrenceDate) returns the same row instead of
/// creating a duplicate.
class GroupSessionService {
  final GroupScheduleRepository _scheduleRepo;
  final SessionDao _sessionDao;

  GroupSessionService(this._scheduleRepo, this._sessionDao);

  /// Expands [groupId]'s schedule between [from] and [to] and overlays any
  /// already-materialized sessions on top — a pure read, no writes.
  Future<List<GroupOccurrence>> upcomingOccurrences({
    required int groupId,
    required DateTime from,
    required DateTime to,
  }) async {
    final virtual = await _scheduleRepo.expandOccurrences(
      groupId: groupId,
      from: from,
      to: to,
    );
    final materialized = await _sessionDao.getMaterializedByGroup(groupId, from, to);
    final byDate = {
      for (final s in materialized)
        if (s.occurrenceDate != null) _dateOnly(s.occurrenceDate!): s,
    };

    final result = <GroupOccurrence>[];
    final coveredDates = <DateTime>{};
    for (final o in virtual) {
      coveredDates.add(o.date);
      final session = byDate[o.date];
      if (session == null) {
        result.add(GroupOccurrence(date: o.date, dateTime: o.dateTime, isRescheduled: o.isRescheduled, sessionId: null));
      } else {
        // The materialized row is the frozen source of truth for this
        // date — its own date/time win over whatever the (possibly
        // since-edited) slot would recompute.
        result.add(GroupOccurrence(
          date: _dateOnly(session.date),
          dateTime: _combine(session.date, session.time),
          isRescheduled: o.isRescheduled,
          sessionId: session.id,
        ));
      }
    }
    // A materialized session whose date the *current* slot rule no longer
    // generates (e.g. effectiveFrom/To or the weekday was edited after the
    // session was recorded) is still real history — surface it too, so
    // editing a slot can never make a recorded session silently vanish
    // from this list (item 2.6's invariant, applied to the read side).
    for (final s in materialized) {
      final date = s.occurrenceDate == null ? null : _dateOnly(s.occurrenceDate!);
      if (date == null || coveredDates.contains(date)) continue;
      result.add(GroupOccurrence(date: date, dateTime: _combine(s.date, s.time), isRescheduled: false, sessionId: s.id));
    }
    result.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return result;
  }

  /// Creates the `Sessions` row for one occurrence if it doesn't already
  /// exist, and returns its id either way. Call this only from an explicit
  /// user action (e.g. "start attendance") — never from a read/list path.
  Future<int> materializeOccurrence({
    required int groupId,
    required DateTime occurrenceDate,
    required DateTime dateTime,
  }) async {
    final dateOnly = _dateOnly(occurrenceDate);
    final existing = await _sessionDao.getByGroupAndOccurrenceDate(groupId, dateOnly);
    if (existing != null) return existing.id;

    return await _sessionDao.insert(SessionsCompanion.insert(
      date: dateOnly,
      time: _formatTime(dateTime),
      groupId: Value(groupId),
      sessionType: Value(SessionType.group.arabic),
      occurrenceDate: Value(dateOnly),
    ));
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  DateTime _combine(DateTime date, String hhmm) {
    final parts = hhmm.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
