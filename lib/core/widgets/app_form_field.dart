import 'package:flutter/material.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';

/// Shared text field style — matches every placeholder-only input in the
/// adopted design (setup, student form, session form, goal/schedule
/// sheets): no floating label, hint text directly in the field, `10px`
/// radius, `#E7E1D3` border. See docs/DESIGN_SPEC.md §3.
///
/// [onCard] switches the fill color for fields inside bottom sheets
/// (`#FFFFFF`) vs. cream-background screens (`#FBFAF6`) — both literal
/// values from the design source.
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
  final bool onCard;
  final bool obscureText;
  final Widget? suffixIcon;

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
    this.onCard = false,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = hintText ?? (required ? '$label *' : label);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: obscureText ? 1 : maxLines,
      obscureText: obscureText,
      textInputAction: textInputAction,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 14, color: AppColors.textMuted),
        helperText: helperText,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: onCard ? AppColors.inputBgOnCard : AppColors.inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      ),
      validator: validator ?? (required ? (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال $label' : null : null),
      onChanged: onChanged,
    );
  }
}
