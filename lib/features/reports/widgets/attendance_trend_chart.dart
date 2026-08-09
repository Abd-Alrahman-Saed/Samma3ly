import 'package:flutter/material.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/domain/entities/dashboard_data.dart';

/// Weekly attendance bar chart — a plain custom-drawn bar row, exactly
/// matching the adopted design (no charting library: seven flex columns,
/// each bar scaled by attendance percent, day label below). See
/// docs/DESIGN_SPEC.md.
class AttendanceTrendChart extends StatelessWidget {
  final List<WeeklyAttendanceData> data;

  const AttendanceTrendChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in data)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Expanded(
                      child: Semantics(
                        label: '${AppDateUtils.weekDayName(item.date)}: ${item.percent.toStringAsFixed(0)}%',
                        child: ExcludeSemantics(
                          child: FractionallySizedBox(
                            heightFactor: item.percent.clamp(0, 100) / 100,
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 2),
                              decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.vertical(top: Radius.circular(6))),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(AppDateUtils.weekDayName(item.date).substring(0, 3), style: const TextStyle(fontFamily: 'Cairo', fontSize: 9.5, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
