// Item 3.5 — pure decision logic only (GroupNotificationPlanner). The
// actual flutter_local_notifications plugin calls in NotificationService
// go through a platform channel and are not unit-tested here, matching
// this project's existing precedent (the pre-Sprint-3 review-reminder
// scheduling was never unit-tested either) — what IS tested is "what
// should be scheduled/cancelled", which is where the real logic (and the
// risk of a bug) lives.
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/services/notification_service.dart';

void main() {
  group('GroupNotificationPlanner.occurrenceNotificationId', () {
    test('حتمي — نفس المدخلات تعطي نفس المعرّف دايماً', () {
      final id1 = GroupNotificationPlanner.occurrenceNotificationId(5, DateTime(2026, 3, 9));
      final id2 = GroupNotificationPlanner.occurrenceNotificationId(5, DateTime(2026, 3, 9));
      expect(id1, id2);
    });

    test('مجموعتان مختلفتان بنفس التاريخ يعطيان معرّفين مختلفين', () {
      final id1 = GroupNotificationPlanner.occurrenceNotificationId(1, DateTime(2026, 3, 9));
      final id2 = GroupNotificationPlanner.occurrenceNotificationId(2, DateTime(2026, 3, 9));
      expect(id1, isNot(id2));
    });

    test('نفس المجموعة بتاريخين مختلفين يعطيان معرّفين مختلفين', () {
      final id1 = GroupNotificationPlanner.occurrenceNotificationId(1, DateTime(2026, 3, 9));
      final id2 = GroupNotificationPlanner.occurrenceNotificationId(1, DateTime(2026, 3, 16));
      expect(id1, isNot(id2));
    });
  });

  group('GroupNotificationPlanner.plan', () {
    test('تاريخ له موعد فعلي يحصل على fireAt = وقت الجلسة ناقص مهلة التذكير', () {
      final plan = GroupNotificationPlanner.plan(
        groupId: 1,
        occurrenceDateTimes: {DateTime(2026, 3, 9): DateTime(2026, 3, 9, 17, 0)},
        leadMinutes: 30,
        windowStart: DateTime(2026, 3, 9),
        windowEnd: DateTime(2026, 3, 9),
        now: DateTime(2026, 3, 1),
      );
      expect(plan, hasLength(1));
      expect(plan.first.fireAt, DateTime(2026, 3, 9, 16, 30));
    });

    test('تاريخ بلا موعد (اتحذف/اتلغى) يحصل على fireAt=null — يعني إلغاء', () {
      final plan = GroupNotificationPlanner.plan(
        groupId: 1,
        occurrenceDateTimes: const {},
        leadMinutes: 30,
        windowStart: DateTime(2026, 3, 9),
        windowEnd: DateTime(2026, 3, 9),
        now: DateTime(2026, 3, 1),
      );
      expect(plan, hasLength(1));
      expect(plan.first.fireAt, isNull);
    });

    test('وقت الإطلاق في الماضي يُعامَل كإلغاء لا جدولة فورية', () {
      final plan = GroupNotificationPlanner.plan(
        groupId: 1,
        occurrenceDateTimes: {DateTime(2026, 3, 9): DateTime(2026, 3, 9, 17, 0)},
        leadMinutes: 30,
        windowStart: DateTime(2026, 3, 9),
        windowEnd: DateTime(2026, 3, 9),
        now: DateTime(2026, 3, 9, 16, 45), // already past 16:30 fire time
      );
      expect(plan.first.fireAt, isNull);
    });

    test('النافذة الزمنية تنتج قراراً واحداً لكل يوم تقويمي بالضبط', () {
      final plan = GroupNotificationPlanner.plan(
        groupId: 1,
        occurrenceDateTimes: {DateTime(2026, 3, 9): DateTime(2026, 3, 9, 17, 0)},
        leadMinutes: 30,
        windowStart: DateTime(2026, 3, 1),
        windowEnd: DateTime(2026, 3, 10),
        now: DateTime(2026, 3, 1),
      );
      expect(plan, hasLength(10)); // March 1 through 10 inclusive
      expect(plan.map((e) => e.date), contains(DateTime(2026, 3, 9)));
      // Every day except the 9th has no occurrence -> cancel.
      final march9 = plan.firstWhere((e) => e.date == DateTime(2026, 3, 9));
      expect(march9.fireAt, isNotNull);
      final others = plan.where((e) => e.date != DateTime(2026, 3, 9));
      expect(others.every((e) => e.fireAt == null), isTrue);
    });

    test('كل يوم في الخطة له نفس المعرّف اللي بيرجّعه occurrenceNotificationId', () {
      final plan = GroupNotificationPlanner.plan(
        groupId: 7,
        occurrenceDateTimes: const {},
        leadMinutes: 10,
        windowStart: DateTime(2026, 3, 9),
        windowEnd: DateTime(2026, 3, 9),
        now: DateTime(2026, 3, 1),
      );
      expect(plan.first.id, GroupNotificationPlanner.occurrenceNotificationId(7, DateTime(2026, 3, 9)));
    });
  });
}
