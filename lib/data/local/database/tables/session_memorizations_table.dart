import 'package:drift/drift.dart';
import 'sessions_table.dart';
import 'surahs_table.dart';

class SessionMemorizations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id).unique()();
  IntColumn get surahId => integer().references(Surahs, #id)();
  IntColumn get fromAyah => integer()();
  IntColumn get toAyah => integer()();

  /// القسم ح.14 (v10): "السورة كاملة" — `fromAyah`/`toAyah` تُملآن آلياً
  /// (1 → عدد آيات السورة)، والعلم هنا لعرض "(كاملة)" بدل المدى الرقمي
  /// ولإعادة فتح الشاشة على نفس الاختيار. نفس الحقل على
  /// `SessionRevisions`.
  BoolColumn get isFullSurah => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
