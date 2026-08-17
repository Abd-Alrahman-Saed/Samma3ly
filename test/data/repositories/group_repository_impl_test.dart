import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Group;
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/data/repositories/group_repository_impl.dart';
import 'package:quran_mobile/domain/entities/group.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late GroupDao dao;
  late StudentDao studentDao;
  late GroupRepositoryImpl repo;

  setUp(() {
    db = openTestDatabase();
    dao = GroupDao(db);
    studentDao = StudentDao(db);
    repo = GroupRepositoryImpl(dao);
  });

  tearDown(() => db.close());

  Future<int> insertStudent({String name = 'طالب تجريبي'}) {
    return studentDao.insert(StudentsCompanion.insert(
      fullName: name,
      age: 10,
      phone: '0100000000',
      address: 'القاهرة',
      createdAt: Value(DateTime.now()),
    ));
  }

  group('GroupRepositoryImpl — Groups CRUD', () {
    test('create() ثم getById() يعيدان نفس البيانات', () async {
      final created = await repo.create(const Group(name: 'حلقة النور'));
      expect(created.id, greaterThan(0));
      expect(created.name, 'حلقة النور');

      final fetched = await repo.getById(created.id);
      expect(fetched, isNotNull);
      expect(fetched!.name, 'حلقة النور');
    });

    test('getAll() يعيد كل المجموعات المُنشأة', () async {
      await repo.create(const Group(name: 'أ'));
      await repo.create(const Group(name: 'ب'));
      final all = await repo.getAll();
      expect(all.map((g) => g.name), containsAll(['أ', 'ب']));
    });

    test('update() يعدّل الاسم مع الحفاظ على المعرّف', () async {
      final created = await repo.create(const Group(name: 'قديم'));
      final updated = await repo.update(created.copyWith(name: 'جديد'));
      expect(updated.id, created.id);
      expect(updated.name, 'جديد');
    });

    test('getById() لمجموعة غير موجودة يعيد null', () async {
      expect(await repo.getById(999), isNull);
    });
  });

  group('GroupRepositoryImpl — الأعضاء', () {
    test('addMember() ثم getMembers() يعيد الطالب المُضاف', () async {
      final group = await repo.create(const Group(name: 'حلقة'));
      final studentId = await insertStudent();

      await repo.addMember(group.id, studentId);
      final members = await repo.getMembers(group.id);

      expect(members, hasLength(1));
      expect(members.first.studentId, studentId);
      expect(members.first.groupId, group.id);
    });

    test('إضافة نفس الطالب مرتين لا تُنشئ صفّاً مكرَّراً', () async {
      final group = await repo.create(const Group(name: 'حلقة'));
      final studentId = await insertStudent();

      await repo.addMember(group.id, studentId);
      await repo.addMember(group.id, studentId);

      expect(await repo.getMembers(group.id), hasLength(1));
    });

    test('removeMember() يحذف الطالب من المجموعة فقط', () async {
      final group = await repo.create(const Group(name: 'حلقة'));
      final s1 = await insertStudent(name: 'أحمد');
      final s2 = await insertStudent(name: 'محمد');
      await repo.addMember(group.id, s1);
      await repo.addMember(group.id, s2);

      await repo.removeMember(group.id, s1);

      final members = await repo.getMembers(group.id);
      expect(members, hasLength(1));
      expect(members.first.studentId, s2);
    });
  });

  group('GroupRepositoryImpl — delete() المتتالي (cascade يدوي)', () {
    test('حذف مجموعة يحذف أعضاءها ومواعيدها واستثناءاتها أيضاً', () async {
      final group = await repo.create(const Group(name: 'حلقة للحذف'));
      final studentId = await insertStudent();
      await repo.addMember(group.id, studentId);

      final slotId = await dao.insertSlot(GroupScheduleSlotsCompanion.insert(
        groupId: group.id,
        weekday: 1,
        fixedTime: const Value('17:00'),
        effectiveFrom: DateTime(2026, 1, 1),
      ));
      await dao.insertException(ScheduleExceptionsCompanion.insert(
        groupScheduleSlotId: slotId,
        occurrenceDate: DateTime(2026, 1, 5),
        exceptionType: 'إلغاء',
      ));

      await repo.delete(group.id);

      expect(await repo.getById(group.id), isNull);
      expect(await dao.getMembers(group.id), isEmpty);
      expect(await dao.getSlots(group.id), isEmpty);
      expect(await dao.getExceptions(slotId), isEmpty);
    });
  });
}
