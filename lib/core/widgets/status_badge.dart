import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/core/enums/memorized_status.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';

/// A small pill showing a status word, always paired with a distinct
/// foreground color (never color alone — see docs/UI_DESIGN_SYSTEM.md §2.2).
///
/// The background is a translucent tint of [foregroundColor] by default —
/// that makes it theme-aware for free: over a light card it reads as a
/// pastel highlight, over a dark card as a subdued glow, with no
/// light/dark branching needed (Sprint 1, item 1.4).
class StatusBadge extends StatelessWidget {
  final String text;
  final Color foregroundColor;
  final Color? backgroundColor;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.text,
    required this.foregroundColor,
    this.backgroundColor,
    this.fontSize = 12,
  });

  factory StatusBadge.attendance(String status) {
    final match = AttendanceStatus.values.firstWhereOrNull((s) => s.arabic == status);
    final color = switch (match) {
      AttendanceStatus.present => StatusColors.present,
      AttendanceStatus.absent => StatusColors.absent,
      AttendanceStatus.excused => StatusColors.excused,
      AttendanceStatus.late => StatusColors.attendanceLate,
      null => StatusColors.notMemorized,
    };
    return StatusBadge(text: status, foregroundColor: color);
  }

  factory StatusBadge.memorization(String status) {
    final match = MemorizedStatus.values.firstWhereOrNull((s) => s.arabic == status);
    final color = switch (match) {
      MemorizedStatus.memorized => StatusColors.memorized,
      MemorizedStatus.needsRevision => StatusColors.needsRevision,
      MemorizedStatus.notMemorized || null => StatusColors.notMemorized,
    };
    return StatusBadge(text: status, foregroundColor: color);
  }

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? foregroundColor.withValues(alpha: 0.15);
    return Semantics(
      label: text,
      child: Container(
        height: 22,
        constraints: const BoxConstraints(minWidth: 52),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: ExcludeSemantics(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: foregroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
