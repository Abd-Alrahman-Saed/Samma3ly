import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/enums/schedule_exception_type.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/domain/services/recurrence_service.dart';

GroupScheduleSlot _fixedSlot({
  int id = 1,
  int groupId = 1,
  required int weekday,
  String fixedTime = '17:00',
  required DateTime effectiveFrom,
  DateTime? effectiveTo,
}) {
  return GroupScheduleSlot(
    id: id,
    groupId: groupId,
    weekday: weekday,
    fixedTime: fixedTime,
    effectiveFrom: effectiveFrom,
    effectiveTo: effectiveTo,
    createdAt: DateTime(2026, 1, 1),
  );
}

ScheduleException _skip({
  int id = 1,
  int groupScheduleSlotId = 1,
  required DateTime occurrenceDate,
}) {
  return ScheduleException(
    id: id,
    groupScheduleSlotId: groupScheduleSlotId,
    occurrenceDate: occurrenceDate,
    exceptionType: ScheduleExceptionType.skip.arabic,
    createdAt: DateTime(2026, 1, 1),
  );
}

ScheduleException _reschedule({
  int id = 1,
  int groupScheduleSlotId = 1,
  required DateTime occurrenceDate,
  DateTime? newDate,
  String? newTime,
}) {
  return ScheduleException(
    id: id,
    groupScheduleSlotId: groupScheduleSlotId,
    occurrenceDate: occurrenceDate,
    exceptionType: ScheduleExceptionType.reschedule.arabic,
    newDate: newDate,
    newTime: newTime,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  final service = RecurrenceService();

  group('توسيع أساسي (weekly expansion)', () {
    test('يولّد موعداً واحداً أسبوعياً في يوم الأسبوع الصحيح', () {
      // Monday slot, 4-week window starting on a Wednesday.
      final slot = _fixedSlot(weekday: DateTime.monday, effectiveFrom: DateTime(2026, 3, 1));
      final result = service.expand(
        slot: slot,
        rangeStart: DateTime(2026, 3, 4), // Wednesday
        rangeEnd: DateTime(2026, 3, 31),
      );

      expect(result, hasLength(4)); // Mondays: 9, 16, 23, 30
      for (final occurrence in result) {
        expect(occurrence.date.weekday, DateTime.monday);
        expect(occurrence.dateTime.hour, 17);
        expect(occurrence.dateTime.minute, 0);
        expect(occurrence.isRescheduled, isFalse);
      }
      expect(result.first.date, DateTime(2026, 3, 9));
      expect(result.last.date, DateTime(2026, 3, 30));
    });

    test('كل موعدين متتاليين يفصل بينهما ٧ أيام تقويمية بالضبط', () {
      final slot = _fixedSlot(weekday: DateTime.friday, effectiveFrom: DateTime(2026, 1, 1));
      final result = service.expand(
        slot: slot,
        rangeStart: DateTime(2026, 1, 1),
        rangeEnd: DateTime(2026, 4, 1),
      );
      for (var i = 1; i < result.length; i++) {
        expect(result[i].date.difference(result[i - 1].date).inDays, 7);
      }
    });

    test('نطاق فارغ (البداية بعد النهاية) يعيد قائمة فارغة', () {
      final slot = _fixedSlot(weekday: DateTime.monday, effectiveFrom: DateTime(2026, 1, 1));
      final result = service.expand(
        slot: slot,
        rangeStart: DateTime(2026, 3, 10),
        rangeEnd: DateTime(2026, 3, 1),
      );
      expect(result, isEmpty);
    });
  });

  group('effectiveFrom / effectiveTo', () {
    test('لا موعد قبل effectiveFrom حتى لو كان داخل نطاق البحث', () {
      final slot = _fixedSlot(weekday: DateTime.monday, effectiveFrom: DateTime(2026, 3, 16));
      final result = service.expand(
        slot: slot,
        rangeStart: DateTime(2026, 3, 1),
        rangeEnd: DateTime(2026, 3, 31),
      );
      // Mondays 2,9 excluded; 16,23,30 included.
      expect(result.map((o) => o.date), [DateTime(2026, 3, 16), DateTime(2026, 3, 23), DateTime(2026, 3, 30)]);
    });

    test('لا موعد بعد effectiveTo حتى لو كان داخل نطاق البحث', () {
      final slot = _fixedSlot(
        weekday: DateTime.monday,
        effectiveFrom: DateTime(2026, 3, 1),
        effectiveTo: DateTime(2026, 3, 20),
      );
      final result = service.expand(
        slot: slot,
        rangeStart: DateTime(2026, 3, 1),
        rangeEnd: DateTime(2026, 3, 31),
      );
      expect(result.map((o) => o.date), [DateTime(2026, 3, 2), DateTime(2026, 3, 9), DateTime(2026, 3, 16)]);
    });

    test('effectiveTo فارغة تعني بلا نهاية (تمتد حتى نهاية نطاق البحث)', () {
      final slot = _fixedSlot(weekday: DateTime.monday, effectiveFrom: DateTime(2026, 1, 1));
      final result = service.expand(
        slot: slot,
        rangeStart: DateTime(2026, 1, 1),
        rangeEnd: DateTime(2027, 1, 1),
      );
      expect(result, isNotEmpty);
      expect(result.last.date.isBefore(DateTime(2027, 1, 2)), isTrue);
    });
  });

  group('حدود الشهر والسنة', () {
    test('التكرار يعبر نهاية الشهر بشكل صحيح', () {
      // Last Monday of Jan 2026 is the 26th; +7 lands on Feb 2nd.
      final slot = _fixedSlot(weekday: DateTime.monday, effectiveFrom: DateTime(2026, 1, 20));
      final result = service.expand(
        slot: slot,
        rangeStart: DateTime(2026, 1, 20),
        rangeEnd: DateTime(2026, 2, 5),
      );
      expect(result.map((o) => o.date), [DateTime(2026, 1, 26), DateTime(2026, 2, 2)]);
    });

    test('التكرار يعبر نهاية السنة بشكل صحيح', () {
      final slot = _fixedSlot(weekday: DateTime.thursday, effectiveFrom: DateTime(2026, 12, 20));
      final result = service.expand(
        slot: slot,
        rangeStart: DateTime(2026, 12, 20),
        rangeEnd: DateTime(2027, 1, 10),
      );
      expect(result.map((o) => o.date), [DateTime(2026, 12, 24), DateTime(2026, 12, 31), DateTime(2027, 1, 7)]);
    });
  });

  group('أمان التوقيت الصيفي (DST)', () {
    test('وقت اليوم (الساعة:الدقيقة) يبقى ثابتاً لكل المواعيد رغم عبور حدود شهرية/فصلية متعددة', () {
      // RecurrenceService steps dates via DateTime(y, m, day + 7) rather
      // than `.add(Duration(days: 7))` specifically so this holds even when
      // the 7-day step crosses a DST transition in the host time zone (a
      // `Duration`-based step would shift the wall-clock hour by ±1 there).
      final slot = _fixedSlot(weekday: DateTime.sunday, effectiveFrom: DateTime(2026, 3, 1));
      final result = service.expand(
        slot: slot,
        rangeStart: DateTime(2026, 3, 1),
        rangeEnd: DateTime(2026, 11, 30),
      );
      expect(result, isNotEmpty);
      for (final occurrence in result) {
        expect(occurrence.dateTime.hour, 17);
        expect(occurrence.dateTime.minute, 0);
      }
    });
  });

  group('الاستثناءات', () {
    test('استثناء "إلغاء" يحذف الموعد المطابق فقط', () {
      final slot = _fixedSlot(weekday: DateTime.monday, effectiveFrom: DateTime(2026, 3, 1));
      final result = service.expand(
        slot: slot,
        exceptions: [_skip(occurrenceDate: DateTime(2026, 3, 16))],
        rangeStart: DateTime(2026, 3, 1),
        rangeEnd: DateTime(2026, 3, 31),
      );
      expect(result.map((o) => o.date), [DateTime(2026, 3, 2), DateTime(2026, 3, 9), DateTime(2026, 3, 23), DateTime(2026, 3, 30)]);
    });

    test('استثناء "إعادة جدولة" بتاريخ جديد فقط يبقي وقت الحلقة الأصلي', () {
      final slot = _fixedSlot(weekday: DateTime.monday, effectiveFrom: DateTime(2026, 3, 1), fixedTime: '17:00');
      final result = service.expand(
        slot: slot,
        exceptions: [_reschedule(occurrenceDate: DateTime(2026, 3, 9), newDate: DateTime(2026, 3, 11))],
        rangeStart: DateTime(2026, 3, 1),
        rangeEnd: DateTime(2026, 3, 15),
      );
      final moved = result.firstWhere((o) => o.isRescheduled);
      expect(moved.date, DateTime(2026, 3, 11));
      expect(moved.dateTime, DateTime(2026, 3, 11, 17, 0));
      // The original Monday slot no longer appears.
      expect(result.any((o) => o.date == DateTime(2026, 3, 9)), isFalse);
    });

    test('استثناء "إعادة جدولة" بتاريخ ووقت جديدين يستخدم كليهما', () {
      final slot = _fixedSlot(weekday: DateTime.monday, effectiveFrom: DateTime(2026, 3, 1), fixedTime: '17:00');
      final result = service.expand(
        slot: slot,
        exceptions: [
          _reschedule(
            occurrenceDate: DateTime(2026, 3, 9),
            newDate: DateTime(2026, 3, 12),
            newTime: '20:30',
          ),
        ],
        rangeStart: DateTime(2026, 3, 1),
        rangeEnd: DateTime(2026, 3, 15),
      );
      final moved = result.firstWhere((o) => o.isRescheduled);
      expect(moved.dateTime, DateTime(2026, 3, 12, 20, 30));
    });

    test('إعادة جدولة بلا تاريخ جديد تبقي نفس التاريخ وتغيّر الوقت فقط', () {
      final slot = _fixedSlot(weekday: DateTime.monday, effectiveFrom: DateTime(2026, 3, 1), fixedTime: '17:00');
      final result = service.expand(
        slot: slot,
        exceptions: [_reschedule(occurrenceDate: DateTime(2026, 3, 9), newTime: '19:00')],
        rangeStart: DateTime(2026, 3, 1),
        rangeEnd: DateTime(2026, 3, 15),
      );
      final moved = result.firstWhere((o) => o.isRescheduled);
      expect(moved.date, DateTime(2026, 3, 9));
      expect(moved.dateTime, DateTime(2026, 3, 9, 19, 0));
    });

    test('إعادة جدولة إلى تاريخ خارج نطاق البحث تُسقَط', () {
      final slot = _fixedSlot(weekday: DateTime.monday, effectiveFrom: DateTime(2026, 3, 1));
      final result = service.expand(
        slot: slot,
        exceptions: [_reschedule(occurrenceDate: DateTime(2026, 3, 9), newDate: DateTime(2026, 4, 15))],
        rangeStart: DateTime(2026, 3, 1),
        rangeEnd: DateTime(2026, 3, 15),
      );
      expect(result.any((o) => o.isRescheduled), isFalse);
      expect(result.any((o) => o.date == DateTime(2026, 3, 9)), isFalse);
    });

    test('استثناءات حلقة أخرى (groupScheduleSlotId مختلف) تُتجاهَل', () {
      final slot = _fixedSlot(id: 1, weekday: DateTime.monday, effectiveFrom: DateTime(2026, 3, 1));
      final result = service.expand(
        slot: slot,
        exceptions: [_skip(groupScheduleSlotId: 99, occurrenceDate: DateTime(2026, 3, 9))],
        rangeStart: DateTime(2026, 3, 1),
        rangeEnd: DateTime(2026, 3, 15),
      );
      expect(result.map((o) => o.date), [DateTime(2026, 3, 2), DateTime(2026, 3, 9)]);
    });
  });

  group('حالات دفاعية (بيانات غير متسقة)', () {
    test('بلا fixedTime يرمي StateError', () {
      final slot = GroupScheduleSlot(
        id: 1,
        groupId: 1,
        weekday: DateTime.monday,
        effectiveFrom: DateTime(2026, 3, 1),
        createdAt: DateTime(2026, 1, 1),
      );
      expect(
        () => service.expand(slot: slot, rangeStart: DateTime(2026, 3, 1), rangeEnd: DateTime(2026, 3, 10)),
        throwsA(isA<StateError>()),
      );
    });

    test('نوع استثناء غير معروف يرمي StateError', () {
      final slot = _fixedSlot(weekday: DateTime.monday, effectiveFrom: DateTime(2026, 3, 1));
      final badException = ScheduleException(
        id: 1,
        groupScheduleSlotId: slot.id,
        occurrenceDate: DateTime(2026, 3, 2),
        exceptionType: 'غير ذلك',
        createdAt: DateTime(2026, 1, 1),
      );
      expect(
        () => service.expand(
          slot: slot,
          exceptions: [badException],
          rangeStart: DateTime(2026, 3, 1),
          rangeEnd: DateTime(2026, 3, 10),
        ),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('expandAll — بوابة الخروج (Sprint 2)', () {
    test('حلقة بثلاثة مواعيد أسبوعية تعرض ٢٤ موعداً صحيحاً على مدى شهرين (٨ أسابيع)', () {
      final effectiveFrom = DateTime(2026, 3, 2); // Monday
      final slots = [
        _fixedSlot(id: 1, weekday: DateTime.monday, fixedTime: '16:00', effectiveFrom: effectiveFrom),
        _fixedSlot(id: 2, weekday: DateTime.wednesday, fixedTime: '17:00', effectiveFrom: effectiveFrom),
        _fixedSlot(id: 3, weekday: DateTime.saturday, fixedTime: '10:00', effectiveFrom: effectiveFrom),
      ];
      // Exactly 8 full weeks starting the same Monday.
      final rangeEnd = effectiveFrom.add(const Duration(days: 55)); // 8 weeks - 1 day

      final result = service.expandAll(
        slots: slots,
        rangeStart: effectiveFrom,
        rangeEnd: rangeEnd,
      );

      expect(result, hasLength(24));
      // Sorted chronologically.
      for (var i = 1; i < result.length; i++) {
        expect(result[i].dateTime.isAfter(result[i - 1].dateTime), isTrue);
      }
    });
  });
}
