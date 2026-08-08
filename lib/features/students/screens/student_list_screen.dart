import 'package:drift/drift.dart' hide Column, Table, Index;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/confirm_delete.dart';
import 'package:quran_mobile/core/widgets/empty_state.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/skeletons.dart';
import 'package:quran_mobile/core/widgets/staggered_list_item.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quran_mobile/data/local/database/app_database.dart' hide Student;
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

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(refreshableStudentListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلاب'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'إضافة طالب',
            onPressed: () => context.goNamed('studentCreate'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'بحث عن طالب...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'مسح البحث',
                        onPressed: () {
                          _searchController.clear();
                          ref.read(studentSearchProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
              onChanged: (v) => ref.read(studentSearchProvider.notifier).state = v,
            ),
          ),
          Expanded(
            child: studentsAsync.when(
              loading: () => const ListSkeleton(),
              error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(refreshableStudentListProvider)),
              data: (students) {
                if (students.isEmpty) {
                  return EmptyState(
                    icon: Icons.people_outline,
                    title: 'لا يوجد طلاب',
                    ctaLabel: 'إضافة طالب',
                    onCta: () => context.goNamed('studentCreate'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(refreshableStudentListProvider.future),
                  child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (_, i) {
                      final student = students[i];
                      return StaggeredListItem(index: i, child: Dismissible(
                        key: ValueKey('student-${student.id}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) => confirmDelete(context, message: 'هل أنت متأكد من حذف الطالب "${student.fullName}"؟'),
                        onDismissed: (_) async {
                          final dao = ref.read(studentDaoProvider);
                          await dao.deleteById(student.id);
                          ref.invalidate(studentListProvider);
                          ref.invalidate(refreshableStudentListProvider);
                          if (!context.mounted) return;
                          showUndoSnackbar(context, 'تم حذف الطالب "${student.fullName}"', () async {
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
                          });
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            leading: ExcludeSemantics(child: CircleAvatar(child: Text('${student.fullName[0]}'))),
                            title: Text(student.fullName, style: AppTextStyles.body),
                            subtitle: Text('المستوى: ${student.level}', style: AppTextStyles.muted),
                            trailing: const Icon(Icons.chevron_left),
                            onTap: () => context.goNamed('studentDetails', pathParameters: {'id': '${student.id}'}),
                          ),
                        ),
                      ));
                    },
                  ),
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
