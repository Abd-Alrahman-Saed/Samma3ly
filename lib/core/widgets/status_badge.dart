import 'package:flutter/material.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';

/// A small pill showing a status word — exact (fg, bg) pairs from
/// docs/DESIGN_SPEC.md, never color alone (always paired with the text
/// label itself, sometimes an icon too at the call site).
class StatusBadge extends StatelessWidget {
  final String text;
  final Color foregroundColor;
  final Color backgroundColor;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.text,
    required this.foregroundColor,
    required this.backgroundColor,
    this.fontSize = 11,
  });

  factory StatusBadge.attendance(String status) {
    final c = StatusColors.forAttendance(status);
    return StatusBadge(text: status, foregroundColor: c.fg, backgroundColor: c.bg);
  }

  factory StatusBadge.memorization(String status) {
    final c = StatusColors.forMemorization(status);
    return StatusBadge(text: status, foregroundColor: c.fg, backgroundColor: c.bg);
  }

  factory StatusBadge.goal(String status) {
    final c = StatusColors.forGoal(status);
    return StatusBadge(text: status, foregroundColor: c.fg, backgroundColor: c.bg);
  }

  factory StatusBadge.level(String level) {
    final c = StatusColors.forLevel(level);
    return StatusBadge(text: level, foregroundColor: c.fg, backgroundColor: c.bg, fontSize: 10.5);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      child: Container(
        height: 22,
        constraints: const BoxConstraints(minWidth: 52),
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999), // pill — نصف قطر الشارات في التصميم المعتمد
        ),
        child: Center(
          child: ExcludeSemantics(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: foregroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
