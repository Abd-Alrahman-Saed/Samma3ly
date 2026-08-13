import 'package:quran_mobile/core/enums/anchor_type.dart';
import 'package:quran_mobile/core/enums/schedule_exception_type.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

/// Resolves the clock time of a named prayer on a given date.
///
/// Implemented against the `adhan` package in item 2.3 — kept as an
/// interface here so [RecurrenceService]'s date math stays fully unit
/// testable without a prayer-time dependency, and so a prayer-anchored slot
/// used without a real resolver fails loudly instead of silently falling
/// back to some made-up fixed time.
abstract class PrayerTimeResolver {
  /// Returns [date] with its time-of-day set to when [prayerName] occurs
  /// on that date (prayer times shift daily, so this must be resolved
  /// per-occurrence, not once for the whole slot).
  DateTime resolve({required DateTime date, required String prayerName});
}

/// One concrete occurrence produced by [RecurrenceService.expand].
class RecurrenceOccurrence {
  /// Calendar date this occurrence falls on (after any reschedule) — this
  /// is always midnight; use [dateTime] for the actual moment.
  final DateTime date;

  /// The resolved date + time the session should happen at.
  final DateTime dateTime;

  /// True if a [ScheduleExceptionType.reschedule] moved this occurrence off
  /// its regular weekly date and/or time.
  final bool isRescheduled;

  const RecurrenceOccurrence({
    required this.date,
    required this.dateTime,
    this.isRescheduled = false,
  });

  @override
  String toString() =>
      'RecurrenceOccurrence($dateTime${isRescheduled ? ', rescheduled' : ''})';

  @override
  bool operator ==(Object other) =>
      other is RecurrenceOccurrence &&
      other.date == date &&
      other.dateTime == dateTime &&
      other.isRescheduled == isRescheduled;

  @override
  int get hashCode => Object.hash(date, dateTime, isRescheduled);
}

/// Expands a [GroupScheduleSlot]'s weekly recurrence rule into concrete
/// occurrences within a date range, applying [ScheduleException] overrides.
///
/// Pure date/time math — no database access, no I/O — so it is fully unit
/// testable, including across DST transitions and month/year boundaries,
/// without a real database or clock.
///
/// Scope (Sprint 2, item 2.2, risk R5): weekly recurrence only. Ramadan
/// scheduling adjustments are explicitly deferred to Sprint 5.
class RecurrenceService {
  /// Expands [slot] into every occurrence between [rangeStart] and
  /// [rangeEnd] inclusive (time-of-day on the range bounds is ignored —
  /// only the calendar date matters), clipped further by the slot's own
  /// `effectiveFrom`/`effectiveTo`.
  ///
  /// [exceptions] may contain rows for other slots — they are ignored; you
  /// do not need to pre-filter by `groupScheduleSlotId`.
  ///
  /// [prayerTimeResolver] is required only when `slot.anchorType` is
  /// [AnchorType.prayer] (or a reschedule exception both targets a
  /// prayer-anchored slot and omits `newTime`); a fixed-time-only slot
  /// never needs one.
  ///
  /// Results are sorted by [RecurrenceOccurrence.dateTime].
  List<RecurrenceOccurrence> expand({
    required GroupScheduleSlot slot,
    List<ScheduleException> exceptions = const [],
    required DateTime rangeStart,
    required DateTime rangeEnd,
    PrayerTimeResolver? prayerTimeResolver,
  }) {
    final rangeStartDate = _dateOnly(rangeStart);
    final rangeEndDate = _dateOnly(rangeEnd);
    if (rangeStartDate.isAfter(rangeEndDate)) return const [];

    final effectiveFrom = _dateOnly(slot.effectiveFrom);
    final effectiveTo =
        slot.effectiveTo == null ? null : _dateOnly(slot.effectiveTo!);

    final windowStart = _laterOf(rangeStartDate, effectiveFrom);
    final windowEnd = effectiveTo == null
        ? rangeEndDate
        : _earlierOf(rangeEndDate, effectiveTo);

    final exceptionsByDate = <DateTime, ScheduleException>{
      for (final e in exceptions)
        if (e.groupScheduleSlotId == slot.id) _dateOnly(e.occurrenceDate): e,
    };

    final results = <RecurrenceOccurrence>[];

    if (!windowStart.isAfter(windowEnd)) {
      var cursor = _firstOnOrAfter(windowStart, slot.weekday);
      while (!cursor.isAfter(windowEnd)) {
        final exception = exceptionsByDate[cursor];
        if (exception == null) {
          results.add(RecurrenceOccurrence(
            date: cursor,
            dateTime: _resolveTime(slot, cursor, prayerTimeResolver),
          ));
        } else if (exception.exceptionType ==
            ScheduleExceptionType.skip.arabic) {
          // Cancelled — no occurrence on this date at all.
        } else if (exception.exceptionType ==
            ScheduleExceptionType.reschedule.arabic) {
          final occurrence = _rescheduledOccurrence(
            slot: slot,
            exception: exception,
            fallbackDate: cursor,
            prayerTimeResolver: prayerTimeResolver,
          );
          if (occurrence != null &&
              !occurrence.date.isBefore(rangeStartDate) &&
              !occurrence.date.isAfter(rangeEndDate)) {
            results.add(occurrence);
          }
        } else {
          throw StateError(
            'ScheduleException ${exception.id}: exceptionType غير معروف '
            '"${exception.exceptionType}".',
          );
        }
        // Component-based stepping (not `.add(Duration(days: 7))`): Dart's
        // Duration arithmetic on a local DateTime is DST-exact, which for a
        // *calendar* weekly recurrence is the wrong semantic — it can shift
        // the resulting wall-clock time by an hour across a DST transition.
        // Rebuilding the date from (year, month, day + 7) instead lets Dart
        // normalize month/year overflow while keeping the same wall time.
        cursor = DateTime(cursor.year, cursor.month, cursor.day + 7);
      }
    }

    results.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return results;
  }

