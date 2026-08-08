import 'package:drift/drift.dart';
import 'package:quran_mobile/core/enums/user_role.dart';
import 'package:quran_mobile/core/security/password_hasher.dart';
import 'package:quran_mobile/data/local/database/daos/user_dao.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

class AuthService {
  final UserDao _userDao;

  AuthService(this._userDao);

  Future<bool> anyUsersExist() => _userDao.anyUsersExist();

  Future<User?> login(String username, String password) async {
    final user = await _userDao.getByUsername(username);
    if (user == null) return null;
    if (!await PasswordHasher.verify(password, user.passwordHash)) return null;

    // ترقية شفّافة: مستخدم بصيغة SHA-256 وحيدة الجولة (ما قبل Sprint 0)
    // يُرقّى تلقائياً إلى PBKDF2 بمجرد نجاح تسجيل الدخول — بلا أي إجراء
    // إضافي من المستخدم، وبلا تحويل جماعي محفوف بالمخاطر لكل السجلات دفعة واحدة.
    if (PasswordHasher.isLegacyFormat(user.passwordHash)) {
      final upgradedHash = await PasswordHasher.hash(password);
      await _userDao.updateEntry(UsersCompanion(
        id: Value(user.id),
        username: Value(user.username),
        passwordHash: Value(upgradedHash),
        fullName: Value(user.fullName),
        role: Value(user.role),
        createdAt: Value(user.createdAt),
      ));
      return user.copyWith(passwordHash: upgradedHash);
    }

    return user;
  }

  Future<User> createAdmin(String username, String password, String fullName) async {
    final id = await _userDao.insert(UsersCompanion(
      username: Value(username),
      passwordHash: Value(await PasswordHasher.hash(password)),
      fullName: Value(fullName),
      role: Value(UserRole.admin.value),
      createdAt: Value(DateTime.now()),
    ));
    return (await _userDao.getById(id))!;
  }

  Future<User> createTeacher(String username, String password, String fullName) async {
    final id = await _userDao.insert(UsersCompanion(
      username: Value(username),
      passwordHash: Value(await PasswordHasher.hash(password)),
      fullName: Value(fullName),
      role: Value(UserRole.teacher.value),
      createdAt: Value(DateTime.now()),
    ));
    return (await _userDao.getById(id))!;
  }

  Future<List<User>> getAllUsers() => _userDao.getAll();
}
