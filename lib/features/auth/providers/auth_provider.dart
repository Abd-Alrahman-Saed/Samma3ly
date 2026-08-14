import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/domain/entities/user.dart';
import 'package:quran_mobile/providers.dart';

/// معلّم واحد بلا كلمة مرور: عند فتح التطبيق يُحمَّل سجل المعلّم تلقائياً
/// إن وُجد (بلا أي خطوة "تسجيل دخول")، وإن لم يوجد بعد يُوجَّه المستخدم
/// لشاشة الإعداد الأولي (اسم فقط) عبر `isLoggedInProvider` في app_router.
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<User?>>((ref) {
  return AuthStateNotifier(ref)..loadTeacher();
});

class AuthStateNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;

  AuthStateNotifier(this._ref) : super(const AsyncLoading());

  Future<void> loadTeacher() async {
    final repo = _ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    try {
      final teacher = await repo.getTeacher();
      state = AsyncData(teacher);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> setupTeacher(String fullName) async {
    final repo = _ref.read(authRepositoryProvider);
    final teacher = await repo.setupTeacher(fullName);
    state = AsyncData(teacher);
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
