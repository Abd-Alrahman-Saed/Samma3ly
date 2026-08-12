import 'package:drift/drift.dart';
import 'groups_table.dart';
import 'students_table.dart';

/// عضوية طالب في مجموعة — علاقة many-to-many بين Students وGroups.
class GroupMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer().references(Groups, #id)();
  IntColumn get studentId => integer().references(Students, #id)();
  DateTimeColumn get joinedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {groupId, studentId},
      ];
}
