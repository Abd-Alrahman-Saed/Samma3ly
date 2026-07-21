import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';
import 'package:quran_mobile/core/widgets/error_banner.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/core/widgets/session_card.dart';
import 'package:quran_mobile/core/widgets/loading_overlay.dart';
import 'package:quran_mobile/features/sessions/providers/session_provider.dart';

class SessionListScreen extends ConsumerStatefulWidget {
  const SessionListScreen({super.key});

  @override
  ConsumerState<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends ConsumerState<SessionListScreen> {
  DateTimeRange? _selectedRange;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _selectedRange ?? DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() => _selectedRange = picked);
      ref.read(sessionDateFilterProvider.notifier).state = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(sessionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الجلسات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _pickDateRange,
          ),
        ],
      ),
      body: sessionsAsync.when(
        loading: () => const LoadingOverlay(),
        error: (e, st) => ErrorBanner(message: e.toString(), onRetry: () => ref.invalidate(sessionListProvider)),
        data: (sessions) {
          if (sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('لا توجد جلسات', style: AppTextStyles.muted),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(sessionListProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (_, i) {
                final session = sessions[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SessionCard(
                    item: SessionCardItem(
                      id: session.id,
                      studentId: session.studentId,
                      studentName: 'طالب رقم ${session.studentId}',
                      initials: 'ط',
                      date: session.date,
                      timeDisplay: session.time,
                      attendanceStatus: session.attendanceStatus,
                      finalScore: session.evaluation?.finalScore ?? 0,
                      memorizationInfo: session.memorization != null ? 'حفظ: سورة ${session.memorization!.surahId} (${session.memorization!.fromAyah}-${session.memorization!.toAyah})' : '',
                      revisionInfo: session.revision != null ? 'مراجعة: سورة ${session.revision!.surahId} (${session.revision!.fromAyah}-${session.revision!.toAyah})' : '',
                    ),
                    onTap: () => context.goNamed('sessionEdit', pathParameters: {'id': '${session.id}'}),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
