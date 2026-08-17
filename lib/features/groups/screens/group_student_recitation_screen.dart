import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/core/enums/recitation_outcome.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/utils/quran_utils.dart';
import 'package:quran_mobile/core/widgets/app_form_field.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/discard_changes_dialog.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/core/widgets/surah_dropdown.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Student, Session;
import 'package:quran_mobile/domain/entities/session.dart';
import 'package:quran_mobile/features/groups/providers/group_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

/// القسم ح.6 — الضغط على طالب في الحلقة المباشرة يفتح هذه الشاشة الكاملة
/// بدل ورقة سفلية (GroupRecitationSheet سابقاً)، لأنها "نفس الحاجة زي ما
/// بعمل جلسة جديدة لطالب" (طلب المستخدم صراحةً): نفس تخطيط
/// `SessionCreateScreen` — حضور، ملاحظات، حفظ، مراجعة، تقييم — لكن
/// التاريخ معروض فقط (مربوط بموعد الحلقة، لا يُعدَّل من هنا)، والحفظ
/// النهائي بزرَّين بدل واحد: "اجتاز" أو "يُعاد" (بند التقييم السريع، v7).
///
/// البيانات تُكتب على SessionAttendances (لا SessionMemorizations/
/// SessionRevisions/SessionEvaluations) — نفس سبب بند 3.4: جلسة جماعية
/// فيها طلاب متعددون، كل واحد له تسميع مستقلّ.
class GroupStudentRecitationScreen extends ConsumerStatefulWidget {
  final int groupId;
  final int sessionId;
  final int studentId;

  const GroupStudentRecitationScreen({
    super.key,
    required this.groupId,
    required this.sessionId,
    required this.studentId,
  });

  @override
  ConsumerState<GroupStudentRecitationScreen> createState() => _GroupStudentRecitationScreenState();
}

class _GroupStudentRecitationScreenState extends ConsumerState<GroupStudentRecitationScreen> {
  String _attendanceStatus = AttendanceStatus.present.arabic;
  final _notesController = TextEditingController();
  int? _memSurahId;
  final _memFromController = TextEditingController();
  final _memToController = TextEditingController();
  int? _revSurahId;
  final _revFromController = TextEditingController();
  final _revToController = TextEditingController();
  double _evalMem = 0;
  double _evalTajweed = 0;
  double _evalFluency = 0;
  double _evalTashkeel = 0;
  // القسم ح.12: تقييم منفصل للمراجعة — يظهر فقط عند اختيار سورة مراجعة.
  double _revEvalMem = 0;
  double _revEvalTajweed = 0;
  double _revEvalFluency = 0;
  double _revEvalTashkeel = 0;

