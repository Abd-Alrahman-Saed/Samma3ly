import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_mobile/core/enums/prayer_calculation_method.dart';
import 'package:quran_mobile/core/enums/prayer_madhab.dart';
import 'package:quran_mobile/features/settings/providers/prayer_settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('PrayerSettingsNotifier', () {
    test('الحالة الافتراضية هي القاهرة + الهيئة المصرية + الشافعي', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      // Let the async _load() from SharedPreferences settle.
      await container.read(prayerSettingsProvider.notifier).ready;

      final settings = container.read(prayerSettingsProvider);
      expect(settings.latitude, closeTo(30.0444, 0.001));
      expect(settings.longitude, closeTo(31.2357, 0.001));
      expect(settings.calculationMethod, PrayerCalculationMethod.egyptian);
      expect(settings.madhab, PrayerMadhab.shafi);
    });

    test('setLocation يحدّث الحالة ويحفظها في SharedPreferences', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(prayerSettingsProvider.notifier).ready;

      await container.read(prayerSettingsProvider.notifier).setLocation(latitude: 21.4225, longitude: 39.8262);

      expect(container.read(prayerSettingsProvider).latitude, closeTo(21.4225, 0.001));
      expect(container.read(prayerSettingsProvider).longitude, closeTo(39.8262, 0.001));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('prayer_settings_latitude'), closeTo(21.4225, 0.001));
    });

    test('setCalculationMethod و setMadhab يحدّثان الحالة ويُحفظان', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(prayerSettingsProvider.notifier).ready;

      await container.read(prayerSettingsProvider.notifier).setCalculationMethod(PrayerCalculationMethod.karachi);
      await container.read(prayerSettingsProvider.notifier).setMadhab(PrayerMadhab.hanafi);

      expect(container.read(prayerSettingsProvider).calculationMethod, PrayerCalculationMethod.karachi);
      expect(container.read(prayerSettingsProvider).madhab, PrayerMadhab.hanafi);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('prayer_settings_method'), 'karachi');
      expect(prefs.getString('prayer_settings_madhab'), 'hanafi');
    });

    test('القيم المحفوظة سابقاً تُحمَّل عند إنشاء notifier جديد', () async {
      SharedPreferences.setMockInitialValues({
        'prayer_settings_latitude': 24.4667,
        'prayer_settings_longitude': 39.6111,
        'prayer_settings_method': 'ummAlQura',
        'prayer_settings_madhab': 'hanafi',
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(prayerSettingsProvider.notifier).ready;

      final settings = container.read(prayerSettingsProvider);
      expect(settings.latitude, closeTo(24.4667, 0.001));
      expect(settings.longitude, closeTo(39.6111, 0.001));
      expect(settings.calculationMethod, PrayerCalculationMethod.ummAlQura);
      expect(settings.madhab, PrayerMadhab.hanafi);
    });
  });

  group('prayerTimeResolverProvider', () {
    test('يبني resolver من إعدادات prayerSettingsProvider الحالية', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(prayerSettingsProvider.notifier).ready;

      await container.read(prayerSettingsProvider.notifier).setLocation(latitude: 21.4225, longitude: 39.8262);
      await container.read(prayerSettingsProvider.notifier).setCalculationMethod(PrayerCalculationMethod.ummAlQura);

      final resolver = container.read(prayerTimeResolverProvider);
      expect(resolver.latitude, closeTo(21.4225, 0.001));
      expect(resolver.longitude, closeTo(39.8262, 0.001));
      expect(resolver.calculationMethod, PrayerCalculationMethod.ummAlQura);
    });
  });
}
