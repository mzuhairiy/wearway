// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// go_router sebagai provider (keepAlive: dibuat sekali seumur app).
/// Dibungkus provider supaya redirect bisa baca auth state dari Riverpod.

@ProviderFor(goRouter)
final goRouterProvider = GoRouterProvider._();

/// go_router sebagai provider (keepAlive: dibuat sekali seumur app).
/// Dibungkus provider supaya redirect bisa baca auth state dari Riverpod.

final class GoRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// go_router sebagai provider (keepAlive: dibuat sekali seumur app).
  /// Dibungkus provider supaya redirect bisa baca auth state dari Riverpod.
  GoRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return goRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$goRouterHash() => r'e8b3be6d121bfb686ae05b874ecb49ad78df6197';
