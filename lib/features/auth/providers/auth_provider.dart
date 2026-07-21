import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/user.dart';
import 'package:quran_mobile/providers.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<User?>>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;

  AuthStateNotifier(this._ref) : super(const AsyncData(null));

  Future<bool> hasUsers() async {
    final repo = _ref.read(authRepositoryProvider);
    return await repo.anyUsersExist();
  }

  Future<User?> login(String username, String password) async {
    final repo = _ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    try {
      final user = await repo.login(username, password);
      state = AsyncData(user);
      return user;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<void> createAdmin(String username, String password, String fullName) async {
    final repo = _ref.read(authRepositoryProvider);
    await repo.createAdmin(username, password, fullName);
  }

  Future<void> logout() async {
    state = const AsyncData(null);
  }
}

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull != null;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull;
});
