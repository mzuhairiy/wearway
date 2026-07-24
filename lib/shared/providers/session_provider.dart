import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/features/auth/providers/auth_controller.dart';

part 'session_provider.g.dart';

/// Status login turunan dari [AuthController] (null = guest).
/// Dipakai router guard & UI. Reaktif: berubah otomatis saat login/logout.
@riverpod
bool isLoggedIn(Ref ref) {
  return ref.watch(authControllerProvider).value != null;
}
