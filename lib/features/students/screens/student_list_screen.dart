import 'package:drift/drift.dart' hide Column, Table, Index;
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
import 'package:quran_mobile/data/local/database/app_database.dart' hide Student;
import 'package:quran_mobile/domain/entities/student.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';
import 'package:quran_mobile/providers.dart';

class StudentListScreen extends ConsumerStatefulWidget {
  const StudentListScreen({super.key});

  @override
  ConsumerState<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends ConsumerState<StudentListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _delete(Student student) async {
    final confirmed = await confirmDelete(context, message: 'هل أنت متأكد من حذف الطالب "${student.fullName}"؟');
    if (!confirmed) return;
    final dao = ref.read(studentDaoProvider);
    await dao.deleteById(student.id);
    ref.invalidate(studentListProvider);
    ref.invalidate(refreshableStudentListProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('تم حذف الطالب "${student.fullName}"'),
      action: SnackBarAction(
        label: 'تراجع',
        onPressed: () async {
          await dao.insert(StudentsCompanion(
            id: Value(student.id),
            fullName: Value(student.fullName),
            age: Value(student.age),
            phone: Value(student.phone),
            address: Value(student.address),
            parentName: Value(student.parentName),
            parentPhone: Value(student.parentPhone),
            currentSurahId: Value(student.currentSurahId),
            lastCompletedSurahId: Value(student.lastCompletedSurahId),
            totalCompletedJuz: Value(student.totalCompletedJuz),
            level: Value(student.level),
            createdAt: Value(student.createdAt ?? DateTime.now()),
          ));
          ref.invalidate(studentListProvider);
          ref.invalidate(refreshableStudentListProvider);
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(refreshableStudentListProvider);
    final surahsAsync = ref.watch(surahListProvider);
    final surahNames = <int, String>{for (final s in surahsAsync.valueOrNull ?? const []) s.id: s.name};

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الطلاب', style: Theme.of(context).textTheme.headlineSmall),
                  InkWell(
                    onTap: () => context.goNamed('studentCreate'),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'بحث عن طالب...',
                  hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, color: AppColors.textSecondary),
                  prefixIcon: const Padding(padding: EdgeInsets.all(14), child: AppIcon(AppIcons.search, size: 16, color: AppColors.textSecondary)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const AppIcon(AppIcons.close, size: 14, color: AppColors.textSecondary),
                          tooltip: 'مسح البحث',
                          onPressed: () {
                            _searchController.clear();
                            ref.read(studentSearchProvider.notifier).state = '';
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 11),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inputBorder)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                ),
                onChanged: (v) {
                  ref.read(studentSearchProvider.notifier).state = v;
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: studentsAsync.when(
                loading: () => const ListSkeleton(),
                error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(refreshableStudentListProvider)),
                data: (students) {
                  if (students.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(color: Color(0xFFE9F3EF), shape: BoxShape.circle),
                            child: const AppIcon(AppIcons.people, size: 26, color: AppColors.primary),
                          ),
                          const SizedBox(height: 14),
                          Text('لا يوجد طلاب', style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 4),
                          Text('أضف أول طالب لبدء تتبع تقدمه في الحفظ', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref.refresh(refreshableStudentListProvider.future),
                    child: AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 6, 20, 90),
                        itemCount: students.length,
                        itemBuilder: (_, i) {
                          final student = students[i];
                          final currentSurah = student.currentSurahId != null ? surahNames[student.currentSurahId] : null;
                          return StaggeredListItem(
                            index: i,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _StudentRow(
                                student: student,
                                currentSurah: currentSurah,
                                onTap: () => context.goNamed('studentDetails', pathParameters: {'id': '${student.id}'}),
                                onDelete: () => _delete(student),
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

class _StudentRow extends StatelessWidget {
  final Student student;
  final String? currentSurah;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _StudentRow({required this.student, required this.currentSurah, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final levelColors = StatusColors.forLevel(student.level);
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
                child: Text(
                  student.fullName.isNotEmpty ? student.fullName[0] : '؟',
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onPrimary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.fullName, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(color: levelColors.bg, borderRadius: BorderRadius.circular(999)),
                          child: Text(student.level, style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, fontWeight: FontWeight.w700, color: levelColors.fg)),
                        ),
                        if (currentSurah != null) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(currentSurah!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textSecondary)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: 'حذف الطالب',
                icon: const AppIcon(AppIcons.trash, size: 16, color: AppColors.deleteIcon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
