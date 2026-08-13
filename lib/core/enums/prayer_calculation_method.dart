import 'package:adhan/adhan.dart' as adhan;

/// The prayer-time calculation methods offered in Settings (item 2.3,
/// risk R7: users can pick the method closest to their mosque instead of
/// the app guessing one). Wraps `package:adhan`'s [adhan.CalculationMethod]
/// rather than exposing it directly, so persisted settings (stored by
/// `.name`) stay stable even if the upstream package ever renumbers or
/// renames its own enum.
enum PrayerCalculationMethod {
  muslimWorldLeague('رابطة العالم الإسلامي', adhan.CalculationMethod.muslim_world_league),
  egyptian('الهيئة المصرية العامة للمساحة', adhan.CalculationMethod.egyptian),
  karachi('جامعة العلوم الإسلامية - كراتشي', adhan.CalculationMethod.karachi),
  ummAlQura('أم القرى - مكة المكرمة', adhan.CalculationMethod.umm_al_qura),
  dubai('دبي', adhan.CalculationMethod.dubai),
  moonSightingCommittee('لجنة رؤية الهلال', adhan.CalculationMethod.moon_sighting_committee),
  northAmerica('أمريكا الشمالية (ISNA)', adhan.CalculationMethod.north_america),
  kuwait('الكويت', adhan.CalculationMethod.kuwait),
  qatar('قطر', adhan.CalculationMethod.qatar),
  singapore('سنغافورة', adhan.CalculationMethod.singapore),
  tehran('طهران', adhan.CalculationMethod.tehran),
  turkey('تركيا (Diyanet)', adhan.CalculationMethod.turkey),
  other('مخصص', adhan.CalculationMethod.other);

  final String arabicLabel;
  final adhan.CalculationMethod adhanMethod;
  const PrayerCalculationMethod(this.arabicLabel, this.adhanMethod);

  static PrayerCalculationMethod fromName(String name) {
    return PrayerCalculationMethod.values.firstWhere(
      (m) => m.name == name,
      orElse: () => PrayerCalculationMethod.egyptian,
    );
  }
}
