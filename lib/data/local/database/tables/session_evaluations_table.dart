import 'package:drift/drift.dart';
import 'sessions_table.dart';

/// تقييم **الحفظ الجديد** في جلسة فردية. تقييم المراجعة لم يعد هنا:
/// القسم ح.14 (v10) نقله إلى `SessionRevisions` نفسها (عمود لكل معيار على
/// صفّ المراجعة)، لأن الجلسة الواحدة بقت تحتمل أكثر من مراجعة بتقييم
/// مستقلّ لكل واحدة — فـ"تقييم مراجعة الجلسة" الواحد (أعمدة v8
/// `revision*Score` التي كانت هنا) لم يعد له معنى، ونُقلت بياناته ثم
/// حُذفت في نفس الترقية.
class SessionEvaluations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id).unique()();
  RealColumn get memorizationScore => real().withDefault(const Constant(0.0))();
  RealColumn get tajweedScore => real().withDefault(const Constant(0.0))();
  RealColumn get fluencyScore => real().withDefault(const Constant(0.0))();
  RealColumn get accuracyScore => real().withDefault(const Constant(0.0))();

  // FinalScore محسوب لا مخزَّن.

  @override
  Set<Column> get primaryKey => {id};
}
