import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/confirm_dialog.dart';
import 'package:quran_mobile/core/widgets/date_picker_tile.dart';
import 'package:quran_mobile/core/widgets/discard_changes_dialog.dart';
import 'package:quran_mobile/core/widgets/student_picker.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/features/schedules/providers/schedule_provider.dart';
import 'package:quran_mobile/providers.dart';

class ScheduleCreateScreen extends ConsumerStatefulWidget {
  final int? studentId;

  const ScheduleCreateScreen({super.key, this.studentId});

  @override
  ConsumerState<ScheduleCreateScreen> createState() => _ScheduleCreateScreenState();
}

class _ScheduleCreateScreenState extends ConsumerState<ScheduleCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int? _studentId;
  bool _isLoading = false;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _studentId = widget.studentId;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final dao = ref.read(scheduleDaoProvider);
    final timeStr = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
    final existing = await dao.getUpcoming(studentId: _studentId);
    final hasConflict = existing.any((s) =>
        s.date.year == _selectedDate.year && s.date.month == _selectedDate.month && s.date.day == _selectedDate.day && s.time == timeStr);
    if (hasConflict) {
      if (!mounted) return;
      final proceed = await showConfirmDialog(
        context,
        title: 'تعارض في الجدولة',
        message: 'يوجد جدول آخر لهذا الطالب في نفس التاريخ والوقت. هل تريد المتابعة؟',
        confirmLabel: 'متابعة',
      );
      if (!proceed) return;
    }
    setState(() => _isLoading = true);
    try {
      await dao.insert(SchedulesCompanion(
        studentId: Value(_studentId!),
        date: Value(_selectedDate),
        time: Value(timeStr),
      ));
      if (mounted) {
        ref.invalidate(upcomingScheduleListProvider);
        AppSnackbar.success(context, 'تم حفظ الجدولة');
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
      appBar: AppBar(title: const Text('جدولة جلسة')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('معلومات الجدولة', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 16),
              if (_studentId == null) ...[
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
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
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
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('حفظ الجدول'),
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
