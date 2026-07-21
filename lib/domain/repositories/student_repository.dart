import '../entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getAll({String? search});
  Future<Student?> getById(int id);
  Future<Student> create(Student student);
  Future<Student> update(Student student);
  Future<void> delete(int id);
  Future<int> count();
  Future<int> countWithCompletedSurah();
}
