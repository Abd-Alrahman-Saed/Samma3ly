import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/enums/user_role.dart';
import 'package:quran_mobile/core/security/password_hasher.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/user_dao.dart';
import 'package:quran_mobile/domain/services/auth_service.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late UserDao userDao;
  late AuthService service;

  setUp(() {
    db = openTestDatabase();
    userDao = UserDao(db);
    service = AuthService(userDao);
  });

  tearDown(() => db.close());

  test('createAdmin() ثم login() بنفس كلمة السر ينجح، وبكلمة خاطئة يفشل', () async {
    await service.createAdmin('admin', 'كلمة-سر-قوية', 'المدير العام');

    final ok = await service.login('admin', 'كلمة-سر-قوية');
    expect(ok, isNotNull);
    expect(ok!.role, UserRole.admin.value);

    final wrong = await service.login('admin', 'كلمة-غلط');
    expect(wrong, isNull);
  });

  test('createAdmin() يخزّن التجزئة بصيغة PBKDF2 لا SHA-256 القديمة', () async {
    await service.createAdmin('admin', 'س', 'م');
    final user = await userDao.getByUsername('admin');
    expect(PasswordHasher.isLegacyFormat(user!.passwordHash), isFalse);
  });

  test('تسجيل دخول بمستخدم غير موجود يُرجع null', () async {
    expect(await service.login('لا-يوجد', 'أي-شيء'), isNull);
  });

  group('الترقية الشفّافة من SHA-256 القديمة إلى PBKDF2', () {
    Future<int> insertLegacyUser(String username, String password) {
      final salt = 'ثابت-للاختبار';
      final hash = sha256.convert(utf8.encode(password + salt)).toString();
      return db.into(db.users).insert(UsersCompanion(
            username: Value(username),
            passwordHash: Value('$salt:$hash'),
            fullName: const Value('مستخدم قديم'),
            role: Value(UserRole.teacher.value),
            createdAt: Value(DateTime.now()),
          ));
    }

    test('تسجيل دخول ناجح لمستخدم بصيغة قديمة يُرقّي التجزئة المخزّنة تلقائياً', () async {
      await insertLegacyUser('old_teacher', 'كلمة-قديمة');

      final before = await userDao.getByUsername('old_teacher');
      expect(PasswordHasher.isLegacyFormat(before!.passwordHash), isTrue);

      final loggedIn = await service.login('old_teacher', 'كلمة-قديمة');
      expect(loggedIn, isNotNull, reason: 'كلمة السر الصحيحة يجب أن تنجح حتى بالصيغة القديمة');

      final after = await userDao.getByUsername('old_teacher');
      expect(PasswordHasher.isLegacyFormat(after!.passwordHash), isFalse,
          reason: 'بعد نجاح الدخول، التجزئة المخزّنة يجب أن تصبح PBKDF2');

      // وأهم شيء: كلمة السر الأصلية نفسها لازم تفضل شغالة بعد الترقية.
      final loggedInAgain = await service.login('old_teacher', 'كلمة-قديمة');
      expect(loggedInAgain, isNotNull);
    });

    test('محاولة دخول فاشلة بمستخدم قديم لا تُرقّي ولا تكسر شيئاً', () async {
      await insertLegacyUser('old_teacher2', 'كلمة-صحيحة');

      final failed = await service.login('old_teacher2', 'كلمة-خطأ');
      expect(failed, isNull);

      final stillLegacy = await userDao.getByUsername('old_teacher2');
      expect(PasswordHasher.isLegacyFormat(stillLegacy!.passwordHash), isTrue,
          reason: 'لا ترقية بلا نجاح تسجيل دخول فعلي');

      // وكلمة السر الصحيحة لسه شغالة عادي.
      final ok = await service.login('old_teacher2', 'كلمة-صحيحة');
      expect(ok, isNotNull);
    });
  });
}
