import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/core/services/notification_service.dart';
import 'package:quran_mobile/features/groups/providers/group_provider.dart';
import 'package:quran_mobile/features/settings/providers/notification_settings_provider.dart';
import 'package:quran_mobile/providers.dart';

/// Item 3.5 — re-syncs a group's upcoming-session reminders (next 14 days)
/// against its current schedule. Call this after anything that can change
/// what "upcoming" looks like for a group: opening its detail screen, and
/// saving/deleting a weekly schedule slot. Not wired into any read
/// provider (Sprint 0 item 0.6's "no write in read" rule) — always an
/// explicit call from a widget after a user action or on screen entry.
Future<void> rescheduleGroupNotifications(WidgetRef ref, int groupId) async {
  final now = DateTime.now();
  final windowStart = DateTime(now.year, now.month, now.day);
  final windowEnd = DateTime(now.year, now.month, now.day + 14);

  final group = await ref.read(groupRepositoryProvider).getById(groupId);
  if (group == null) return; // deleted mid-flight — nothing to schedule for.

  final settings = ref.read(notificationSettingsProvider);
  final service = ref.read(groupSessionServiceProvider);
  final occurrences = await service.upcomingOccurrences(
    groupId: groupId,
    from: windowStart,
    to: windowEnd,
  );
  final occurrenceDateTimes = {for (final o in occurrences) o.date: o.dateTime};

  await NotificationService.instance.rescheduleGroupOccurrences(
    groupId: groupId,
    groupName: group.name,
    occurrenceDateTimes: occurrenceDateTimes,
    leadMinutes: settings.groupSessionLeadMinutes,
    windowStart: windowStart,
    windowEnd: windowEnd,
  );
}

/// Cancels a deleted group's upcoming-session reminders — otherwise a
/// dangling notification could still fire for a group that no longer
/// exists.
Future<void> cancelGroupNotifications(int groupId) async {
  final now = DateTime.now();
  await NotificationService.instance.cancelAllGroupOccurrences(
    groupId: groupId,
    windowStart: DateTime(now.year, now.month, now.day),
    windowEnd: DateTime(now.year, now.month, now.day + 14),
  );
}
