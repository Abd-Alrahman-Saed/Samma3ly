import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/utils/quran_utils.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/date_picker_tile.dart';
import 'package:quran_mobile/core/widgets/discard_changes_dialog.dart';
import 'package:quran_mobile/core/widgets/score_field.dart';
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
  final _evalMemController = TextEditingController();
  final _evalTajweedController = TextEditingController();
  final _evalFluencyController = TextEditingController();
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
    for (final c in [
      _notesController,
      _memFromAyahController,
      _memToAyahController,
      _revFromAyahController,
      _revToAyahController,
      _evalMemController,
      _evalTajweedController,
      _evalFluencyController,
    ]) {
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
        _evalMemController.text = '${evaluation.memorizationScore}';
        _evalTajweedController.text = '${evaluation.tajweedScore}';
        _evalFluencyController.text = '${evaluation.fluencyScore}';
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
    _evalMemController.dispose();
    _evalTajweedController.dispose();
    _evalFluencyController.dispose();
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار الطالب')),
      );
      return;
    }
    if (!_isPresent) {
      _memSurahId = null;
      _revSurahId = null;
      _evalMemController.clear();
      _evalTajweedController.clear();
      _evalFluencyController.clear();
    }
    setState(() => _isLoading = true);
    try {
      final sessionDao = ref.read(sessionDaoProvider);
      final timeStr = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

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
        if (_evalMemController.text.trim().isNotEmpty) {
          await sessionDao.upsertEvaluation(SessionEvaluationsCompanion(
            sessionId: Value(widget.sessionId!),
            memorizationScore: Value(double.parse(_evalMemController.text.trim())),
            tajweedScore: Value(double.parse(_evalTajweedController.text.trim().isEmpty ? '0' : _evalTajweedController.text.trim())),
            fluencyScore: Value(double.parse(_evalFluencyController.text.trim().isEmpty ? '0' : _evalFluencyController.text.trim())),
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
        if (_evalMemController.text.trim().isNotEmpty) {
          await sessionDao.upsertEvaluation(SessionEvaluationsCompanion(
            sessionId: Value(sessionId),
            memorizationScore: Value(double.parse(_evalMemController.text.trim())),
            tajweedScore: Value(double.parse(_evalTajweedController.text.trim().isEmpty ? '0' : _evalTajweedController.text.trim())),
            fluencyScore: Value(double.parse(_evalFluencyController.text.trim().isEmpty ? '0' : _evalFluencyController.text.trim())),
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
      appBar: AppBar(title: Text(_isEdit ? 'تعديل جلسة' : 'جلسة جديدة')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('معلومات الجلسة', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 16),
              if (widget.studentId == null && !_isEdit) ...[
                StudentPicker(
                  value: _studentId,
                  onChanged: (v) => setState(() {
                    _studentId = v;
                    _isDirty = true;
                  }),
                ),
                const SizedBox(height: 16),
              ],
              DatePickerTile(
                value: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                onChanged: (picked) => setState(() {
                  _selectedDate = picked;
                  _isDirty = true;
                }),
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(_selectedTime.format(context)),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                  if (picked != null) {
                    setState(() {
                      _selectedTime = picked;
                      _isDirty = true;
                    });
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: _attendanceStatus,
                decoration: const InputDecoration(labelText: 'حالة الحضور'),
                items: AttendanceStatus.values.map((s) => DropdownMenuItem(value: s.arabic, child: Text(s.arabic))).toList(),
                onChanged: (v) => setState(() {
                  _attendanceStatus = v!;
                  _isDirty = true;
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'ملاحظات'),
                maxLines: 3,
              ),
              if (!_isPresent) ...[
                const SizedBox(height: 16),
                Text('لا يمكن تسجيل الحفظ أو المراجعة أو التقييم لجلسة غياب', style: AppTextStyles.muted),
              ],
              if (_isPresent) ...[
                const SizedBox(height: 24),
                Text('الحفظ الجديد', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 16),
                SurahDropdown(
                  value: _memSurahId,
                  onChanged: (v) => setState(() {
                    _memSurahId = v;
                    _isDirty = true;
                  }),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextFormField(
                      controller: _memFromAyahController,
                      decoration: const InputDecoration(labelText: 'من آية'),
                      keyboardType: TextInputType.number,
                      validator: (_) => _validateAyahRange(
                        surahId: _memSurahId,
                        fromController: _memFromAyahController,
                        toController: _memToAyahController,
                      ),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(
                      controller: _memToAyahController,
                      decoration: const InputDecoration(labelText: 'إلى آية'),
                      keyboardType: TextInputType.number,
                      validator: (_) => _validateAyahRange(
                        surahId: _memSurahId,
                        fromController: _memFromAyahController,
                        toController: _memToAyahController,
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 24),
                Text('المراجعة', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 2),
                Text('اختياري - اتركه فارغاً إذا لم تكن هناك مراجعة', style: AppTextStyles.muted),
                const SizedBox(height: 16),
                SurahDropdown(
                  value: _revSurahId,
                  onChanged: (v) => setState(() {
                    _revSurahId = v;
                    _isDirty = true;
                  }),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextFormField(
                      controller: _revFromAyahController,
                      decoration: const InputDecoration(labelText: 'من آية'),
                      keyboardType: TextInputType.number,
                      validator: (_) => _validateAyahRange(
                        surahId: _revSurahId,
                        fromController: _revFromAyahController,
                        toController: _revToAyahController,
                      ),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(
                      controller: _revToAyahController,
                      decoration: const InputDecoration(labelText: 'إلى آية'),
                      keyboardType: TextInputType.number,
                      validator: (_) => _validateAyahRange(
                        surahId: _revSurahId,
                        fromController: _revFromAyahController,
                        toController: _revToAyahController,
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 24),
                Text('التقييم', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: ScoreField(controller: _evalMemController, label: 'الحفظ')),
                    const SizedBox(width: 12),
                    Expanded(child: ScoreField(controller: _evalTajweedController, label: 'التجويد')),
                  ],
                ),
                const SizedBox(height: 12),
                ScoreField(controller: _evalFluencyController, label: 'الطلاقة'),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(_isEdit ? 'حفظ التعديلات' : 'حفظ الجلسة'),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
