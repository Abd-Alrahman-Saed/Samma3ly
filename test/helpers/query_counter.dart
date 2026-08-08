import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:quran_mobile/data/local/database/app_database.dart';

/// Counts SQL statements executed through a [QueryExecutor].
///
/// Used to lock in the current N+1 query behavior of `ProgressService`
/// (Sprint 0 item 0.5) as a regression guard: the count is expected to be
/// high before the fix and low after it.
class QueryCountInterceptor extends QueryInterceptor {
  int selectCount = 0;
  int totalCount = 0;

  @override
  Future<List<Map<String, Object?>>> runSelect(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    selectCount++;
    totalCount++;
    return executor.runSelect(statement, args);
  }

  @override
  Future<int> runInsert(QueryExecutor executor, String statement, List<Object?> args) {
    totalCount++;
    return executor.runInsert(statement, args);
  }

  @override
  Future<int> runUpdate(QueryExecutor executor, String statement, List<Object?> args) {
    totalCount++;
    return executor.runUpdate(statement, args);
  }
}

/// Opens an in-memory [AppDatabase] whose executed queries are counted by
/// [interceptor].
AppDatabase openCountedTestDatabase(QueryCountInterceptor interceptor) {
  final base = NativeDatabase.memory();
  return AppDatabase.forTesting(base.interceptWith(interceptor));
}
