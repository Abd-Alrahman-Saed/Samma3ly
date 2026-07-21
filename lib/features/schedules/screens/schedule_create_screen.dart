import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
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

  @override
  void initState() {
    super.initState();
    _studentId = widget.studentId;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final dao = ref.read(scheduleDaoProvider);
      final timeStr = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
      await dao.insert(SchedulesCompanion(
        studentId: Value(_studentId!),
        date: Value(_selectedDate),
        time: Value(timeStr),
      ));
      if (mounted) {
        ref.invalidate(upcomingScheduleListProvider);
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
              if (_studentId == null)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'رقم الطالب *'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال رقم الطالب' : null,
                  onChanged: (v) => _studentId = int.tryParse(v.trim()),
                ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text('${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)), initialDate: _selectedDate);
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
    );
  }
}
