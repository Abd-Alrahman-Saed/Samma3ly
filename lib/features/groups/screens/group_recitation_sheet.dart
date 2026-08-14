import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/widgets/app_form_field.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

/// Item 3.4 — recording one student's recitation (memorization/revision/
/// scores) for a group session, with autosave: every field persists on
/// its own (debounced for free-typed text, immediate for discrete
/// picks/slider commits) instead of waiting on an explicit Save button, so
/// the app being killed mid-entry (a call, a crash, low battery) loses at
/// most the last few hundred milliseconds of typing — never the whole
/// entry.
class GroupRecitationSheet {
  static Future<void> show(
    BuildContext context, {
    required int sessionId,
    required int studentId,
    required String studentName,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RecitationSheetContent(sessionId: sessionId, studentId: studentId, studentName: studentName),
    );
  }
}

class _RecitationSheetContent extends ConsumerStatefulWidget {
  final int sessionId;
  final int studentId;
  final String studentName;

  const _RecitationSheetContent({required this.sessionId, required this.studentId, required this.studentName});

  @override
  ConsumerState<_RecitationSheetContent> createState() => _RecitationSheetContentState();
}

class _RecitationSheetContentState extends ConsumerState<_RecitationSheetContent> {
  static const _autosaveDelay = Duration(milliseconds: 500);

  int? _memSurahId;
  int? _revSurahId;
  final _memFromController = TextEditingController();
  final _memToController = TextEditingController();
  final _revFromController = TextEditingController();
  final _revToController = TextEditingController();
  final _notesController = TextEditingController();
  double _memorizationScore = 0;
  double _tajweedScore = 0;
  double _fluencyScore = 0;
  double _accuracyScore = 0;

