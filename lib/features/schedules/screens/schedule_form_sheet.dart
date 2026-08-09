import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/confirm_dialog.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Student;
import 'package:quran_mobile/domain/entities/student.dart';
import 'package:quran_mobile/features/schedules/providers/schedule_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

/// Bottom-sheet form for scheduling a session — exact layout from the
/// adopted design. See docs/DESIGN_SPEC.md and [GoalFormSheet] (the
/// sibling sheet for goals, sharing the same visual pattern).
class ScheduleFormSheet {
  static Future<void> show(BuildContext context, {int? studentId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ScheduleFormSheetContent(studentId: studentId),
    );
  }
}

class _ScheduleFormSheetContent extends ConsumerStatefulWidget {
  final int? studentId;

  const _ScheduleFormSheetContent({this.studentId});

  @override
  ConsumerState<_ScheduleFormSheetContent> createState() => _ScheduleFormSheetContentState();
}

class _ScheduleFormSheetContentState extends ConsumerState<_ScheduleFormSheetContent> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int? _studentId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _studentId = widget.studentId;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار الطالب')));
      return;
    }
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
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) AppSnackbar.error(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(allStudentsProvider);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        decoration: const BoxDecoration(color: AppColors.appBackground, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('جدولة جلسة', style: Theme.of(context).textTheme.titleLarge),
                  _SheetCloseButton(onTap: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: 14),
              if (widget.studentId == null) ...[
                studentsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('تعذر تحميل قائمة الطلاب: $e'),
                  data: (students) => _StudentSelect(
                    value: _studentId,
                    students: students,
                    onChanged: (v) => setState(() => _studentId = v),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Expanded(child: _SheetDateField(label: 'التاريخ', value: _selectedDate, onTap: () async {
                    final picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)), initialDate: _selectedDate);
                    if (picked != null) setState(() => _selectedDate = picked);
                  })),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Builder(builder: (context) => InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                        if (picked != null) setState(() => _selectedTime = picked);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
                        child: Text(_selectedTime.format(context), style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, color: AppColors.textPrimary)),
                      ),
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                      : const Text('حفظ الجدول'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetCloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SheetCloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.dividerLight,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 30,
          height: 30,
          child: Center(child: AppIcon(AppIcons.close, size: 14, color: AppColors.textPrimary)),
        ),
      ),
    );
  }
}

class _SheetDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const _SheetDateField({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
        child: Text(
          value != null ? AppDateUtils.formatDate(value!) : label,
          style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: value != null ? AppColors.textPrimary : AppColors.textMuted),
        ),
      ),
    );
  }
}

class _StudentSelect extends StatelessWidget {
  final int? value;
  final List<Student> students;
  final ValueChanged<int?> onChanged;

  const _StudentSelect({required this.value, required this.students, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      isExpanded: true,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'اختر الطالب',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      ),
      items: [for (final s in students) DropdownMenuItem<int>(value: s.id, child: Text(s.fullName))],
      validator: (v) => v == null ? 'الرجاء اختيار الطالب' : null,
      onChanged: onChanged,
    );
  }
}
