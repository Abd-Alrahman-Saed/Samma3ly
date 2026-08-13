import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/group.dart';
import 'package:quran_mobile/domain/entities/group_member.dart';
import 'package:quran_mobile/domain/entities/group_schedule_slot.dart';
import 'package:quran_mobile/domain/entities/schedule_exception.dart';
import 'package:quran_mobile/domain/services/recurrence_service.dart';
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

/// Occurrences for a group within [from, to] — see
/// [GroupScheduleRepository.expandOccurrences] (item 2.4). Resolves prayer
/// times via `prayerTimeResolverProvider` (item 2.3) so prayer-anchored
/// slots work without the caller wiring anything extra.
typedef GroupOccurrencesQuery = ({int groupId, DateTime from, DateTime to});

final groupOccurrencesProvider =
    FutureProvider.family.autoDispose<List<RecurrenceOccurrence>, GroupOccurrencesQuery>((ref, query) async {
  ref.watch(groupRefreshProvider);
  final repo = ref.watch(groupScheduleRepositoryProvider);
  final resolver = ref.watch(prayerTimeResolverProvider);
  return await repo.expandOccurrences(
    groupId: query.groupId,
    from: query.from,
    to: query.to,
    prayerTimeResolver: resolver,
  );
});
