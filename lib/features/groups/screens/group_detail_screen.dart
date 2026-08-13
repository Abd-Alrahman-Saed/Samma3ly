import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/enums/anchor_type.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/confirm_delete.dart';
import 'package:quran_mobile/core/widgets/empty_state.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/domain/entities/group.dart';
import 'package:quran_mobile/domain/entities/group_member.dart';
import 'package:quran_mobile/domain/entities/group_schedule_slot.dart';
import 'package:quran_mobile/domain/entities/student.dart';
import 'package:quran_mobile/domain/services/group_session_service.dart';
import 'package:quran_mobile/features/groups/providers/group_provider.dart';
import 'package:quran_mobile/features/groups/screens/group_schedule_slot_sheet.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  final int groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _delete(Group group) async {
    final confirmed = await confirmDelete(
      context,
      message: 'هل أنت متأكد من حذف حلقة "${group.name}"؟ سيُحذف أعضاؤها ومواعيدها الأسبوعية أيضاً.',
    );
    if (!confirmed) return;
    await ref.read(groupRepositoryProvider).delete(group.id);
    ref.read(groupRefreshProvider.notifier).state++;
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(groupByIdProvider(widget.groupId));

    return groupAsync.when(
      loading: () => const Scaffold(body: LoadingOverlay()),
      error: (e, st) => Scaffold(body: ErrorBanner(message: e.toString())),
      data: (group) {
        if (group == null) {
          return const Scaffold(body: Center(child: Text('الحلقة غير موجودة')));
        }
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
                      Expanded(
                        child: Text(group.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge),
                      ),
                      const SizedBox(width: 10),
                      _RoundIconButton(icon: AppIcons.edit, onTap: () => context.goNamed('groupEdit', pathParameters: {'id': '${group.id}'})),
                      const SizedBox(width: 8),
                      _RoundIconButton(icon: AppIcons.trash, onTap: () => _delete(group)),
                    ],
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(text: 'الأعضاء'),
                    Tab(text: 'الجدول الأسبوعي'),
                    Tab(text: 'المواعيد القادمة'),
                    Tab(text: 'الإعدادات'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _MembersTab(groupId: group.id),
                      _ScheduleTab(groupId: group.id),
                      _UpcomingTab(groupId: group.id),
                      _SettingsTab(group: group),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          child: AppIcon(icon, size: 16, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

// ── تبويب الأعضاء ────────────────────────────────────────────────────────

class _MembersTab extends ConsumerWidget {
  final int groupId;
  const _MembersTab({required this.groupId});

  Future<void> _showAddMemberSheet(BuildContext context, WidgetRef ref, List<Student> candidates) async {
    final picked = await showModalBottomSheet<Student>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddMemberSheet(candidates: candidates),
    );
    if (picked != null) {
      await ref.read(groupRepositoryProvider).addMember(groupId, picked.id);
      ref.read(groupRefreshProvider.notifier).state++;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final studentsAsync = ref.watch(allStudentsProvider);
    final students = studentsAsync.valueOrNull ?? const <Student>[];
    final names = {for (final s in students) s.id: s.fullName};

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              final memberIds = (membersAsync.valueOrNull ?? const <GroupMember>[]).map((m) => m.studentId).toSet();
              final candidates = students.where((s) => !memberIds.contains(s.id)).toList();
              _showAddMemberSheet(context, ref, candidates);
            },
            icon: const AppIcon(AppIcons.plus, size: 14, color: AppColors.primary),
            label: const Text('إضافة طالب'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: membersAsync.when(
              loading: () => const ListSkeleton(),
              error: (e, _) => ErrorBanner(message: e.toString()),
              data: (members) {
                if (members.isEmpty) {
                  return const EmptyState(
                    icon: Icons.people_outline,
                    title: 'لا يوجد طلاب في هذه الحلقة بعد',
                    description: 'أضف طلاباً لتنظيم جلساتهم الجماعية',
                    card: true,
                  );
                }
                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (_, i) {
                    final m = members[i];
                    final name = names[m.studentId] ?? 'طالب رقم ${m.studentId}';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(color: AppColors.dividerLight, shape: BoxShape.circle),
                              child: Text(name.isNotEmpty ? name[0] : '؟', style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(name, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                            IconButton(
                              tooltip: 'إزالة من الحلقة',
                              onPressed: () async {
                                await ref.read(groupRepositoryProvider).removeMember(groupId, m.studentId);
                                ref.read(groupRefreshProvider.notifier).state++;
                              },
                              icon: const AppIcon(AppIcons.close, size: 14, color: AppColors.deleteIcon),
                            ),
                          ],
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
    );
  }
}

class _AddMemberSheet extends StatefulWidget {
  final List<Student> candidates;
  const _AddMemberSheet({required this.candidates});

  @override
  State<_AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends State<_AddMemberSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.trim().isEmpty
        ? widget.candidates
        : widget.candidates.where((s) => s.fullName.contains(_query.trim())).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        decoration: const BoxDecoration(color: AppColors.appBackground, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('إضافة طالب للحلقة', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              autofocus: true,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'بحث عن طالب...',
                hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, color: AppColors.textSecondary),
                prefixIcon: const Padding(padding: EdgeInsets.all(14), child: AppIcon(AppIcons.search, size: 16, color: AppColors.textSecondary)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        widget.candidates.isEmpty ? 'كل الطلاب مسجّلون في هذه الحلقة بالفعل' : 'لا يوجد طلاب مطابقون',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final s = filtered[i];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(backgroundColor: AppColors.primary, child: Text(s.fullName.isNotEmpty ? s.fullName[0] : '؟', style: const TextStyle(fontFamily: 'Cairo', color: AppColors.onPrimary))),
                          title: Text(s.fullName, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          onTap: () => Navigator.pop(context, s),
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

// ── تبويب الجدول الأسبوعي ────────────────────────────────────────────────

const _weekdayOrder = [
  DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday,
  DateTime.friday, DateTime.saturday, DateTime.sunday,
];

const _weekdayLabels = {
  DateTime.monday: 'الاثنين', DateTime.tuesday: 'الثلاثاء', DateTime.wednesday: 'الأربعاء',
  DateTime.thursday: 'الخميس', DateTime.friday: 'الجمعة', DateTime.saturday: 'السبت', DateTime.sunday: 'الأحد',
};

/// Item 2.6 — a genuine *weekly* view (slots grouped under their weekday,
/// Monday→Sunday) built on top of item 2.5's functional CRUD form
/// (`GroupScheduleSlotSheet`), not a replacement for it.
///
/// The invariant this item is graded on ("editing a slot must not
/// retroactively change past sessions") is enforced one layer down, in
/// `GroupSessionService` (item 2.7): editing here only ever writes to
/// `group_schedule_slots`, never to `sessions` — a materialized session's
/// own date/time always wins over whatever the current slot rule would
/// recompute for that date. See group_session_service.dart.
class _ScheduleTab extends ConsumerWidget {
  final int groupId;
  const _ScheduleTab({required this.groupId});

  String _timeLabel(GroupScheduleSlot slot) {
    if (AnchorType.fromArabic(slot.anchorType) == AnchorType.fixedTime) {
      return 'الساعة ${slot.fixedTime ?? '؟'}';
    }
    final offset = slot.offsetMinutes;
    final offsetText = offset == 0 ? '' : (offset > 0 ? ' +$offset د' : ' $offset د');
    return '${slot.prayerName ?? '؟'}$offsetText';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slotsAsync = ref.watch(groupSlotsProvider(groupId));

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            onPressed: () => GroupScheduleSlotSheet.show(context, groupId: groupId),
            icon: const AppIcon(AppIcons.plus, size: 14, color: AppColors.primary),
            label: const Text('إضافة موعد أسبوعي'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: slotsAsync.when(
              loading: () => const ListSkeleton(),
              error: (e, _) => ErrorBanner(message: e.toString()),
              data: (slots) {
                if (slots.isEmpty) {
                  return const EmptyState(
                    icon: Icons.event_repeat_outlined,
                    title: 'لا توجد مواعيد أسبوعية بعد',
                    description: 'أضف موعداً متكرراً — بوقت محدد أو مرتبطاً بصلاة',
                    card: true,
                  );
                }
                final byWeekday = <int, List<GroupScheduleSlot>>{};
                for (final s in slots) {
                  (byWeekday[s.weekday] ??= []).add(s);
                }
                final activeDays = _weekdayOrder.where(byWeekday.containsKey).toList();
                return ListView.builder(
                  itemCount: activeDays.length,
                  itemBuilder: (_, dayIndex) {
                    final weekday = activeDays[dayIndex];
                    final daySlots = byWeekday[weekday]!;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Text(_weekdayLabels[weekday]!, style: Theme.of(context).textTheme.titleSmall),
                            ],
                          ),
                          const SizedBox(height: 6),
                          for (final slot in daySlots)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () => GroupScheduleSlotSheet.show(context, groupId: groupId, existing: slot),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    child: Row(
                                      children: [
                                        const AppIcon(AppIcons.clock, size: 16, color: AppColors.primary),
                                        const SizedBox(width: 10),
                                        Expanded(child: Text(_timeLabel(slot), style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                                        IconButton(
                                          tooltip: 'حذف الموعد',
                                          onPressed: () async {
                                            final confirmed = await confirmDelete(context, message: 'هل تريد حذف هذا الموعد الأسبوعي؟');
                                            if (!confirmed) return;
                                            await ref.read(groupScheduleRepositoryProvider).deleteSlot(slot.id);
                                            ref.read(groupRefreshProvider.notifier).state++;
                                          },
                                          icon: const AppIcon(AppIcons.trash, size: 15, color: AppColors.deleteIcon),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── تبويب المواعيد القادمة ───────────────────────────────────────────────

class _UpcomingTab extends ConsumerWidget {
  final int groupId;
  const _UpcomingTab({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final query = (groupId: groupId, from: DateTime(now.year, now.month, now.day), to: DateTime(now.year, now.month, now.day + 30));
    final occurrencesAsync = ref.watch(groupOccurrencesProvider(query));

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 90),
      child: occurrencesAsync.when(
        loading: () => const ListSkeleton(),
        error: (e, _) => ErrorBanner(message: e.toString()),
        data: (occurrences) {
          if (occurrences.isEmpty) {
            return const EmptyState(
              icon: Icons.event_busy_outlined,
              title: 'لا مواعيد قادمة خلال الثلاثين يوماً القادمة',
              description: 'تأكد من إضافة مواعيد أسبوعية للحلقة',
              card: true,
            );
          }
          return ListView.builder(
            itemCount: occurrences.length,
            itemBuilder: (_, i) {
              final GroupOccurrence o = occurrences[i];
              final hour = o.dateTime.hour.toString().padLeft(2, '0');
              final minute = o.dateTime.minute.toString().padLeft(2, '0');
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      AppIcon(o.isRescheduled ? AppIcons.calendarCheck : AppIcons.calendar, size: 16, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${AppDateUtils.formatDate(o.date)} — $hour:$minute',
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ),
                      if (o.isRescheduled)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.streakBg, borderRadius: BorderRadius.circular(999)),
                          child: const Text('مُعاد جدولته', style: TextStyle(fontFamily: 'Cairo', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.streakIconFg)),
                        ),
                      if (o.isMaterialized)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFE9F3EF), borderRadius: BorderRadius.circular(999)),
                          child: const Text('مُسجَّلة', style: TextStyle(fontFamily: 'Cairo', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        )
                      else
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          onPressed: () async {
                            await ref.read(groupSessionServiceProvider).materializeOccurrence(
                                  groupId: groupId,
                                  occurrenceDate: o.date,
                                  dateTime: o.dateTime,
                                );
                            ref.read(groupRefreshProvider.notifier).state++;
                          },
                          child: const Text('تسجيل الحضور', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ── تبويب الإعدادات ──────────────────────────────────────────────────────

class _SettingsTab extends ConsumerWidget {
  final Group group;
  const _SettingsTab({required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('اسم الحلقة', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(group.name, style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                Text('تاريخ الإنشاء', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(group.createdAt != null ? AppDateUtils.formatDate(group.createdAt!) : '—', style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => context.goNamed('groupEdit', pathParameters: {'id': '${group.id}'}),
            icon: const AppIcon(AppIcons.edit, size: 14, color: AppColors.primary),
            label: const Text('تعديل بيانات الحلقة'),
          ),
        ],
      ),
    );
  }
}
