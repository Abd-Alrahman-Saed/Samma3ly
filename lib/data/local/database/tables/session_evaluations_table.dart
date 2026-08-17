import 'package:drift/drift.dart';
import 'sessions_table.dart';

class SessionEvaluations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id).unique()();
  RealColumn get memorizationScore => real().withDefault(const Constant(0.0))();
  RealColumn get tajweedScore => real().withDefault(const Constant(0.0))();
  RealColumn get fluencyScore => real().withDefault(const Constant(0.0))();
  RealColumn get accuracyScore => real().withDefault(const Constant(0.0))();

  // v8 (القسم ح.12): تقييم منفصل للمراجعة — نفس المعايير الأربعة، لكن
  // لأداء المراجعة لا الحفظ الجديد. عمود مستقلّ لكل معيار بدل مشاركة
  // الأعمدة أعلاه، لأن جلسة واحدة قد تحتوي حفظاً جديداً ومراجعة معاً،
  // بتقييمين مختلفين تماماً.
  RealColumn get revisionMemorizationScore => real().withDefault(const Constant(0.0))();
  RealColumn get revisionTajweedScore => real().withDefault(const Constant(0.0))();
  RealColumn get revisionFluencyScore => real().withDefault(const Constant(0.0))();
  RealColumn get revisionAccuracyScore => real().withDefault(const Constant(0.0))();

  // FinalScore/revisionFinalScore محسوبان لا مخزَّنان.

  @override
  Set<Column> get primaryKey => {id};
}
