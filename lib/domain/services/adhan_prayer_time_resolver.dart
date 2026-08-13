import 'package:adhan/adhan.dart' as adhan;
import 'package:quran_mobile/core/enums/prayer_calculation_method.dart';
import 'package:quran_mobile/core/enums/prayer_madhab.dart';
import 'package:quran_mobile/core/enums/prayer_name.dart';
import 'package:quran_mobile/domain/services/recurrence_service.dart';

/// Real, `adhan`-package-backed [PrayerTimeResolver] (item 2.3). The pure
/// recurrence math in [RecurrenceService] never depends on this directly —
/// it only knows the [PrayerTimeResolver] interface — so this class is the
/// one place that actually talks to `package:adhan`.
///
/// [latitude]/[longitude] and [calculationMethod]/[madhab] come from the
/// teacher's Settings (risk R7: prayer times can legitimately differ a few
/// minutes from one mosque to the next, so the calculation method — and,
/// per slot, `offsetMinutes` already in the schema — are both adjustable
/// rather than hard-coded).
class AdhanPrayerTimeResolver implements PrayerTimeResolver {
  final double latitude;
  final double longitude;
  final PrayerCalculationMethod calculationMethod;
  final PrayerMadhab madhab;

  const AdhanPrayerTimeResolver({
    required this.latitude,
    required this.longitude,
    this.calculationMethod = PrayerCalculationMethod.egyptian,
    this.madhab = PrayerMadhab.shafi,
  });

  @override
  DateTime resolve({required DateTime date, required String prayerName}) {
    final prayer = PrayerName.fromArabic(prayerName);
    final coordinates = adhan.Coordinates(latitude, longitude);
    final params = calculationMethod.adhanMethod.getParameters();
    params.madhab = madhab.adhanMadhab;

    final times = adhan.PrayerTimes(
      coordinates,
      adhan.DateComponents.from(DateTime(date.year, date.month, date.day)),
      params,
    );

    final resolved = switch (prayer) {
      PrayerName.fajr => times.fajr,
      PrayerName.dhuhr => times.dhuhr,
      PrayerName.asr => times.asr,
      PrayerName.maghrib => times.maghrib,
      PrayerName.isha => times.isha,
    };

    // `PrayerTimes` (constructed without `.utc`/`.utcOffset`) already
    // returns local `DateTime`s for the exact calendar [date] requested.
    return resolved;
  }
}
