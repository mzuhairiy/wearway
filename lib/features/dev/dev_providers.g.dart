// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// SeedManager sebagai provider (dipakai dev menu "Reset all data").
/// Membangun dari box yang sudah dibuka di main().

@ProviderFor(seedManager)
final seedManagerProvider = SeedManagerProvider._();

/// SeedManager sebagai provider (dipakai dev menu "Reset all data").
/// Membangun dari box yang sudah dibuka di main().

final class SeedManagerProvider
    extends $FunctionalProvider<SeedManager, SeedManager, SeedManager>
    with $Provider<SeedManager> {
  /// SeedManager sebagai provider (dipakai dev menu "Reset all data").
  /// Membangun dari box yang sudah dibuka di main().
  SeedManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seedManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seedManagerHash();

  @$internal
  @override
  $ProviderElement<SeedManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SeedManager create(Ref ref) {
    return seedManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeedManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeedManager>(value),
    );
  }
}

String _$seedManagerHash() => r'6d212831925a806701494b305ec2f03be8a3d612';
