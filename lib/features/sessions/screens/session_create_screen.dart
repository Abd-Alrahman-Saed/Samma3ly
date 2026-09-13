import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/core/enums/recitation_outcome.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/utils/quran_utils.dart';
import 'package:quran_mobile/core/widgets/app_form_field.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/discard_changes_dialog.dart';
import 'package:quran_mobile/core/widgets/student_picker.dart';
import 'package:quran_mobile/core/widgets/surah_dropdown.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Student;
import 'package:quran_mobile/features/sessions/providers/session_provider.dart';
import 'package:quran_mobile/features/sessions/widgets/session_share_card.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

/// القسم ح.14 — أنواع المراجعة الجاهزة كأزرار سريعة (شرائح اختيار). أي
/// تسمية أخرى (بما فيها القديمة "مراجعة" الافتراضية على بيانات ما قبل هذا
/// التحديث) تُعرَض كـ"مخصّص" مع حقل نصّ حرّ.
const _revisionLabelPresets = ['قريبة', 'بعيدة', 'عامة'];

/// حالة مراجعة واحدة داخل الشاشة — الجلسة الواحدة تحتمل عدة مراجعات
/// (القسم ح.14)، كل واحدة بسورتها/مداها/تقييمها المستقلّ تماماً عن الباقي.
class _RevisionEntry {
  int? surahId;
  final TextEditingController fromController = TextEditingController(text: '1');
  final TextEditingController toController = TextEditingController(text: '1');
  bool isFullSurah = false;
  String label = 'قريبة';
  final TextEditingController customLabelController = TextEditingController();
  double evalMem = 0;
  double evalTajweed = 0;
  double evalFluency = 0;
  double evalTashkeel = 0;

  double get finalScore {
    final sum = evalMem + evalTajweed + evalFluency + evalTashkeel;
    return (sum / 4 * 10).roundToDouble() / 10;
  }

  void dispose() {
    fromController.dispose();
    toController.dispose();
    customLabelController.dispose();
  }
}

class SessionCreateScreen extends ConsumerStatefulWidget {
  final int? studentId;
  final int? sessionId;

  const SessionCreateScreen({super.key, this.studentId, this.sessionId});

  @override
  ConsumerState<SessionCreateScreen> createState() => _SessionCreateScreenState();
}

