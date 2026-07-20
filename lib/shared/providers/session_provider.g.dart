// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Placeholder status login untuk router guard (Prompt 1).
/// TODO(Prompt 3): ganti body → baca 'current_user_id' dari Hive box 'meta'
/// via auth notifier. Sementara selalu `false` (guest).

@ProviderFor(isLoggedIn)
final isLoggedInProvider = IsLoggedInProvider._();

/// Placeholder status login untuk router guard (Prompt 1).
/// TODO(Prompt 3): ganti body → baca 'current_user_id' dari Hive box 'meta'
/// via auth notifier. Sementara selalu `false` (guest).

final class IsLoggedInProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Placeholder status login untuk router guard (Prompt 1).
  /// TODO(Prompt 3): ganti body → baca 'current_user_id' dari Hive box 'meta'
  /// via auth notifier. Sementara selalu `false` (guest).
  IsLoggedInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isLoggedInProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isLoggedInHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isLoggedIn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isLoggedInHash() => r'320bc70210c984383e6b712e1bf899709caea227';