  bool _loading = true;
  bool _isSaving = false;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _load();
    for (final c in [_notesController, _memFromController, _memToController, _revFromController, _revToController]) {
      c.addListener(() => _isDirty = true);
    }
  }

  Future<void> _load() async {
    final dao = ref.read(sessionDaoProvider);
    final existing = await dao.getAttendance(widget.sessionId, widget.studentId);
    if (existing != null) {
      _attendanceStatus = existing.attendanceStatus;
      _memSurahId = existing.memorizationSurahId;
      _memFromController.text = existing.memorizationFromAyah?.toString() ?? '';
      _memToController.text = existing.memorizationToAyah?.toString() ?? '';
      _revSurahId = existing.revisionSurahId;
      _revFromController.text = existing.revisionFromAyah?.toString() ?? '';
      _revToController.text = existing.revisionToAyah?.toString() ?? '';
      _evalMem = existing.memorizationScore;
      _evalTajweed = existing.tajweedScore;
      _evalFluency = existing.fluencyScore;
      _evalTashkeel = existing.accuracyScore;
      _revEvalMem = existing.revisionMemorizationScore;
      _revEvalTajweed = existing.revisionTajweedScore;
      _revEvalFluency = existing.revisionFluencyScore;
      _revEvalTashkeel = existing.revisionAccuracyScore;
      _notesController.text = existing.notes ?? '';
    }
    if (mounted) {
      setState(() => _loading = false);
      _isDirty = false;
    }
  }

  @override
  void dispose() {
    for (final c in [_notesController, _memFromController, _memToController, _revFromController, _revToController]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _isPresent => _attendanceStatus == AttendanceStatus.present.arabic;

  double get _liveFinalScore => ((_evalMem + _evalTajweed + _evalFluency + _evalTashkeel) / 4 * 10).roundToDouble() / 10;

  double get _liveRevisionFinalScore =>
      ((_revEvalMem + _revEvalTajweed + _revEvalFluency + _revEvalTashkeel) / 4 * 10).roundToDouble() / 10;

  Future<void> _save(RecitationOutcome outcome) async {
    setState(() => _isSaving = true);
    try {
      final sessionDao = ref.read(sessionDaoProvider);
      await sessionDao.upsertAttendance(widget.sessionId, widget.studentId, _attendanceStatus);
      await sessionDao.upsertRecitation(SessionAttendancesCompanion(
        sessionId: Value(widget.sessionId),
        studentId: Value(widget.studentId),
        memorizationSurahId: Value(_isPresent ? _memSurahId : null),
        memorizationFromAyah: Value(_isPresent ? int.tryParse(_memFromController.text.trim()) : null),
        memorizationToAyah: Value(_isPresent ? int.tryParse(_memToController.text.trim()) : null),
        revisionSurahId: Value(_isPresent ? _revSurahId : null),
        revisionFromAyah: Value(_isPresent ? int.tryParse(_revFromController.text.trim()) : null),
        revisionToAyah: Value(_isPresent ? int.tryParse(_revToController.text.trim()) : null),
        memorizationScore: Value(_isPresent ? _evalMem : 0),
        tajweedScore: Value(_isPresent ? _evalTajweed : 0),
        fluencyScore: Value(_isPresent ? _evalFluency : 0),
        accuracyScore: Value(_isPresent ? _evalTashkeel : 0),
        // القسم ح.12: تُحفَظ فقط لو الطالب حاضر وفيه سورة مراجعة مختارة.
        revisionMemorizationScore: Value(_isPresent && _revSurahId != null ? _revEvalMem : 0),
        revisionTajweedScore: Value(_isPresent && _revSurahId != null ? _revEvalTajweed : 0),
        revisionFluencyScore: Value(_isPresent && _revSurahId != null ? _revEvalFluency : 0),
        revisionAccuracyScore: Value(_isPresent && _revSurahId != null ? _revEvalTashkeel : 0),
        notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        recitationOutcome: Value(outcome.arabic),
      ));
      if (mounted) {
        ref.read(sessionAttendanceRefreshProvider(widget.sessionId).notifier).state++;
        AppSnackbar.success(context, 'تم حفظ التسميع');
        _isDirty = false;
        context.pop();
      }
    } catch (e) {
      if (mounted) AppSnackbar.error(context, e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentAsync = ref.watch(studentByIdProvider(widget.studentId));
    final sessionAsync = ref.watch(groupLiveSessionProvider(widget.sessionId));

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final discard = await confirmDiscardChanges(context);
        if (discard && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: SafeArea(
          child: _loading || studentAsync.isLoading || sessionAsync.isLoading
              ? const LoadingOverlay()
              : (studentAsync.error ?? sessionAsync.error) != null
                  ? ErrorBanner(message: (studentAsync.error ?? sessionAsync.error).toString())
                  : _buildForm(context, studentAsync.value?.fullName ?? 'طالب', sessionAsync.value),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, String studentName, Session? session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => Navigator.of(context).maybePop(),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
                    child: const AppIcon(AppIcons.chevronRight, size: 16, color: AppColors.textPrimary),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(studentName, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (session != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
                    child: Row(
                      children: [
                        const AppIcon(AppIcons.calendar, size: 15, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          '${AppDateUtils.formatDate(session.date)} — ${session.time}',
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                const Text('حالة الحضور', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _AttendanceButton(icon: AppIcons.checkCircle, label: AttendanceStatus.present.arabic, colors: StatusColors.present, selected: _attendanceStatus == AttendanceStatus.present.arabic, onTap: () => setState(() { _attendanceStatus = AttendanceStatus.present.arabic; _isDirty = true; }))),
                    const SizedBox(width: 6),
                    Expanded(child: _AttendanceButton(icon: AppIcons.clock, label: AttendanceStatus.late.arabic, colors: StatusColors.attendanceLate, selected: _attendanceStatus == AttendanceStatus.late.arabic, onTap: () => setState(() { _attendanceStatus = AttendanceStatus.late.arabic; _isDirty = true; }))),
                    const SizedBox(width: 6),
                    Expanded(child: _AttendanceButton(icon: AppIcons.circleX, label: AttendanceStatus.absent.arabic, colors: StatusColors.absent, selected: _attendanceStatus == AttendanceStatus.absent.arabic, onTap: () => setState(() { _attendanceStatus = AttendanceStatus.absent.arabic; _isDirty = true; }))),
                    const SizedBox(width: 6),
                    Expanded(child: _AttendanceButton(icon: AppIcons.circleDash, label: AttendanceStatus.excused.arabic, colors: StatusColors.excused, selected: _attendanceStatus == AttendanceStatus.excused.arabic, onTap: () => setState(() { _attendanceStatus = AttendanceStatus.excused.arabic; _isDirty = true; }))),
                  ],
                ),
                const SizedBox(height: 14),
                AppFormField(controller: _notesController, label: 'ملاحظات', hintText: 'ملاحظات', maxLines: 2),
                if (!_isPresent) ...[
                  const SizedBox(height: 14),
                  const Text('لا يمكن تسجيل الحفظ أو التقييم لجلسة غياب', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textSecondary)),
                ],
                if (_isPresent) ...[
                  const SizedBox(height: 6),
                  const Text('الحفظ الجديد', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  SurahDropdown(value: _memSurahId, onChanged: (v) => setState(() { _memSurahId = v; _isDirty = true; }), label: 'السورة', noneLabel: 'اختر السورة'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: AppFormField(controller: _memFromController, label: 'من آية', keyboardType: TextInputType.number, validator: (_) => _validateAyahRange(_memSurahId, _memFromController, _memToController))),
                      const SizedBox(width: 10),
                      Expanded(child: AppFormField(controller: _memToController, label: 'إلى آية', keyboardType: TextInputType.number, validator: (_) => _validateAyahRange(_memSurahId, _memFromController, _memToController))),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text('المراجعة (اختياري)', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  SurahDropdown(value: _revSurahId, onChanged: (v) => setState(() { _revSurahId = v; _isDirty = true; }), label: 'السورة', noneLabel: 'اختر السورة'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: AppFormField(controller: _revFromController, label: 'من آية', keyboardType: TextInputType.number, validator: (_) => _validateAyahRange(_revSurahId, _revFromController, _revToController))),
                      const SizedBox(width: 10),
                      Expanded(child: AppFormField(controller: _revToController, label: 'إلى آية', keyboardType: TextInputType.number, validator: (_) => _validateAyahRange(_revSurahId, _revFromController, _revToController))),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('التقييم', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFE9F3EF), borderRadius: BorderRadius.circular(999)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_liveFinalScore.toStringAsFixed(1), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
                            const SizedBox(width: 3),
                            const Text('/ ١٠', style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _ScoreSlider(label: 'الحفظ', value: _evalMem, onChanged: (v) => setState(() { _evalMem = v; _isDirty = true; })),
                  _ScoreSlider(label: 'التجويد', value: _evalTajweed, onChanged: (v) => setState(() { _evalTajweed = v; _isDirty = true; })),
                  _ScoreSlider(label: 'الطلاقة', value: _evalFluency, onChanged: (v) => setState(() { _evalFluency = v; _isDirty = true; })),
                  _ScoreSlider(label: 'التشكيل', value: _evalTashkeel, onChanged: (v) => setState(() { _evalTashkeel = v; _isDirty = true; })),
                  // القسم ح.12: تقييم مستقلّ للمراجعة، يظهر فقط عند اختيار
                  // سورة مراجعة — مطلب المستخدم صراحةً.
                  if (_revSurahId != null) ...[
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('تقييم المراجعة', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFE9F3EF), borderRadius: BorderRadius.circular(999)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_liveRevisionFinalScore.toStringAsFixed(1), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
                              const SizedBox(width: 3),
                              const Text('/ ١٠', style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _ScoreSlider(label: 'الحفظ', value: _revEvalMem, onChanged: (v) => setState(() { _revEvalMem = v; _isDirty = true; })),
                    _ScoreSlider(label: 'التجويد', value: _revEvalTajweed, onChanged: (v) => setState(() { _revEvalTajweed = v; _isDirty = true; })),
                    _ScoreSlider(label: 'الطلاقة', value: _revEvalFluency, onChanged: (v) => setState(() { _revEvalFluency = v; _isDirty = true; })),
                    _ScoreSlider(label: 'التشكيل', value: _revEvalTashkeel, onChanged: (v) => setState(() { _revEvalTashkeel = v; _isDirty = true; })),
                  ],
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('recitationRepeat'),
                        onPressed: _isSaving ? null : () => _save(RecitationOutcome.repeat),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFD97706),
                          side: const BorderSide(color: Color(0xFFD97706)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('يُعاد'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        key: const Key('recitationExcellent'),
                        onPressed: _isSaving ? null : () => _save(RecitationOutcome.excellent),
                        child: _isSaving
                            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                            : const Text('اجتاز'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String? _validateAyahRange(int? surahId, TextEditingController fromController, TextEditingController toController) {
    if (surahId == null) return null;
    final fromText = fromController.text.trim();
    final toText = toController.text.trim();
    final from = int.tryParse(fromText.isEmpty ? '1' : fromText);
    final to = int.tryParse(toText.isEmpty ? '1' : toText);
    if (from == null || to == null) return 'رقم آية غير صحيح';
    if (from < 1) return 'يجب أن تبدأ الآية من 1 على الأقل';
    if (from > to) return 'يجب أن تكون "من آية" أصغر من أو تساوي "إلى آية"';
    final count = QuranUtils.getAyahCount(surahId);
    if (to > count) return 'هذه السورة تحتوي على $count آية فقط';
    return null;
  }
}

class _AttendanceButton extends StatelessWidget {
  final String icon;
  final String label;
  final ({Color fg, Color bg}) colors;
  final bool selected;
  final VoidCallback onTap;

  const _AttendanceButton({required this.icon, required this.label, required this.colors, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? colors.bg : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: selected ? colors.fg : AppColors.inputBorder)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(icon, size: 15, color: selected ? colors.fg : AppColors.textSecondary),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, fontWeight: FontWeight.w700, color: selected ? colors.fg : AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _ScoreSlider({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textSecondary)),
            Text(value.toStringAsFixed(1), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.dividerLight,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.12),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(min: 0, max: 10, divisions: 20, value: value, onChanged: onChanged),
        ),
      ],
    );
  }
}
