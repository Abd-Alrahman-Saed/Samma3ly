import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';
import 'package:quran_mobile/data/local/database/daos/user_dao.dart';
import 'package:quran_mobile/data/local/database/daos/surah_dao.dart';
import 'package:quran_mobile/data/local/database/daos/juz_surah_range_dao.dart';
import 'package:quran_mobile/data/local/database/daos/student_dao.dart';
import 'package:quran_mobile/data/local/database/daos/session_dao.dart';
import 'package:quran_mobile/data/local/database/daos/schedule_dao.dart';
import 'package:quran_mobile/data/local/database/daos/goal_dao.dart';
import 'package:quran_mobile/data/local/database/daos/memorized_range_dao.dart';
import 'package:quran_mobile/data/local/database/daos/group_dao.dart';
import 'package:quran_mobile/domain/services/auth_service.dart';
import 'package:quran_mobile/domain/services/progress_service.dart';
import 'package:quran_mobile/domain/services/memorized_range_service.dart';
import 'package:quran_mobile/domain/services/dashboard_service.dart';
import 'package:quran_mobile/domain/services/backup_service.dart';
import 'package:quran_mobile/domain/services/group_session_service.dart';
import 'package:quran_mobile/data/repositories/auth_repository_impl.dart';
import 'package:quran_mobile/data/repositories/student_repository_impl.dart';
import 'package:quran_mobile/data/repositories/session_repository_impl.dart';
import 'package:quran_mobile/data/repositories/schedule_repository_impl.dart';
import 'package:quran_mobile/data/repositories/goal_repository_impl.dart';
import 'package:quran_mobile/data/repositories/memorized_range_repository_impl.dart';
import 'package:quran_mobile/data/repositories/dashboard_repository_impl.dart';
import 'package:quran_mobile/data/repositories/group_repository_impl.dart';
import 'package:quran_mobile/data/repositories/group_schedule_repository_impl.dart';
import 'package:quran_mobile/domain/repositories/auth_repository.dart';
import 'package:quran_mobile/domain/repositories/student_repository.dart';
import 'package:quran_mobile/domain/repositories/session_repository.dart';
import 'package:quran_mobile/domain/repositories/schedule_repository.dart';
import 'package:quran_mobile/domain/repositories/goal_repository.dart';
import 'package:quran_mobile/domain/repositories/memorized_range_repository.dart';
import 'package:quran_mobile/domain/repositories/dashboard_repository.dart';
import 'package:quran_mobile/domain/repositories/group_repository.dart';
import 'package:quran_mobile/domain/repositories/group_schedule_repository.dart';

// Database
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

// DAOs
final userDaoProvider = Provider<UserDao>((ref) => UserDao(ref.watch(appDatabaseProvider)));
final surahDaoProvider = Provider<SurahDao>((ref) => SurahDao(ref.watch(appDatabaseProvider)));
final juzSurahRangeDaoProvider = Provider<JuzSurahRangeDao>((ref) => JuzSurahRangeDao(ref.watch(appDatabaseProvider)));
final studentDaoProvider = Provider<StudentDao>((ref) => StudentDao(ref.watch(appDatabaseProvider)));
final sessionDaoProvider = Provider<SessionDao>((ref) => SessionDao(ref.watch(appDatabaseProvider)));
final scheduleDaoProvider = Provider<ScheduleDao>((ref) => ScheduleDao(ref.watch(appDatabaseProvider)));
final goalDaoProvider = Provider<GoalDao>((ref) => GoalDao(ref.watch(appDatabaseProvider)));
final memorizedRangeDaoProvider = Provider<MemorizedRangeDao>((ref) => MemorizedRangeDao(ref.watch(appDatabaseProvider)));
final groupDaoProvider = Provider<GroupDao>((ref) => GroupDao(ref.watch(appDatabaseProvider)));

// Services
final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref.watch(userDaoProvider)));

final progressServiceProvider = Provider<ProgressService>((ref) => ProgressService(
  studentDao: ref.watch(studentDaoProvider),
  sessionDao: ref.watch(sessionDaoProvider),
  goalDao: ref.watch(goalDaoProvider),
  juzRangeDao: ref.watch(juzSurahRangeDaoProvider),
  surahDao: ref.watch(surahDaoProvider),
));

final memorizedRangeServiceProvider = Provider<MemorizedRangeService>(
  (ref) => MemorizedRangeService(ref.watch(memorizedRangeDaoProvider)),
);

final dashboardServiceProvider = Provider<DashboardService>((ref) => DashboardService(
  studentDao: ref.watch(studentDaoProvider),
  sessionDao: ref.watch(sessionDaoProvider),
  scheduleDao: ref.watch(scheduleDaoProvider),
  userDao: ref.watch(userDaoProvider),
));

// Repositories
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authServiceProvider)),
);

final studentRepositoryProvider = Provider<StudentRepository>(
  (ref) => StudentRepositoryImpl(ref.watch(studentDaoProvider), ref.watch(surahDaoProvider)),
);

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepositoryImpl(ref.watch(sessionDaoProvider)),
);

final scheduleRepositoryProvider = Provider<ScheduleRepository>(
  (ref) => ScheduleRepositoryImpl(ref.watch(scheduleDaoProvider), ref.watch(sessionDaoProvider)),
);

final goalRepositoryProvider = Provider<GoalRepository>(
  (ref) => GoalRepositoryImpl(ref.watch(goalDaoProvider)),
);

final memorizedRangeRepositoryProvider = Provider<MemorizedRangeRepository>(
  (ref) => MemorizedRangeRepositoryImpl(ref.watch(memorizedRangeServiceProvider)),
);

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepositoryImpl(ref.watch(dashboardServiceProvider)),
);

final groupRepositoryProvider = Provider<GroupRepository>(
  (ref) => GroupRepositoryImpl(ref.watch(groupDaoProvider)),
);

final groupScheduleRepositoryProvider = Provider<GroupScheduleRepository>(
  (ref) => GroupScheduleRepositoryImpl(ref.watch(groupDaoProvider)),
);

final groupSessionServiceProvider = Provider<GroupSessionService>(
  (ref) => GroupSessionService(ref.watch(groupScheduleRepositoryProvider), ref.watch(sessionDaoProvider)),
);

final backupServiceProvider = Provider<BackupService>((ref) => BackupService(
  db: ref.watch(appDatabaseProvider),
  userDao: ref.watch(userDaoProvider),
  studentDao: ref.watch(studentDaoProvider),
  sessionDao: ref.watch(sessionDaoProvider),
  scheduleDao: ref.watch(scheduleDaoProvider),
  goalDao: ref.watch(goalDaoProvider),
  memRangeDao: ref.watch(memorizedRangeDaoProvider),
  surahDao: ref.watch(surahDaoProvider),
  juzRangeDao: ref.watch(juzSurahRangeDaoProvider),
));
