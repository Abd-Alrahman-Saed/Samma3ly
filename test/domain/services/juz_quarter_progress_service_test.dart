import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/juz_quarter_progress_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/domain/services/juz_quarter_progress_service.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late JuzQuarterProgressDao dao;
  late JuzQuarterProgressService service;
  late int studentId;

  setUp(() async {
    db = openTestDatabase();
    dao = JuzQuarterProgressDao(db);
    service = JuzQuarterProgressService(dao);
    studentId = await StudentDao(db).insert(
      StudentsCompanion.insert(fullName: 'طالب', age: 10, phone: '0100000000', address: 'عنوان'),
    );
  });

  tearDown(() => db.close());

  test('طالب جديد بلا أي ربع محفوظ — النسبة الكلية صفر', () async {
    final completed = await service.getCompleted(studentId);
    expect(completed, isEmpty);
    expect(JuzQuarterProgressService.overallPercentage(completed), 0);
  });

  test('تعليم ربع واحد محفوظاً يظهر في القراءة التالية', () async {
    await service.setQuarterCompleted(studentId, 5, 3, true);

    final completed = await service.getCompleted(studentId);
    expect(completed, contains((5, 3)));
    expect(JuzQuarterProgressService.completedQuartersInJuz(completed, 5), 1);
  });

  test('تعليم نفس الربع محفوظاً مرتين لا يكرّر الصفّ (idempotent)', () async {
    await service.setQuarterCompleted(studentId, 1, 1, true);
    await service.setQuarterCompleted(studentId, 1, 1, true);

    final completed = await service.getCompleted(studentId);
    expect(completed.where((c) => c == (1, 1)), hasLength(1));
  });

  test('إلغاء تعليم ربع يحذفه من المكتمل', () async {
    await service.setQuarterCompleted(studentId, 2, 4, true);
    await service.setQuarterCompleted(studentId, 2, 4, false);

    final completed = await service.getCompleted(studentId);
    expect(completed, isEmpty);
  });

  test('إلغاء تعليم ربع غير موجود أصلاً لا يفشل (idempotent)', () async {
    await service.setQuarterCompleted(studentId, 9, 9, false);
    expect(await service.getCompleted(studentId), isEmpty);
  });

  test('جزء كامل (8 أرباع) يعطي نسبة 100% لذلك الجزء فقط، والنسبة الكلية 8/240', () async {
    for (var q = 1; q <= 8; q++) {
      await service.setQuarterCompleted(studentId, 7, q, true);
    }
    final completed = await service.getCompleted(studentId);

    expect(JuzQuarterProgressService.juzPercentage(completed, 7), 100);
    expect(JuzQuarterProgressService.juzPercentage(completed, 8), 0, reason: 'جزء آخر لم يُلمَس يجب أن يبقى صفراً');
    expect(JuzQuarterProgressService.overallPercentage(completed), closeTo(8 / 240 * 100, 0.0001));
  });

  test('تقدّم كل طالب مستقلّ عن الآخر', () async {
    final student2 = await StudentDao(db).insert(
      StudentsCompanion.insert(fullName: 'طالب آخر', age: 11, phone: '0100000001', address: 'عنوان'),
    );

    await service.setQuarterCompleted(studentId, 10, 1, true);

    expect(await service.getCompleted(studentId), contains((10, 1)));
    expect(await service.getCompleted(student2), isEmpty);
  });
}
