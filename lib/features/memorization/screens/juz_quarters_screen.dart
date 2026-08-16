import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/domain/services/juz_quarter_progress_service.dart';
import 'package:quran_mobile/features/memorization/providers/juz_quarter_progress_provider.dart';
import 'package:quran_mobile/providers.dart';

/// أرباع جزء واحد (تقسيم "ربع الحزب" المطبوع في المصحف — 8 أرباع لكل جزء).
/// الضغط على ربع يعلّمه محفوظاً/غير محفوظ فوراً (بلا زر حفظ منفصل).
class JuzQuartersScreen extends ConsumerWidget {
  final int studentId;
  final int juzNumber;

  const JuzQuartersScreen({super.key, required this.studentId, required this.juzNumber});

  Future<void> _toggle(WidgetRef ref, int quarterIndex, bool completed) async {
    await ref.read(juzQuarterProgressServiceProvider).setQuarterCompleted(studentId, juzNumber, quarterIndex, completed);
    ref.read(juzQuarterProgressRefreshProvider(studentId).notifier).state++;
    HapticFeedback.selectionClick();
  }

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
                  Expanded(child: Text('جزء $juzNumber', style: Theme.of(context).textTheme.titleLarge)),
                ],
              ),
            ),
            Expanded(
              child: completedAsync.when(
                loading: () => const LoadingOverlay(),
                error: (e, _) => ErrorBanner(message: e.toString()),
                data: (completed) {
                  final done = JuzQuarterProgressService.completedQuartersInJuz(completed, juzNumber);
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: JuzQuarterProgressService.quartersPerJuz + 1,
                    itemBuilder: (_, i) {
                      if (i == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _JuzProgressHeader(completedQuarters: done),
                        );
                      }
                      final quarterIndex = i;
                      final isDone = completed.contains((juzNumber, quarterIndex));
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _QuarterRow(
                          quarterIndex: quarterIndex,
                          completed: isDone,
                          onTap: () => _toggle(ref, quarterIndex, !isDone),
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

class _JuzProgressHeader extends StatelessWidget {
  final int completedQuarters;

  const _JuzProgressHeader({required this.completedQuarters});

  @override
  Widget build(BuildContext context) {
    final pct = completedQuarters / JuzQuarterProgressService.quartersPerJuz * 100;
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
              Text(
                '$completedQuarters/${JuzQuarterProgressService.quartersPerJuz} أرباع محفوظة',
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: pct / 100,
              minHeight: 8,
              backgroundColor: AppColors.dividerLight,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuarterRow extends StatelessWidget {
  final int quarterIndex;
  final bool completed;
  final VoidCallback onTap;

  const _QuarterRow({required this.quarterIndex, required this.completed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: completed ? AppColors.primaryLight : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: ValueKey('quarterRow-$quarterIndex'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: completed ? AppColors.primary : AppColors.cardBorder)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'الربع $quarterIndex',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w700, color: completed ? AppColors.primary : AppColors.textPrimary),
                ),
              ),
              AppIcon(
                completed ? AppIcons.checkCircle : AppIcons.circleDash,
                size: 20,
                color: completed ? AppColors.primary : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
