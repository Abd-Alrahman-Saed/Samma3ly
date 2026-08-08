import 'core/services/notification_service.dart';

Future<void> bootstrap() async {
  // Initialize any pre-app services here
  // The database is lazily initialized on first use
  await NotificationService.instance.init();
}
