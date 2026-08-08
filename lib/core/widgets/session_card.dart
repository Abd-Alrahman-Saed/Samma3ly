import 'package:flutter/material.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'score_display.dart';
import 'status_badge.dart';

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

class SessionCard extends StatelessWidget {
  final SessionCardItem item;
  final VoidCallback? onTap;

  const SessionCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              ExcludeSemantics(
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    item.initials,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.studentName,
                      style: textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.timeDisplay.isNotEmpty
                          ? '${AppDateUtils.formatDate(item.date)} | ${item.timeDisplay}'
                          : AppDateUtils.formatDate(item.date),
                      style: textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.memorizationInfo.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          item.memorizationInfo,
                          style: TextStyle(fontSize: 12, color: colorScheme.primary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (item.revisionInfo.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          item.revisionInfo,
                          style: TextStyle(fontSize: 12, color: colorScheme.secondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusBadge.attendance(item.attendanceStatus),
                  if (!item.isSchedule)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        height: 22,
                        constraints: const BoxConstraints(minWidth: 44),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: ScoreDisplay(score: item.finalScore),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
