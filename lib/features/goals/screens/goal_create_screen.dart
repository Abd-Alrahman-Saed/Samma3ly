import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/enums/goal_type.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
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

  @override
  void initState() {
    super.initState();
    _studentId = widget.studentId;
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
              if (_studentId == null)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'رقم الطالب *'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال رقم الطالب' : null,
                  onChanged: (v) => _studentId = int.tryParse(v.trim()),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'عنوان الهدف *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال عنوان الهدف' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _goalType,
                decoration: const InputDecoration(labelText: 'نوع الهدف'),
                items: GoalType.values.map((t) => DropdownMenuItem(value: t.arabic, child: Text(t.arabic))).toList(),
                onChanged: (v) => setState(() => _goalType = v!),
              ),
              const SizedBox(height: 16),
              if (_goalType == 'سورة')
                TextFormField(
                  controller: _targetSurahController,
                  decoration: const InputDecoration(labelText: 'رقم السورة المستهدفة'),
                  keyboardType: TextInputType.number,
                ),
              if (_goalType == 'جزء')
                TextFormField(
                  controller: _targetJuzController,
                  decoration: const InputDecoration(labelText: 'رقم الجزء المستهدف'),
                  keyboardType: TextInputType.number,
                ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text('تاريخ البداية: ${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}'),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final picked = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2030), initialDate: _startDate);
                  if (picked != null) setState(() => _startDate = picked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.event),
                title: Text(_targetDate != null ? 'تاريخ الاستهداف: ${_targetDate!.year}-${_targetDate!.month.toString().padLeft(2, '0')}-${_targetDate!.day.toString().padLeft(2, '0')}' : 'تاريخ الاستهداف: (اختياري)'),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2030), initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 30)));
                  if (picked != null) setState(() => _targetDate = picked);
                },
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
    );
  }
}
