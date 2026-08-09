import 'package:flutter/material.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'score_display.dart';

class SessionCardItem {
  final int id;
  final int studentId;
  final String studentName;
  final String initials;
  final DateTime date;
  final String timeDisplay;
  final String attendanceStatus;
  final double finalScore;
  final String memorizationInfo;
  final String revisionInfo;
  final bool isSchedule;

  SessionCardItem({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.initials,
    required this.date,
    required this.timeDisplay,
    required this.attendanceStatus,
    this.finalScore = 0,
    this.memorizationInfo = '',
    this.revisionInfo = '',
    this.isSchedule = false,
  });
}

/// Session row card — exact layout from the adopted design: avatar +
/// name/date on top-right, attendance pill top-left, optional
/// memorization/revision lines below, then a score pill + delete button
/// on the bottom row. See docs/DESIGN_SPEC.md §"شاشة الجلسات".
class SessionCard extends StatelessWidget {
  final SessionCardItem item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SessionCard({super.key, required this.item, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final statusColors = StatusColors.forAttendance(item.attendanceStatus);
    final hasScore = !item.isSchedule && item.finalScore > 0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: Color(0xFFE9F3EF), shape: BoxShape.circle),
                      child: Text(item.initials, style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.studentName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        const SizedBox(height: 1),
                        Text(
                          item.timeDisplay.isNotEmpty ? '${AppDateUtils.formatDate(item.date)} · ${item.timeDisplay}' : AppDateUtils.formatDate(item.date),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(color: statusColors.bg, borderRadius: BorderRadius.circular(999)),
                    child: Text(item.attendanceStatus, style: TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w700, color: statusColors.fg)),
                  ),
                ],
              ),
              if (item.memorizationInfo.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(item.memorizationInfo, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.primary)),
                ),
              if (item.revisionInfo.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(item.revisionInfo, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.streakIconFg)),
                ),
              if (hasScore || onDelete != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (hasScore)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.dividerLight, borderRadius: BorderRadius.circular(999)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ScoreDisplay(score: item.finalScore, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      if (onDelete != null)
                        IconButton(
                          onPressed: onDelete,
                          tooltip: 'حذف الجلسة',
                          icon: const AppIcon(AppIcons.trash, size: 15, color: AppColors.deleteIcon),
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
