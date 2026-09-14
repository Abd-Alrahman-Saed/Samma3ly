import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/users_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<List<User>> getAll() => select(users).get();

  Future<User?> getById(int id) => (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<User?> getByUsername(String username) =>
      (select(users)..where((t) => t.username.equals(username))).getSingleOrNull();

  Future<bool> anyUsersExist() => select(users).get().then((list) => list.isNotEmpty);

  Future<int> insert(UsersCompanion entry) => into(users).insert(entry);

  Future<bool> updateEntry(UsersCompanion entry) => update(users).replace(entry);

  Future<int> countByRole(String role) =>
      (select(users)..where((t) => t.role.equals(role))).get().then((list) => list.length);
}
