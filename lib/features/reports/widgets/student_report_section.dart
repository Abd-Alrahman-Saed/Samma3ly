import 'dart:io';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/core/widgets/session_card.dart';
import 'package:quran_mobile/domain/entities/session.dart';
import 'package:quran_mobile/domain/entities/student.dart';
import 'package:quran_mobile/domain/services/juz_quarter_progress_service.dart';
import 'package:quran_mobile/features/memorization/providers/juz_quarter_progress_provider.dart';
import 'package:quran_mobile/features/reports/providers/report_provider.dart';
import 'package:quran_mobile/features/reports/widgets/student_report_share_card.dart';
import 'package:quran_mobile/features/sessions/providers/session_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';

/// القسم ح.5 — تقرير مستقل لطالب واحد يختاره المعلّم، منفصل عن الإحصاءات
/// الإجمالية أعلى الشاشة. لا خدمة جديدة: يُبنى مباشرة من
/// `sessionsByStudentProvider(studentId)` (نفس الجلسات المعروضة في صفحة
/// الطالب نفسها) بحساب بسيط للحضور والتقييم — لا داعي لازدواج منطق
/// `DashboardService` هنا.
class StudentReportSection extends ConsumerWidget {
  const StudentReportSection({super.key});

  Future<void> _openPicker(BuildContext context, WidgetRef ref) async {
    final students = await ref.read(studentListProvider.future);
    if (!context.mounted) return;
    final picked = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _StudentReportPickerSheet(students: students),
    );
    if (picked != null) {
      ref.read(reportSelectedStudentProvider.notifier).state = picked;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(reportSelectedStudentProvider);

    if (selectedId == null) {
      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => _openPicker(context, ref),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
            child: const Row(
              children: [
                AppIcon(AppIcons.people, size: 17, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text('اختر طالباً لعرض تقريره', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ),
                AppIcon(AppIcons.chevronLeft, size: 14, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      );
    }

    return _SelectedStudentReport(
      studentId: selectedId,
      onChangeStudent: () => _openPicker(context, ref),
    );
  }
}

class _SelectedStudentReport extends ConsumerWidget {
  final int studentId;
  final VoidCallback onChangeStudent;

  const _SelectedStudentReport({required this.studentId, required this.onChangeStudent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentByIdProvider(studentId));
    final sessionsAsync = ref.watch(sessionsByStudentProvider(studentId));
    // القسم "تقرير كل طالب" — السورة الحالية والكمية المحفوظة من القرآن،
    // نفس مصدرَي بطاقتَي شاشة تفاصيل الطالب (student.currentSurahId
    // وJuzQuarterProgressService، القسم ح.2) — لا حساب جديد، إعادة عرض
    // لنفس البيانات هنا. لا تحجب الشاشة بانتظارهما (نفس تسامح
    // student_details_screen.dart): تظهر '—'/0% لحين وصولهما.
    final surahsAsync = ref.watch(surahListProvider);
    final memorizedAsync = ref.watch(juzQuarterProgressProvider(studentId));

    if (studentAsync.isLoading || sessionsAsync.isLoading) {
      return const LoadingOverlay();
    }
    final error = studentAsync.error ?? sessionsAsync.error;
    if (error != null) return ErrorBanner(message: error.toString());

    final student = studentAsync.value;
    if (student == null) {
      return const Text('الطالب غير موجود', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary));
    }
    final sessions = sessionsAsync.value ?? const [];
    final total = sessions.length;
    final present = sessions.where((s) => s.attendanceStatus == AttendanceStatus.present.arabic).length;
    final attendancePct = total > 0 ? present / total * 100 : 0.0;
    // القسم ح.14: المتوسط يشمل الآن أي جلسة قُيِّمت فعلياً — حفظاً أو
    // مراجعة فقط بلا حفظ — بدل `evaluation != null` وحدها (كانت تتجاهل
    // جلسات المراجعة-فقط، فتخفّض متوسط الطالب زوراً).
    final scored = sessions.where((s) => s.overallScore != null).toList();
    final avgScore = scored.isEmpty ? 0.0 : scored.map((s) => s.overallScore!).reduce((a, b) => a + b) / scored.length;
    final currentSurahName = student.currentSurahId != null
        ? (surahsAsync.valueOrNull ?? const []).firstWhereOrNull((s) => s.id == student.currentSurahId)?.name
        : null;
    final memorizedPct = memorizedAsync.valueOrNull != null ? JuzQuarterProgressService.overallPercentage(memorizedAsync.value!) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: Text(
                student.fullName.isNotEmpty ? student.fullName[0] : '؟',
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(student.fullName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ),
            IconButton(
              tooltip: 'مشاركة تقرير الطالب',
              onPressed: () => _shareReport(
                context,
                student: student,
                sessions: sessions,
                total: total,
                attendancePct: attendancePct,
                avgScore: avgScore,
                currentSurahName: currentSurahName,
                memorizedPct: memorizedPct,
              ),
              icon: const AppIcon(AppIcons.share, size: 16, color: AppColors.textSecondary),
            ),
            TextButton(onPressed: onChangeStudent, child: const Text('تغيير')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _MiniStat(label: 'الجلسات', value: '$total')),
            const SizedBox(width: 8),
            Expanded(child: _MiniStat(label: 'الحضور', value: '${attendancePct.toStringAsFixed(0)}%')),
            const SizedBox(width: 8),
            Expanded(child: _MiniStat(label: 'متوسط التقييم', value: avgScore.toStringAsFixed(1))),
          ],
        ),
        const SizedBox(height: 8),
        // طلب المستخدم: الكمية المحفوظة من القرآن والسورة الحالية ضمن
        // تقرير الطالب — نفس بطاقتَي شاشة تفاصيل الطالب (currentSurahId
        // وJuzQuarterProgressService، القسم ح.2)، معروضتان هنا كإضافة على
        // المعلومات الموجودة مسبقاً، لا بديلاً عنها.
        Row(
          children: [
            Expanded(child: _MiniStat(label: 'السورة الحالية', value: currentSurahName ?? '—')),
            const SizedBox(width: 8),
            Expanded(child: _MiniStat(label: 'المحفوظ من القرآن', value: '${memorizedPct.toStringAsFixed(0)}%')),
          ],
        ),
        const SizedBox(height: 12),
        if (sessions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('لا توجد جلسات لهذا الطالب بعد', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary)),
          )
        else
          ...sessions.take(5).map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SessionCard(
                  item: SessionCardItem(
                    id: s.id,
                    studentId: studentId,
                    studentName: student.fullName,
                    initials: student.fullName.isNotEmpty ? student.fullName[0] : '؟',
                    date: s.date,
                    timeDisplay: s.time,
                    attendanceStatus: s.attendanceStatus,
                    finalScore: s.evaluation?.finalScore ?? 0,
                    recitationOutcome: s.recitationOutcome,
                    revisions: [
                      for (final r in s.revisions) SessionRevisionCardInfo(info: r.label, finalScore: r.finalScore),
                    ],
                  ),
                  // القسم ح.10: جلسة الحلقة تفتح شاشة تسميع الطالب داخل
                  // الحلقة، لا شاشة الجلسة الفردية.
                  onTap: () => s.groupId != null
                      ? context.goNamed('groupStudentRecitation', pathParameters: {
                          'id': '${s.groupId}',
                          'sessionId': '${s.id}',
                          'studentId': '$studentId',
                        })
                      : context.goNamed('sessionEdit', pathParameters: {'id': '${s.id}'}),
                ),
              )),
      ],
    );
  }

  /// مشاركة تقرير الطالب كصورة — نفس أسلوب
  /// `SessionCreateScreen._shareSession` (القسم ح.14) بالضبط: بطاقة
  /// `StudentReportShareCard` تُدرَج في overlay جذر التطبيق (لا في شجرة
  /// هذا الودجت نفسه)، تُلتقَط عبر `RepaintBoundary.toImage`، ثم تُشارَك
  /// كملف PNG عبر شيت المشاركة الأصلي للنظام. هذا الودجت (`ConsumerWidget`
  /// بلا state خاص) لا يُهدَم أثناء الضغط (لا تنقّل يحدث من هنا)، فلا حاجة
  /// لالتقاط `ProviderContainer` مسبقاً كما في شاشة الجلسة — لكن نفس أسلوب
  /// الـoverlay مُتَّبَع للاتساق وتفادي أي اعتماد على مكان هذا الودجت داخل
  /// الشجرة وقت الالتقاط.
  Future<void> _shareReport(
    BuildContext context, {
    required Student student,
    required List<Session> sessions,
    required int total,
    required double attendancePct,
    required double avgScore,
    required String? currentSurahName,
    required double memorizedPct,
  }) async {
    final overlay = Overlay.of(context, rootOverlay: true);
    final boundaryKey = GlobalKey();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: -2000,
        top: 0,
        child: Material(
          color: Colors.transparent,
          child: RepaintBoundary(
            key: boundaryKey,
            child: StudentReportShareCard(
              student: student,
              totalSessions: total,
              attendancePercent: attendancePct,
              averageScore: avgScore,
              currentSurahName: currentSurahName,
              memorizedPercent: memorizedPct,
              recentSessions: [
                for (final s in sessions.take(5))
                  ReportSessionLine(date: s.date, attendanceStatus: s.attendanceStatus, score: s.overallScore),
              ],
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    try {
      // فرصة لإتمام تخطيط/رسم الإطار الأول قبل الالتقاط.
      await WidgetsBinding.instance.endOfFrame;
      await WidgetsBinding.instance.endOfFrame;
      final boundary = boundaryKey.currentContext?.findRenderObject();
      if (boundary is! RenderRepaintBoundary) return;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/student_report_${student.id}.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], subject: 'تقرير الطالب: ${student.fullName}'));
    } finally {
      entry.remove();
    }
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
      child: Column(
        children: [
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 10.5, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _StudentReportPickerSheet extends StatefulWidget {
  final List<Student> students;

  const _StudentReportPickerSheet({required this.students});

  @override
  State<_StudentReportPickerSheet> createState() => _StudentReportPickerSheetState();
}

class _StudentReportPickerSheetState extends State<_StudentReportPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.trim().isEmpty
        ? widget.students
        : widget.students.where((s) => s.fullName.contains(_query.trim())).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 18, 20, 20 + MediaQuery.of(context).padding.bottom),
          decoration: const BoxDecoration(color: AppColors.appBackground, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('اختر طالباً', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'بحث عن طالب...',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  filled: true,
                  fillColor: AppColors.inputBg,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('لا يوجد طلاب مطابقون', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary)))
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final s = filtered[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: () => Navigator.of(context).pop(s.id),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(color: AppColors.dividerLight, shape: BoxShape.circle),
                                        child: Text(s.fullName.isNotEmpty ? s.fullName[0] : '؟', style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(s.fullName, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
