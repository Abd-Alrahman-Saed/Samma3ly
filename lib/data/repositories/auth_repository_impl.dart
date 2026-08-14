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
  Future<User?> getTeacher() async {
    final u = await _authService.getTeacher();
    return u == null ? null : _toEntity(u);
  }

  @override
  Future<User> setupTeacher(String fullName) async {
    return _toEntity(await _authService.setupTeacher(fullName));
  }

  @override
  Future<List<User>> getAllUsers() async {
    return (await _authService.getAllUsers()).map(_toEntity).toList();
  }
}
