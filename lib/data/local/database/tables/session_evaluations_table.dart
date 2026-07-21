import 'package:drift/drift.dart';
import 'sessions_table.dart';

class SessionEvaluations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id).unique()();
  RealColumn get memorizationScore => real().withDefault(const Constant(0.0))();
  RealColumn get tajweedScore => real().withDefault(const Constant(0.0))();
  RealColumn get fluencyScore => real().withDefault(const Constant(0.0))();
  RealColumn get accuracyScore => real().withDefault(const Constant(0.0))();

  // FinalScore is computed, not stored

  @override
  Set<Column> get primaryKey => {id};
}
