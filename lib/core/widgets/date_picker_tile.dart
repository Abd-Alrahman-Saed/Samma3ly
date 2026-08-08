import 'package:flutter/material.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';

class DatePickerTile extends StatelessWidget {
  final String? label;
  final DateTime? value;
  final String emptyLabel;
  final ValueChanged<DateTime> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final IconData icon;

  const DatePickerTile({
    super.key,
    this.label,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.emptyLabel = '(اختياري)',
    this.icon = Icons.calendar_month,
  });

  @override
  Widget build(BuildContext context) {
    final display = value != null ? AppDateUtils.formatDate(value!) : emptyLabel;
    return ListTile(
      leading: Icon(icon),
      title: Text(label != null ? '$label: $display' : display),
      trailing: const Icon(Icons.edit),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: firstDate,
          lastDate: lastDate,
          initialDate: value ?? DateTime.now(),
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}
