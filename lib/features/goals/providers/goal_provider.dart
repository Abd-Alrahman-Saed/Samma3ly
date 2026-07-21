import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/goal.dart';
import 'package:quran_mobile/providers.dart';

final goalListProvider = FutureProvider.autoDispose<List<Goal>>((ref) async {
  final repo = ref.watch(goalRepositoryProvider);
  return await repo.getAll();
});

final goalsByStudentProvider = FutureProvider.family.autoDispose<List<Goal>, int>((ref, studentId) async {
  final repo = ref.watch(goalRepositoryProvider);
  return await repo.getByStudent(studentId);
});

final activeGoalListProvider = FutureProvider.autoDispose<List<Goal>>((ref) async {
  final repo = ref.watch(goalRepositoryProvider);
  return await repo.getAllActive();
});
