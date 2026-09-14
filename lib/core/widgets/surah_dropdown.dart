import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';

class SurahDropdown extends ConsumerWidget {
  final int? value;
  final ValueChanged<int?> onChanged;
  final String label;
  final String noneLabel;

  const SurahDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'السورة',
    this.noneLabel = 'بدون',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListProvider);
    return surahsAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('تعذر تحميل قائمة السور: $e'),
      data: (surahs) {
        final validValue = surahs.any((s) => s.id == value) ? value : null;
        return DropdownButtonFormField<int?>(
          initialValue: validValue,
          isExpanded: true,
          decoration: InputDecoration(labelText: label),
          items: [
            DropdownMenuItem<int?>(value: null, child: Text(noneLabel)),
            ...surahs.map((s) => DropdownMenuItem<int?>(
                  value: s.id,
                  child: Text('${s.number}. ${s.name}'),
                )),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}
