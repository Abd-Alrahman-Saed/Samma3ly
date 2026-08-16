import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/providers.dart';

/// يُزاد بعد كل تعليم/إلغاء تعليم ربع (explicit call — never inside a read
/// provider، بند 0.6) لإجبار `juzQuarterProgressProvider` على إعادة القراءة.
final juzQuarterProgressRefreshProvider = StateProvider.family<int, int>((ref, studentId) => 0);

final juzQuarterProgressProvider = FutureProvider.family<Set<(int, int)>, int>((ref, studentId) async {
  ref.watch(juzQuarterProgressRefreshProvider(studentId));
  final service = ref.watch(juzQuarterProgressServiceProvider);
  return service.getCompleted(studentId);
});
