import 'package:quran_mobile/domain/entities/user.dart';
import 'package:quran_mobile/domain/repositories/auth_repository.dart';
import 'package:quran_mobile/domain/services/auth_service.dart';

User _toEntity(dynamic u) => User(
      id: u.id,
      username: u.username,
      passwordHash: u.passwordHash,
      fullName: u.fullName,
      role: u.role,
      createdAt: u.createdAt,
    );

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<bool> anyUsersExist() => _authService.anyUsersExist();

  @override
  Future<User?> login(String username, String password) async {
    final u = await _authService.login(username, password);
    return u == null ? null : _toEntity(u);
  }

  @override
  Future<User> createAdmin(String username, String password, String fullName) async {
    return _toEntity(await _authService.createAdmin(username, password, fullName));
  }

  @override
  Future<User> createTeacher(String username, String password, String fullName) async {
    return _toEntity(await _authService.createTeacher(username, password, fullName));
  }

  @override
  Future<List<User>> getAllUsers() async {
    return (await _authService.getAllUsers()).map(_toEntity).toList();
  }
}
