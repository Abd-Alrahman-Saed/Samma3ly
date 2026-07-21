import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/students_table.dart';

part 'student_dao.g.dart';

@DriftAccessor(tables: [Students])
class StudentDao extends DatabaseAccessor<AppDatabase> with _$StudentDaoMixin {
  StudentDao(AppDatabase db) : super(db);

  Future<List<Student>> getAll({String? search}) {
    if (search != null && search.isNotEmpty) {
      return (select(students)..where((t) => t.fullName.contains(search))).get();
    }
    return select(students).get();
  }

  Future<Student?> getById(int id) => (select(students)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insert(StudentsCompanion entry) => into(students).insert(entry);

  Future<bool> updateEntry(StudentsCompanion entry) => (update(students)..where((t) => t.id.equals(entry.id.value))).replace(entry);

  Future<int> deleteById(int id) => (delete(students)..where((t) => t.id.equals(id))).go();

  Future<int> count() => select(students).get().then((list) => list.length);

  Future<int> countWithCompletedSurah() =>
      (select(students)..where((t) => t.lastCompletedSurahId.isNotNull())).get().then((list) => list.length);
}
