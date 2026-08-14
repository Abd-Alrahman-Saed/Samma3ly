import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_mobile/features/settings/providers/notification_settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('NotificationSettingsNotifier', () {
    test('الحالة الافتراضية: مراجعة الساعة ٩:٠٠، تذكير الحلقات قبلها بـ٣٠ دقيقة', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(notificationSettingsProvider.notifier).ready;

      final settings = container.read(notificationSettingsProvider);
      expect(settings.reviewReminderHour, 9);
      expect(settings.reviewReminderMinute, 0);
      expect(settings.groupSessionLeadMinutes, 30);
    });

    test('setReviewReminderTime يحدّث الحالة ويحفظها', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(notificationSettingsProvider.notifier).ready;

      await container.read(notificationSettingsProvider.notifier).setReviewReminderTime(hour: 20, minute: 15);

      expect(container.read(notificationSettingsProvider).reviewReminderHour, 20);
      expect(container.read(notificationSettingsProvider).reviewReminderMinute, 15);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('notification_settings_review_hour'), 20);
      expect(prefs.getInt('notification_settings_review_minute'), 15);
    });

    test('setGroupSessionLeadMinutes يحدّث الحالة ويحفظها', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(notificationSettingsProvider.notifier).ready;

      await container.read(notificationSettingsProvider.notifier).setGroupSessionLeadMinutes(15);

      expect(container.read(notificationSettingsProvider).groupSessionLeadMinutes, 15);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('notification_settings_group_lead_minutes'), 15);
    });

    test('القيم المحفوظة سابقاً تُحمَّل عند إنشاء notifier جديد', () async {
      SharedPreferences.setMockInitialValues({
        'notification_settings_review_hour': 21,
        'notification_settings_review_minute': 30,
        'notification_settings_group_lead_minutes': 45,
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(notificationSettingsProvider.notifier).ready;

      final settings = container.read(notificationSettingsProvider);
      expect(settings.reviewReminderHour, 21);
      expect(settings.reviewReminderMinute, 30);
      expect(settings.groupSessionLeadMinutes, 45);
    });
  });
}
