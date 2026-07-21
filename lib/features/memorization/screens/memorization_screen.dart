import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/core/enums/memorized_status.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/utils/date_utils.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide MemorizedRange;
import 'package:quran_mobile/domain/entities/memorized_range.dart';
import 'package:quran_mobile/features/memorization/providers/memorization_provider.dart';
import 'package:quran_mobile/providers.dart';

class MemorizationScreen extends ConsumerStatefulWidget {
  final int studentId;

  const MemorizationScreen({super.key, required this.studentId});

  @override
  ConsumerState<MemorizationScreen> createState() => _MemorizationScreenState();
}

class _MemorizationScreenState extends ConsumerState<MemorizationScreen> {
  final _surahController = TextEditingController();
  final _fromAyahController = TextEditingController();
  final _toAyahController = TextEditingController();
  String _status = 'محفوظ';
  int? _editId;

  @override
  void dispose() {
    _surahController.dispose();
    _fromAyahController.dispose();
    _toAyahController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_surahController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إدخال رقم السورة')));
      return;
    }
    try {
      final dao = ref.read(memorizedRangeDaoProvider);
      final now = DateTime.now();
      final revisionDays = 7;
      final nextReview = now.add(Duration(days: revisionDays));

      if (_editId != null) {
        await dao.updateEntry(MemorizedRangesCompanion(
          id: Value(_editId!),
          surahId: Value(int.parse(_surahController.text.trim())),
          fromAyah: Value(int.parse(_fromAyahController.text.trim().isEmpty ? '1' : _fromAyahController.text.trim())),
          toAyah: Value(int.parse(_toAyahController.text.trim().isEmpty ? '1' : _toAyahController.text.trim())),
          status: Value(_status),
          nextReviewDate: Value(nextReview),
          updatedAt: Value(now),
        ));
      } else {
        await dao.insert(MemorizedRangesCompanion(
          studentId: Value(widget.studentId),
          surahId: Value(int.parse(_surahController.text.trim())),
          fromAyah: Value(int.parse(_fromAyahController.text.trim().isEmpty ? '1' : _fromAyahController.text.trim())),
          toAyah: Value(int.parse(_toAyahController.text.trim().isEmpty ? '1' : _toAyahController.text.trim())),
          status: Value(_status),
          revisionCycleDays: Value(revisionDays),
          nextReviewDate: Value(nextReview),
        ));
      }

      _surahController.clear();
      _fromAyahController.clear();
      _toAyahController.clear();
      _status = 'محفوظ';
      _editId = null;
      ref.invalidate(memorizedRangeByStudentProvider(widget.studentId));
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  void _edit(MemorizedRange range) {
    _surahController.text = '${range.surahId}';
    _fromAyahController.text = '${range.fromAyah}';
    _toAyahController.text = '${range.toAyah}';
    _status = range.status;
    _editId = range.id;
    setState(() {});
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
      ref.invalidate(memorizedRangeByStudentProvider(widget.studentId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final rangesAsync = ref.watch(memorizedRangeByStudentProvider(widget.studentId));

    return Scaffold(
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _surahController,
                    decoration: const InputDecoration(labelText: 'رقم السورة', prefixIcon: Icon(Icons.auto_stories)),
                    keyboardType: TextInputType.number,
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
                    onChanged: (v) => setState(() => _status = v!),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _save,
                          child: Text(_editId != null ? 'تحديث' : 'إضافة'),
                        ),
                      ),
                      if (_editId != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              _surahController.clear();
                              _fromAyahController.clear();
                              _toAyahController.clear();
                              _status = 'محفوظ';
                              _editId = null;
                              setState(() {});
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
              loading: () => const LoadingOverlay(),
              error: (e, _) => ErrorBanner(message: e.toString()),
              data: (ranges) {
                if (ranges.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_stories, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('لا توجد نطاقات حفظ', style: AppTextStyles.muted),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.refresh(memorizedRangeByStudentProvider(widget.studentId)),
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
                          leading: CircleAvatar(
                            backgroundColor: statusColor.withAlpha(51),
                            child: Text('${r.surahId}', style: TextStyle(color: statusColor)),
                          ),
                          title: Text('سورة ${r.surahId} (${r.fromAyah}-${r.toAyah})', style: AppTextStyles.body),
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
                              IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _edit(r)),
                              IconButton(icon: const Icon(Icons.delete, size: 20, color: AppColors.error), onPressed: () => _delete(r.id!)),
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
    );
  }
}
