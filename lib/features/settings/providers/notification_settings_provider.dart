import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sprint 3, item 3.5 — replaces the two previously-hardcoded notification
/// times (memorization review reminders fired at a literal `9`, group
/// sessions had no reminder at all) with settings the teacher can adjust.
class NotificationSettings {
  /// Time-of-day the daily memorization-review reminder fires at.
  final int reviewReminderHour;
  final int reviewReminderMinute;

  /// How many minutes before a group session's *computed* start time
  /// (fixed-time or prayer-anchored — see item 2.2/2.3) its reminder fires.
  final int groupSessionLeadMinutes;

  const NotificationSettings({
    this.reviewReminderHour = 9,
    this.reviewReminderMinute = 0,
    this.groupSessionLeadMinutes = 30,
  });

  NotificationSettings copyWith({
    int? reviewReminderHour,
    int? reviewReminderMinute,
    int? groupSessionLeadMinutes,
  }) {
    return NotificationSettings(
      reviewReminderHour: reviewReminderHour ?? this.reviewReminderHour,
      reviewReminderMinute: reviewReminderMinute ?? this.reviewReminderMinute,
      groupSessionLeadMinutes: groupSessionLeadMinutes ?? this.groupSessionLeadMinutes,
    );
  }
}

const _prefsReviewHourKey = 'notification_settings_review_hour';
const _prefsReviewMinuteKey = 'notification_settings_review_minute';
const _prefsGroupLeadMinutesKey = 'notification_settings_group_lead_minutes';

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  /// Lets tests await the initial SharedPreferences load deterministically
  /// instead of racing it.
  late final Future<void> ready;

  NotificationSettingsNotifier() : super(const NotificationSettings()) {
    ready = _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      reviewReminderHour: prefs.getInt(_prefsReviewHourKey) ?? state.reviewReminderHour,
      reviewReminderMinute: prefs.getInt(_prefsReviewMinuteKey) ?? state.reviewReminderMinute,
      groupSessionLeadMinutes: prefs.getInt(_prefsGroupLeadMinutesKey) ?? state.groupSessionLeadMinutes,
    );
  }

  Future<void> setReviewReminderTime({required int hour, required int minute}) async {
    state = state.copyWith(reviewReminderHour: hour, reviewReminderMinute: minute);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsReviewHourKey, hour);
    await prefs.setInt(_prefsReviewMinuteKey, minute);
  }

  Future<void> setGroupSessionLeadMinutes(int minutes) async {
    state = state.copyWith(groupSessionLeadMinutes: minutes);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsGroupLeadMinutesKey, minutes);
  }
}

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  (ref) => NotificationSettingsNotifier(),
);
