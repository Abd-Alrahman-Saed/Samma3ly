import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/group.dart';
import 'package:quran_mobile/domain/entities/group_member.dart';
import 'package:quran_mobile/domain/entities/group_schedule_slot.dart';
import 'package:quran_mobile/domain/entities/schedule_exception.dart';
import 'package:quran_mobile/domain/entities/session.dart';
import 'package:quran_mobile/domain/services/group_session_service.dart';
import 'package:quran_mobile/features/settings/providers/prayer_settings_provider.dart';
import 'package:quran_mobile/providers.dart';

/// Bumped after any create/update/delete to invalidate the `refreshable*`
/// providers below — same pattern as `studentRefreshProvider`.
final groupRefreshProvider = StateProvider<int>((ref) => 0);

final groupListProvider = FutureProvider.autoDispose<List<Group>>((ref) async {
  final repo = ref.watch(groupRepositoryProvider);
  return await repo.getAll();
});

final refreshableGroupListProvider = FutureProvider.autoDispose<List<Group>>((ref) async {
  ref.watch(groupRefreshProvider);
  final repo = ref.watch(groupRepositoryProvider);
  return await repo.getAll();
});

final groupCountProvider = FutureProvider.autoDispose<int>((ref) async {
  ref.watch(groupRefreshProvider);
  final repo = ref.watch(groupRepositoryProvider);
  return (await repo.getAll()).length;
});

final groupByIdProvider = FutureProvider.family.autoDispose<Group?, int>((ref, id) async {
  ref.watch(groupRefreshProvider);
  final repo = ref.watch(groupRepositoryProvider);
  return await repo.getById(id);
});

final groupMembersProvider = FutureProvider.family.autoDispose<List<GroupMember>, int>((ref, groupId) async {
  ref.watch(groupRefreshProvider);
  final repo = ref.watch(groupRepositoryProvider);
  return await repo.getMembers(groupId);
});

final groupMemberCountProvider = FutureProvider.family.autoDispose<int, int>((ref, groupId) async {
  final members = await ref.watch(groupMembersProvider(groupId).future);
  return members.length;
});

final groupSlotsProvider = FutureProvider.family.autoDispose<List<GroupScheduleSlot>, int>((ref, groupId) async {
  ref.watch(groupRefreshProvider);
  final repo = ref.watch(groupScheduleRepositoryProvider);
  return await repo.getSlots(groupId);
});

final slotExceptionsProvider = FutureProvider.family.autoDispose<List<ScheduleException>, int>((ref, slotId) async {
  ref.watch(groupRefreshProvider);
  final repo = ref.watch(groupScheduleRepositoryProvider);
  return await repo.getExceptions(slotId);
});

/// Occurrences for a group within [from, to], merged with any already-
/// materialized `Sessions` rows (item 2.7) — see
/// [GroupSessionService.upcomingOccurrences]. Resolves prayer times via
/// `prayerTimeResolverProvider` (item 2.3) so prayer-anchored slots work
/// without the caller wiring anything extra. Pure read: never materializes
/// anything itself (item 2.7's exit gate — viewing must not write).
typedef GroupOccurrencesQuery = ({int groupId, DateTime from, DateTime to});

final groupOccurrencesProvider =
    FutureProvider.family.autoDispose<List<GroupOccurrence>, GroupOccurrencesQuery>((ref, query) async {
  ref.watch(groupRefreshProvider);
  final service = ref.watch(groupSessionServiceProvider);
  final resolver = ref.watch(prayerTimeResolverProvider);
  return await service.upcomingOccurrences(
    groupId: query.groupId,
    from: query.from,
    to: query.to,
    prayerTimeResolver: resolver,
  );
});

// ── الحلقة المباشرة (Sprint 3، بند 3.1-3.4) ──────────────────────────────

/// Bumped after any attendance change in the live-session screen — kept
/// separate from [groupRefreshProvider] so a swipe/tap doesn't also
/// re-fetch members/slots/exceptions it didn't touch.
final sessionAttendanceRefreshProvider = StateProvider.family<int, int>((ref, sessionId) => 0);

final groupLiveSessionProvider = FutureProvider.family.autoDispose<Session?, int>((ref, sessionId) async {
  final repo = ref.watch(sessionRepositoryProvider);
  return await repo.getById(sessionId);
});

/// studentId -> attendance-status Arabic literal, for every attendance row
/// recorded so far in this session. A student with no entry here hasn't
/// been marked yet (distinct from any of the four real statuses).
final sessionAttendanceMapProvider = FutureProvider.family.autoDispose<Map<int, String>, int>((ref, sessionId) async {
  ref.watch(sessionAttendanceRefreshProvider(sessionId));
  final dao = ref.watch(sessionDaoProvider);
  final rows = await dao.getAttendancesForSession(sessionId);
  return {for (final r in rows) r.studentId: r.attendanceStatus};
});
