import 'package:drift/drift.dart';
import 'sessions_table.dart';
import 'students_table.dart';

/// حضور طالب واحد في جلسة واحدة. جلسة فردية لها صف واحد بالضبط؛ جلسة
/// جماعية (Sessions.sessionType == 'جماعي') لها صف لكل طالب حضر. كانت
/// هذه القيمة عمود attendanceStatus مباشرة على Sessions قبل v4 — نُقلت
/// هنا لأن الجلسة الجماعية تحتاج حالة حضور مستقلة لكل طالب فيها.
class SessionAttendances extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  IntColumn get studentId => integer().references(Students, #id)();
  TextColumn get attendanceStatus => text().withLength(max: 20).withDefault(const Constant('حاضر'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {sessionId, studentId},
      ];
}
