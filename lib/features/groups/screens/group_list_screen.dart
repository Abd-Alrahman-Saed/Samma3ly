import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/widgets/confirm_delete.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/core/widgets/staggered_list_item.dart';
import 'package:quran_mobile/domain/entities/group.dart';
import 'package:quran_mobile/features/groups/providers/group_provider.dart';
import 'package:quran_mobile/providers.dart';

class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  Future<void> _delete(BuildContext context, WidgetRef ref, Group group) async {
    final confirmed = await confirmDelete(
      context,
      message: 'هل أنت متأكد من حذف حلقة "${group.name}"؟ سيُحذف أعضاؤها ومواعيدها الأسبوعية أيضاً.',
    );
    if (!confirmed) return;
    final repo = ref.read(groupRepositoryProvider);
    await repo.delete(group.id);
    ref.read(groupRefreshProvider.notifier).state++;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(refreshableGroupListProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الحلقات الجماعية', style: Theme.of(context).textTheme.headlineSmall),
                  InkWell(
                    onTap: () => context.goNamed('groupCreate'),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                      child: const AppIcon(AppIcons.plus, size: 18, color: AppColors.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: groupsAsync.when(
                loading: () => const ListSkeleton(),
                error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(refreshableGroupListProvider)),
                data: (groups) {
                  if (groups.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(color: Color(0xFFE9F3EF), shape: BoxShape.circle),
                            child: const AppIcon(AppIcons.peopleTab, size: 26, color: AppColors.primary),
                          ),
                          const SizedBox(height: 14),
                          Text('لا توجد حلقات جماعية', style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 4),
                          Text('أنشئ أول حلقة لتنظيم جلسات جماعية متكرّرة', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => ref.read(groupRefreshProvider.notifier).state++,
                    child: AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 6, 20, 90),
                        itemCount: groups.length,
                        itemBuilder: (_, i) {
                          final group = groups[i];
                          return StaggeredListItem(
                            index: i,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _GroupRow(
                                group: group,
                                onTap: () => context.goNamed('groupDetails', pathParameters: {'id': '${group.id}'}),
                                onDelete: () => _delete(context, ref, group),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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

class _GroupRow extends ConsumerWidget {
  final Group group;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _GroupRow({required this.group, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberCountAsync = ref.watch(groupMemberCountProvider(group.id));
    final slotsAsync = ref.watch(groupSlotsProvider(group.id));

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const AppIcon(AppIcons.peopleTab, size: 18, color: AppColors.onPrimary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.dividerLight, borderRadius: BorderRadius.circular(999)),
                          child: Text(
                            '${memberCountAsync.valueOrNull ?? 0} طالب',
                            style: const TextStyle(fontFamily: 'Cairo', fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${slotsAsync.valueOrNull?.length ?? 0} موعد أسبوعي',
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: 'حذف الحلقة',
                icon: const AppIcon(AppIcons.trash, size: 16, color: AppColors.deleteIcon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
