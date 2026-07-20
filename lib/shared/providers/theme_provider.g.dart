// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller ThemeMode global (light/dark/system).
/// `@riverpod` + Notifier = state provider bergaya reducer, AutoDispose default.
/// Prompt Settings nanti bakal persist pilihan ini ke Hive box 'settings'.

@ProviderFor(ThemeModeController)
final themeModeControllerProvider = ThemeModeControllerProvider._();

/// Controller ThemeMode global (light/dark/system).
/// `@riverpod` + Notifier = state provider bergaya reducer, AutoDispose default.
/// Prompt Settings nanti bakal persist pilihan ini ke Hive box 'settings'.
final class ThemeModeControllerProvider
    extends $NotifierProvider<ThemeModeController, ThemeMode> {
  /// Controller ThemeMode global (light/dark/system).
  /// `@riverpod` + Notifier = state provider bergaya reducer, AutoDispose default.
  /// Prompt Settings nanti bakal persist pilihan ini ke Hive box 'settings'.
  ThemeModeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeControllerHash();

  @$internal
  @override
  ThemeModeController create() => ThemeModeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeControllerHash() =>
    r'c9b61d4e3becf845a3017e2bc6dc5ade14685335';

/// Controller ThemeMode global (light/dark/system).
/// `@riverpod` + Notifier = state provider bergaya reducer, AutoDispose default.
/// Prompt Settings nanti bakal persist pilihan ini ke Hive box 'settings'.

abstract class _$ThemeModeController extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
