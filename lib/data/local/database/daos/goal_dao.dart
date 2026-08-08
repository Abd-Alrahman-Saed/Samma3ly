import 'package:drift/drift.dart';
import 'package:quran_mobile/core/enums/goal_status.dart';
import '../app_database.dart';
import '../tables/goals_table.dart';

part 'goal_dao.g.dart';

@DriftAccessor(tables: [Goals])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin {
  GoalDao(AppDatabase db) : super(db);

  Future<List<Goal>> getByStudent(int studentId) =>
      (select(goals)..where((t) => t.studentId.equals(studentId))..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

  Future<List<Goal>> getAll() => select(goals).get();

  Future<List<Goal>> getAllActive() =>
      (select(goals)..where((t) => t.status.isNotValue(GoalStatus.completed.arabic))).get();

  Future<Goal?> getById(int id) => (select(goals)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insert(GoalsCompanion entry) => into(goals).insert(entry);

  Future<bool> updateEntry(GoalsCompanion entry) => update(goals).replace(entry);

  Future<int> deleteById(int id) => (delete(goals)..where((t) => t.id.equals(id))).go();
}
