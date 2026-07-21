import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/features/sessions/providers/session_provider.dart';
import 'package:quran_mobile/features/goals/providers/goal_provider.dart';
import 'package:quran_mobile/features/memorization/providers/memorization_provider.dart';

class StudentDetailsScreen extends ConsumerWidget {
  final int studentId;

  const StudentDetailsScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentByIdProvider(studentId));

    return studentAsync.when(
      loading: () => const Scaffold(body: LoadingOverlay()),
      error: (e, st) => Scaffold(body: ErrorBanner(message: e.toString())),
      data: (student) {
        if (student == null) {
          return const Scaffold(body: Center(child: Text('الطالب غير موجود')));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(student.fullName),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.goNamed('studentEdit', pathParameters: {'id': '$studentId'}),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('معلومات الطالب', style: AppTextStyles.sectionTitle),
                      const Divider(),
                      _InfoRow(label: 'الاسم', value: student.fullName),
                      _InfoRow(label: 'العمر', value: '${student.age}'),
                      _InfoRow(label: 'رقم الهاتف', value: student.phone ?? ''),
                      _InfoRow(label: 'العنوان', value: student.address ?? ''),
                      _InfoRow(label: 'ولي الأمر', value: student.parentName ?? ''),
                      _InfoRow(label: 'هاتف ولي الأمر', value: student.parentPhone ?? ''),
                      _InfoRow(label: 'المستوى', value: student.level),
                      _InfoRow(label: 'الأجزاء المكتملة', value: '${student.totalCompletedJuz}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.playlist_add_check,
                      label: 'جلسة جديدة',
                      onTap: () => context.goNamed('sessionCreate', pathParameters: {'studentId': '$studentId'}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.schedule,
                      label: 'جدولة',
                      onTap: () => context.goNamed('scheduleCreate', pathParameters: {'studentId': '$studentId'}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.auto_stories,
                      label: 'الحفظ',
                      onTap: () => context.goNamed('memorization', pathParameters: {'studentId': '$studentId'}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.flag,
                      label: 'هدف جديد',
                      onTap: () => context.goNamed('goalCreate', pathParameters: {'studentId': '$studentId'}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('الجلسات السابقة', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              _StudentSessionsList(studentId: studentId),
              const SizedBox(height: 24),
              Text('الأهداف', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              _StudentGoalsList(studentId: studentId),
            ],
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text('$label:', style: AppTextStyles.infoLabel)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: AppTextStyles.infoValue)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 4),
              Text(label, style: AppTextStyles.small),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudentSessionsList extends ConsumerWidget {
  final int studentId;

  const _StudentSessionsList({required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionsByStudentProvider(studentId));
    return sessionsAsync.when(
      loading: () => const LoadingOverlay(),
      error: (e, _) => ErrorBanner(message: e.toString()),
      data: (sessions) {
        if (sessions.isEmpty) return Text('لا توجد جلسات', style: AppTextStyles.muted);
        return Column(
          children: sessions.take(5).map((s) => Card(
            child: ListTile(
              title: Text(AppDateUtils.formatDate(s.date)),
              subtitle: Text('الحضور: ${s.attendanceStatus}'),
              trailing: s.evaluation != null ? Text('${s.evaluation!.finalScore.toStringAsFixed(1)}', style: AppTextStyles.score) : null,
            ),
          )).toList(),
        );
      },
    );
  }
}

class _StudentGoalsList extends ConsumerWidget {
  final int studentId;

  const _StudentGoalsList({required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsByStudentProvider(studentId));
    return goalsAsync.when(
      loading: () => const LoadingOverlay(),
      error: (e, _) => ErrorBanner(message: e.toString()),
      data: (goals) {
        if (goals.isEmpty) return Text('لا توجد أهداف', style: AppTextStyles.muted);
        return Column(
          children: goals.map((g) => Card(
            child: ListTile(
              title: Text(g.title),
              subtitle: Text('الحالة: ${g.status}'),
              trailing: Icon(
                g.status == 'مكتمل' ? Icons.check_circle : g.status == 'قيد التنفيذ' ? Icons.hourglass_top : Icons.radio_button_unchecked,
                color: g.status == 'مكتمل' ? AppColors.success : g.status == 'قيد التنفيذ' ? AppColors.warning : AppColors.textMuted,
              ),
            ),
          )).toList(),
        );
      },
    );
  }
}
