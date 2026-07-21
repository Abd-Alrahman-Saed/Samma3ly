import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/features/students/providers/student_provider.dart';

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
              loading: () => const LoadingOverlay(),
              error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(refreshableStudentListProvider)),
              data: (students) {
                if (students.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('لا يوجد طلاب', style: AppTextStyles.muted),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('إضافة طالب'),
                          onPressed: () => context.goNamed('studentCreate'),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.refresh(refreshableStudentListProvider),
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (_, i) {
                      final student = students[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${student.fullName[0]}')),
                          title: Text(student.fullName, style: AppTextStyles.body),
                          subtitle: Text('المستوى: ${student.level}', style: AppTextStyles.muted),
                          trailing: const Icon(Icons.chevron_left),
                          onTap: () => context.goNamed('studentDetails', pathParameters: {'id': '${student.id}'}),
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
