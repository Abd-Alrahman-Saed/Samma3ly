import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/enums/memorized_status.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/memorized_range_dao.dart';
import 'package:quran_mobile/domain/services/memorized_range_service.dart';

import '../../helpers/query_counter.dart';
import '../../helpers/test_database.dart';

void main() {
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  late AppDatabase db;
  late MemorizedRangeDao dao;
  late MemorizedRangeService service;

  setUp(() {
    db = openTestDatabase();
    dao = MemorizedRangeDao(db);
    service = MemorizedRangeService(dao);
  });

  tearDown(() => db.close());

  Future<int> insertStudent(AppDatabase database) {
    return database.into(database.students).insert(const StudentsCompanion(
          fullName: Value('طالب تجريبي'),
          age: Value(10),
          phone: Value('0100000000'),
          address: Value('عنوان'),
        ));
  }

  Future<int> insertRange(
    AppDatabase database, {
    required int studentId,
    DateTime? nextReviewDate,
    String status = 'محفوظ',
  }) {
    return database.into(database.memorizedRanges).insert(MemorizedRangesCompanion(
          studentId: Value(studentId),
          surahId: const Value(1),
          fromAyah: const Value(1),
          toAyah: const Value(7),
          status: Value(status),
          nextReviewDate: Value(nextReviewDate),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));
  }

  test('نطاق مستحقّ المراجعة يظهر بحالة "يحتاج مراجعة" محسوبة، بلا تعديل مخزّن', () async {
    final studentId = await insertStudent(db);
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await insertRange(db, studentId: studentId, nextReviewDate: yesterday);

    final result = await service.getByStudent(studentId);

    expect(result, hasLength(1));
    expect(result.first.status, MemorizedStatus.needsRevision.arabic);

    // الحالة المخزّنة فعلياً في قاعدة البيانات تفضل "محفوظ" — التحويل
    // للعرض بس، مش كتابة (بند 0.6).
    final stored = await dao.getById(result.first.id);
    expect(stored!.status, MemorizedStatus.memorized.arabic);
  });

  test('نطاق غير مستحقّ المراجعة بعد يفضل بحالته الأصلية', () async {
    final studentId = await insertStudent(db);
    final nextWeek = DateTime.now().add(const Duration(days: 7));
    await insertRange(db, studentId: studentId, nextReviewDate: nextWeek);

    final result = await service.getByStudent(studentId);

    expect(result.first.status, MemorizedStatus.memorized.arabic);
  });

  test('استدعاء getByStudent مرتين متتاليين لا يُصدر أي UPDATE على قاعدة البيانات', () async {
    final interceptor = QueryCountInterceptor();
    final countedDb = openCountedTestDatabase(interceptor);
    addTearDown(countedDb.close);
    final countedDao = MemorizedRangeDao(countedDb);
    final countedService = MemorizedRangeService(countedDao);

    final studentId = await insertStudent(countedDb);
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await insertRange(countedDb, studentId: studentId, nextReviewDate: yesterday);

    interceptor.totalCount = 0;
    await countedService.getByStudent(studentId);
    await countedService.getByStudent(studentId);

    // صفر عمليات كتابة (UPDATE/INSERT) — القراءة المتكرّرة لا تُنتج أي أثر
    // جانبي على القرص، ولا تُعطّل drift's watch() streams.
    expect(interceptor.totalCount, greaterThan(0), reason: 'لازم يبقى فيه SELECTs على الأقل');
    // كل الاستعلامات المُنفَّذة SELECT فقط.
    expect(interceptor.selectCount, interceptor.totalCount,
        reason: 'صفر INSERT/UPDATE — كل الاستدعاءات SELECT بحتة');
  });
}
