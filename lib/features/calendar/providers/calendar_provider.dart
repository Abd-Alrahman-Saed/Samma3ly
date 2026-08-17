import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/services/weekly_calendar_service.dart';
import 'package:quran_mobile/features/groups/providers/group_provider.dart';
import 'package:quran_mobile/providers.dart';

/// Item 3.6 — the weekly calendar's data: individual sessions merged with
/// every group's occurrences (virtual and materialized) for a date range.
typedef WeekQuery = ({DateTime from, DateTime to});

final weekEntriesProvider = FutureProvider.family.autoDispose<List<CalendarEntry>, WeekQuery>((ref, query) async {
  // Refreshes alongside anything that can change a week's contents —
  // sessions created/edited, or a group's schedule/materialization state.
  ref.watch(groupRefreshProvider);
  final service = ref.watch(weeklyCalendarServiceProvider);
  return await service.getEntries(from: query.from, to: query.to);
});
