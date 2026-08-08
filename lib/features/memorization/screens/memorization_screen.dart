import 'package:collection/collection.dart';
import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/core/enums/memorized_status.dart';
import 'package:quran_mobile/core/services/notification_service.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/utils/quran_utils.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/core/widgets/discard_changes_dialog.dart';
import 'package:quran_mobile/core/widgets/empty_state.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/core/widgets/surah_dropdown.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide MemorizedRange;
import 'package:quran_mobile/domain/entities/memorized_range.dart';
import 'package:quran_mobile/features/memorization/providers/memorization_provider.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

class MemorizationScreen extends ConsumerStatefulWidget {
  final int studentId;

  const MemorizationScreen({super.key, required this.studentId});

  @override
  ConsumerState<MemorizationScreen> createState() => _MemorizationScreenState();
}

class _MemorizationScreenState extends ConsumerState<MemorizationScreen> {
  int? _surahId;
  final _fromAyahController = TextEditingController();
  final _toAyahController = TextEditingController();
  String _status = 'محفوظ';
  int? _editId;
  bool _isDirty = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_fromAyahController, _toAyahController]) {
      c.addListener(() => _isDirty = true);
    }
    NotificationService.instance.requestPermissions();
  }

  @override
  void dispose() {
    _fromAyahController.dispose();
    _toAyahController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final surahId = _surahId;
    if (surahId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار السورة')));
      return;
    }
    final fromAyah = int.parse(_fromAyahController.text.trim().isEmpty ? '1' : _fromAyahController.text.trim());
    final toAyah = int.parse(_toAyahController.text.trim().isEmpty ? '1' : _toAyahController.text.trim());
    final ayahCount = QuranUtils.getAyahCount(surahId);
    if (fromAyah < 1 || fromAyah > toAyah) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يجب أن تكون "من آية" أصغر من أو تساوي "إلى آية"')));
      return;
    }
    if (toAyah > ayahCount) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('هذه السورة تحتوي على $ayahCount آية فقط')));
      return;
    }
    setState(() => _isSaving = true);
    try {
      final dao = ref.read(memorizedRangeDaoProvider);
      final now = DateTime.now();
      final revisionDays = 7;
      final nextReview = now.add(Duration(days: revisionDays));
      int rangeId;

      if (_editId != null) {
        rangeId = _editId!;
        await dao.updateEntry(MemorizedRangesCompanion(
          id: Value(rangeId),
          surahId: Value(surahId),
          fromAyah: Value(fromAyah),
          toAyah: Value(toAyah),
          status: Value(_status),
          nextReviewDate: Value(nextReview),
          updatedAt: Value(now),
        ));
      } else {
        rangeId = await dao.insert(MemorizedRangesCompanion(
          studentId: Value(widget.studentId),
          surahId: Value(surahId),
          fromAyah: Value(fromAyah),
          toAyah: Value(toAyah),
          status: Value(_status),
          revisionCycleDays: Value(revisionDays),
          nextReviewDate: Value(nextReview),
        ));
      }

      final student = await ref.read(studentByIdProvider(widget.studentId).future);
      final surahs = await ref.read(surahListProvider.future);
      final surahName = surahs.firstWhereOrNull((s) => s.id == surahId)?.name ?? 'السورة';
      await NotificationService.instance.scheduleReviewReminder(
        rangeId: rangeId,
        reviewDate: nextReview,
        studentName: student?.fullName ?? 'الطالب',
        surahName: surahName,
      );

      final wasEdit = _editId != null;
      _surahId = null;
      _fromAyahController.clear();
      _toAyahController.clear();
      _status = 'محفوظ';
      _editId = null;
      ref.invalidate(memorizedRangeByStudentProvider(widget.studentId));
      setState(() {});
      _isDirty = false;
      if (mounted) {
        AppSnackbar.success(context, wasEdit ? 'تم تحديث نطاق الحفظ' : 'تم إضافة نطاق الحفظ');
      }
    } catch (e) {
      if (mounted) AppSnackbar.error(context, e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _edit(MemorizedRange range) {
    _surahId = range.surahId;
    _fromAyahController.text = '${range.fromAyah}';
    _toAyahController.text = '${range.toAyah}';
    _status = range.status;
    _editId = range.id;
    setState(() {});
    _isDirty = false;
  }

  Future<void> _delete(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا النطاق؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حذف')),
        ],
      ),
    );
    if (confirmed == true) {
      final dao = ref.read(memorizedRangeDaoProvider);
      await dao.deleteById(id);
      await NotificationService.instance.cancelReviewReminder(id);
      ref.invalidate(memorizedRangeByStudentProvider(widget.studentId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final rangesAsync = ref.watch(memorizedRangeByStudentProvider(widget.studentId));
    final surahsAsync = ref.watch(surahListProvider);
    final surahNames = <int, String>{
      for (final s in surahsAsync.valueOrNull ?? const []) s.id: s.name,
    };
    String surahLabel(int surahId) => surahNames[surahId] ?? 'سورة $surahId';

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final discard = await confirmDiscardChanges(context);
        if (discard && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
      appBar: AppBar(title: const Text('إدارة الحفظ')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_editId != null ? 'تعديل نطاق الحفظ' : 'إضافة نطاق حفظ جديد', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 2),
                  Text('يتم تحديد موعد المراجعة تلقائياً بعد 7 أيام من الحفظ', style: AppTextStyles.muted),
                  const SizedBox(height: 16),
                  SurahDropdown(
                    value: _surahId,
                    noneLabel: 'اختر السورة',
                    onChanged: (v) => setState(() {
                      _surahId = v;
                      _isDirty = true;
                    }),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextFormField(
                        controller: _fromAyahController,
                        decoration: const InputDecoration(labelText: 'من آية'),
                        keyboardType: TextInputType.number,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: TextFormField(
                        controller: _toAyahController,
                        decoration: const InputDecoration(labelText: 'إلى آية'),
                        keyboardType: TextInputType.number,
                      )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(labelText: 'الحالة'),
                    items: MemorizedStatus.values.map((s) => DropdownMenuItem(value: s.arabic, child: Text(s.arabic))).toList(),
                    onChanged: (v) => setState(() {
                      _status = v!;
                      _isDirty = true;
                    }),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          child: _isSaving
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : Text(_editId != null ? 'تحديث' : 'إضافة'),
                        ),
                      ),
                      if (_editId != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              _surahId = null;
                              _fromAyahController.clear();
                              _toAyahController.clear();
                              _status = 'محفوظ';
                              _editId = null;
                              setState(() {});
                              _isDirty = false;
                            },
                            child: const Text('إلغاء'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: rangesAsync.when(
              loading: () => const ListSkeleton(),
              error: (e, _) => ErrorBanner(message: e.toString()),
              data: (ranges) {
                if (ranges.isEmpty) {
                  return const EmptyState(
                    icon: Icons.auto_stories,
                    title: 'لا توجد نطاقات حفظ',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(memorizedRangeByStudentProvider(widget.studentId).future),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: ranges.length,
                    itemBuilder: (_, i) {
                      final r = ranges[i];
                      final statusColorHex = MemorizedStatus.color(r.status);
                      final statusColor = Color(int.parse(statusColorHex.replaceFirst('#', '0xFF')));
                      final isOverdue = r.nextReviewDate != null && r.nextReviewDate!.isBefore(DateTime.now());
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: ExcludeSemantics(
                            child: CircleAvatar(
                              backgroundColor: statusColor.withAlpha(51),
                              child: Text('${r.surahId}', style: TextStyle(color: statusColor)),
                            ),
                          ),
                          title: Text('${surahLabel(r.surahId)} (${r.fromAyah}-${r.toAyah})', style: AppTextStyles.body),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('الحالة: ${r.status}', style: AppTextStyles.muted),
                              if (r.nextReviewDate != null)
                                Text('المراجعة القادمة: ${AppDateUtils.formatDate(r.nextReviewDate!)}${isOverdue ? ' (متأخرة)' : ''}', style: TextStyle(fontSize: 12, color: isOverdue ? AppColors.error : AppColors.textMuted)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.edit, size: 20), tooltip: 'تعديل', onPressed: () => _edit(r)),
                              IconButton(icon: const Icon(Icons.delete, size: 20, color: AppColors.error), tooltip: 'حذف', onPressed: () => _delete(r.id!)),
                            ],
                          ),
                        ),
                      );
                    },
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
