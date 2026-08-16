import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/domain/services/juz_quarter_progress_service.dart';
import 'package:quran_mobile/features/memorization/providers/juz_quarter_progress_provider.dart';

/// القسم ح.2 — تتبّع الحفظ اليدوي: قائمة الأجزاء الثلاثين، كل جزء بشريط
/// تقدّم ونسبة مبنيّين على كام ربع من ثمانية علّمه المعلّم كـ"محفوظ". الضغط
/// على جزء يفتح أربعته الثمانية (JuzQuartersScreen).
class JuzProgressScreen extends ConsumerWidget {
  final int studentId;

  const JuzProgressScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedAsync = ref.watch(juzQuarterProgressProvider(studentId));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  _RoundIconButton(icon: AppIcons.chevronRight, onTap: () => context.pop()),
                  const SizedBox(width: 10),
                  Expanded(child: Text('المحفوظ من القرآن', style: Theme.of(context).textTheme.titleLarge)),
                ],
              ),
            ),
            Expanded(
              child: completedAsync.when(
                loading: () => const LoadingOverlay(),
                error: (e, _) => ErrorBanner(message: e.toString()),
                data: (completed) {
                  final overall = JuzQuarterProgressService.overallPercentage(completed);
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: JuzQuarterProgressService.juzCount + 1,
                    itemBuilder: (_, i) {
                      if (i == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _OverallCard(percentage: overall, completedCount: completed.length),
                        );
                      }
                      final juzNumber = i;
                      final done = JuzQuarterProgressService.completedQuartersInJuz(completed, juzNumber);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _JuzRow(
                          juzNumber: juzNumber,
                          completedQuarters: done,
                          onTap: () => context.goNamed(
                            'juzQuarters',
                            pathParameters: {'id': '$studentId', 'juzNumber': '$juzNumber'},
                          ),
                        ),
                      );
                    },
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

class _RoundIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
          child: AppIcon(icon, size: 15, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _OverallCard extends StatelessWidget {
  final double percentage;
  final int completedCount;

  const _OverallCard({required this.percentage, required this.completedCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('النسبة الكلية', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text('${percentage.toStringAsFixed(0)}%', style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: AppColors.dividerLight,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$completedCount من ${JuzQuarterProgressService.totalQuarters} ربعاً محفوظاً',
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _JuzRow extends StatelessWidget {
  final int juzNumber;
  final int completedQuarters;
  final VoidCallback onTap;

  const _JuzRow({required this.juzNumber, required this.completedQuarters, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pct = completedQuarters / JuzQuarterProgressService.quartersPerJuz;
    final isComplete = completedQuarters == JuzQuarterProgressService.quartersPerJuz;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: isComplete ? AppColors.primaryLight : AppColors.dividerLight, shape: BoxShape.circle),
                child: isComplete
                    ? const AppIcon(AppIcons.checkCircle, size: 16, color: AppColors.primary)
                    : Text('$juzNumber', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('جزء $juzNumber', style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 5,
                        backgroundColor: AppColors.dividerLight,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$completedQuarters/${JuzQuarterProgressService.quartersPerJuz}',
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 4),
              const AppIcon(AppIcons.chevronLeft, size: 13, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
