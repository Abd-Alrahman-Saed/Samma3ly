import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    this.fontSize = 10,
  });

  factory StatusBadge.attendance(String status) {
    return switch (status) {
      'حاضر' => StatusBadge(
          text: status,
          backgroundColor: const Color(0xFFDCFCE7),
          foregroundColor: const Color(0xFF16A34A),
        ),
      'غائب' => StatusBadge(
          text: status,
          backgroundColor: const Color(0xFFFEE2E2),
          foregroundColor: const Color(0xFFDC2626),
        ),
      'معذور' => StatusBadge(
          text: status,
          backgroundColor: const Color(0xFFFEF9C3),
          foregroundColor: const Color(0xFFCA8A04),
        ),
      'متأخر' => StatusBadge(
          text: status,
          backgroundColor: const Color(0xFFFFEDD5),
          foregroundColor: const Color(0xFFEA580C),
        ),
      'مجدول' => StatusBadge(
          text: status,
          backgroundColor: const Color(0xFFDBEAFE),
          foregroundColor: const Color(0xFF2563EB),
        ),
      _ => StatusBadge(
          text: status,
          backgroundColor: const Color(0xFFF1F5F9),
          foregroundColor: const Color(0xFF64748B),
        ),
    };
  }

  factory StatusBadge.memorization(String status) {
    return switch (status) {
      'محفوظ' => StatusBadge(
          text: status,
          backgroundColor: const Color(0xFFDCFCE7),
          foregroundColor: const Color(0xFF16A34A),
        ),
      'يحتاج مراجعة' => StatusBadge(
          text: status,
          backgroundColor: const Color(0xFFFFEDD5),
          foregroundColor: const Color(0xFFEA580C),
        ),
      _ => StatusBadge(
          text: status,
          backgroundColor: const Color(0xFFF1F5F9),
          foregroundColor: const Color(0xFF64748B),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      constraints: const BoxConstraints(minWidth: 52),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }
}
