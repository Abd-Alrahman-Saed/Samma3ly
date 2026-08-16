import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/session.dart';
import 'package:quran_mobile/providers.dart';

final reportDateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);

final allSessionsReportProvider = FutureProvider.autoDispose<List<Session>>((ref) async {
  final repo = ref.watch(sessionRepositoryProvider);
  final range = ref.watch(reportDateRangeProvider);
  return await repo.getAll(from: range?.start, to: range?.end);
});

/// القسم ح.5 — الطالب المختار حالياً لعرض تقريره الفردي في شاشة التقارير.
/// null يعني "لم يُختر طالب بعد".
final reportSelectedStudentProvider = StateProvider<int?>((ref) => null);
