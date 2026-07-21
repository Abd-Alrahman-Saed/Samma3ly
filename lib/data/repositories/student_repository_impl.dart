import 'package:drift/drift.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/data/local/database/daos/surah_dao.dart';
import 'package:quran_mobile/domain/entities/student.dart';
import 'package:quran_mobile/domain/repositories/student_repository.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Student;

Student _toEntity(dynamic s) => Student(
      id: s.id,
      fullName: s.fullName,
      age: s.age,
      phone: s.phone,
      address: s.address,
      parentName: s.parentName,
      parentPhone: s.parentPhone,
      currentSurahId: s.currentSurahId,
      lastCompletedSurahId: s.lastCompletedSurahId,
      totalCompletedJuz: s.totalCompletedJuz,
      level: s.level,
      createdAt: s.createdAt,
    );

class StudentRepositoryImpl implements StudentRepository {
  final StudentDao _dao;
  final SurahDao _surahDao;

  StudentRepositoryImpl(this._dao, this._surahDao);

  @override
  Future<List<Student>> getAll({String? search}) async {
    return (await _dao.getAll(search: search)).map(_toEntity).toList();
  }

  @override
  Future<Student?> getById(int id) async {
    final s = await _dao.getById(id);
    return s == null ? null : _toEntity(s);
  }

  @override
  Future<Student> create(Student student) async {
    final id = await _dao.insert(StudentsCompanion(
      fullName: Value(student.fullName),
      age: Value(student.age),
      phone: Value(student.phone),
      address: Value(student.address),
      parentName: Value(student.parentName),
      parentPhone: Value(student.parentPhone),
      currentSurahId: Value(student.currentSurahId),
      lastCompletedSurahId: Value(student.lastCompletedSurahId),
      totalCompletedJuz: Value(student.totalCompletedJuz),
      level: Value(student.level),
      createdAt: Value(DateTime.now()),
    ));
    return _toEntity((await _dao.getById(id))!);
  }

  @override
  Future<Student> update(Student student) async {
    await _dao.updateEntry(StudentsCompanion(
      id: Value(student.id),
      fullName: Value(student.fullName),
      age: Value(student.age),
      phone: Value(student.phone),
      address: Value(student.address),
      parentName: Value(student.parentName),
      parentPhone: Value(student.parentPhone),
      currentSurahId: Value(student.currentSurahId),
      lastCompletedSurahId: Value(student.lastCompletedSurahId),
      totalCompletedJuz: Value(student.totalCompletedJuz),
      level: Value(student.level),
      createdAt: Value(student.createdAt ?? DateTime.now()),
    ));
    return _toEntity((await _dao.getById(student.id))!);
  }

  @override
  Future<void> delete(int id) => _dao.deleteById(id);

  @override
  Future<int> count() => _dao.count();

  @override
  Future<int> countWithCompletedSurah() => _dao.countWithCompletedSurah();
}
