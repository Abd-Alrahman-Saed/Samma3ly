// Regression guard for a real bug found while adding item 3.6 (weekly
// calendar): AppDateUtils.weekStart had never had a caller before, and its
// original formula computed the *next* Sunday instead of the current
// week's start on any day but Sunday itself. `now` isn't injectable here,
// so these assert the invariants that formula violated, rather than a
// fixed date — still fails deterministically against the old bug on any
// day of the week the suite happens to run.
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';

void main() {
  group('AppDateUtils.weekStart', () {
    test('يقع دايماً يوم أحد', () {
      expect(AppDateUtils.weekStart.weekday, DateTime.sunday);
    });

    test('لا يقع أبداً في المستقبل — دايماً اليوم أو قبله', () {
      final today = DateTime.now();
      final todayDateOnly = DateTime(today.year, today.month, today.day);
      expect(AppDateUtils.weekStart.isAfter(todayDateOnly), isFalse);
    });

    test('اليوم يقع دايماً ضمن نطاق [weekStart, weekStart + 6 أيام]', () {
      final today = DateTime.now();
      final todayDateOnly = DateTime(today.year, today.month, today.day);
      final weekStart = AppDateUtils.weekStart;
      final weekLastDay = DateTime(weekStart.year, weekStart.month, weekStart.day + 6);
      expect(todayDateOnly.isBefore(weekStart), isFalse);
      expect(todayDateOnly.isAfter(weekLastDay), isFalse);
    });
  });

  group('AppDateUtils.weekEnd', () {
    test('يساوي weekStart + ٧ أيام بالضبط', () {
      final expected = DateTime(
        AppDateUtils.weekStart.year,
        AppDateUtils.weekStart.month,
        AppDateUtils.weekStart.day + 7,
      );
      expect(AppDateUtils.weekEnd, expected);
    });
  });
}
