import 'package:drift/native.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

/// Opens a fresh in-memory [AppDatabase] for tests.
///
/// Uses the real `onCreate` migration (including surah/juz seeding), so
/// tests exercise the same schema-creation path as production — just
/// backed by memory instead of a file on disk.
AppDatabase openTestDatabase() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}
