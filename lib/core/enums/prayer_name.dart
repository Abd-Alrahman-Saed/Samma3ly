/// The five daily prayers a [GroupScheduleSlots] row can anchor to when
/// `anchorType == AnchorType.prayer` (item 2.3). Kept as an enum — not a
/// free-text `prayerName` column value picked from thin air in the UI — so
/// every layer (schema, `RecurrenceService`, the `adhan`-backed resolver)
/// agrees on the same fixed set of valid Arabic strings.
enum PrayerName {
  fajr('الفجر'),
  dhuhr('الظهر'),
  asr('العصر'),
  maghrib('المغرب'),
  isha('العشاء');

  final String arabic;
  const PrayerName(this.arabic);

  static PrayerName? tryFromArabic(String value) {
    for (final p in PrayerName.values) {
      if (p.arabic == value) return p;
    }
    return null;
  }

  static PrayerName fromArabic(String value) {
    return tryFromArabic(value) ??
        (throw ArgumentError('اسم صلاة غير معروف: "$value"'));
  }
}
