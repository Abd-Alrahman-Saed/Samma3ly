import '../entities/session.dart';

abstract class SessionRepository {
  Future<List<Session>> getAll({int? studentId, DateTime? from, DateTime? to});
  Future<Session?> getById(int id);
  Future<Session> create(Session session);
  Future<Session> update(Session session);
  Future<void> delete(int id);
  Future<int> countByDate(DateTime date);
  Future<List<Session>> getByDateRange(DateTime from, DateTime to);
}
