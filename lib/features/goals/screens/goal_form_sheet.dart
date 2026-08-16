import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/core/enums/goal_type.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/app_form_field.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/juz_dropdown.dart';
import 'package:quran_mobile/core/widgets/surah_dropdown.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Student;
import 'package:quran_mobile/domain/entities/student.dart';
import 'package:quran_mobile/features/goals/providers/goal_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

/// Bottom-sheet form for creating a goal — exact layout from the adopted
/// design (the mock presents goal/schedule creation as a modal sheet,
/// unlike student/session creation which are full screens). See
/// docs/DESIGN_SPEC.md.
class GoalFormSheet {
  static Future<void> show(BuildContext context, {int? studentId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _GoalFormSheetContent(studentId: studentId),
    );
  }
}

class _GoalFormSheetContent extends ConsumerStatefulWidget {
  final int? studentId;

  const _GoalFormSheetContent({this.studentId});

  @override
  ConsumerState<_GoalFormSheetContent> createState() => _GoalFormSheetContentState();
}

class _GoalFormSheetContentState extends ConsumerState<_GoalFormSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _goalType = 'سورة';
  int? _targetSurahId;
  int? _targetJuzNumber;
  int? _studentId;
  DateTime? _startDate = DateTime.now();
  DateTime? _targetDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _studentId = widget.studentId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار الطالب')));
      return;
    }
    final target = _goalType == GoalType.surah.arabic ? _targetSurahId : _targetJuzNumber;
    if (target == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_goalType == GoalType.surah.arabic ? 'الرجاء اختيار السورة' : 'الرجاء اختيار الجزء')));
      return;
    }
    if (_targetDate != null && _startDate != null && _targetDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يجب أن يكون تاريخ الاستهداف بعد تاريخ البداية')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final dao = ref.read(goalDaoProvider);
      await dao.insert(GoalsCompanion(
        studentId: Value(_studentId!),
        title: Value(_titleController.text.trim()),
        goalType: Value(_goalType),
        targetSurahId: Value(_goalType == GoalType.surah.arabic ? target : null),
        targetJuzNumber: Value(_goalType == GoalType.juz.arabic ? target : null),
        startDate: Value(_startDate ?? DateTime.now()),
        targetDate: Value(_targetDate),
      ));
      if (mounted) {
        ref.invalidate(goalListProvider);
        ref.invalidate(activeGoalListProvider);
        if (_studentId != null) ref.invalidate(goalsByStudentProvider(_studentId!));
        AppSnackbar.success(context, 'تم حفظ الهدف');
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
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        decoration: const BoxDecoration(color: AppColors.appBackground, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('هدف جديد', style: Theme.of(context).textTheme.titleLarge),
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
                AppFormField(controller: _titleController, label: 'عنوان الهدف', hintText: 'عنوان الهدف', onCard: true, required: true),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // تبديل النوع يصفّر الهدف السابق — قيمة سورة وقيمة جزء
                    // مساحتان مختلفتان تماماً، والاحتفاظ بقيمة قديمة بعد
                    // التبديل قد يُحفَظ خطأً بلا أن يظهر ذلك في الواجهة.
                    Expanded(child: _TypeToggle(label: GoalType.surah.arabic, selected: _goalType == GoalType.surah.arabic, onTap: () => setState(() { _goalType = GoalType.surah.arabic; _targetJuzNumber = null; }))),
                    const SizedBox(width: 6),
                    Expanded(child: _TypeToggle(label: GoalType.juz.arabic, selected: _goalType == GoalType.juz.arabic, onTap: () => setState(() { _goalType = GoalType.juz.arabic; _targetSurahId = null; }))),
                  ],
                ),
                const SizedBox(height: 12),
                if (_goalType == GoalType.surah.arabic)
                  SurahDropdown(
                    key: const Key('goalTargetSurah'),
                    value: _targetSurahId,
                    onChanged: (v) => setState(() => _targetSurahId = v),
                    label: 'السورة المستهدفة',
                    noneLabel: 'اختر السورة',
                  )
                else
                  JuzDropdown(
                    key: const Key('goalTargetJuz'),
                    value: _targetJuzNumber,
                    onChanged: (v) => setState(() => _targetJuzNumber = v),
                    label: 'الجزء المستهدف',
                    noneLabel: 'اختر الجزء',
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _SheetDateField(label: 'تاريخ البداية', value: _startDate, onTap: () async {
                      final picked = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2030), initialDate: _startDate ?? DateTime.now());
                      if (picked != null) setState(() => _startDate = picked);
                    })),
                    const SizedBox(width: 10),
                    Expanded(child: _SheetDateField(label: 'تاريخ الاستهداف', value: _targetDate, onTap: () async {
                      final picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2030), initialDate: _targetDate ?? DateTime.now());
                      if (picked != null) setState(() => _targetDate = picked);
                    })),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                        : const Text('حفظ الهدف'),
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

class _TypeToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeToggle({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: selected ? AppColors.primary : AppColors.inputBorder)),
          child: Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: selected ? AppColors.onPrimary : AppColors.textSecondary)),
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
