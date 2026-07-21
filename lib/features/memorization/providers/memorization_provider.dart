import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/memorized_range.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

final memorizedRangeByStudentProvider = FutureProvider.family.autoDispose<List<MemorizedRange>, int>((ref, studentId) async {
  final repo = ref.watch(memorizedRangeRepositoryProvider);
  return await repo.getByStudent(studentId);
});

final overdueMemorizedRangesProvider = FutureProvider.autoDispose<List<MemorizedRange>>((ref) async {
  final repo = ref.watch(memorizedRangeRepositoryProvider);
  final now = DateTime.now();
  final allStudents = ref.watch(studentListProvider);
  final all = <MemorizedRange>[];
  final students = allStudents.valueOrNull ?? [];
  for (final student in students) {
    final ranges = await repo.getByStudent(student.id!);
    all.addAll(ranges.where((r) => r.nextReviewDate != null && r.nextReviewDate!.isBefore(now)));
  }
  return all;
});
