import '../entities/goal.dart';

abstract class GoalRepository {
  Future<List<Goal>> getByStudent(int studentId);
  Future<List<Goal>> getAll();
  Future<List<Goal>> getAllActive();
  Future<Goal> create(Goal goal);
  Future<Goal> update(Goal goal);
  Future<void> delete(int id);
}