  /// Expands every slot in [slots] and merges the results, sorted by
  /// [RecurrenceOccurrence.dateTime]. Convenience for rendering a whole
  /// group's schedule (which typically has multiple weekly slots) in one
  /// call.
  List<RecurrenceOccurrence> expandAll({
    required List<GroupScheduleSlot> slots,
    List<ScheduleException> exceptions = const [],
    required DateTime rangeStart,
    required DateTime rangeEnd,
    PrayerTimeResolver? prayerTimeResolver,
  }) {
    final results = <RecurrenceOccurrence>[];
    for (final slot in slots) {
      results.addAll(expand(
        slot: slot,
        exceptions: exceptions,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
        prayerTimeResolver: prayerTimeResolver,
      ));
    }
    results.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return results;
  }

  RecurrenceOccurrence? _rescheduledOccurrence({
    required GroupScheduleSlot slot,
    required ScheduleException exception,
    required DateTime fallbackDate,
    required PrayerTimeResolver? prayerTimeResolver,
  }) {
    final newDate =
        exception.newDate != null ? _dateOnly(exception.newDate!) : fallbackDate;
    final dateTime = _resolveTime(
      slot,
      newDate,
      prayerTimeResolver,
      timeOverride: exception.newTime,
    );
    return RecurrenceOccurrence(date: newDate, dateTime: dateTime, isRescheduled: true);
  }

  DateTime _resolveTime(
    GroupScheduleSlot slot,
    DateTime date,
    PrayerTimeResolver? resolver, {
    String? timeOverride,
  }) {
    if (timeOverride != null) {
      return _combine(date, timeOverride);
    }
    if (slot.anchorType == AnchorType.fixedTime.arabic) {
      final fixedTime = slot.fixedTime;
      if (fixedTime == null) {
        throw StateError(
          'GroupScheduleSlot ${slot.id}: anchorType="وقت محدد" لكن fixedTime فارغ.',
        );
      }
      return _combine(date, fixedTime);
    }
    if (slot.anchorType == AnchorType.prayer.arabic) {
      final prayerName = slot.prayerName;
      if (prayerName == null) {
        throw StateError(
          'GroupScheduleSlot ${slot.id}: anchorType="مرتبط بصلاة" لكن prayerName فارغ.',
        );
      }
      if (resolver == null) {
        throw StateError(
          'GroupScheduleSlot ${slot.id} مرتبط بصلاة ($prayerName) لكن لم يُمرَّر '
          'prayerTimeResolver إلى RecurrenceService.expand — التنفيذ الفعلي '
          'لحساب المواقيت في بند 2.3.',
        );
      }
      final base = resolver.resolve(date: date, prayerName: prayerName);
      return base.add(Duration(minutes: slot.offsetMinutes));
    }
    throw StateError(
      'GroupScheduleSlot ${slot.id}: anchorType غير معروف "${slot.anchorType}".',
    );
  }

  DateTime _combine(DateTime date, String hhmm) {
    final parts = hhmm.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  DateTime _laterOf(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

  DateTime _earlierOf(DateTime a, DateTime b) => a.isBefore(b) ? a : b;

  /// First date on or after [date] whose `weekday` matches [weekday]
  /// (1 = Monday .. 7 = Sunday, matching `DateTime.weekday`).
  DateTime _firstOnOrAfter(DateTime date, int weekday) {
    var d = date;
    while (d.weekday != weekday) {
      d = DateTime(d.year, d.month, d.day + 1);
    }
    return d;
  }
}
