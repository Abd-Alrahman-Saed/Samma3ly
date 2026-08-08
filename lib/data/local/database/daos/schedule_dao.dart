import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/schedules_table.dart';

part 'schedule_dao.g.dart';

@DriftAccessor(tables: [Schedules])
class ScheduleDao extends DatabaseAccessor<AppDatabase> with _$ScheduleDaoMixin {
  ScheduleDao(AppDatabase db) : super(db);

  Future<List<Schedule>> getUpcoming({int? studentId}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var query = select(schedules)
      ..where((t) => t.isCompleted.equals(false) & t.date.isBiggerOrEqualValue(today))
      ..orderBy([(t) => OrderingTerm.asc(t.date), (t) => OrderingTerm.asc(t.time)]);
    if (studentId != null) query.where((t) => t.studentId.equals(studentId));
    return query.get();
  }

  Future<Schedule?> getById(int id) => (select(schedules)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insert(SchedulesCompanion entry) => into(schedules).insert(entry);

  Future<bool> updateEntry(SchedulesCompanion entry) => update(schedules).replace(entry);

  Future<int> deleteById(int id) => (delete(schedules)..where((t) => t.id.equals(id))).go();
}