class _SessionCreateScreenState extends ConsumerState<SessionCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _attendanceStatus = 'حاضر';
  final _notesController = TextEditingController();
  int? _memSurahId;
  final _memFromAyahController = TextEditingController();
  final _memToAyahController = TextEditingController();
  bool _memIsFullSurah = false;
  double _evalMem = 0;
  double _evalTajweed = 0;
  double _evalFluency = 0;
  double _evalTashkeel = 0;
  // القسم ح.14: أكثر من مراجعة للجلسة الواحدة، كل واحدة بتقييمها المستقلّ
  // — كانت حقول `_rev*` مفردة قبل هذا التحديث.
  final List<_RevisionEntry> _revisions = [];
  int? _studentId;
  bool _isLoading = false;
  bool _isEdit = false;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.sessionId != null;
    _studentId = widget.studentId;
    if (_isEdit) _loadSession();
    for (final c in [_notesController, _memFromAyahController, _memToAyahController]) {
      c.addListener(() => _isDirty = true);
    }
  }

  Future<void> _loadSession() async {
    final dao = ref.read(sessionDaoProvider);
    final session = await dao.getById(widget.sessionId!);
    if (session != null && mounted) {
      _selectedDate = session.date;
      _selectedTime = TimeOfDay(hour: int.parse(session.time.split(':')[0]), minute: int.parse(session.time.split(':')[1]));
      _notesController.text = session.notes ?? '';
      _studentId = session.studentId;
      if (session.studentId != null) {
        final attendance = await dao.getAttendance(session.id, session.studentId!);
        if (attendance != null) _attendanceStatus = attendance.attendanceStatus;
      }

      final memorization = await dao.getMemorizationBySession(widget.sessionId!);
      if (memorization != null) {
        _memSurahId = memorization.surahId;
        _memFromAyahController.text = '${memorization.fromAyah}';
        _memToAyahController.text = '${memorization.toAyah}';
        _memIsFullSurah = memorization.isFullSurah;
      }
      final revisions = await dao.getRevisionsBySession(widget.sessionId!);
      for (final r in revisions) {
        final entry = _RevisionEntry()
          ..surahId = r.surahId
          ..isFullSurah = r.isFullSurah
          ..evalMem = r.memorizationScore
          ..evalTajweed = r.tajweedScore
          ..evalFluency = r.fluencyScore
          ..evalTashkeel = r.accuracyScore;
        entry.fromController.text = '${r.fromAyah}';
        entry.toController.text = '${r.toAyah}';
        if (_revisionLabelPresets.contains(r.label)) {
          entry.label = r.label;
        } else {
          entry.label = r.label;
          entry.customLabelController.text = r.label;
        }
        _wireRevisionEntry(entry);
        _revisions.add(entry);
      }
      final evaluation = await dao.getEvaluationBySession(widget.sessionId!);
      if (evaluation != null) {
        _evalMem = evaluation.memorizationScore;
        _evalTajweed = evaluation.tajweedScore;
        _evalFluency = evaluation.fluencyScore;
        _evalTashkeel = evaluation.accuracyScore;
      }
      setState(() {});
      _isDirty = false;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _memFromAyahController.dispose();
    _memToAyahController.dispose();
    for (final r in _revisions) {
      r.dispose();
    }
    super.dispose();
  }

  String? _validateAyahRange({
    required int? surahId,
    required TextEditingController fromController,
    required TextEditingController toController,
  }) {
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

  /// يربط تغييرات حقول "من/إلى آية" الحرّة الكتابة بـ`_isDirty` — الحقول
  /// الأخرى (السورة، السويتش، الشرائح، الـSlider) تُحدِّث `_isDirty` مباشرة
  /// عبر `onChanged` في `_RevisionCard`، لكن هذين الحقلين نصّيان يُكتَب
  /// فيهما مباشرة بلا callback وسيط.
  void _wireRevisionEntry(_RevisionEntry entry) {
    for (final c in [entry.fromController, entry.toController]) {
      c.addListener(() => _isDirty = true);
    }
  }

  void _addRevision() {
    setState(() {
      final entry = _RevisionEntry();
      _wireRevisionEntry(entry);
      _revisions.add(entry);
      _isDirty = true;
    });
  }

  void _removeRevision(_RevisionEntry entry) {
    setState(() {
      _revisions.remove(entry);
      entry.dispose();
      _isDirty = true;
    });
  }

  void _setMemFullSurah(bool value) {
    setState(() {
      _memIsFullSurah = value;
      _memFromAyahController.text = '1';
      _memToAyahController.text = value && _memSurahId != null ? '${QuranUtils.getAyahCount(_memSurahId!)}' : '1';
      _isDirty = true;
    });
  }

  void _setRevisionFullSurah(_RevisionEntry entry, bool value) {
    setState(() {
      entry.isFullSurah = value;
      entry.fromController.text = '1';
      entry.toController.text = value && entry.surahId != null ? '${QuranUtils.getAyahCount(entry.surahId!)}' : '1';
      _isDirty = true;
    });
  }

  Future<void> _save(RecitationOutcome outcome) async {
    if (!_formKey.currentState!.validate()) return;
    if (_studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار الطالب')));
      return;
    }
    if (!_isPresent) {
      _memSurahId = null;
      _evalMem = 0;
      _evalTajweed = 0;
      _evalFluency = 0;
      _evalTashkeel = 0;
      for (final r in List.of(_revisions)) {
        r.dispose();
      }
      _revisions.clear();
    }
    setState(() => _isLoading = true);
    try {
      final sessionDao = ref.read(sessionDaoProvider);
      final timeStr = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
      final hasEvaluation = _isPresent && (_evalMem > 0 || _evalTajweed > 0 || _evalFluency > 0 || _evalTashkeel > 0);

      late final int sessionId;
      if (_isEdit) {
        sessionId = widget.sessionId!;
        await sessionDao.updateEntry(SessionsCompanion(
          id: Value(sessionId),
          studentId: Value(_studentId!),
          date: Value(_selectedDate),
          time: Value(timeStr),
          notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        ));
      } else {
        sessionId = await sessionDao.insert(SessionsCompanion(
          studentId: Value(_studentId!),
          date: Value(_selectedDate),
          time: Value(timeStr),
          notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        ));
      }

      if (_memSurahId != null) {
        await sessionDao.upsertMemorization(SessionMemorizationsCompanion(
          sessionId: Value(sessionId),
          surahId: Value(_memSurahId!),
          fromAyah: Value(int.parse(_memFromAyahController.text.trim().isEmpty ? '1' : _memFromAyahController.text.trim())),
          toAyah: Value(int.parse(_memToAyahController.text.trim().isEmpty ? '1' : _memToAyahController.text.trim())),
          isFullSurah: Value(_memIsFullSurah),
        ));
      } else if (_isEdit) {
        await sessionDao.deleteMemorization(sessionId);
      }

      // القسم ح.14: استبدال كل مراجعات الجلسة دفعة واحدة — يعمل بنفس
      // البساطة سواء كانت الجلسة جديدة (لا مراجعات قديمة أصلاً فتُحذَف
      // مجموعة فارغة) أو مُعدَّلة (تستبدل القديمة بالكامل). صفوف بلا سورة
      // مختارة (مراجعة أُضيفت ثم لم تُكمَل) تُستبعَد بصمت بدل إجبار
      // المعلّم على حذفها يدوياً.
      await sessionDao.replaceRevisions(sessionId, [
        for (var i = 0; i < _revisions.length; i++)
          if (_revisions[i].surahId != null)
            SessionRevisionsCompanion(
              sessionId: Value(sessionId),
              surahId: Value(_revisions[i].surahId!),
              fromAyah: Value(int.parse(_revisions[i].fromController.text.trim().isEmpty ? '1' : _revisions[i].fromController.text.trim())),
              toAyah: Value(int.parse(_revisions[i].toController.text.trim().isEmpty ? '1' : _revisions[i].toController.text.trim())),
              label: Value(_revisions[i].label.trim().isEmpty ? 'مراجعة' : _revisions[i].label.trim()),
              isFullSurah: Value(_revisions[i].isFullSurah),
              sortOrder: Value(i),
              memorizationScore: Value(_revisions[i].evalMem),
              tajweedScore: Value(_revisions[i].evalTajweed),
              fluencyScore: Value(_revisions[i].evalFluency),
              accuracyScore: Value(_revisions[i].evalTashkeel),
            ),
      ]);

      if (hasEvaluation) {
        await sessionDao.upsertEvaluation(SessionEvaluationsCompanion(
          sessionId: Value(sessionId),
          memorizationScore: Value(_evalMem),
          tajweedScore: Value(_evalTajweed),
          fluencyScore: Value(_evalFluency),
          accuracyScore: Value(_evalTashkeel),
        ));
      } else if (_isEdit) {
        await sessionDao.deleteEvaluation(sessionId);
      }

      if (!_isEdit) {
        await ref.read(progressServiceProvider).syncStudentProgress(_studentId!);
        if (_memSurahId != null) {
          await ref.read(memorizedRangeServiceProvider).syncFromSession(
            _studentId!,
            _memSurahId!,
            int.parse(_memFromAyahController.text.trim().isEmpty ? '1' : _memFromAyahController.text.trim()),
            int.parse(_memToAyahController.text.trim().isEmpty ? '1' : _memToAyahController.text.trim()),
          );
        }
      }

      // القسم ح.10: حالة الحضور والقرار السريع (اجتاز/يُعاد) بعد كل تفاصيل
      // الجلسة الأخرى — upsertAttendance أولاً (يحفظ الحضور)، ثم
      // upsertRecitation (تحفظ recitationOutcome فقط هنا؛ الجلسة الفردية
      // تخزّن الحفظ/المراجعة/التقييم في جداولها المنفصلة كالمعتاد، لا في
      // أعمدة SessionAttendances المخصَّصة للحلقات — لكن العمود نفسه
      // (v7) مشترك، فلا داعي لمخطط جديد).
      await sessionDao.upsertAttendance(sessionId, _studentId!, _attendanceStatus);
      await sessionDao.upsertRecitation(SessionAttendancesCompanion(
        sessionId: Value(sessionId),
        studentId: Value(_studentId!),
        recitationOutcome: Value(outcome.arabic),
      ));

      if (mounted) {
        ref.invalidate(sessionListProvider);
        ref.invalidate(sessionsByStudentProvider(_studentId!));
        ref.invalidate(studentByIdProvider(_studentId!));
        if (_isEdit) ref.invalidate(sessionByIdProvider(widget.sessionId!));
        _isDirty = false;

        // القسم ح.14 — زرار "مشاركة" داخل الـsnackbar: يلتقط الـoverlay
        // وحاوية Riverpod *قبل* الخروج من الشاشة (context.pop أسفل)، عشان
        // يبقى الزرار شغّالاً حتى لو ضُغِط بعد رجوع المستخدم للشاشة السابقة
        // — لا يعتمد بعدها على state هذه الشاشة (المتوقَّع أن يُهدَم فوراً).
        final overlay = Overlay.of(context, rootOverlay: true);
        final container = ProviderScope.containerOf(context, listen: false);
        AppSnackbar.success(
          context,
          _isEdit ? 'تم تحديث الجلسة' : 'تم حفظ الجلسة',
          actionLabel: 'مشاركة',
          onAction: () => _shareSession(sessionId, overlay: overlay, container: container),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.error(context, e);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// القسم ح.14 — يبني بطاقة نتيجة الجلسة ([SessionShareCard]) ويلتقطها
  /// كصورة PNG عبر `RepaintBoundary` مُدرَجة في [overlay] (لا في شجرة هذه
  /// الشاشة نفسها — الزرار قد يُضغَط بعد أن تكون الشاشة قد أُغلقت فعلاً،
  /// راجع التعليق في `_save`)، ثم يفتح شيت المشاركة الأصلي للنظام.
  /// [container] بدل `ref` لنفس السبب — قد لا يبقى `State` هذه الشاشة حيّاً.
  Future<void> _shareSession(int sessionId, {required OverlayState overlay, required ProviderContainer container}) async {
    final repo = container.read(sessionRepositoryProvider);
    final session = await repo.getById(sessionId);
    if (session == null) return;

    var studentName = 'الطالب';
    final sid = session.studentId;
    if (sid != null) {
      final student = await container.read(studentByIdProvider(sid).future);
      if (student != null) studentName = student.fullName;
    }
    final surahs = await container.read(surahListProvider.future);
    final surahNames = {for (final s in surahs) s.id: s.name};
    String surahLabel(int id) => surahNames[id] ?? 'سورة $id';

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
            child: SessionShareCard(studentName: studentName, session: session, surahLabel: surahLabel),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    try {
      // فرصة لإتمام تخطيط/رسم الإطار الأول قبل الالتقاط — إدراج
      // OverlayEntry وحده لا يعني أنه رُسِم فعلياً بعد.
      await WidgetsBinding.instance.endOfFrame;
      await WidgetsBinding.instance.endOfFrame;
      final boundary = boundaryKey.currentContext?.findRenderObject();
      if (boundary is! RenderRepaintBoundary) return;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/session_share_$sessionId.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], subject: 'نتيجة جلسة $studentName'));
    } finally {
      entry.remove();
    }
  }

  bool get _isPresent => _attendanceStatus == AttendanceStatus.present.arabic;

  double get _liveFinalScore => ((_evalMem + _evalTajweed + _evalFluency + _evalTashkeel) / 4 * 10).roundToDouble() / 10;

  @override
  Widget build(BuildContext context) {
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
          child: Column(
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
                        onTap: () => context.pop(),
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
                    Expanded(child: Text(_isEdit ? 'تعديل جلسة' : 'جلسة جديدة', style: Theme.of(context).textTheme.titleLarge)),
                    // القسم ح.14 — مشاركة نتيجة جلسة محفوظة سلفاً مباشرة من
                    // الهيدر (بلا حاجة للحفظ أولاً، الجلسة موجودة أصلاً).
                    if (_isEdit)
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () => _shareSession(
                            widget.sessionId!,
                            overlay: Overlay.of(context, rootOverlay: true),
                            container: ProviderScope.containerOf(context, listen: false),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
                            child: const AppIcon(AppIcons.share, size: 16, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.studentId == null && !_isEdit) ...[
                          StudentPicker(
                            value: _studentId,
                            onChanged: (v) => setState(() {
                              _studentId = v;
                              _isDirty = true;
                            }),
                          ),
                          const SizedBox(height: 14),
                        ],
                        Row(
                          children: [
                            Expanded(child: _InlineDateField(value: _selectedDate, onTap: () async {
                              final picked = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2030), initialDate: _selectedDate);
                              if (picked != null) setState(() { _selectedDate = picked; _isDirty = true; });
                            })),
                            const SizedBox(width: 10),
                            Expanded(child: _InlineTimeField(value: _selectedTime, onTap: () async {
                              final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                              if (picked != null) setState(() { _selectedTime = picked; _isDirty = true; });
                            })),
                          ],
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
                        // القسم ح.14: صندوق ملاحظات أكبر (4 أسطر افتراضياً،
                        // يتمدّد حتى 8) — يساعد على كتابة ملاحظة حقيقية بدل
                        // سطر واحد ضيق.
                        AppFormField(controller: _notesController, label: 'ملاحظات', hintText: 'ملاحظات', minLines: 4, maxLines: 8),
                        if (!_isPresent) ...[
                          const SizedBox(height: 14),
                          const Text('لا يمكن تسجيل الحفظ أو التقييم لجلسة غياب', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textSecondary)),
                        ],
                        if (_isPresent) ...[
                          const SizedBox(height: 6),
                          const Text('الحفظ الجديد (اختياري)', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 8),
                          SurahDropdown(
                            value: _memSurahId,
                            onChanged: (v) => setState(() {
                              _memSurahId = v;
                              if (_memIsFullSurah) _memToAyahController.text = v != null ? '${QuranUtils.getAyahCount(v)}' : '1';
                              _isDirty = true;
                            }),
                            label: 'السورة',
                            noneLabel: 'اختر السورة',
                          ),
                          if (_memSurahId != null) ...[
                            const SizedBox(height: 6),
                            _FullSurahSwitch(value: _memIsFullSurah, onChanged: _setMemFullSurah),
                            if (!_memIsFullSurah) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: AppFormField(controller: _memFromAyahController, label: 'من آية', keyboardType: TextInputType.number, validator: (_) => _validateAyahRange(surahId: _memSurahId, fromController: _memFromAyahController, toController: _memToAyahController))),
                                  const SizedBox(width: 10),
                                  Expanded(child: AppFormField(controller: _memToAyahController, label: 'إلى آية', keyboardType: TextInputType.number, validator: (_) => _validateAyahRange(surahId: _memSurahId, fromController: _memFromAyahController, toController: _memToAyahController))),
                                ],
                              ),
                            ],
                            // القسم ح.1: التقييم يظهر فقط لما تُختار سورة
                            // حفظ فعلياً — جلسة مراجعة فقط بلا حفظ متوفّر
                            // ما تحمل أصفار تقييم حفظ وهمية.
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('تقييم الحفظ', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
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
                          ],
                          const SizedBox(height: 22),
                          // القسم ح.14: مراجعات متعددة — قريبة/بعيدة/عامة أو
                          // مخصَّصة، كل واحدة بسورتها وتقييمها المستقلّ. لا
                          // حاجة لحفظ جديد لإضافة مراجعة.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('المراجعة', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              TextButton.icon(
                                onPressed: _addRevision,
                                icon: const AppIcon(AppIcons.plus, size: 13, color: AppColors.primary),
                                label: const Text('إضافة مراجعة'),
                              ),
                            ],
                          ),
                          for (final entry in _revisions) ...[
                            const SizedBox(height: 8),
                            _RevisionCard(
                              entry: entry,
                              onChanged: () => setState(() => _isDirty = true),
                              onFullSurahChanged: (v) => _setRevisionFullSurah(entry, v),
                              onDelete: () => _removeRevision(entry),
                              validator: () => _validateAyahRange(surahId: entry.surahId, fromController: entry.fromController, toController: entry.toController),
                            ),
                          ],
                        ],
                        const SizedBox(height: 24),
                        // القسم ح.10: بديل زر "حفظ الجلسة" الواحد — قرار سريع
                        // بعد التسميع، نفس زرَّي GroupStudentRecitationScreen
                        // بالضبط (بند ح.6)، فتجربة تسجيل الجلسة موحَّدة فردية
                        // كانت أو جماعية.
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                key: const Key('sessionRepeat'),
                                onPressed: _isLoading ? null : () => _save(RecitationOutcome.repeat),
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
                                key: const Key('sessionExcellent'),
                                onPressed: _isLoading ? null : () => _save(RecitationOutcome.excellent),
                                child: _isLoading
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineDateField extends StatelessWidget {
  final DateTime value;
  final VoidCallback onTap;

  const _InlineDateField({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
        child: Text(AppDateUtils.formatDate(value), style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, color: AppColors.textPrimary)),
      ),
    );
  }
}

