import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/memorized_range.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

final memorizedRangeByStudentProvider = FutureProvider.family.autoDispose<List<MemorizedRange>, int>((ref, studentId) async {
  final repo = ref.watch(memorizedRangeRepositoryProvider);
  return await repo.getByStudent(studentId);
});

class DueReviewItem {
  final MemorizedRange range;
  final int studentId;
  final String studentName;

  const DueReviewItem({required this.range, required this.studentId, required this.studentName});
}

/// Memorized ranges that are overdue for review, or due within the next 3 days,
/// across all students, sorted soonest-first.
final dueForReviewProvider = FutureProvider.autoDispose<List<DueReviewItem>>((ref) async {
  final repo = ref.watch(memorizedRangeRepositoryProvider);
  final students = ref.watch(studentListProvider).valueOrNull ?? const [];
  final cutoff = DateTime.now().add(const Duration(days: 3));

  final items = <DueReviewItem>[];
  for (final student in students) {
    final ranges = await repo.getByStudent(student.id);
    for (final r in ranges) {
      if (r.nextReviewDate != null && r.nextReviewDate!.isBefore(cutoff)) {
        items.add(DueReviewItem(range: r, studentId: student.id, studentName: student.fullName));
      }
    }
  }
  items.sort((a, b) => a.range.nextReviewDate!.compareTo(b.range.nextReviewDate!));
  return items;
});
