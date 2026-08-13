import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/core/widgets/app_shell.dart';
import 'package:quran_mobile/features/auth/providers/auth_provider.dart';
import 'package:quran_mobile/features/auth/screens/login_screen.dart';
import 'package:quran_mobile/features/auth/screens/setup_screen.dart';
import 'package:quran_mobile/features/onboarding/screens/onboarding_screen.dart';
import 'package:quran_mobile/features/dashboard/screens/dashboard_screen.dart';
import 'package:quran_mobile/features/students/screens/student_list_screen.dart';
import 'package:quran_mobile/features/students/screens/student_details_screen.dart';
import 'package:quran_mobile/features/students/screens/student_create_screen.dart';
import 'package:quran_mobile/features/sessions/screens/session_list_screen.dart';
import 'package:quran_mobile/features/sessions/screens/session_create_screen.dart';
import 'package:quran_mobile/features/schedules/screens/schedule_list_screen.dart';
import 'package:quran_mobile/features/goals/screens/goal_list_screen.dart';
import 'package:quran_mobile/features/groups/screens/group_list_screen.dart';
import 'package:quran_mobile/features/groups/screens/group_create_screen.dart';
import 'package:quran_mobile/features/groups/screens/group_detail_screen.dart';
import 'package:quran_mobile/features/memorization/screens/memorization_screen.dart';
import 'package:quran_mobile/features/memorization/screens/review_queue_screen.dart';
import 'package:quran_mobile/features/reports/screens/reports_screen.dart';
import 'package:quran_mobile/features/settings/screens/settings_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final location = state.matchedLocation;

      if (location == '/onboarding') return null;

      if (location == '/login' || location == '/setup') {
        if (isLoggedIn) return '/';
        return null;
      }

      if (!isLoggedIn) return '/login';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/setup',
        name: 'setup',
        builder: (_, __) => const SetupScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (_, state) => OnboardingScreen(nextRoute: state.uri.queryParameters['next'] ?? 'login'),
      ),
      ShellRoute(
        builder: (_, state, child) => AppShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard',
            builder: (_, __) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/students',
            name: 'students',
            builder: (_, __) => const StudentListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                name: 'studentCreate',
                builder: (_, __) => const StudentCreateScreen(),
              ),
              GoRoute(
                path: ':id',
                name: 'studentDetails',
                builder: (_, state) => StudentDetailsScreen(
                  studentId: int.parse(state.pathParameters['id']!),
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'studentEdit',
                    builder: (_, state) => StudentCreateScreen(
                      studentId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                  GoRoute(
                    path: 'sessions/create',
                    name: 'sessionCreate',
                    builder: (_, state) => SessionCreateScreen(
                      studentId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                  GoRoute(
                    path: 'memorization',
                    name: 'memorization',
                    builder: (_, state) => MemorizationScreen(
                      studentId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/sessions',
            name: 'sessionsList',
            builder: (_, __) => const SessionListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                name: 'sessionCreateStandalone',
                builder: (_, __) => const SessionCreateScreen(),
              ),
              GoRoute(
                path: ':id',
                name: 'sessionEdit',
                builder: (_, state) => SessionCreateScreen(
                  sessionId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/schedules',
            name: 'schedulesList',
            builder: (_, __) => const ScheduleListScreen(),
          ),
          GoRoute(
            path: '/groups',
            name: 'groupsList',
            builder: (_, __) => const GroupListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                name: 'groupCreate',
                builder: (_, __) => const GroupCreateScreen(),
              ),
              GoRoute(
                path: ':id',
                name: 'groupDetails',
                builder: (_, state) => GroupDetailScreen(
                  groupId: int.parse(state.pathParameters['id']!),
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'groupEdit',
                    builder: (_, state) => GroupCreateScreen(
                      groupId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/goals',
            name: 'goalsList',
            builder: (_, __) => const GoalListScreen(),
          ),
          GoRoute(
            path: '/reports',
            name: 'reports',
            builder: (_, __) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/review-queue',
            name: 'reviewQueue',
            builder: (_, __) => const ReviewQueueScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
