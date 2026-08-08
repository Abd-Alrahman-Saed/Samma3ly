import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/enums/student_level.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/confirm_dialog.dart';
import 'package:quran_mobile/core/widgets/discard_changes_dialog.dart';
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
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.studentId != null;
    if (_isEdit) _loadStudent();
    for (final c in [_fullNameController, _ageController, _phoneController, _addressController, _parentNameController, _parentPhoneController]) {
      c.addListener(() => _isDirty = true);
    }
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
      _isDirty = false;
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
    final dao = ref.read(studentDaoProvider);
    if (!_isEdit) {
      final name = _fullNameController.text.trim();
      final matches = await dao.getAll(search: name);
      final hasDuplicate = matches.any((s) => s.fullName.trim().toLowerCase() == name.toLowerCase());
      if (hasDuplicate) {
        if (!mounted) return;
        final proceed = await showConfirmDialog(
          context,
          title: 'طالب مكرر؟',
          message: 'يوجد طالب آخر بنفس الاسم "$name". هل تريد المتابعة؟',
          confirmLabel: 'متابعة',
        );
        if (!proceed) return;
      }
    }
    setState(() => _isLoading = true);
    try {
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
        AppSnackbar.success(context, _isEdit ? 'تم تحديث بيانات الطالب' : 'تم حفظ الطالب');
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
                    final age = int.tryParse(v.trim());
                    if (age == null) return 'الرجاء إدخال رقم صحيح';
                    if (age < 3 || age > 100) return 'يجب أن يكون العمر بين 3 و 100';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedLevel,
                  decoration: const InputDecoration(labelText: 'المستوى'),
                  items: StudentLevel.values.map((l) => DropdownMenuItem(value: l.arabic, child: Text(l.arabic))).toList(),
                  onChanged: (v) => setState(() {
                    _selectedLevel = v!;
                    _isDirty = true;
                  }),
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
      ),
    );
  }
}
