import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:quran_mobile/data/local/database/daos/user_dao.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

class AuthService {
  final UserDao _userDao;

  AuthService(this._userDao);

  Future<bool> anyUsersExist() => _userDao.anyUsersExist();

  Future<User?> login(String username, String password) async {
    final user = await _userDao.getByUsername(username);
    if (user == null) return null;
    if (!_verifyPassword(password, user.passwordHash)) return null;
    return user;
  }

  Future<User> createAdmin(String username, String password, String fullName) async {
    final id = await _userDao.insert(UsersCompanion(
      username: Value(username),
      passwordHash: Value(_hashPassword(password)),
      fullName: Value(fullName),
      role: const Value('Admin'),
      createdAt: Value(DateTime.now()),
    ));
    return (await _userDao.getById(id))!;
  }

  Future<User> createTeacher(String username, String password, String fullName) async {
    final id = await _userDao.insert(UsersCompanion(
      username: Value(username),
      passwordHash: Value(_hashPassword(password)),
      fullName: Value(fullName),
      role: const Value('Teacher'),
      createdAt: Value(DateTime.now()),
    ));
    return (await _userDao.getById(id))!;
  }

  Future<List<User>> getAllUsers() => _userDao.getAll();

  String _hashPassword(String password) {
    final salt = _generateSalt();
    final hash = _sha256Hash(password, salt);
    return '$salt:$hash';
  }

  bool _verifyPassword(String password, String stored) {
    final parts = stored.split(':');
    if (parts.length != 2) return false;
    final salt = parts[0];
    final hash = parts[1];
    return _sha256Hash(password, salt) == hash;
  }

  String _sha256Hash(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    return sha256.convert(bytes).toString();
  }

  String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }
}
