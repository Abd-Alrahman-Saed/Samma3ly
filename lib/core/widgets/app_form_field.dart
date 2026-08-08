import 'package:flutter/material.dart';

class AppFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final bool required;
  final String? helperText;
  final String? hintText;
  final TextInputType? keyboardType;
  final int maxLines;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  const AppFormField({
    super.key,
    this.controller,
    required this.label,
    this.required = false,
    this.helperText,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        helperText: helperText,
        hintText: hintText,
      ),
      validator: validator ?? (required ? (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال $label' : null : null),
      onChanged: onChanged,
    );
  }
}
