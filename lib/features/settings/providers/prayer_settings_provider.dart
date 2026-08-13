import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_mobile/core/enums/prayer_calculation_method.dart';
import 'package:quran_mobile/core/enums/prayer_madhab.dart';
import 'package:quran_mobile/domain/services/adhan_prayer_time_resolver.dart';

/// Sprint 2, item 2.3 — where and how to compute prayer times for
/// `anchorType = 'مرتبط بصلاة'` schedule slots. Defaults to Cairo, since
/// this app targets Egyptian Quran teachers (see `docs/IMPLEMENTATION_PLAN.md`).
class PrayerSettings {
  final double latitude;
  final double longitude;
  final PrayerCalculationMethod calculationMethod;
  final PrayerMadhab madhab;

  const PrayerSettings({
    this.latitude = _cairoLatitude,
    this.longitude = _cairoLongitude,
    this.calculationMethod = PrayerCalculationMethod.egyptian,
    this.madhab = PrayerMadhab.shafi,
  });

  static const _cairoLatitude = 30.0444;
  static const _cairoLongitude = 31.2357;

  PrayerSettings copyWith({
    double? latitude,
    double? longitude,
    PrayerCalculationMethod? calculationMethod,
    PrayerMadhab? madhab,
  }) {
    return PrayerSettings(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhab: madhab ?? this.madhab,
    );
  }
}

const _prefsLatitudeKey = 'prayer_settings_latitude';
const _prefsLongitudeKey = 'prayer_settings_longitude';
const _prefsMethodKey = 'prayer_settings_method';
const _prefsMadhabKey = 'prayer_settings_madhab';

class PrayerSettingsNotifier extends StateNotifier<PrayerSettings> {
  /// Resolves once the initial SharedPreferences read has applied to
  /// [state]. Tests await this instead of a fixed delay, so they aren't
  /// racing the async load (and don't dispose the container while it's
  /// still in flight, which would otherwise throw on the notifier).
  late final Future<void> ready;

  PrayerSettingsNotifier() : super(const PrayerSettings()) {
    ready = _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getDouble(_prefsLatitudeKey);
    final longitude = prefs.getDouble(_prefsLongitudeKey);
    final methodName = prefs.getString(_prefsMethodKey);
    final madhabName = prefs.getString(_prefsMadhabKey);
    state = PrayerSettings(
      latitude: latitude ?? state.latitude,
      longitude: longitude ?? state.longitude,
      calculationMethod: methodName != null ? PrayerCalculationMethod.fromName(methodName) : state.calculationMethod,
      madhab: madhabName != null ? PrayerMadhab.fromName(madhabName) : state.madhab,
    );
  }

  Future<void> setLocation({required double latitude, required double longitude}) async {
    state = state.copyWith(latitude: latitude, longitude: longitude);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefsLatitudeKey, latitude);
    await prefs.setDouble(_prefsLongitudeKey, longitude);
  }

  Future<void> setCalculationMethod(PrayerCalculationMethod method) async {
    state = state.copyWith(calculationMethod: method);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsMethodKey, method.name);
  }

  Future<void> setMadhab(PrayerMadhab madhab) async {
    state = state.copyWith(madhab: madhab);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsMadhabKey, madhab.name);
  }
}

final prayerSettingsProvider = StateNotifierProvider<PrayerSettingsNotifier, PrayerSettings>(
  (ref) => PrayerSettingsNotifier(),
);

/// Ready-to-inject [AdhanPrayerTimeResolver] built from the current
/// [prayerSettingsProvider] state — this is what item 2.4's repositories
/// pass to `RecurrenceService.expand()`/`expandAll()`.
final prayerTimeResolverProvider = Provider<AdhanPrayerTimeResolver>((ref) {
  final settings = ref.watch(prayerSettingsProvider);
  return AdhanPrayerTimeResolver(
    latitude: settings.latitude,
    longitude: settings.longitude,
    calculationMethod: settings.calculationMethod,
    madhab: settings.madhab,
  );
});
