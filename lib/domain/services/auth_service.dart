import 'dart:math';

import 'package:drift/drift.dart';
import 'package:quran_mobile/core/enums/user_role.dart';
import 'package:quran_mobile/data/local/database/daos/user_dao.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

class AuthService {
  final UserDao _userDao;

  AuthService(this._userDao);

  /// المعلّم الوحيد المسجَّل على هذا الجهاز، أو null قبل الإعداد الأولي.
  /// التطبيق شخصي لمعلّم واحد؛ إن وُجد أكثر من سجل (بيانات قديمة من نسخة
  /// سابقة تعدّدت فيها الحسابات) يُعتمد أول سجل بثبات.
  Future<User?> getTeacher() async {
    final all = await _userDao.getAll();
    return all.isEmpty ? null : all.first;
  }

  /// الإعداد الأولي — بالاسم فقط، بلا كلمة مرور. عمود passwordHash ما زال
  /// إلزامياً في الجدول (NOT NULL) فيُملأ بقيمة عشوائية غير مستخدمة في أي
  /// تحقق لاحق (لا يوجد تسجيل دخول أصلاً)، تفادياً لأي تعديل في المخطط.
  Future<User> setupTeacher(String fullName) async {
    final id = await _userDao.insert(UsersCompanion(
      username: const Value('teacher'),
      passwordHash: Value(_unusedPlaceholderSecret()),
      fullName: Value(fullName.trim()),
      role: Value(UserRole.admin.value),
      createdAt: Value(DateTime.now()),
    ));
    return (await _userDao.getById(id))!;
  }

  Future<List<User>> getAllUsers() => _userDao.getAll();

  String _unusedPlaceholderSecret() {
    final rand = Random.secure();
    return List.generate(32, (_) => rand.nextInt(256)).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