  bool _loading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _load();
    for (final c in [_memFromController, _memToController, _revFromController, _revToController, _notesController]) {
      c.addListener(_scheduleAutosave);
    }
  }

  Future<void> _load() async {
    final dao = ref.read(sessionDaoProvider);
    final existing = await dao.getAttendance(widget.sessionId, widget.studentId);
    if (existing != null) {
      _memSurahId = existing.memorizationSurahId;
      _memFromController.text = existing.memorizationFromAyah?.toString() ?? '';
      _memToController.text = existing.memorizationToAyah?.toString() ?? '';
      _revSurahId = existing.revisionSurahId;
      _revFromController.text = existing.revisionFromAyah?.toString() ?? '';
      _revToController.text = existing.revisionToAyah?.toString() ?? '';
      _memorizationScore = existing.memorizationScore;
      _tajweedScore = existing.tajweedScore;
      _fluencyScore = existing.fluencyScore;
      _accuracyScore = existing.accuracyScore;
      _notesController.text = existing.notes ?? '';
    }
    if (mounted) setState(() => _loading = false);
  }

  void _scheduleAutosave() {
    _debounce?.cancel();
    _debounce = Timer(_autosaveDelay, _save);
  }

  Future<void> _save() async {
    final dao = ref.read(sessionDaoProvider);
    await dao.upsertRecitation(SessionAttendancesCompanion(
      sessionId: Value(widget.sessionId),
      studentId: Value(widget.studentId),
      memorizationSurahId: Value(_memSurahId),
      memorizationFromAyah: Value(int.tryParse(_memFromController.text.trim())),
      memorizationToAyah: Value(int.tryParse(_memToController.text.trim())),
      revisionSurahId: Value(_revSurahId),
      revisionFromAyah: Value(int.tryParse(_revFromController.text.trim())),
      revisionToAyah: Value(int.tryParse(_revToController.text.trim())),
      memorizationScore: Value(_memorizationScore),
      tajweedScore: Value(_tajweedScore),
      fluencyScore: Value(_fluencyScore),
      accuracyScore: Value(_accuracyScore),
      notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
    ));
  }

  /// Discrete picks (surah dropdown, slider release) save right away —
  /// no reason to debounce a single tap. Also flushed on close.
  Future<void> _saveNow() async {
    _debounce?.cancel();
    await _save();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    for (final c in [_memFromController, _memToController, _revFromController, _revToController, _notesController]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Intercepts EVERY way this sheet's route can pop — the close button,
    // the system back gesture, tapping the barrier, and dragging the sheet
    // down to dismiss it — and flushes any pending debounced save before
    // letting the pop actually happen. This is what makes the autosave
    // guarantee ("closing the app suddenly must not lose data", item 3.4)
    // deterministic rather than a best-effort dispose()-time race; same
    // pattern already used for the discard-changes flow in
    // student_create_screen.dart/group_create_screen.dart.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _saveNow();
        if (context.mounted) Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
          decoration: const BoxDecoration(color: AppColors.appBackground, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: _loading
            ? const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()))
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('تسجيل التسميع', style: Theme.of(context).textTheme.titleLarge),
                              Text(widget.studentName, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Material(
                          key: const Key('recitationSheetClose'),
                          color: AppColors.dividerLight,
                          shape: const CircleBorder(),
                          child: InkWell(
                            // PopScope above intercepts this pop and does
                            // the actual flush + Navigator.pop.
                            onTap: () => Navigator.of(context).maybePop(),
                            customBorder: const CircleBorder(),
                            child: const SizedBox(width: 30, height: 30, child: Center(child: AppIcon(AppIcons.close, size: 14, color: AppColors.textPrimary))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text('الحفظ', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    _SurahDropdown(key: const Key('memSurahDropdown'), value: _memSurahId, onChanged: (v) { setState(() => _memSurahId = v); _saveNow(); }),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: AppFormField(key: const Key('memFromAyah'), controller: _memFromController, label: 'من آية', keyboardType: TextInputType.number, onCard: true)),
                        const SizedBox(width: 8),
                        Expanded(child: AppFormField(key: const Key('memToAyah'), controller: _memToController, label: 'إلى آية', keyboardType: TextInputType.number, onCard: true)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('المراجعة', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    _SurahDropdown(value: _revSurahId, onChanged: (v) { setState(() => _revSurahId = v); _saveNow(); }),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: AppFormField(key: const Key('revFromAyah'), controller: _revFromController, label: 'من آية', keyboardType: TextInputType.number, onCard: true)),
                        const SizedBox(width: 8),
                        Expanded(child: AppFormField(key: const Key('revToAyah'), controller: _revToController, label: 'إلى آية', keyboardType: TextInputType.number, onCard: true)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('التقييم (من ١٠)', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    _ScoreSlider(label: 'الحفظ', value: _memorizationScore, onChanged: (v) => setState(() => _memorizationScore = v), onChangeEnd: (_) => _saveNow()),
                    _ScoreSlider(label: 'التجويد', value: _tajweedScore, onChanged: (v) => setState(() => _tajweedScore = v), onChangeEnd: (_) => _saveNow()),
                    _ScoreSlider(label: 'الطلاقة', value: _fluencyScore, onChanged: (v) => setState(() => _fluencyScore = v), onChangeEnd: (_) => _saveNow()),
                    _ScoreSlider(label: 'الدقّة', value: _accuracyScore, onChanged: (v) => setState(() => _accuracyScore = v), onChangeEnd: (_) => _saveNow()),
                    const SizedBox(height: 10),
                    AppFormField(key: const Key('recitationNotes'), controller: _notesController, label: 'ملاحظات', maxLines: 3, onCard: true),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}

class _SurahDropdown extends ConsumerWidget {
  final int? value;
  final ValueChanged<int?> onChanged;

  const _SurahDropdown({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListProvider);
    return surahsAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('تعذر تحميل السور: $e'),
      data: (surahs) {
        final validValue = surahs.any((s) => s.id == value) ? value : null;
        return DropdownButtonFormField<int?>(
          initialValue: validValue,
          isExpanded: true,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'السورة (اختياري)',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          ),
          items: [
            const DropdownMenuItem<int?>(value: null, child: Text('بلا سورة محدَّدة')),
            for (final s in surahs) DropdownMenuItem<int?>(value: s.id, child: Text('${s.number}. ${s.name}')),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}

class _ScoreSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  const _ScoreSlider({required this.label, required this.value, required this.onChanged, required this.onChangeEnd});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 55, child: Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textSecondary))),
        Expanded(
          child: Slider(
            value: value,
            min: 0,
            max: 10,
            divisions: 20,
            label: value.toStringAsFixed(1),
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ),
        SizedBox(width: 28, child: Text(value.toStringAsFixed(1), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
      ],
    );
  }
}
