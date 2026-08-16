import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/enums/attendance_status.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/core/widgets/status_badge.dart';
import 'package:quran_mobile/domain/entities/group_member.dart';
import 'package:quran_mobile/domain/entities/student.dart';
import 'package:quran_mobile/features/groups/providers/group_provider.dart';
import 'package:quran_mobile/features/groups/screens/group_recitation_sheet.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

/// Sprint 3, items 3.1–3.3 — the "أهم شاشة في التطبيق" (most important
/// screen): recording attendance for one materialized group session.
///
/// C3's resolution (docs/IMPLEMENTATION_PLAN.md): swipe (not a segmented
/// button — 55px < the 44px minimum touch target) with `Dismissible`
/// written in LOGICAL directions (`startToEnd`/`endToStart`, never
/// `left`/`right`, since `startToEnd` is a *leftward* drag in this RTL
/// app) and `confirmDismiss` always returning `false` — a swipe changes a
/// status, it never removes the row. Rare statuses (متأخر/مستأذن) and a
/// general accessible alternative to swiping are both a tap on the status
/// chip, opening `_StatusPickerSheet`. Tapping the row itself (its main,
/// largest touch target) opens the full recitation sheet — that's the
/// actual point of a session: recording what was recited and rating it,
/// not just presence. Attendance stays fast (swipe / status chip);
/// recitation is what tapping a student is *for*.
class GroupLiveSessionScreen extends ConsumerWidget {
  final int groupId;
  final int sessionId;

  const GroupLiveSessionScreen({super.key, required this.groupId, required this.sessionId});

  Future<void> _setStatus(WidgetRef ref, int studentId, AttendanceStatus status) async {
    await ref.read(sessionDaoProvider).upsertAttendance(sessionId, studentId, status.arabic);
    ref.read(sessionAttendanceRefreshProvider(sessionId).notifier).state++;
  }

  Future<void> _markAllPresent(WidgetRef ref, List<GroupMember> members) async {
    if (members.isEmpty) return;
    await ref.read(sessionDaoProvider).markAllAttendance(
          sessionId,
          members.map((m) => m.studentId).toList(),
          AttendanceStatus.present.arabic,
        );
    ref.read(sessionAttendanceRefreshProvider(sessionId).notifier).state++;
  }

