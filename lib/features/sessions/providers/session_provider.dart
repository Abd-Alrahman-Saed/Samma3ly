import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/session.dart';
import 'package:quran_mobile/providers.dart';

final sessionDateFilterProvider = StateProvider<DateTimeRange?>((ref) => null);

enum SessionTimeFilter { all, past, upcoming }

final sessionTimeFilterProvider = StateProvider<SessionTimeFilter>((ref) => SessionTimeFilter.all);

final sessionListProvider = FutureProvider.autoDispose<List<Session>>((ref) async {
  final repo = ref.watch(sessionRepositoryProvider);
  final dateFilter = ref.watch(sessionDateFilterProvider);
  return await repo.getAll(from: dateFilter?.start, to: dateFilter?.end);
});

final sessionByIdProvider = FutureProvider.family.autoDispose<Session?, int>((ref, id) async {
  final repo = ref.watch(sessionRepositoryProvider);
  return await repo.getById(id);
});

final sessionsByStudentProvider = FutureProvider.family.autoDispose<List<Session>, int>((ref, studentId) async {
  final repo = ref.watch(sessionRepositoryProvider);
  return await repo.getAll(studentId: studentId);
});

final todaySessionCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final repo = ref.watch(sessionRepositoryProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return await repo.countByDate(today);
});
