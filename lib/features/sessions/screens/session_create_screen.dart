import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/features/sessions/providers/session_provider.dart';
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
  final _memSurahController = TextEditingController();
  final _memFromAyahController = TextEditingController();
  final _memToAyahController = TextEditingController();
  final _revSurahController = TextEditingController();
  final _revFromAyahController = TextEditingController();
  final _revToAyahController = TextEditingController();
  final _evalMemController = TextEditingController();
  final _evalTajweedController = TextEditingController();
  final _evalFluencyController = TextEditingController();
  final _evalAccuracyController = TextEditingController();
  int? _studentId;
  bool _isLoading = false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.sessionId != null;
    _studentId = widget.studentId;
    if (_isEdit) _loadSession();
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
        _memSurahController.text = '${memorization.surahId}';
        _memFromAyahController.text = '${memorization.fromAyah}';
        _memToAyahController.text = '${memorization.toAyah}';
      }
      final revision = await dao.getRevisionBySession(widget.sessionId!);
      if (revision != null) {
        _revSurahController.text = '${revision.surahId}';
        _revFromAyahController.text = '${revision.fromAyah}';
        _revToAyahController.text = '${revision.toAyah}';
      }
      final evaluation = await dao.getEvaluationBySession(widget.sessionId!);
      if (evaluation != null) {
        _evalMemController.text = '${evaluation.memorizationScore}';
        _evalTajweedController.text = '${evaluation.tajweedScore}';
        _evalFluencyController.text = '${evaluation.fluencyScore}';
        _evalAccuracyController.text = '${evaluation.accuracyScore}';
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _memSurahController.dispose();
    _memFromAyahController.dispose();
    _memToAyahController.dispose();
    _revSurahController.dispose();
    _revFromAyahController.dispose();
    _revToAyahController.dispose();
    _evalMemController.dispose();
    _evalTajweedController.dispose();
    _evalFluencyController.dispose();
    _evalAccuracyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
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

        if (_memSurahController.text.trim().isNotEmpty) {
          await sessionDao.upsertMemorization(SessionMemorizationsCompanion(
            sessionId: Value(widget.sessionId!),
            surahId: Value(int.parse(_memSurahController.text.trim())),
            fromAyah: Value(int.parse(_memFromAyahController.text.trim().isEmpty ? '1' : _memFromAyahController.text.trim())),
            toAyah: Value(int.parse(_memToAyahController.text.trim().isEmpty ? '1' : _memToAyahController.text.trim())),
          ));
        }
        if (_revSurahController.text.trim().isNotEmpty) {
          await sessionDao.upsertRevision(SessionRevisionsCompanion(
            sessionId: Value(widget.sessionId!),
            surahId: Value(int.parse(_revSurahController.text.trim())),
            fromAyah: Value(int.parse(_revFromAyahController.text.trim().isEmpty ? '1' : _revFromAyahController.text.trim())),
            toAyah: Value(int.parse(_revToAyahController.text.trim().isEmpty ? '1' : _revToAyahController.text.trim())),
          ));
        }
        if (_evalMemController.text.trim().isNotEmpty) {
          await sessionDao.upsertEvaluation(SessionEvaluationsCompanion(
            sessionId: Value(widget.sessionId!),
            memorizationScore: Value(double.parse(_evalMemController.text.trim())),
            tajweedScore: Value(double.parse(_evalTajweedController.text.trim().isEmpty ? '0' : _evalTajweedController.text.trim())),
            fluencyScore: Value(double.parse(_evalFluencyController.text.trim().isEmpty ? '0' : _evalFluencyController.text.trim())),
            accuracyScore: Value(double.parse(_evalAccuracyController.text.trim().isEmpty ? '0' : _evalAccuracyController.text.trim())),
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

        if (_memSurahController.text.trim().isNotEmpty) {
          await sessionDao.upsertMemorization(SessionMemorizationsCompanion(
            sessionId: Value(sessionId),
            surahId: Value(int.parse(_memSurahController.text.trim())),
            fromAyah: Value(int.parse(_memFromAyahController.text.trim().isEmpty ? '1' : _memFromAyahController.text.trim())),
            toAyah: Value(int.parse(_memToAyahController.text.trim().isEmpty ? '1' : _memToAyahController.text.trim())),
          ));
        }
        if (_revSurahController.text.trim().isNotEmpty) {
          await sessionDao.upsertRevision(SessionRevisionsCompanion(
            sessionId: Value(sessionId),
            surahId: Value(int.parse(_revSurahController.text.trim())),
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
            accuracyScore: Value(double.parse(_evalAccuracyController.text.trim().isEmpty ? '0' : _evalAccuracyController.text.trim())),
          ));
        }

        await ref.read(progressServiceProvider).syncStudentProgress(_studentId!);
        if (_memSurahController.text.trim().isNotEmpty) {
          await ref.read(memorizedRangeServiceProvider).syncFromSession(
            _studentId!,
            int.parse(_memSurahController.text.trim()),
            int.parse(_memFromAyahController.text.trim().isEmpty ? '1' : _memFromAyahController.text.trim()),
            int.parse(_memToAyahController.text.trim().isEmpty ? '1' : _memToAyahController.text.trim()),
          );
        }
      }

      if (mounted) {
        ref.invalidate(sessionListProvider);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text('${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final picked = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2030), initialDate: _selectedDate);
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(_selectedTime.format(context)),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                  if (picked != null) setState(() => _selectedTime = picked);
                },
              ),
              DropdownButtonFormField<String>(
                value: _attendanceStatus,
                decoration: const InputDecoration(labelText: 'حالة الحضور'),
                items: AttendanceStatus.values.map((s) => DropdownMenuItem(value: s.arabic, child: Text(s.arabic))).toList(),
                onChanged: (v) => setState(() => _attendanceStatus = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'ملاحظات'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Text('الحفظ الجديد', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 16),
              TextFormField(
                controller: _memSurahController,
                decoration: const InputDecoration(labelText: 'رقم السورة'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: _memFromAyahController,
                    decoration: const InputDecoration(labelText: 'من آية'),
                    keyboardType: TextInputType.number,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(
                    controller: _memToAyahController,
                    decoration: const InputDecoration(labelText: 'إلى آية'),
                    keyboardType: TextInputType.number,
                  )),
                ],
              ),
              const SizedBox(height: 24),
              Text('المراجعة', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 16),
              TextFormField(
                controller: _revSurahController,
                decoration: const InputDecoration(labelText: 'رقم السورة'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: _revFromAyahController,
                    decoration: const InputDecoration(labelText: 'من آية'),
                    keyboardType: TextInputType.number,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(
                    controller: _revToAyahController,
                    decoration: const InputDecoration(labelText: 'إلى آية'),
                    keyboardType: TextInputType.number,
                  )),
                ],
              ),
              const SizedBox(height: 24),
              Text('التقييم', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: _evalMemController,
                    decoration: const InputDecoration(labelText: 'الحفظ'),
                    keyboardType: TextInputType.number,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(
                    controller: _evalTajweedController,
                    decoration: const InputDecoration(labelText: 'التجويد'),
                    keyboardType: TextInputType.number,
                  )),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: _evalFluencyController,
                    decoration: const InputDecoration(labelText: 'الطلاقة'),
                    keyboardType: TextInputType.number,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(
                    controller: _evalAccuracyController,
                    decoration: const InputDecoration(labelText: 'الدقة'),
                    keyboardType: TextInputType.number,
                  )),
                ],
              ),
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
    );
  }
}
