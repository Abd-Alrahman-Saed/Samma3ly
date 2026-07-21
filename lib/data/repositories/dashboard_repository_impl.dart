import 'package:quran_mobile/domain/entities/dashboard_data.dart';
import 'package:quran_mobile/domain/repositories/dashboard_repository.dart';
import 'package:quran_mobile/domain/services/dashboard_service.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardService _dashboardService;

  DashboardRepositoryImpl(this._dashboardService);

  @override
  Future<DashboardData> getDashboardData() => _dashboardService.getDashboardData();
}