class _InlineTimeField extends StatelessWidget {
  final TimeOfDay value;
  final VoidCallback onTap;

  const _InlineTimeField({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
        child: Builder(builder: (context) => Text(value.format(context), style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, color: AppColors.textPrimary))),
      ),
    );
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

/// القسم ح.14 — مفتاح "السورة كاملة": يُخفي حقلَي "من/إلى آية" ويملأ
/// المدى آلياً (١ → عدد آيات السورة) بدل إدخال الأرقام يدوياً في الحالة
/// الشائعة (حفظ/مراجعة السورة بأكملها).
class _FullSurahSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _FullSurahSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.primary),
          const SizedBox(width: 4),
          const Text('السورة كاملة', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

/// القسم ح.14 — بطاقة مراجعة واحدة: نوع المراجعة (شرائح قريبة/بعيدة/عامة
/// أو مخصَّص)، السورة والمدى (أو "كاملة")، وتقييم مستقلّ بأربعة معايير.
class _RevisionCard extends StatelessWidget {
  final _RevisionEntry entry;
  final VoidCallback onChanged;
  final ValueChanged<bool> onFullSurahChanged;
  final VoidCallback onDelete;
  final String? Function() validator;

  const _RevisionCard({
    required this.entry,
    required this.onChanged,
    required this.onFullSurahChanged,
    required this.onDelete,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isCustomLabel = !_revisionLabelPresets.contains(entry.label);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.inputBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final preset in _revisionLabelPresets)
                      ChoiceChip(
                        label: Text(preset),
                        selected: !isCustomLabel && entry.label == preset,
                        onSelected: (_) {
                          entry.label = preset;
                          onChanged();
                        },
                      ),
                    ChoiceChip(
                      label: const Text('مخصّص'),
                      selected: isCustomLabel,
                      onSelected: (_) {
                        entry.label = entry.customLabelController.text.trim();
                        onChanged();
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: 'حذف المراجعة',
                icon: const AppIcon(AppIcons.trash, size: 15, color: AppColors.deleteIcon),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          if (isCustomLabel) ...[
            const SizedBox(height: 8),
            AppFormField(
              controller: entry.customLabelController,
              label: 'نوع المراجعة',
              hintText: 'اكتب نوع المراجعة',
              onChanged: (v) {
                entry.label = v;
                onChanged();
              },
            ),
          ],
          const SizedBox(height: 10),
          SurahDropdown(
            value: entry.surahId,
            onChanged: (v) {
              entry.surahId = v;
              if (entry.isFullSurah) entry.toController.text = v != null ? '${QuranUtils.getAyahCount(v)}' : '1';
              onChanged();
            },
            label: 'السورة',
            noneLabel: 'اختر السورة',
          ),
          if (entry.surahId != null) ...[
            const SizedBox(height: 6),
            _FullSurahSwitch(value: entry.isFullSurah, onChanged: onFullSurahChanged),
            if (!entry.isFullSurah) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: AppFormField(controller: entry.fromController, label: 'من آية', keyboardType: TextInputType.number, validator: (_) => validator())),
                  const SizedBox(width: 10),
                  Expanded(child: AppFormField(controller: entry.toController, label: 'إلى آية', keyboardType: TextInputType.number, validator: (_) => validator())),
                ],
              ),
            ],
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('تقييم هذه المراجعة', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFE9F3EF), borderRadius: BorderRadius.circular(999)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(entry.finalScore.toStringAsFixed(1), style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      const SizedBox(width: 3),
                      const Text('/ ١٠', style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _ScoreSlider(label: 'الحفظ', value: entry.evalMem, onChanged: (v) { entry.evalMem = v; onChanged(); }),
            _ScoreSlider(label: 'التجويد', value: entry.evalTajweed, onChanged: (v) { entry.evalTajweed = v; onChanged(); }),
            _ScoreSlider(label: 'الطلاقة', value: entry.evalFluency, onChanged: (v) { entry.evalFluency = v; onChanged(); }),
            _ScoreSlider(label: 'التشكيل', value: entry.evalTashkeel, onChanged: (v) { entry.evalTashkeel = v; onChanged(); }),
          ],
        ],
      ),
    );
  }
}
