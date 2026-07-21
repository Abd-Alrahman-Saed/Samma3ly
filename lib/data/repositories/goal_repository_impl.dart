import 'package:drift/drift.dart';
import 'package:quran_mobile/data/local/database/daos/goal_dao.dart';
import 'package:quran_mobile/domain/entities/goal.dart';
import 'package:quran_mobile/domain/repositories/goal_repository.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Goal;

Goal _toEntity(dynamic g) => Goal(
      id: g.id,
      studentId: g.studentId,
      title: g.title,
      goalType: g.goalType,
      targetSurahId: g.targetSurahId,
      targetJuzNumber: g.targetJuzNumber,
      startDate: g.startDate,
      targetDate: g.targetDate,
      status: g.status,
      createdAt: g.createdAt,
    );

class GoalRepositoryImpl implements GoalRepository {
  final GoalDao _dao;

  GoalRepositoryImpl(this._dao);

  @override
  Future<List<Goal>> getByStudent(int studentId) async {
    return (await _dao.getByStudent(studentId)).map(_toEntity).toList();
  }

  @override
  Future<List<Goal>> getAll() async {
    return (await _dao.getAll()).map(_toEntity).toList();
  }

  @override
  Future<List<Goal>> getAllActive() async {
    return (await _dao.getAllActive()).map(_toEntity).toList();
  }

  @override
  Future<Goal> create(Goal goal) async {
    final id = await _dao.insert(GoalsCompanion(
      studentId: Value(goal.studentId),
      title: Value(goal.title),
      goalType: Value(goal.goalType),
      targetSurahId: Value(goal.targetSurahId),
      targetJuzNumber: Value(goal.targetJuzNumber),
      startDate: Value(goal.startDate),
      targetDate: Value(goal.targetDate),
      status: Value(goal.status),
      createdAt: Value(DateTime.now()),
    ));
    return _toEntity((await _dao.getById(id))!);
  }

  @override
  Future<Goal> update(Goal goal) async {
    await _dao.updateEntry(GoalsCompanion(
      id: Value(goal.id),
      studentId: Value(goal.studentId),
      title: Value(goal.title),
      goalType: Value(goal.goalType),
      targetSurahId: Value(goal.targetSurahId),
      targetJuzNumber: Value(goal.targetJuzNumber),
      startDate: Value(goal.startDate),
      targetDate: Value(goal.targetDate),
      status: Value(goal.status),
      createdAt: Value(goal.createdAt ?? DateTime.now()),
    ));
    return _toEntity((await _dao.getById(goal.id))!);
  }

  @override
  Future<void> delete(int id) => _dao.deleteById(id);
}
