import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/enums/anchor_type.dart';
import 'package:quran_mobile/core/enums/prayer_calculation_method.dart';
import 'package:quran_mobile/core/enums/prayer_madhab.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/domain/services/adhan_prayer_time_resolver.dart';
import 'package:quran_mobile/domain/services/recurrence_service.dart';

void main() {
  // Cairo, Egypt — the app's default location (see PrayerSettings).
  const resolver = AdhanPrayerTimeResolver(latitude: 30.0444, longitude: 31.2357);

  group('AdhanPrayerTimeResolver', () {
    test('يرتّب الصلوات الخمس زمنياً بشكل صحيح في أي يوم', () {
      for (final date in [DateTime(2026, 1, 15), DateTime(2026, 6, 21), DateTime(2026, 12, 21)]) {
        final fajr = resolver.resolve(date: date, prayerName: 'الفجر');
        final dhuhr = resolver.resolve(date: date, prayerName: 'الظهر');
        final asr = resolver.resolve(date: date, prayerName: 'العصر');
        final maghrib = resolver.resolve(date: date, prayerName: 'المغرب');
        final isha = resolver.resolve(date: date, prayerName: 'العشاء');

        expect(fajr.isBefore(dhuhr), isTrue, reason: 'fajr < dhuhr on $date');
        expect(dhuhr.isBefore(asr), isTrue, reason: 'dhuhr < asr on $date');
        expect(asr.isBefore(maghrib), isTrue, reason: 'asr < maghrib on $date');
        expect(maghrib.isBefore(isha), isTrue, reason: 'maghrib < isha on $date');
      }
    });

    test('كل الأوقات المحسوبة تقع في نفس التاريخ المطلوب', () {
      final date = DateTime(2026, 3, 15);
      for (final prayer in ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء']) {
        final resolved = resolver.resolve(date: date, prayerName: prayer);
        expect(resolved.year, date.year);
        expect(resolved.month, date.month);
        expect(resolved.day, date.day);
      }
    });

    test('وقت المغرب منطقي (بين الساعة ١٦ و٢٠) في القاهرة على مدار السنة', () {
      // Sanity bound, not an exact oracle: Cairo's Maghrib never falls
      // outside roughly 16:50–19:40 local time across the year.
      for (final date in [DateTime(2026, 1, 1), DateTime(2026, 4, 1), DateTime(2026, 7, 1), DateTime(2026, 10, 1)]) {
        final maghrib = resolver.resolve(date: date, prayerName: 'المغرب');
        expect(maghrib.hour, inInclusiveRange(16, 20));
      }
    });

    test('المغرب في الصيف يقع لاحقاً منه في الشتاء (يعكس تغيّر طول النهار)', () {
      final winterMaghrib = resolver.resolve(date: DateTime(2026, 1, 1), prayerName: 'المغرب');
      final summerMaghrib = resolver.resolve(date: DateTime(2026, 7, 1), prayerName: 'المغرب');
      expect(summerMaghrib.hour * 60 + summerMaghrib.minute, greaterThan(winterMaghrib.hour * 60 + winterMaghrib.minute));
    });

    test('نفس الصلاة تُعطي وقتاً مختلفاً كل يوم (لا قيمة ثابتة)', () {
      final day1 = resolver.resolve(date: DateTime(2026, 3, 1), prayerName: 'المغرب');
      final day2 = resolver.resolve(date: DateTime(2026, 3, 15), prayerName: 'المغرب');
      expect(day1, isNot(equals(day2)));
    });

    test('تغيير طريقة الحساب يغيّر الوقت المحسوب', () {
      const egyptianResolver = AdhanPrayerTimeResolver(latitude: 30.0444, longitude: 31.2357);
      const karachiResolver = AdhanPrayerTimeResolver(
        latitude: 30.0444,
        longitude: 31.2357,
        calculationMethod: PrayerCalculationMethod.karachi,
      );
      final date = DateTime(2026, 3, 15);
      final egyptianFajr = egyptianResolver.resolve(date: date, prayerName: 'الفجر');
      final karachiFajr = karachiResolver.resolve(date: date, prayerName: 'الفجر');
      // Different methods use different Fajr sun-angle conventions.
      expect(egyptianFajr, isNot(equals(karachiFajr)));
    });

    test('تغيير المذهب يغيّر وقت العصر المحسوب فقط', () {
      const shafiResolver = AdhanPrayerTimeResolver(latitude: 30.0444, longitude: 31.2357);
      const hanafiResolver = AdhanPrayerTimeResolver(
        latitude: 30.0444,
        longitude: 31.2357,
        madhab: PrayerMadhab.hanafi,
      );
      final date = DateTime(2026, 3, 15);
      final shafiAsr = shafiResolver.resolve(date: date, prayerName: 'العصر');
      final hanafiAsr = hanafiResolver.resolve(date: date, prayerName: 'العصر');
      // Hanafi's Asr is always later than Shafi's (shadow-length ratio 2 vs 1).
      expect(hanafiAsr.isAfter(shafiAsr), isTrue);

      final shafiFajr = shafiResolver.resolve(date: date, prayerName: 'الفجر');
      final hanafiFajr = hanafiResolver.resolve(date: date, prayerName: 'الفجر');
      expect(shafiFajr, hanafiFajr); // madhab only affects Asr
    });

    test('اسم صلاة غير معروف يرمي ArgumentError', () {
      expect(
        () => resolver.resolve(date: DateTime(2026, 3, 1), prayerName: 'غير موجود'),
        throwsArgumentError,
      );
    });
  });

  group('التكامل مع RecurrenceService', () {
    test('حلقة مرتبطة بصلاة المغرب + إزاحة تعطي وقتاً صحيحاً ومختلفاً كل أسبوع', () {
      final service = RecurrenceService();
      final slot = GroupScheduleSlot(
        id: 1,
        groupId: 1,
        weekday: DateTime.tuesday,
        anchorType: AnchorType.prayer.arabic,
        prayerName: 'المغرب',
        offsetMinutes: 15,
        effectiveFrom: DateTime(2026, 3, 1),
        createdAt: DateTime(2026, 1, 1),
      );

      final result = service.expand(
        slot: slot,
        rangeStart: DateTime(2026, 3, 1),
        rangeEnd: DateTime(2026, 3, 31),
        prayerTimeResolver: resolver,
      );

      expect(result, isNotEmpty);
      for (final occurrence in result) {
        final rawMaghrib = resolver.resolve(date: occurrence.date, prayerName: 'المغرب');
        expect(occurrence.dateTime, rawMaghrib.add(const Duration(minutes: 15)));
      }
      // "يحسب وقتاً صحيحاً لكل يوم" (2.3's definition of done): consecutive
      // occurrences must NOT share the same clock time, since Maghrib
      // itself shifts day to day.
      final distinctTimes = result.map((o) => (o.dateTime.hour, o.dateTime.minute)).toSet();
      expect(distinctTimes.length, greaterThan(1));
    });
  });
}
