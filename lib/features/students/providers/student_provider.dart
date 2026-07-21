import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/student.dart';
import 'package:quran_mobile/providers.dart';

final studentSearchProvider = StateProvider<String>((ref) => '');

final studentListProvider = FutureProvider.autoDispose<List<Student>>((ref) async {
  final repo = ref.watch(studentRepositoryProvider);
  final search = ref.watch(studentSearchProvider);
  return await repo.getAll(search: search.isEmpty ? null : search);
});

final studentByIdProvider = FutureProvider.family.autoDispose<Student?, int>((ref, id) async {
  final repo = ref.watch(studentRepositoryProvider);
  return await repo.getById(id);
});

final studentCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final repo = ref.watch(studentRepositoryProvider);
  return await repo.count();
});

final studentRefreshProvider = StateProvider<int>((ref) => 0);

final refreshableStudentListProvider = FutureProvider.autoDispose<List<Student>>((ref) async {
  ref.watch(studentRefreshProvider);
  final repo = ref.watch(studentRepositoryProvider);
  final search = ref.watch(studentSearchProvider);
  return await repo.getAll(search: search.isEmpty ? null : search);
});

final surahListProvider = FutureProvider.autoDispose<List>((ref) async {
  final dao = ref.watch(surahDaoProvider);
  return await dao.getAll();
});
