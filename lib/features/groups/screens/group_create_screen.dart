import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/widgets/app_form_field.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/discard_changes_dialog.dart';
import 'package:quran_mobile/domain/entities/group.dart';
import 'package:quran_mobile/domain/entities/user.dart';
import 'package:quran_mobile/features/groups/providers/group_provider.dart';
import 'package:quran_mobile/features/settings/providers/settings_provider.dart';
import 'package:quran_mobile/providers.dart';

class GroupCreateScreen extends ConsumerStatefulWidget {
  final int? groupId;

  const GroupCreateScreen({super.key, this.groupId});

  @override
  ConsumerState<GroupCreateScreen> createState() => _GroupCreateScreenState();
}

class _GroupCreateScreenState extends ConsumerState<GroupCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int? _teacherId;
  bool _isLoading = false;
  bool _isEdit = false;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.groupId != null;
    if (_isEdit) _loadGroup();
    _nameController.addListener(() => _isDirty = true);
  }

  Future<void> _loadGroup() async {
    final repo = ref.read(groupRepositoryProvider);
    final group = await repo.getById(widget.groupId!);
    if (group != null && mounted) {
      _nameController.text = group.name;
      _teacherId = group.teacherId;
      setState(() {});
      _isDirty = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(groupRepositoryProvider);
      if (_isEdit) {
        await repo.update(Group(id: widget.groupId!, name: _nameController.text.trim(), teacherId: _teacherId));
      } else {
        await repo.create(Group(name: _nameController.text.trim(), teacherId: _teacherId));
      }
      if (mounted) {
        ref.read(groupRefreshProvider.notifier).state++;
        AppSnackbar.success(context, _isEdit ? 'تم تحديث بيانات الحلقة' : 'تم إنشاء الحلقة');
        _isDirty = false;
        context.pop();
      }
    } catch (e) {
      if (mounted) AppSnackbar.error(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(allUsersProvider);

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final discard = await confirmDiscardChanges(context);
        if (discard && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
                          child: const AppIcon(AppIcons.chevronRight, size: 16, color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(_isEdit ? 'تعديل حلقة' : 'حلقة جديدة', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppFormField(
                          controller: _nameController,
                          label: 'اسم الحلقة',
                          hintText: 'اسم الحلقة *',
                          validator: (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال اسم الحلقة' : null,
                        ),
                        const SizedBox(height: 14),
                        usersAsync.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (e, _) => const SizedBox.shrink(),
                          data: (users) => _TeacherDropdown(
                            value: _teacherId,
                            users: users,
                            onChanged: (v) => setState(() {
                              _teacherId = v;
                              _isDirty = true;
                            }),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _save,
                            child: _isLoading
                                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                                : Text(_isEdit ? 'حفظ التعديلات' : 'إنشاء الحلقة'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeacherDropdown extends StatelessWidget {
  final int? value;
  final List<User> users;
  final ValueChanged<int?> onChanged;

  const _TeacherDropdown({required this.value, required this.users, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int?>(
      initialValue: value,
      isExpanded: true,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'المعلم المسؤول (اختياري)',
        filled: true,
        fillColor: AppColors.inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      ),
      items: [
        const DropdownMenuItem<int?>(value: null, child: Text('بلا معلم محدَّد')),
        for (final u in users) DropdownMenuItem<int?>(value: u.id, child: Text(u.fullName)),
      ],
      onChanged: onChanged,
    );
  }
}
