import 'dart:developer' as developer;

class AppErrorUtils {
  static final RegExp _arabic = RegExp(r'[؀-ۿ]');

  static const String genericMessage = 'حدث خطأ غير متوقع. الرجاء المحاولة مرة أخرى.';

  /// Logs the raw [error] for developers and returns a friendly Arabic
  /// message safe to show to end users. If [error] already carries a
  /// human-written Arabic message (e.g. a domain-level exception), that
  /// message is surfaced as-is; otherwise a generic message is returned so
  /// raw technical/exception text never reaches the UI.
  static String friendlyMessage(Object error, [StackTrace? stackTrace]) {
    developer.log('Unhandled error', error: error, stackTrace: stackTrace, name: 'quran_mobile');

    final raw = error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '').trim();
    if (raw.isNotEmpty && _arabic.hasMatch(raw)) {
      return raw;
    }
    return genericMessage;
  }
}
