import 'package:flutter/material.dart';

class ScoreField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onChanged;

  const ScoreField({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: 'من 10'),
      keyboardType: TextInputType.number,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return null;
        final n = double.tryParse(v.trim());
        if (n == null) return 'الرجاء إدخال رقم صحيح';
        if (n < 0 || n > 10) return 'يجب أن تكون الدرجة بين 0 و 10';
        return null;
      },
      onChanged: (v) {
        final parsed = double.tryParse(v);
        if (parsed != null && parsed > 10) {
          controller.text = '10';
          controller.selection = TextSelection.collapsed(offset: controller.text.length);
        }
        onChanged?.call(v);
      },
    );
  }
}
