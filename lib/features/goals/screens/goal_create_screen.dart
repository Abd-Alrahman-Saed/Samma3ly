import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/enums/goal_type.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/app_form_field.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/date_picker_tile.dart';
import 'package:quran_mobile/core/widgets/discard_changes_dialog.dart';
import 'package:quran_mobile/core/widgets/student_picker.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/features/goals/providers/goal_provider.dart';
import 'package:quran_mobile/providers.dart';

class GoalCreateScreen extends ConsumerStatefulWidget {
  final int? studentId;

  const GoalCreateScreen({super.key, this.studentId});

  @override
  ConsumerState<GoalCreateScreen> createState() => _GoalCreateScreenState();
}

class _GoalCreateScreenState extends ConsumerState<GoalCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetSurahController = TextEditingController();
  final _targetJuzController = TextEditingController();
  String _goalType = 'سورة';
  int? _studentId;
  DateTime _startDate = DateTime.now();
  DateTime? _targetDate;
  bool _isLoading = false;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _studentId = widget.studentId;
    for (final c in [_titleController, _targetSurahController, _targetJuzController]) {
      c.addListener(() => _isDirty = true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetSurahController.dispose();
    _targetJuzController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_targetDate != null && _targetDate!.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب أن يكون تاريخ الاستهداف بعد تاريخ البداية')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final dao = ref.read(goalDaoProvider);
      await dao.insert(GoalsCompanion(
        studentId: Value(_studentId!),
        title: Value(_titleController.text.trim()),
        goalType: Value(_goalType),
        targetSurahId: Value(_goalType == 'سورة' && _targetSurahController.text.trim().isNotEmpty ? int.tryParse(_targetSurahController.text.trim()) : null),
        targetJuzNumber: Value(_goalType == 'جزء' && _targetJuzController.text.trim().isNotEmpty ? int.tryParse(_targetJuzController.text.trim()) : null),
        startDate: Value(_startDate),
        targetDate: Value(_targetDate),
      ));
      if (mounted) {
        ref.invalidate(goalListProvider);
        AppSnackbar.success(context, 'تم حفظ الهدف');
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
      appBar: AppBar(title: const Text('إضافة هدف')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('معلومات الهدف', style: AppTextStyles.sectionTitle),
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
              AppFormField(
                controller: _titleController,
                label: 'عنوان الهدف',
                required: true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _goalType,
                decoration: const InputDecoration(labelText: 'نوع الهدف'),
                items: GoalType.values.map((t) => DropdownMenuItem(value: t.arabic, child: Text(t.arabic))).toList(),
                onChanged: (v) => setState(() {
                  _goalType = v!;
                  _isDirty = true;
                }),
              ),
              const SizedBox(height: 16),
              if (_goalType == 'سورة')
                TextFormField(
                  controller: _targetSurahController,
                  decoration: const InputDecoration(labelText: 'رقم السورة المستهدفة *'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'الرجاء إدخال رقم السورة المستهدفة';
                    final n = int.tryParse(v.trim());
                    if (n == null || n < 1 || n > 114) return 'يجب أن يكون رقم السورة بين 1 و 114';
                    return null;
                  },
                ),
              if (_goalType == 'جزء')
                TextFormField(
                  controller: _targetJuzController,
                  decoration: const InputDecoration(labelText: 'رقم الجزء المستهدف *'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'الرجاء إدخال رقم الجزء المستهدف';
                    final n = int.tryParse(v.trim());
                    if (n == null || n < 1 || n > 30) return 'يجب أن يكون رقم الجزء بين 1 و 30';
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              DatePickerTile(
                label: 'تاريخ البداية',
                value: _startDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                onChanged: (picked) => setState(() {
                  _startDate = picked;
                  _isDirty = true;
                }),
              ),
              DatePickerTile(
                label: 'تاريخ الاستهداف',
                icon: Icons.event,
                value: _targetDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
                onChanged: (picked) => setState(() {
                  _targetDate = picked;
                  _isDirty = true;
                }),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('حفظ الهدف'),
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
