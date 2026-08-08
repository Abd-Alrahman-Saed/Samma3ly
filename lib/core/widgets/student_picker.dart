import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/domain/entities/student.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';

class StudentPicker extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;

  const StudentPicker({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FormField<int>(
      initialValue: value,
      validator: (v) => v == null ? 'الرجاء اختيار الطالب' : null,
      builder: (field) {
        return Consumer(
          builder: (context, ref, _) {
            final studentsAsync = ref.watch(allStudentsProvider);
            return studentsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('تعذر تحميل قائمة الطلاب: $e'),
              data: (students) {
                Student? selected;
                for (final s in students) {
                  if (s.id == field.value) {
                    selected = s;
                    break;
                  }
                }
                return InkWell(
                  onTap: () async {
                    final picked = await showModalBottomSheet<Student>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => _StudentPickerSheet(students: students),
                    );
                    if (picked != null) {
                      field.didChange(picked.id);
                      onChanged(picked.id);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'الطالب *',
                      errorText: field.errorText,
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(selected?.fullName ?? 'اختر طالباً'),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _StudentPickerSheet extends StatefulWidget {
  final List<Student> students;

  const _StudentPickerSheet({required this.students});

  @override
  State<_StudentPickerSheet> createState() => _StudentPickerSheetState();
}

class _StudentPickerSheetState extends State<_StudentPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.trim().isEmpty
        ? widget.students
        : widget.students.where((s) => s.fullName.contains(_query.trim())).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('اختر الطالب', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 12),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'بحث عن طالب...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('لا يوجد طلاب مطابقون'))
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final s = filtered[i];
                          return ListTile(
                            leading: ExcludeSemantics(child: CircleAvatar(child: Text(s.fullName.substring(0, 1)))),
                            title: Text(s.fullName),
                            subtitle: Text(s.level),
                            onTap: () => Navigator.pop(context, s),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
