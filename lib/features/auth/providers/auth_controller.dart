import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';
import 'package:wearway_flutter/features/dev/dev_providers.dart';

part 'auth_controller.g.dart';

/// State auth global: `UserModel?` (null = guest).
///
/// `build()` = restoreSession — baca 'current_user_id' dari Hive box 'meta'
/// saat provider pertama dibaca (dipicu splash gate di app.dart).
/// AsyncNotifier dipilih supaya form bisa tampilkan loading/error langsung.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<UserModel?> build() async {
    final current = await ref.read(userRepositoryProvider).getCurrent();
    if (current != null) return current;

    // Dev "skip login": auto-login sebagai user seed saat belum ada sesi.
    final skipLogin = ref.read(settingsRepositoryProvider).getSkipLogin();
    if (skipLogin) {
      try {
        return await ref
            .read(userRepositoryProvider)
            .login(kDevEmail, kDevPassword);
      } on Object {
        return null; // creds seed berubah / user dihapus → tetap guest.
      }
    }
    return null;
  }

  /// Restore eksplisit (dipakai kalau perlu re-check sesi). Sama dgn build().
  Future<void> restoreSession() async {
    state = await AsyncValue.guard(
      () => ref.read(userRepositoryProvider).getCurrent(),
    );
  }

  Future<void> login(String email, String password) async {
    await _run(() async {
      final user = await ref
          .read(userRepositoryProvider)
          .login(email, password);
      // Guest cart pindah ke akun setelah login (repo dari Prompt 2).
      await ref.read(cartRepositoryProvider).transferGuestToUser(user.id);
      return user;
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required int createdAtMs,
  }) async {
    await _run(() async {
      final user = await ref
          .read(userRepositoryProvider)
          .register(
            email: email,
            password: password,
            name: name,
            createdAtMs: createdAtMs,
          );
      await ref.read(cartRepositoryProvider).transferGuestToUser(user.id);
      return user;
    });
  }

  Future<void> logout() async {
    await ref.read(userRepositoryProvider).logout();
    state = const AsyncData(null);
  }

  Future<void> _run(Future<UserModel?> Function() action) async {
    state = const AsyncLoading<UserModel?>();
    state = await AsyncValue.guard(action);
  }
}

/// Bootstrap sekali: tunggu restore session pertama selesai.
/// Splash di app.dart nge-gate provider ini (bukan authController) supaya
/// login/logout berikutnya tidak memicu splash lagi.
@Riverpod(keepAlive: true)
Future<void> appBootstrap(Ref ref) async {
  await ref.read(authControllerProvider.future);
}
