import '../entities/user.dart';

abstract class AuthRepository {
  Future<bool> anyUsersExist();
  Future<User?> login(String username, String password);
  Future<User> createAdmin(String username, String password, String fullName);
  Future<User> createTeacher(String username, String password, String fullName);
  Future<List<User>> getAllUsers();
}
