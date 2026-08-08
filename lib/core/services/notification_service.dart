import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Schedules local reminders for memorization review dates.
/// Notification ids are derived from the memorized range's own database id
/// so a range's reminder can be uniquely rescheduled or cancelled.
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

  Future<void> scheduleReviewReminder({
    required int rangeId,
    required DateTime reviewDate,
    required String studentName,
    required String surahName,
  }) async {
    if (!_initialized) return;
    final scheduled = tz.TZDateTime.from(
      DateTime(reviewDate.year, reviewDate.month, reviewDate.day, 9),
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
}
