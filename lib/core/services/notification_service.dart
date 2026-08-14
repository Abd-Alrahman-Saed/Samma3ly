import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Pure helpers for deciding *what* to schedule — kept free of the plugin
/// so this logic is unit-testable without a platform channel (the actual
/// `flutter_local_notifications` calls have never been unit-tested in this
/// project; see the DAO/service/repository tests elsewhere in the codebase
/// for where the real test weight lives).
class GroupNotificationPlanner {
  GroupNotificationPlanner._();

  /// Deterministic per-(group, calendar date) notification id. Offset by
  /// a large constant so this id space never collides with review-reminder
  /// ids (which are raw `MemorizedRanges.id` values — always small).
  /// Bounded so `groupId` and the day count both fit without overflowing a
  /// 32-bit notification id (Android's plugin requires one).
  static int occurrenceNotificationId(int groupId, DateTime date) {
    final days = date.difference(DateTime(2024, 1, 1)).inDays;
    return 1000000 + ((groupId % 10000) * 100000) + (days % 100000);
  }

  /// For every calendar day in `[windowStart, windowEnd]`, decides whether
  /// that day's notification should be (re)scheduled (it's in
  /// [occurrenceDateTimes], keyed by date-only) or cancelled (it isn't —
  /// e.g. the slot was edited/deleted/skipped since the last reschedule).
  /// Pure decision list; the caller does the actual plugin calls.
  static List<({DateTime date, int id, DateTime? fireAt})> plan({
    required int groupId,
    required Map<DateTime, DateTime> occurrenceDateTimes,
    required int leadMinutes,
    required DateTime windowStart,
    required DateTime windowEnd,
    required DateTime now,
  }) {
    final start = DateTime(windowStart.year, windowStart.month, windowStart.day);
    final end = DateTime(windowEnd.year, windowEnd.month, windowEnd.day);
    final result = <({DateTime date, int id, DateTime? fireAt})>[];
    for (var d = start; !d.isAfter(end); d = DateTime(d.year, d.month, d.day + 1)) {
      final id = occurrenceNotificationId(groupId, d);
      final sessionTime = occurrenceDateTimes[d];
      if (sessionTime == null) {
        result.add((date: d, id: id, fireAt: null)); // cancel
        continue;
      }
      final fireAt = sessionTime.subtract(Duration(minutes: leadMinutes));
      // A fire time already in the past is as good as "don't schedule" —
      // cancel instead of asking the plugin to fire something instantly.
      result.add((date: d, id: id, fireAt: fireAt.isBefore(now) ? null : fireAt));
    }
    return result;
  }
}

/// Schedules local reminders — memorization review dates (per-range id) and
/// upcoming group sessions (per-group-per-date id via
/// [GroupNotificationPlanner]), both at a real computed time instead of a
/// hardcoded one (item 3.5): review reminders fire at the teacher's chosen
/// time-of-day (`NotificationSettings.reviewReminderHour/Minute`, was a
/// literal `9`); group reminders fire `leadMinutes` before the occurrence's
/// actual resolved time (fixed-clock or prayer-anchored — items 2.2/2.3).
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
    } catch (_) {
      // Fall back to UTC if the local timezone name can't be resolved.
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
    _initialized = true;
  }

  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// [hour]/[minute] come from `NotificationSettings.reviewReminderHour/Minute`
  /// (Settings, adjustable) — previously hardcoded to 9:00.
  Future<void> scheduleReviewReminder({
    required int rangeId,
    required DateTime reviewDate,
    required String studentName,
    required String surahName,
    int hour = 9,
    int minute = 0,
  }) async {
    if (!_initialized) return;
    final scheduled = tz.TZDateTime.from(
      DateTime(reviewDate.year, reviewDate.month, reviewDate.day, hour, minute),
      tz.local,
    );
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;

    try {
      await _plugin.zonedSchedule(
        id: rangeId,
        title: 'مراجعة مستحقة',
        body: 'حان موعد مراجعة $surahName مع $studentName',
        scheduledDate: scheduled,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'review_reminders',
            'تذكيرات المراجعة',
            channelDescription: 'تذكيرات بمواعيد مراجعة الحفظ',
            importance: Importance.defaultImportance,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Failed to schedule review reminder: $e');
    }
  }

  Future<void> cancelReviewReminder(int rangeId) async {
    if (!_initialized) return;
    await _plugin.cancel(id: rangeId);
  }

  /// Re-syncs group-session reminders for [windowStart, windowEnd] against
  /// [occurrenceDateTimes] (date-only -> resolved session dateTime, exactly
  /// what `GroupOccurrence`/`upcomingOccurrences()` — items 2.6/2.7 —
  /// already compute). Call this after schedule slots change and when a
  /// group's upcoming list is viewed, so stale/skipped occurrences get
  /// their reminder cancelled, not just new ones scheduled.
  Future<void> rescheduleGroupOccurrences({
    required int groupId,
    required String groupName,
    required Map<DateTime, DateTime> occurrenceDateTimes,
    required int leadMinutes,
    required DateTime windowStart,
    required DateTime windowEnd,
  }) async {
    if (!_initialized) return;
    final plan = GroupNotificationPlanner.plan(
      groupId: groupId,
      occurrenceDateTimes: occurrenceDateTimes,
      leadMinutes: leadMinutes,
      windowStart: windowStart,
      windowEnd: windowEnd,
      now: DateTime.now(),
    );
    for (final entry in plan) {
      if (entry.fireAt == null) {
        await _plugin.cancel(id: entry.id);
        continue;
      }
      try {
        await _plugin.zonedSchedule(
          id: entry.id,
          title: 'حلقة قريباً',
          body: 'حلقة "$groupName" تبدأ خلال $leadMinutes دقيقة',
          scheduledDate: tz.TZDateTime.from(entry.fireAt!, tz.local),
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'group_session_reminders',
              'تذكيرات الحلقات',
              channelDescription: 'تذكيرات بمواعيد الحلقات الجماعية القادمة',
              importance: Importance.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (e) {
        debugPrint('Failed to schedule group session reminder: $e');
      }
    }
  }

  Future<void> cancelAllGroupOccurrences({
    required int groupId,
    required DateTime windowStart,
    required DateTime windowEnd,
  }) async {
    if (!_initialized) return;
    final plan = GroupNotificationPlanner.plan(
      groupId: groupId,
      occurrenceDateTimes: const {},
      leadMinutes: 0,
      windowStart: windowStart,
      windowEnd: windowEnd,
      now: DateTime.now(),
    );
    for (final entry in plan) {
      await _plugin.cancel(id: entry.id);
    }
  }
}
