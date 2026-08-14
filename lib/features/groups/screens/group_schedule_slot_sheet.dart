import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/core/enums/anchor_type.dart';
import 'package:quran_mobile/core/enums/prayer_name.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/app_form_field.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/domain/entities/group_schedule_slot.dart';
import 'package:quran_mobile/features/groups/notifications/group_notification_scheduler.dart';
import 'package:quran_mobile/features/groups/providers/group_provider.dart';
import 'package:quran_mobile/providers.dart';

/// Bottom-sheet form to add/edit one `GroupScheduleSlot` — weekday +
/// anchor (fixed clock time, or a prayer name + offset). See item 2.1 for
/// the schema and item 2.2/2.3 for how this rule gets expanded into actual
/// dated occurrences. The dedicated drag-and-drop weekly editor UI is item
/// 2.6 — this is the functional (non-visual-editor) CRUD form it will sit
/// on top of.
class GroupScheduleSlotSheet {
  static Future<void> show(BuildContext context, {required int groupId, GroupScheduleSlot? existing}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SlotSheetContent(groupId: groupId, existing: existing),
    );
  }
}

const _weekdayLabels = {
  DateTime.monday: 'الاثنين',
  DateTime.tuesday: 'الثلاثاء',
  DateTime.wednesday: 'الأربعاء',
  DateTime.thursday: 'الخميس',
  DateTime.friday: 'الجمعة',
  DateTime.saturday: 'السبت',
  DateTime.sunday: 'الأحد',
};

class _SlotSheetContent extends ConsumerStatefulWidget {
  final int groupId;
  final GroupScheduleSlot? existing;

  const _SlotSheetContent({required this.groupId, this.existing});

  @override
  ConsumerState<_SlotSheetContent> createState() => _SlotSheetContentState();
}

