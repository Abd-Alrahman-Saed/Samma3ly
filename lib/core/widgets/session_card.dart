import 'package:flutter/material.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
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
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  item.initials,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          AppDateUtils.formatDate(item.date),
                          style: AppTextStyles.small,
                        ),
                        if (item.timeDisplay.isNotEmpty) ...[
                          Text(' | ${item.timeDisplay}', style: AppTextStyles.muted),
                        ],
                      ],
                    ),
                    if (item.memorizationInfo.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          item.memorizationInfo,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    if (item.revisionInfo.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          item.revisionInfo,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8B5CF6),
                          ),
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
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${item.finalScore.toStringAsFixed(0)}/10',
                            style: AppTextStyles.score,
                          ),
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
