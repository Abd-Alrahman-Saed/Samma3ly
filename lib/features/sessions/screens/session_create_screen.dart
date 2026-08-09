import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
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
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

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
  int? _revSurahId;
  final _revFromAyahController = TextEditingController();
  final _revToAyahController = TextEditingController();
  double _evalMem = 0;
  double _evalTajweed = 0;
  double _evalFluency = 0;
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
    for (final c in [_notesController, _memFromAyahController, _memToAyahController, _revFromAyahController, _revToAyahController]) {
      c.addListener(() => _isDirty = true);
    }
  }

  Future<void> _loadSession() async {
    final dao = ref.read(sessionDaoProvider);
    final session = await dao.getById(widget.sessionId!);
    if (session != null && mounted) {
      _selectedDate = session.date;
      _selectedTime = TimeOfDay(hour: int.parse(session.time.split(':')[0]), minute: int.parse(session.time.split(':')[1]));
      _attendanceStatus = session.attendanceStatus;
      _notesController.text = session.notes ?? '';
      _studentId = session.studentId;

      final memorization = await dao.getMemorizationBySession(widget.sessionId!);
      if (memorization != null) {
        _memSurahId = memorization.surahId;
        _memFromAyahController.text = '${memorization.fromAyah}';
        _memToAyahController.text = '${memorization.toAyah}';
      }
      final revision = await dao.getRevisionBySession(widget.sessionId!);
      if (revision != null) {
        _revSurahId = revision.surahId;
        _revFromAyahController.text = '${revision.fromAyah}';
        _revToAyahController.text = '${revision.toAyah}';
      }
      final evaluation = await dao.getEvaluationBySession(widget.sessionId!);
      if (evaluation != null) {
        _evalMem = evaluation.memorizationScore;
        _evalTajweed = evaluation.tajweedScore;
        _evalFluency = evaluation.fluencyScore;
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
    _revFromAyahController.dispose();
    _revToAyahController.dispose();
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار الطالب')));
      return;
    }
    if (!_isPresent) {
      _memSurahId = null;
      _revSurahId = null;
      _evalMem = 0;
      _evalTajweed = 0;
      _evalFluency = 0;
    }
    setState(() => _isLoading = true);
    try {
      final sessionDao = ref.read(sessionDaoProvider);
      final timeStr = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
      final hasEvaluation = _isPresent && (_evalMem > 0 || _evalTajweed > 0 || _evalFluency > 0);

      if (_isEdit) {
        await sessionDao.updateEntry(SessionsCompanion(
          id: Value(widget.sessionId!),
          studentId: Value(_studentId!),
          date: Value(_selectedDate),
          time: Value(timeStr),
          attendanceStatus: Value(_attendanceStatus),
          notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        ));

        if (_memSurahId != null) {
          await sessionDao.upsertMemorization(SessionMemorizationsCompanion(
            sessionId: Value(widget.sessionId!),
            surahId: Value(_memSurahId!),
            fromAyah: Value(int.parse(_memFromAyahController.text.trim().isEmpty ? '1' : _memFromAyahController.text.trim())),
            toAyah: Value(int.parse(_memToAyahController.text.trim().isEmpty ? '1' : _memToAyahController.text.trim())),
          ));
        } else {
          await sessionDao.deleteMemorization(widget.sessionId!);
        }
        if (_revSurahId != null) {
          await sessionDao.upsertRevision(SessionRevisionsCompanion(
            sessionId: Value(widget.sessionId!),
            surahId: Value(_revSurahId!),
            fromAyah: Value(int.parse(_revFromAyahController.text.trim().isEmpty ? '1' : _revFromAyahController.text.trim())),
            toAyah: Value(int.parse(_revToAyahController.text.trim().isEmpty ? '1' : _revToAyahController.text.trim())),
          ));
        } else {
          await sessionDao.deleteRevision(widget.sessionId!);
        }
        if (hasEvaluation) {
          await sessionDao.upsertEvaluation(SessionEvaluationsCompanion(
            sessionId: Value(widget.sessionId!),
            memorizationScore: Value(_evalMem),
            tajweedScore: Value(_evalTajweed),
            fluencyScore: Value(_evalFluency),
          ));
        }
      } else {
        final sessionId = await sessionDao.insert(SessionsCompanion(
          studentId: Value(_studentId!),
          date: Value(_selectedDate),
          time: Value(timeStr),
          attendanceStatus: Value(_attendanceStatus),
          notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        ));

        if (_memSurahId != null) {
          await sessionDao.upsertMemorization(SessionMemorizationsCompanion(
            sessionId: Value(sessionId),
            surahId: Value(_memSurahId!),
            fromAyah: Value(int.parse(_memFromAyahController.text.trim().isEmpty ? '1' : _memFromAyahController.text.trim())),
            toAyah: Value(int.parse(_memToAyahController.text.trim().isEmpty ? '1' : _memToAyahController.text.trim())),
          ));
        }
        if (_revSurahId != null) {
          await sessionDao.upsertRevision(SessionRevisionsCompanion(
            sessionId: Value(sessionId),
            surahId: Value(_revSurahId!),
            fromAyah: Value(int.parse(_revFromAyahController.text.trim().isEmpty ? '1' : _revFromAyahController.text.trim())),
            toAyah: Value(int.parse(_revToAyahController.text.trim().isEmpty ? '1' : _revToAyahController.text.trim())),
          ));
        }
        if (hasEvaluation) {
          await sessionDao.upsertEvaluation(SessionEvaluationsCompanion(
            sessionId: Value(sessionId),
            memorizationScore: Value(_evalMem),
            tajweedScore: Value(_evalTajweed),
            fluencyScore: Value(_evalFluency),
          ));
        }

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

      if (mounted) {
        ref.invalidate(sessionListProvider);
        ref.invalidate(sessionsByStudentProvider(_studentId!));
        ref.invalidate(studentByIdProvider(_studentId!));
        if (_isEdit) ref.invalidate(sessionByIdProvider(widget.sessionId!));
        AppSnackbar.success(context, _isEdit ? 'تم تحديث الجلسة' : 'تم حفظ الجلسة');
        _isDirty = false;
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

  bool get _isPresent => _attendanceStatus == AttendanceStatus.present.arabic;

  double get _liveFinalScore => ((_evalMem + _evalTajweed + _evalFluency) / 3 * 10).roundToDouble() / 10;

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
                    Text(_isEdit ? 'تعديل جلسة' : 'جلسة جديدة', style: Theme.of(context).textTheme.titleLarge),
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
                              Expanded(child: AppFormField(controller: _memFromAyahController, label: 'من آية', keyboardType: TextInputType.number, validator: (_) => _validateAyahRange(surahId: _memSurahId, fromController: _memFromAyahController, toController: _memToAyahController))),
                              const SizedBox(width: 10),
                              Expanded(child: AppFormField(controller: _memToAyahController, label: 'إلى آية', keyboardType: TextInputType.number, validator: (_) => _validateAyahRange(surahId: _memSurahId, fromController: _memFromAyahController, toController: _memToAyahController))),
                            ],
                          ),
                          const SizedBox(height: 18),
                          const Text('المراجعة (اختياري)', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 8),
                          SurahDropdown(value: _revSurahId, onChanged: (v) => setState(() { _revSurahId = v; _isDirty = true; }), label: 'السورة', noneLabel: 'اختر السورة'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(child: AppFormField(controller: _revFromAyahController, label: 'من آية', keyboardType: TextInputType.number, validator: (_) => _validateAyahRange(surahId: _revSurahId, fromController: _revFromAyahController, toController: _revToAyahController))),
                              const SizedBox(width: 10),
                              Expanded(child: AppFormField(controller: _revToAyahController, label: 'إلى آية', keyboardType: TextInputType.number, validator: (_) => _validateAyahRange(surahId: _revSurahId, fromController: _revFromAyahController, toController: _revToAyahController))),
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
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _save,
                            child: _isLoading
                                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                                : Text(_isEdit ? 'حفظ التعديلات' : 'حفظ الجلسة'),
                          ),
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
