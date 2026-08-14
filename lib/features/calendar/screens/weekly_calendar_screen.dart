import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/empty_state.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/domain/entities/group.dart';
import 'package:quran_mobile/domain/entities/student.dart';
import 'package:quran_mobile/domain/services/weekly_calendar_service.dart';
import 'package:quran_mobile/features/calendar/providers/calendar_provider.dart';
import 'package:quran_mobile/features/groups/providers/group_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';

/// Item 3.6 — the week's individual sessions and group occurrences at a
/// glance, in one place (previously only visible split across the
/// Dashboard's "recent sessions" and each group's own "Upcoming" tab).
class WeeklyCalendarScreen extends ConsumerStatefulWidget {
  const WeeklyCalendarScreen({super.key});

  @override
  ConsumerState<WeeklyCalendarScreen> createState() => _WeeklyCalendarScreenState();
}

class _WeeklyCalendarScreenState extends ConsumerState<WeeklyCalendarScreen> {
  // Weeks start on Sunday in this app — see AppDateUtils.weekStart.
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    _weekStart = AppDateUtils.weekStart;
  }

  DateTime get _weekEndInclusive => DateTime(_weekStart.year, _weekStart.month, _weekStart.day + 6);

  void _shiftWeek(int days) => setState(() => _weekStart = DateTime(_weekStart.year, _weekStart.month, _weekStart.day + days));

  bool get _isCurrentWeek => _weekStart == AppDateUtils.weekStart;

  @override
  Widget build(BuildContext context) {
    final query = (from: _weekStart, to: _weekEndInclusive);
    final entriesAsync = ref.watch(weekEntriesProvider(query));
    final studentsAsync = ref.watch(allStudentsProvider);
    final groupsAsync = ref.watch(groupListProvider);

    final studentNames = {for (final s in studentsAsync.valueOrNull ?? const <Student>[]) s.id: s.fullName};
    final groupNames = {for (final g in groupsAsync.valueOrNull ?? const <Group>[]) g.id: g.name};

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 6),
              child: Text('التقويم الأسبوعي', style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  _RoundIconButton(key: const Key('previousWeek'), icon: AppIcons.chevronRight, onTap: () => _shiftWeek(-7)),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${AppDateUtils.formatDate(_weekStart)} — ${AppDateUtils.formatDate(_weekEndInclusive)}',
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                        if (!_isCurrentWeek)
                          TextButton(
                            onPressed: () => setState(() => _weekStart = AppDateUtils.weekStart),
                            child: const Text('العودة لهذا الأسبوع', style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5)),
                          ),
                      ],
                    ),
                  ),
                  _RoundIconButton(key: const Key('nextWeek'), icon: AppIcons.chevronLeft, onTap: () => _shiftWeek(7)),
                ],
              ),
            ),
            Expanded(
              child: entriesAsync.when(
                loading: () => const ListSkeleton(),
                error: (e, _) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(weekEntriesProvider(query))),
                data: (entries) {
                  if (entries.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                      child: EmptyState(
                        icon: Icons.event_note_outlined,
                        title: 'لا مواعيد هذا الأسبوع',
                        description: 'الجلسات الفردية ومواعيد الحلقات الجماعية هتظهر هنا',
                      ),
                    );
                  }
                  final byDay = <DateTime, List<CalendarEntry>>{};
                  for (final e in entries) {
                    final day = DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day);
                    (byDay[day] ??= []).add(e);
                  }
                  final days = byDay.keys.toList()..sort();
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: days.length,
                    itemBuilder: (_, i) {
                      final day = days[i];
                      final dayEntries = byDay[day]!;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                                const SizedBox(width: 8),
                                Text('${AppDateUtils.weekDayName(day)} — ${AppDateUtils.formatDate(day)}', style: Theme.of(context).textTheme.titleSmall),
                              ],
                            ),
                            const SizedBox(height: 6),
                            for (final entry in dayEntries)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: _CalendarEntryRow(
                                  entry: entry,
                                  title: entry.isGroup ? (groupNames[entry.groupId] ?? 'حلقة') : (studentNames[entry.studentId] ?? 'طالب'),
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
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _RoundIconButton({super.key, required this.icon, required this.onTap});

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

class _CalendarEntryRow extends StatelessWidget {
  final CalendarEntry entry;
  final String title;

  const _CalendarEntryRow({required this.entry, required this.title});

  @override
  Widget build(BuildContext context) {
    final hour = entry.dateTime.hour.toString().padLeft(2, '0');
    final minute = entry.dateTime.minute.toString().padLeft(2, '0');
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          if (entry.isGroup) {
            if (entry.sessionId != null) {
              context.goNamed('groupLiveSession', pathParameters: {'id': '${entry.groupId}', 'sessionId': '${entry.sessionId}'});
            } else {
              context.goNamed('groupDetails', pathParameters: {'id': '${entry.groupId}'});
            }
          } else if (entry.sessionId != null) {
            context.goNamed('sessionEdit', pathParameters: {'id': '${entry.sessionId}'});
          }
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              AppIcon(entry.isGroup ? AppIcons.peopleTab : AppIcons.person, size: 15, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ),
              if (entry.isGroup && !entry.isMaterialized)
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.dividerLight, borderRadius: BorderRadius.circular(999)),
                  child: const Text('متوقّعة', style: TextStyle(fontFamily: 'Cairo', fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
                ),
              Text('$hour:$minute', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
