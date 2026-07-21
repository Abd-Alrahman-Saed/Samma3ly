import '../entities/schedule.dart';
import '../entities/session.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>> getUpcoming({int? studentId});
  Future<Schedule?> getById(int id);
  Future<Schedule> create(Schedule schedule);
  Future<Schedule> update(Schedule schedule);
  Future<void> delete(int id);
  Future<Session> convertToSession(int scheduleId);
}
