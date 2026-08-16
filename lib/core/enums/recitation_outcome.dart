/// القسم ح.6 — قرار المعلّم السريع بعد تسميع طالب في حلقة: "ممتاز" (أتقن)
/// أو "يُعاد" (يحتاج إعادة المقطع). مستقلّ عن درجات التقييم الأربعة.
enum RecitationOutcome {
  excellent('ممتاز'),
  repeat('يُعاد');

  final String arabic;
  const RecitationOutcome(this.arabic);

  static RecitationOutcome? fromArabic(String? value) {
    if (value == null) return null;
    for (final o in RecitationOutcome.values) {
      if (o.arabic == value) return o;
    }
    return null;
  }
}
