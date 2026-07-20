import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_provider.g.dart';

/// Placeholder status login untuk router guard (Prompt 1).
/// Sementara selalu `false` (guest).
// TODO(prompt3): baca 'current_user_id' dari Hive box 'meta' via auth notifier.
@riverpod
bool isLoggedIn(Ref ref) => false;
