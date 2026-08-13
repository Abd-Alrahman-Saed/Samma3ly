import 'package:adhan/adhan.dart' as adhan;

/// Which jurisprudential school determines the Asr calculation (Hanafi's
/// Asr falls later than the other schools). Only affects `Asr`; kept
/// separate from [PrayerCalculationMethod] because `package:adhan` treats
/// them as independent settings too.
enum PrayerMadhab {
  shafi('الشافعي/المالكي/الحنبلي', adhan.Madhab.shafi),
  hanafi('الحنفي', adhan.Madhab.hanafi);

  final String arabicLabel;
  final adhan.Madhab adhanMadhab;
  const PrayerMadhab(this.arabicLabel, this.adhanMadhab);

  static PrayerMadhab fromName(String name) {
    return PrayerMadhab.values.firstWhere(
      (m) => m.name == name,
      orElse: () => PrayerMadhab.shafi,
    );
  }
}
