import 'package:drift/drift.dart';
import 'sessions_table.dart';
import 'surahs_table.dart';

/// القسم ح.14 (v10): الجلسة الواحدة بقت تحتمل **أكثر من مراجعة** (مراجعة
/// قريبة + مراجعة بعيدة مثلاً)، كل واحدة بسورتها ومداها وتقييمها المستقلّ
/// — فـ`sessionId` لم يعد `.unique()`.
///
/// التقييم نفسه انتقل إلى هنا (الأعمدة الأربعة أسفله) بدل
/// `SessionEvaluations.revision*Score` (v8) التي كانت تمثّل "تقييم مراجعة
/// الجلسة" الواحد — معنى لم يعد قائماً بوجود مراجعات متعددة. تلك الأعمدة
/// نُقلت بياناتها إلى هنا ثم حُذفت في نفس ترقية v10، فلا يبقى مصدران
/// للحقيقة. (نظيرتها على `SessionAttendances` لجلسات الحلقات لم تُمسّ —
/// مسار مختلف تماماً، وما زالت مراجعة واحدة لكل طالب هناك.)
class SessionRevisions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  IntColumn get surahId => integer().references(Surahs, #id)();
  IntColumn get fromAyah => integer()();
  IntColumn get toAyah => integer()();

  /// نوع المراجعة كما اختاره المعلّم: "قريبة"/"بعيدة"/"عامة" أو نصّ مخصَّص
  /// — تسمية حرّة عمداً (لا enum) لأن المعلّمين يستخدمون مصطلحات مختلفة،
  /// والقيم الثلاث مجرد اقتراحات سريعة في الواجهة.
  TextColumn get label => text().withLength(max: 40).withDefault(const Constant('مراجعة'))();

  /// "السورة كاملة" — `fromAyah`/`toAyah` تُملآن آلياً (1 → عدد آيات
  /// السورة)، والعلم هنا لعرض "(كاملة)" بدل "(1-7)" ولإعادة فتح الشاشة
  /// على نفس الاختيار.
  BoolColumn get isFullSurah => boolean().withDefault(const Constant(false))();

  /// ترتيب العرض داخل الجلسة — يحفظ ترتيب إدخال المعلّم للمراجعات.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  RealColumn get memorizationScore => real().withDefault(const Constant(0.0))();
  RealColumn get tajweedScore => real().withDefault(const Constant(0.0))();
  RealColumn get fluencyScore => real().withDefault(const Constant(0.0))();
  RealColumn get accuracyScore => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}