class _SlotSheetContentState extends ConsumerState<_SlotSheetContent> {
  late int _weekday;
  late AnchorType _anchorType;
  TimeOfDay? _fixedTime;
  PrayerName _prayerName = PrayerName.maghrib;
  int _offsetMinutes = 0;
  late final TextEditingController _offsetController;
  late DateTime _effectiveFrom;
  DateTime? _effectiveTo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _weekday = e?.weekday ?? DateTime.monday;
    _anchorType = e != null ? AnchorType.fromArabic(e.anchorType) : AnchorType.fixedTime;
    _fixedTime = e?.fixedTime != null ? _parseTime(e!.fixedTime!) : null;
    _prayerName = e?.prayerName != null ? PrayerName.fromArabic(e!.prayerName!) : PrayerName.maghrib;
    _offsetMinutes = e?.offsetMinutes ?? 0;
    _offsetController = TextEditingController(text: _offsetMinutes == 0 ? '' : '$_offsetMinutes');
    _effectiveFrom = e?.effectiveFrom ?? DateTime.now();
    _effectiveTo = e?.effectiveTo;
  }

  @override
  void dispose() {
    _offsetController.dispose();
    super.dispose();
  }

  TimeOfDay _parseTime(String hhmm) {
    final parts = hhmm.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts.length > 1 ? parts[1] : '0'));
  }

  Future<void> _save() async {
    if (_anchorType == AnchorType.fixedTime && _fixedTime == null) {
      AppSnackbar.info(context, 'الرجاء اختيار الوقت');
      return;
    }
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(groupScheduleRepositoryProvider);
      final slot = GroupScheduleSlot(
        id: widget.existing?.id ?? 0,
        groupId: widget.groupId,
        weekday: _weekday,
        anchorType: _anchorType.arabic,
        fixedTime: _anchorType == AnchorType.fixedTime ? AppDateUtils.formatTime(_fixedTime!) : null,
        prayerName: _anchorType == AnchorType.prayer ? _prayerName.arabic : null,
        offsetMinutes: _anchorType == AnchorType.prayer ? _offsetMinutes : 0,
        effectiveFrom: _effectiveFrom,
        effectiveTo: _effectiveTo,
        createdAt: widget.existing?.createdAt,
      );
      if (widget.existing != null) {
        await repo.updateSlot(slot);
      } else {
        await repo.createSlot(slot);
      }
      ref.read(groupRefreshProvider.notifier).state++;
      await rescheduleGroupNotifications(ref, widget.groupId);
      if (mounted) {
        AppSnackbar.success(context, widget.existing != null ? 'تم تحديث الموعد' : 'تم إضافة الموعد');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) AppSnackbar.error(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        decoration: const BoxDecoration(color: AppColors.appBackground, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.existing != null ? 'تعديل موعد' : 'موعد أسبوعي جديد', style: Theme.of(context).textTheme.titleLarge),
                  Material(
                    color: AppColors.dividerLight,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      customBorder: const CircleBorder(),
                      child: const SizedBox(width: 30, height: 30, child: Center(child: AppIcon(AppIcons.close, size: 14, color: AppColors.textPrimary))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text('يوم الأسبوع', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final entry in _weekdayLabels.entries)
                    _Chip(label: entry.value, selected: _weekday == entry.key, onTap: () => setState(() => _weekday = entry.key)),
                ],
              ),
              const SizedBox(height: 16),
              Text('التوقيت', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _Chip(label: 'وقت محدد', selected: _anchorType == AnchorType.fixedTime, onTap: () => setState(() => _anchorType = AnchorType.fixedTime), fullWidth: true)),
                  const SizedBox(width: 6),
                  Expanded(child: _Chip(label: 'مرتبط بصلاة', selected: _anchorType == AnchorType.prayer, onTap: () => setState(() => _anchorType = AnchorType.prayer), fullWidth: true)),
                ],
              ),
              const SizedBox(height: 12),
              if (_anchorType == AnchorType.fixedTime)
                InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(context: context, initialTime: _fixedTime ?? TimeOfDay.now());
                    if (picked != null) setState(() => _fixedTime = picked);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
                    child: Text(
                      _fixedTime != null ? AppDateUtils.formatTime(_fixedTime!) : 'اختر الوقت',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: _fixedTime != null ? AppColors.textPrimary : AppColors.textMuted),
                    ),
                  ),
                )
              else ...[
                DropdownButtonFormField<PrayerName>(
                  initialValue: _prayerName,
                  isExpanded: true,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                  ),
                  items: [for (final p in PrayerName.values) DropdownMenuItem(value: p, child: Text(p.arabic))],
                  onChanged: (v) => setState(() => _prayerName = v ?? _prayerName),
                ),
                const SizedBox(height: 10),
                AppFormField(
                  controller: _offsetController,
                  label: 'الإزاحة بالدقائق',
                  hintText: 'مثال: 15 (بعد الصلاة) أو -10 (قبلها)',
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  onCard: true,
                  onChanged: (v) => _offsetMinutes = int.tryParse(v.trim()) ?? 0,
                ),
              ],
              const SizedBox(height: 16),
              Text('نطاق السريان', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      label: 'من تاريخ',
                      value: _effectiveFrom,
                      onTap: () async {
                        final picked = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2035), initialDate: _effectiveFrom);
                        if (picked != null) setState(() => _effectiveFrom = picked);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DateField(
                      label: 'حتى تاريخ (اختياري)',
                      value: _effectiveTo,
                      onTap: () async {
                        final picked = await showDatePicker(context: context, firstDate: _effectiveFrom, lastDate: DateTime(2035), initialDate: _effectiveTo ?? _effectiveFrom);
                        if (picked != null) setState(() => _effectiveTo = picked);
                      },
                      onClear: _effectiveTo != null ? () => setState(() => _effectiveTo = null) : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                      : const Text('حفظ الموعد'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool fullWidth;

  const _Chip({required this.label, required this.selected, required this.onTap, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: selected ? AppColors.primary : AppColors.inputBorder)),
          child: Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: selected ? AppColors.onPrimary : AppColors.textSecondary)),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DateField({required this.label, required this.value, required this.onTap, this.onClear});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.inputBorder)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value != null ? AppDateUtils.formatDate(value!) : label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: value != null ? AppColors.textPrimary : AppColors.textMuted),
              ),
            ),
            if (onClear != null)
              InkWell(onTap: onClear, child: const AppIcon(AppIcons.close, size: 12, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
