import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/schedule.dart';
import 'package:quran_mobile/providers.dart';

final upcomingScheduleListProvider = FutureProvider.autoDispose<List<Schedule>>((ref) async {
  final repo = ref.watch(scheduleRepositoryProvider);
  return await repo.getUpcoming();
});

final scheduleByIdProvider = FutureProvider.family.autoDispose<Schedule?, int>((ref, id) async {
  final repo = ref.watch(scheduleRepositoryProvider);
  return await repo.getById(id);
});
