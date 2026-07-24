// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller flow checkout: navigasi step, isi form, place order.

@ProviderFor(CheckoutController)
final checkoutControllerProvider = CheckoutControllerProvider._();

/// Controller flow checkout: navigasi step, isi form, place order.
final class CheckoutControllerProvider
    extends $NotifierProvider<CheckoutController, CheckoutState> {
  /// Controller flow checkout: navigasi step, isi form, place order.
  CheckoutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutControllerHash();

  @$internal
  @override
  CheckoutController create() => CheckoutController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckoutState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckoutState>(value),
    );
  }
}

String _$checkoutControllerHash() =>
    r'99f1f207aaaf5a38be2f468a5627c2f7c6664dc3';

/// Controller flow checkout: navigasi step, isi form, place order.

abstract class _$CheckoutController extends $Notifier<CheckoutState> {
  CheckoutState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CheckoutState, CheckoutState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CheckoutState, CheckoutState>,
              CheckoutState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(checkoutSummary)
final checkoutSummaryProvider = CheckoutSummaryProvider._();

final class CheckoutSummaryProvider
    extends
        $FunctionalProvider<CheckoutSummary, CheckoutSummary, CheckoutSummary>
    with $Provider<CheckoutSummary> {
  CheckoutSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutSummaryHash();

  @$internal
  @override
  $ProviderElement<CheckoutSummary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CheckoutSummary create(Ref ref) {
    return checkoutSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckoutSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckoutSummary>(value),
    );
  }
}

String _$checkoutSummaryHash() => r'53851ded618937acfa8f54285a77871092203095';
