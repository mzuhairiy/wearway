// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State auth global: `UserModel?` (null = guest).
///
/// `build()` = restoreSession — baca 'current_user_id' dari Hive box 'meta'
/// saat provider pertama dibaca (dipicu splash gate di app.dart).
/// AsyncNotifier dipilih supaya form bisa tampilkan loading/error langsung.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// State auth global: `UserModel?` (null = guest).
///
/// `build()` = restoreSession — baca 'current_user_id' dari Hive box 'meta'
/// saat provider pertama dibaca (dipicu splash gate di app.dart).
/// AsyncNotifier dipilih supaya form bisa tampilkan loading/error langsung.
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, UserModel?> {
  /// State auth global: `UserModel?` (null = guest).
  ///
  /// `build()` = restoreSession — baca 'current_user_id' dari Hive box 'meta'
  /// saat provider pertama dibaca (dipicu splash gate di app.dart).
  /// AsyncNotifier dipilih supaya form bisa tampilkan loading/error langsung.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'3e4612291a88619f22e65a34c2f378e76ad9ce28';

/// State auth global: `UserModel?` (null = guest).
///
/// `build()` = restoreSession — baca 'current_user_id' dari Hive box 'meta'
/// saat provider pertama dibaca (dipicu splash gate di app.dart).
/// AsyncNotifier dipilih supaya form bisa tampilkan loading/error langsung.

abstract class _$AuthController extends $AsyncNotifier<UserModel?> {
  FutureOr<UserModel?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserModel?>, UserModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserModel?>, UserModel?>,
              AsyncValue<UserModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Bootstrap sekali: tunggu restore session pertama selesai.
/// Splash di app.dart nge-gate provider ini (bukan authController) supaya
/// login/logout berikutnya tidak memicu splash lagi.

@ProviderFor(appBootstrap)
final appBootstrapProvider = AppBootstrapProvider._();

/// Bootstrap sekali: tunggu restore session pertama selesai.
/// Splash di app.dart nge-gate provider ini (bukan authController) supaya
/// login/logout berikutnya tidak memicu splash lagi.

final class AppBootstrapProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Bootstrap sekali: tunggu restore session pertama selesai.
  /// Splash di app.dart nge-gate provider ini (bukan authController) supaya
  /// login/logout berikutnya tidak memicu splash lagi.
  AppBootstrapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appBootstrapProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appBootstrapHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return appBootstrap(ref);
  }
}

String _$appBootstrapHash() => r'9d1d0545bf86c993d9013b31798a8a63b8bb0da6';
