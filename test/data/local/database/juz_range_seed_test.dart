// Regression guard for item 0.4b: the `_juzRangeData` seed in
// app_database.dart was previously corrupted (juz 20-30 all miscoded as
// juz 30; juz 3/4/5 boundaries also off by one surah-split) — hand-typed
// with no cited source. It was rebuilt from two independent, cross-checked
// public APIs (see the comment above `_juzRangeData`). This test locks in
// the structural invariants that made that verification possible, so a
// future hand-edit that reintroduces a similar corruption fails loudly
// here instead of silently shipping.
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  test('juzSurahRanges: كل الأجزاء الثلاثين ممثَّلة، ولا يوجد أي جزء منهار في جزء آخر', () async {
    final rows = await db.select(db.juzSurahRanges).get();
    final juzNumbers = rows.map((r) => r.juzNumber).toSet();

    expect(juzNumbers, equals(Set.from(List.generate(30, (i) => i + 1))),
        reason: 'يجب أن تظهر كل الأجزاء من ١ إلى ٣٠ — لا انهيار جزء داخل آخر');
  });

  test('كل جزء يبدأ عند نهاية الجزء السابق مباشرة بلا فجوة أو تداخل', () async {
    final rows = await db.select(db.juzSurahRanges).get();
    final surahAyahCounts = <int, int>{
      for (final s in await db.select(db.surahs).get()) s.id: s.ayahCount,
    };

    // آخر (سورة، آية) لكل جزء
    final lastOf = <int, (int surahId, int ayah)>{};
    // أول (سورة، آية) لكل جزء
    final firstOf = <int, (int surahId, int ayah)>{};
    for (final r in rows) {
      final current = firstOf[r.juzNumber];
      if (current == null || r.surahId < current.$1) {
        firstOf[r.juzNumber] = (r.surahId, r.fromAyah);
      }
      final currentLast = lastOf[r.juzNumber];
      if (currentLast == null || r.surahId > currentLast.$1) {
        lastOf[r.juzNumber] = (r.surahId, r.toAyah);
      }
    }

    (int, int) nextAyah(int surahId, int ayah) {
      final count = surahAyahCounts[surahId]!;
      return ayah < count ? (surahId, ayah + 1) : (surahId + 1, 1);
    }

    for (var n = 1; n < 30; n++) {
      final last = lastOf[n]!;
      final expectedNext = nextAyah(last.$1, last.$2);
      final actualNext = firstOf[n + 1]!;
      expect(
        (actualNext.$1, actualNext.$2),
        equals(expectedNext),
        reason: 'فجوة أو تداخل بين الجزء $n والجزء ${n + 1}',
      );
    }
  });

  test('الجزء ١ يبدأ عند الفاتحة ١ والجزء ٣٠ ينتهي عند الناس ٦', () async {
    final rows = await db.select(db.juzSurahRanges).get();
    final juz1 = rows.where((r) => r.juzNumber == 1).toList()..sort((a, b) => a.surahId.compareTo(b.surahId));
    final juz30 = rows.where((r) => r.juzNumber == 30).toList()..sort((a, b) => a.surahId.compareTo(b.surahId));

    expect(juz1.first.surahId, 1);
    expect(juz1.first.fromAyah, 1);
    expect(juz30.last.surahId, 114);
    expect(juz30.last.toAyah, 6);
  });

  test('كل نطاق ضمن حدود عدد آيات سورته', () async {
    final rows = await db.select(db.juzSurahRanges).get();
    final surahAyahCounts = <int, int>{
      for (final s in await db.select(db.surahs).get()) s.id: s.ayahCount,
    };

    for (final r in rows) {
      expect(r.fromAyah, lessThanOrEqualTo(r.toAyah), reason: 'جزء ${r.juzNumber} سورة ${r.surahId}');
      expect(r.toAyah, lessThanOrEqualTo(surahAyahCounts[r.surahId]!), reason: 'جزء ${r.juzNumber} سورة ${r.surahId}');
    }
  });
}
