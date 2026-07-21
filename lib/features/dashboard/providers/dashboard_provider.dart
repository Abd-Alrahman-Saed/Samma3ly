import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/dashboard_data.dart';
import 'package:quran_mobile/providers.dart';

final dashboardProvider = FutureProvider.autoDispose<DashboardData>((ref) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  return await repo.getDashboardData();
});
