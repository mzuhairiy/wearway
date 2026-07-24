// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Status login turunan dari [AuthController] (null = guest).
/// Dipakai router guard & UI. Reaktif: berubah otomatis saat login/logout.

@ProviderFor(isLoggedIn)
final isLoggedInProvider = IsLoggedInProvider._();

/// Status login turunan dari [AuthController] (null = guest).
/// Dipakai router guard & UI. Reaktif: berubah otomatis saat login/logout.

final class IsLoggedInProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Status login turunan dari [AuthController] (null = guest).
  /// Dipakai router guard & UI. Reaktif: berubah otomatis saat login/logout.
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

String _$isLoggedInHash() => r'29d92f3e7819625284094a3947e86d437151e45e';
