import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/enums/user_role.dart';
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

  test('getTeacher() يُرجع null قبل الإعداد الأولي', () async {
    expect(await service.getTeacher(), isNull);
  });

  test('setupTeacher() ينشئ معلّماً بالاسم فقط بلا أي إدخال لكلمة مرور', () async {
    final teacher = await service.setupTeacher('أحمد المعلم');

    expect(teacher.fullName, 'أحمد المعلم');
    expect(teacher.role, UserRole.admin.value);
    expect(teacher.passwordHash, isNotEmpty, reason: 'العمود إلزامي في المخطط حتى لو لم يُستخدم في أي تحقق لاحقاً');
  });

  test('setupTeacher() يقصّ المسافات الطرفية من الاسم', () async {
    final teacher = await service.setupTeacher('  فاطمة  ');
    expect(teacher.fullName, 'فاطمة');
  });

  test('getTeacher() بعد setupTeacher() يُرجع نفس المعلّم', () async {
    final created = await service.setupTeacher('سعيد');
    final loaded = await service.getTeacher();

    expect(loaded, isNotNull);
    expect(loaded!.id, created.id);
    expect(loaded.fullName, 'سعيد');
  });

  test('getTeacher() يعتمد أول سجل بثبات عند وجود أكثر من مستخدم (بيانات قديمة)', () async {
    await db.into(db.users).insert(UsersCompanion(
          username: const Value('teacher1'),
          passwordHash: const Value('x'),
          fullName: const Value('الأول'),
          role: Value(UserRole.admin.value),
          createdAt: Value(DateTime.now()),
        ));
    await db.into(db.users).insert(UsersCompanion(
          username: const Value('teacher2'),
          passwordHash: const Value('y'),
          fullName: const Value('الثاني'),
          role: Value(UserRole.teacher.value),
          createdAt: Value(DateTime.now()),
        ));

    final teacher = await service.getTeacher();
    expect(teacher!.fullName, 'الأول');
  });

  test('getAllUsers() يُرجع كل السجلات', () async {
    await service.setupTeacher('واحد');
    expect(await service.getAllUsers(), hasLength(1));
  });
}
