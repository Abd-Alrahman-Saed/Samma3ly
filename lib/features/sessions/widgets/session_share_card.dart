import 'package:flutter/material.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/utils/quran_utils.dart';
import 'package:quran_mobile/core/widgets/app_logo_mark.dart';
import 'package:quran_mobile/core/widgets/score_display.dart';
import 'package:quran_mobile/domain/entities/session.dart';

/// القسم ح.14 — بطاقة نتيجة الجلسة الجاهزة للمشاركة كصورة: تُلتقَط عبر
/// `RepaintBoundary` (راجع `SessionCreateScreen._shareSession`) وتُشارَك
/// عبر شيت المشاركة الأصلي للنظام (واتساب/ماسنجر/...). مصمَّمة كصورة
/// مستقلّة بذاتها — كل المعلومات المطلوبة (طالب/تاريخ/حضور/حفظ/مراجعات/
/// ملاحظات) داخل الصورة نفسها، بلا اعتماد على سياق التطبيق وقت العرض.
class SessionShareCard extends StatelessWidget {
  final String studentName;
  final Session session;
  final String Function(int surahId) surahLabel;

  const SessionShareCard({
    super.key,
    required this.studentName,
    required this.session,
    required this.surahLabel,
  });

  @override
  Widget build(BuildContext context) {
    final statusColors = StatusColors.forAttendance(session.attendanceStatus);
    final outcomeColors = session.recitationOutcome == 'يُعاد' ? StatusColors.attendanceLate : StatusColors.present;
    final mem = session.memorization;
    final overallScore = session.overallScore;
    final notes = session.notes?.trim();

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
              if (overallScore != null) ScoreDisplay(score: overallScore, style: const TextStyle(fontFamily: 'Cairo', fontSize: 17, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 18),
          Text(studentName, style: const TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 3),
          Text(
            session.time.isNotEmpty ? '${AppDateUtils.formatDate(session.date)} · ${session.time}' : AppDateUtils.formatDate(session.date),
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Badge(text: session.attendanceStatus, colors: statusColors),
              if (session.recitationOutcome != null) _Badge(text: session.recitationOutcome!, colors: outcomeColors),
            ],
          ),
          if (mem != null) ...[
            const SizedBox(height: 16),
            _SessionPart(
              title: 'الحفظ الجديد',
              titleColor: AppColors.primary,
              text: '${surahLabel(mem.surahId)} ${QuranUtils.rangeLabel(fromAyah: mem.fromAyah, toAyah: mem.toAyah, isFullSurah: mem.isFullSurah)}',
              score: session.evaluation?.hasEvaluation == true ? session.evaluation!.finalScore : null,
            ),
          ],
          for (final r in session.revisions) ...[
            const SizedBox(height: 12),
            _SessionPart(
              title: r.label,
              titleColor: AppColors.streakIconFg,
              text: '${surahLabel(r.surahId)} ${QuranUtils.rangeLabel(fromAyah: r.fromAyah, toAyah: r.toAyah, isFullSurah: r.isFullSurah)}',
              score: r.hasEvaluation ? r.finalScore : null,
            ),
          ],
          if (notes != null && notes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(10)),
              child: Text(notes, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textSecondary)),
            ),
          ],
          const SizedBox(height: 18),
          Center(
            child: Text(
              AppDateUtils.formatDate(DateTime.now()),
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 10.5, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final ({Color fg, Color bg}) colors;

  const _Badge({required this.text, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: colors.bg, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, fontWeight: FontWeight.w700, color: colors.fg)),
    );
  }
}

class _SessionPart extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String text;
  final double? score;

  const _SessionPart({required this.title, required this.titleColor, required this.text, this.score});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w700, color: titleColor)),
              const SizedBox(height: 3),
              Text(text, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textPrimary)),
            ],
          ),
        ),
        if (score != null) ...[
          const SizedBox(width: 8),
          ScoreDisplay(score: score!, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800)),
        ],
      ],
    );
  }
}