  Future<void> _showStatusPicker(BuildContext context, WidgetRef ref, int studentId, String? current) async {
    final picked = await showModalBottomSheet<AttendanceStatus>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _StatusPickerSheet(current: current),
    );
    if (picked != null) await _setStatus(ref, studentId, picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsync = ref.watch(groupByIdProvider(groupId));
    final sessionAsync = ref.watch(groupLiveSessionProvider(sessionId));
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final studentsAsync = ref.watch(allStudentsProvider);
    final attendanceAsync = ref.watch(sessionAttendanceMapProvider(sessionId));

    if (groupAsync.isLoading || membersAsync.isLoading || studentsAsync.isLoading || attendanceAsync.isLoading) {
      return const Scaffold(body: LoadingOverlay());
    }
    final error = groupAsync.error ?? membersAsync.error ?? studentsAsync.error ?? attendanceAsync.error;
    if (error != null) return Scaffold(body: ErrorBanner(message: error.toString()));

    final group = groupAsync.value;
    if (group == null) return const Scaffold(body: Center(child: Text('الحلقة غير موجودة')));

    final members = membersAsync.value ?? const <GroupMember>[];
    final studentsById = {for (final s in studentsAsync.value ?? const <Student>[]) s.id: s};
    final attendance = attendanceAsync.value ?? const <int, String>{};
    final session = sessionAsync.valueOrNull;

    final presentCount = attendance.values.where((s) => s == AttendanceStatus.present.arabic).length;

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(group.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge),
                        if (session != null)
                          Text(
                            '${AppDateUtils.formatDate(session.date)} — ${session.time}',
                            style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textSecondary),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
                      child: Row(
                        children: [
                          const AppIcon(AppIcons.checkCircle, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            '$presentCount/${members.length} حاضر',
                            style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: members.isEmpty ? null : () => _markAllPresent(ref, members),
                    child: const Text('تحضير الكل'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: members.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                      child: Column(
                        children: [
                          Text('لا يوجد طلاب في هذه الحلقة', style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 4),
                          Text('أضف طلاباً من تبويب الأعضاء أولاً', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: members.length,
                      itemBuilder: (_, i) {
                        final member = members[i];
                        final student = studentsById[member.studentId];
                        final name = student?.fullName ?? 'طالب رقم ${member.studentId}';
                        final status = attendance[member.studentId];
                        return _AttendanceRow(
                          key: ValueKey('attendanceRow-${member.studentId}'),
                          studentId: member.studentId,
                          name: name,
                          status: status,
                          onSetStatus: (s) => _setStatus(ref, member.studentId, s),
                          onTap: () => _showStatusPicker(context, ref, member.studentId, status),
                          onOpenRecitation: () => GroupRecitationSheet.show(
                            context,
                            sessionId: sessionId,
                            studentId: member.studentId,
                            studentName: name,
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

String _iconForStatus(String status) => switch (AttendanceStatus.fromArabic(status)) {
      AttendanceStatus.present => AppIcons.checkCircle,
      AttendanceStatus.absent => AppIcons.circleX,
      AttendanceStatus.late => AppIcons.clock,
      AttendanceStatus.excused => AppIcons.circleDash,
    };

class _AttendanceRow extends StatelessWidget {
  final int studentId;
  final String name;
  final String? status;
  final ValueChanged<AttendanceStatus> onSetStatus;
  final VoidCallback onTap;
  final VoidCallback onOpenRecitation;

  const _AttendanceRow({
    super.key,
    required this.studentId,
    required this.name,
    required this.status,
    required this.onSetStatus,
    required this.onTap,
    required this.onOpenRecitation,
  });

  @override
  Widget build(BuildContext context) {
    // Keyed on studentId (stable identity), never on `status` — a
    // status-derived key would make Dismissible see a "new" widget on
    // every swipe and break its own gesture/animation mid-interaction.
    return Dismissible(
      key: ValueKey(studentId),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        final newStatus = direction == DismissDirection.startToEnd ? AttendanceStatus.present : AttendanceStatus.absent;
        onSetStatus(newStatus);
        HapticFeedback.selectionClick();
        return false; // never actually remove the row — only change its status.
      },
      background: _SwipeBackground(
        color: StatusColors.present.fg,
        icon: AppIcons.checkCircle,
        label: 'حاضر',
        alignment: AlignmentDirectional.centerStart,
      ),
      secondaryBackground: _SwipeBackground(
        color: StatusColors.absent.fg,
        icon: AppIcons.circleX,
        label: 'غائب',
        alignment: AlignmentDirectional.centerEnd,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onOpenRecitation,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              constraints: const BoxConstraints(minHeight: 56), // >= 44px touch-target rule
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.dividerLight, shape: BoxShape.circle),
                    child: Text(name.isNotEmpty ? name[0] : '؟', style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                  GestureDetector(
                    key: ValueKey('statusChip-$studentId'),
                    behavior: HitTestBehavior.opaque,
                    onTap: onTap,
                    child: _StatusChip(status: status),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Never color alone (item 3.3): an icon (shape — distinguishable in a
/// colorblind simulator) is always paired with the Arabic status word.
class _StatusChip extends StatelessWidget {
  final String? status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null) {
      return Container(
        height: 22,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(color: AppColors.dividerLight, borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIcon(AppIcons.circleDash, size: 11, color: AppColors.textMuted),
            const SizedBox(width: 4),
            const Text('لم يُسجَّل', style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
          ],
        ),
      );
    }
    final c = StatusColors.forAttendance(status!);
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(color: c.bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(_iconForStatus(status!), size: 11, color: c.fg),
          const SizedBox(width: 4),
          StatusBadge.attendance(status!),
        ],
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  final Color color;
  final String icon;
  final String label;
  final AlignmentDirectional alignment;

  const _SwipeBackground({required this.color, required this.icon, required this.label, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      alignment: alignment,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 22),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
        ],
      ),
    );
  }
}

class _StatusPickerSheet extends StatelessWidget {
  final String? current;
  const _StatusPickerSheet({required this.current});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 18, 20, 20 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(color: AppColors.appBackground, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('حالة الحضور', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final status in AttendanceStatus.values)
            _StatusOption(
              status: status,
              selected: current == status.arabic,
              onTap: () => Navigator.of(context).pop(status),
            ),
        ],
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  final AttendanceStatus status;
  final bool selected;
  final VoidCallback onTap;

  const _StatusOption({required this.status, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = StatusColors.forAttendance(status.arabic);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? c.bg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: selected ? c.fg : AppColors.cardBorder)),
            child: Row(
              children: [
                AppIcon(_iconForStatus(status.arabic), size: 18, color: c.fg),
                const SizedBox(width: 12),
                Text(status.arabic, style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w700, color: selected ? c.fg : AppColors.textPrimary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
