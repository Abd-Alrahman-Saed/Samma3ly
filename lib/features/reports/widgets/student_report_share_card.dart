import 'package:flutter/material.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/app_logo_mark.dart';
import 'package:quran_mobile/core/widgets/score_display.dart';
import 'package:quran_mobile/domain/entities/student.dart';

/// معلومات جلسة واحدة كما تُعرَض في سطر "آخر الجلسات" على بطاقة المشاركة.
class ReportSessionLine {
  final DateTime date;
  final String attendanceStatus;
  final double? score;

  const ReportSessionLine({required this.date, required this.attendanceStatus, this.score});
}

/// بطاقة تقرير الطالب الجاهزة للمشاركة كصورة — نفس فكرة `SessionShareCard`
/// (القسم ح.14) بالضبط: تُلتقَط عبر `RepaintBoundary` وتُشارَك عبر شيت
/// المشاركة الأصلي للنظام. تحمل كل معلومات التقرير الحالية (الجلسات،
/// الحضور، متوسط التقييم، آخر الجلسات) بالإضافة إلى السورة الحالية
/// والكمية المحفوظة من القرآن — مصدر مستقلّ بذاته، بلا اعتماد على سياق
/// التطبيق وقت العرض.
class StudentReportShareCard extends StatelessWidget {
  final Student student;
  final int totalSessions;
  final double attendancePercent;
  final double averageScore;
  final String? currentSurahName;
  final double memorizedPercent;
  final List<ReportSessionLine> recentSessions;

  const StudentReportShareCard({
    super.key,
    required this.student,
    required this.totalSessions,
    required this.attendancePercent,
    required this.averageScore,
    required this.currentSurahName,
    required this.memorizedPercent,
    required this.recentSessions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const AppLogoMark(size: 34, showBadge: false, iconSize: 18),
              const SizedBox(width: 8),
              const Text('سمَّعلي', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
              const Spacer(),
              if (averageScore > 0) ScoreDisplay(score: averageScore, style: const TextStyle(fontFamily: 'Cairo', fontSize: 17, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 18),
          Text(student.fullName, style: const TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 3),
          Text('تقرير الطالب · ${AppDateUtils.formatDate(DateTime.now())}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _StatBox(label: 'الجلسات', value: '$totalSessions')),
              const SizedBox(width: 8),
              Expanded(child: _StatBox(label: 'الحضور', value: '${attendancePercent.toStringAsFixed(0)}%')),
              const SizedBox(width: 8),
              Expanded(child: _StatBox(label: 'متوسط التقييم', value: averageScore.toStringAsFixed(1))),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('السورة الحالية', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ),
                    Flexible(
                      child: Text(
                        currentSurahName ?? '—',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(
                      child: Text('المحفوظ من القرآن', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ),
                    Text('${memorizedPercent.toStringAsFixed(0)}%', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: (memorizedPercent / 100).clamp(0, 1),
                    minHeight: 5,
                    backgroundColor: AppColors.dividerLight,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          if (recentSessions.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('آخر الجلسات', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            for (final s in recentSessions)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${AppDateUtils.formatDate(s.date)} · ${s.attendanceStatus}',
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                    if (s.score != null) ScoreDisplay(score: s.score!, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 10.5, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
