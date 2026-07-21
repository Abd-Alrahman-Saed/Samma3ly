import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/session.dart';
import 'package:quran_mobile/providers.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';

final attendanceDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final todayAttendanceProvider = FutureProvider.autoDispose<List<Session>>((ref) async {
  final repo = ref.watch(sessionRepositoryProvider);
  final date = ref.watch(attendanceDateProvider);
  final dayStart = DateTime(date.year, date.month, date.day);
  final dayEnd = dayStart.add(const Duration(days: 1));
  return await repo.getByDateRange(dayStart, dayEnd);
});

final attendanceSummaryProvider = FutureProvider.autoDispose<Map<AttendanceStatus, int>>((ref) async {
  final sessions = ref.watch(todayAttendanceProvider).valueOrNull ?? [];
  final summary = <AttendanceStatus, int>{};
  for (final status in AttendanceStatus.values) {
    summary[status] = 0;
  }
  for (final session in sessions) {
    final status = AttendanceStatus.fromArabic(session.attendanceStatus);
    summary[status] = (summary[status] ?? 0) + 1;
  }
  return summary;
});
