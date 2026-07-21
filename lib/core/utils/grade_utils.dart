class GradeUtils {
  static String scoreToGrade(double score) {
    if (score >= 9.0) return 'ممتاز';
    if (score >= 8.0) return 'جيد جداً';
    if (score >= 6.5) return 'جيد';
    if (score >= 5.0) return 'مقبول';
    return 'ضعيف';
  }

  static String colorForScore(double score) {
    if (score >= 9.0) return '#16A34A';
    if (score >= 8.0) return '#2563EB';
    if (score >= 6.5) return '#CA8A04';
    if (score >= 5.0) return '#EA580C';
    return '#DC2626';
  }
}
