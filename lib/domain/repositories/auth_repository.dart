import '../entities/user.dart';

/// تطبيق شخصي لمعلّم واحد بلا كلمة مرور: لا "تسجيل دخول" ولا "تسجيل خروج"،
/// فقط إعداد أولي مرة واحدة بالاسم، ثم تحميل تلقائي لاحقاً.
abstract class AuthRepository {
  /// المعلّم المسجَّل على هذا الجهاز، أو null إن لم يتم الإعداد الأولي بعد.
  Future<User?> getTeacher();

  /// الإعداد الأولي: يُنشئ حساب المعلّم الوحيد بالاسم فقط.
  Future<User> setupTeacher(String fullName);

  Future<List<User>> getAllUsers();
}
