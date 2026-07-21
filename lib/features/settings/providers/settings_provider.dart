import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/user.dart';
import 'package:quran_mobile/providers.dart';

final allUsersProvider = FutureProvider.autoDispose<List<User>>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return await repo.getAllUsers();
});
