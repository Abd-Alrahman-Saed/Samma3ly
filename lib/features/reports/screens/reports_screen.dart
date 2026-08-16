import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/kpi_card.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/domain/entities/dashboard_data.dart';
import 'package:quran_mobile/features/dashboard/providers/dashboard_provider.dart';
import 'package:quran_mobile/features/reports/widgets/attendance_trend_chart.dart';
import 'package:quran_mobile/features/reports/widgets/top_students_score_chart.dart';
import 'package:quran_mobile/features/reports/widgets/student_report_section.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  String _summaryText(DashboardData data) {
    final buffer = StringBuffer()
      ..writeln('تقرير نظام إدارة وتحفيظ القرآن الكريم')
      ..writeln('إجمالي الطلاب: ${data.totalStudents}')
      ..writeln('إجمالي الجلسات: ${data.totalSessionsEver}')
      ..writeln('المعلمون: ${data.totalTeachers}')
      ..writeln('نسبة الحضور: ${data.averageAttendance.toStringAsFixed(0)}%')
      ..writeln('الصفحات المحفوظة: ${data.totalPagesMemorized}')
      ..writeln('السور المكتملة: ${data.totalSurahsCompleted}');
    if (data.topStudents.isNotEmpty) {
      buffer.writeln('\nأفضل الطلاب:');
      for (final s in data.topStudents) {
        buffer.writeln('- ${s.studentName}: ${s.averageScore.toStringAsFixed(1)}/10');
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('التقارير', style: Theme.of(context).textTheme.headlineSmall),
                  if (dashboardAsync.hasValue)
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () => SharePlus.instance.share(
                          ShareParams(text: _summaryText(dashboardAsync.value!), subject: 'تقرير نظام إدارة وتحفيظ القرآن الكريم'),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 38,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
                          child: const AppIcon(AppIcons.share, size: 17, color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: dashboardAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      KpiGridSkeleton(rows: 2),
                      SizedBox(height: 24),
                      Expanded(child: ListSkeleton(itemCount: 5)),
                    ],
                  ),
                ),
                error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(dashboardProvider)),
                data: (data) {
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                    children: [
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        // القسم ح.5: 1.7 كانت تضيّق البطاقات لدرجة تُسبّب فيض
                        // نص فعلي (سطر القيمة الكبير + سطر العنوان يتزاحمان) —
                        // 1.5 هي نفس النسبة المستخدَمة فعلياً في KpiCard
                        // بالداشبورد (dashboard_screen.dart) لنفس الودجت.
                        childAspectRatio: 1.5,
                        children: [
                          KpiCard(icon: AppIcons.people, title: 'إجمالي الطلاب', value: '${data.totalStudents}'),
                          KpiCard(icon: AppIcons.calendar, title: 'الجلسات', value: '${data.totalSessionsEver}'),
                          KpiCard(icon: AppIcons.checkCircle, title: 'نسبة الحضور', value: '${data.averageAttendance.toStringAsFixed(0)}%'),
                          KpiCard(icon: AppIcons.book, title: 'الصفحات المحفوظة', value: '${data.totalPagesMemorized}'),
                        ],
                      ),
                      const SizedBox(height: 22),
                      const Text('اتجاه الحضور الأسبوعي', style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      if (data.weeklyAttendance.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('لا توجد بيانات حضور كافية بعد', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary)),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
                          child: AttendanceTrendChart(data: data.weeklyAttendance),
                        ),
                      const SizedBox(height: 22),
                      const Text('أفضل 5 طلاب', style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      if (data.topStudents.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('لا توجد بيانات كافية بعد', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary)),
                        )
                      else
                        TopStudentsScoreChart(students: data.topStudents),
                      const SizedBox(height: 22),
                      const Text('تقرير طالب', style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      const StudentReportSection(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
