import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/enums/student_level.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

class StudentCreateScreen extends ConsumerStatefulWidget {
  final int? studentId;

  const StudentCreateScreen({super.key, this.studentId});

  @override
  ConsumerState<StudentCreateScreen> createState() => _StudentCreateScreenState();
}

class _StudentCreateScreenState extends ConsumerState<StudentCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  String _selectedLevel = 'مبتدئ';
  bool _isLoading = false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.studentId != null;
    if (_isEdit) _loadStudent();
  }

  Future<void> _loadStudent() async {
    final dao = ref.read(studentDaoProvider);
    final student = await dao.getById(widget.studentId!);
    if (student != null && mounted) {
      _fullNameController.text = student.fullName;
      _ageController.text = '${student.age}';
      _phoneController.text = student.phone ?? '';
      _addressController.text = student.address ?? '';
      _parentNameController.text = student.parentName ?? '';
      _parentPhoneController.text = student.parentPhone ?? '';
      _selectedLevel = student.level;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final dao = ref.read(studentDaoProvider);
      if (_isEdit) {
        await dao.updateEntry(StudentsCompanion(
          id: Value(widget.studentId!),
          fullName: Value(_fullNameController.text.trim()),
          age: Value(int.parse(_ageController.text.trim())),
          phone: Value(_phoneController.text.trim().isEmpty ? '' : _phoneController.text.trim()),
          address: Value(_addressController.text.trim().isEmpty ? '' : _addressController.text.trim()),
          parentName: Value(_parentNameController.text.trim().isEmpty ? null : _parentNameController.text.trim()),
          parentPhone: Value(_parentPhoneController.text.trim().isEmpty ? null : _parentPhoneController.text.trim()),
          level: Value(_selectedLevel),
        ));
      } else {
        await dao.insert(StudentsCompanion(
          fullName: Value(_fullNameController.text.trim()),
          age: Value(int.parse(_ageController.text.trim())),
          phone: Value(_phoneController.text.trim().isEmpty ? '' : _phoneController.text.trim()),
          address: Value(_addressController.text.trim().isEmpty ? '' : _addressController.text.trim()),
          parentName: Value(_parentNameController.text.trim().isEmpty ? null : _parentNameController.text.trim()),
          parentPhone: Value(_parentPhoneController.text.trim().isEmpty ? null : _parentPhoneController.text.trim()),
          level: Value(_selectedLevel),
        ));
      }
      if (mounted) {
        ref.invalidate(studentListProvider);
        ref.invalidate(refreshableStudentListProvider);
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
      appBar: AppBar(title: Text(_isEdit ? 'تعديل طالب' : 'إضافة طالب')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('البيانات الأساسية', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'الاسم الكامل *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال الاسم' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'العمر *'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'الرجاء إدخال العمر';
                  if (int.tryParse(v.trim()) == null) return 'الرجاء إدخال رقم صحيح';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedLevel,
                decoration: const InputDecoration(labelText: 'المستوى'),
                items: StudentLevel.values.map((l) => DropdownMenuItem(value: l.arabic, child: Text(l.arabic))).toList(),
                onChanged: (v) => setState(() => _selectedLevel = v!),
              ),
              const SizedBox(height: 24),
              Text('معلومات الاتصال', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'العنوان'),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              Text('ولي الأمر', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 16),
              TextFormField(
                controller: _parentNameController,
                decoration: const InputDecoration(labelText: 'اسم ولي الأمر'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _parentPhoneController,
                decoration: const InputDecoration(labelText: 'هاتف ولي الأمر'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(_isEdit ? 'حفظ التعديلات' : 'إضافة الطالب'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
