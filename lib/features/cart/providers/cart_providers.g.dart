// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// userId pemilik cart aktif (null = guest). Reaktif ke login/logout.

@ProviderFor(currentCartUserId)
final currentCartUserIdProvider = CurrentCartUserIdProvider._();

/// userId pemilik cart aktif (null = guest). Reaktif ke login/logout.

final class CurrentCartUserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// userId pemilik cart aktif (null = guest). Reaktif ke login/logout.
  CurrentCartUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentCartUserIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentCartUserIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentCartUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentCartUserIdHash() => r'bfd5429e2bfccf319eae2d8c9b68c94b9348ff97';

/// Stream cart items milik user/guest aktif (reaktif ke perubahan box).

@ProviderFor(cartItems)
final cartItemsProvider = CartItemsProvider._();

/// Stream cart items milik user/guest aktif (reaktif ke perubahan box).

final class CartItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CartItemModel>>,
          List<CartItemModel>,
          Stream<List<CartItemModel>>
        >
    with
        $FutureModifier<List<CartItemModel>>,
        $StreamProvider<List<CartItemModel>> {
  /// Stream cart items milik user/guest aktif (reaktif ke perubahan box).
  CartItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartItemsHash();

  @$internal
  @override
  $StreamProviderElement<List<CartItemModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CartItemModel>> create(Ref ref) {
    return cartItems(ref);
  }
}

String _$cartItemsHash() => r'ea61bbafc1c8097f953e9a8af0a3ed4635371b28';

/// Total kuantitas item di cart (untuk badge bottom nav).

@ProviderFor(cartCount)
final cartCountProvider = CartCountProvider._();

/// Total kuantitas item di cart (untuk badge bottom nav).

final class CartCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Total kuantitas item di cart (untuk badge bottom nav).
  CartCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return cartCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$cartCountHash() => r'0157a12347600b2f553aba9f8ae50be84714a814';

/// Gabungan cart items + data produk (skip item yang produknya hilang).

@ProviderFor(cartLines)
final cartLinesProvider = CartLinesProvider._();

/// Gabungan cart items + data produk (skip item yang produknya hilang).

final class CartLinesProvider
    extends $FunctionalProvider<List<CartLine>, List<CartLine>, List<CartLine>>
    with $Provider<List<CartLine>> {
  /// Gabungan cart items + data produk (skip item yang produknya hilang).
  CartLinesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartLinesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartLinesHash();

  @$internal
  @override
  $ProviderElement<List<CartLine>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<CartLine> create(Ref ref) {
    return cartLines(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CartLine> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CartLine>>(value),
    );
  }
}

String _$cartLinesHash() => r'59196f7048ea38e302d14610d2399ea0eb528520';

/// Subtotal (tanpa promo/ongkir) — dasar validasi promo & summary.

@ProviderFor(cartSubtotal)
final cartSubtotalProvider = CartSubtotalProvider._();

/// Subtotal (tanpa promo/ongkir) — dasar validasi promo & summary.

final class CartSubtotalProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Subtotal (tanpa promo/ongkir) — dasar validasi promo & summary.
  CartSubtotalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartSubtotalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartSubtotalHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return cartSubtotal(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$cartSubtotalHash() => r'16961e30872f9572ad251fd9c3f64a7acff0157b';

@ProviderFor(cartSummary)
final cartSummaryProvider = CartSummaryProvider._();

final class CartSummaryProvider
    extends $FunctionalProvider<CartSummary, CartSummary, CartSummary>
    with $Provider<CartSummary> {
  CartSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartSummaryHash();

  @$internal
  @override
  $ProviderElement<CartSummary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CartSummary create(Ref ref) {
    return cartSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartSummary>(value),
    );
  }
}

String _$cartSummaryHash() => r'dd697fc51f717ae17faf0f3ea847d1df0ea20ed1';

/// Promo controller: apply/remove kode. Validasi pakai subtotal saat apply.

@ProviderFor(PromoController)
final promoControllerProvider = PromoControllerProvider._();

/// Promo controller: apply/remove kode. Validasi pakai subtotal saat apply.
final class PromoControllerProvider
    extends $NotifierProvider<PromoController, PromoState> {
  /// Promo controller: apply/remove kode. Validasi pakai subtotal saat apply.
  PromoControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'promoControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$promoControllerHash();

  @$internal
  @override
  PromoController create() => PromoController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PromoState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PromoState>(value),
    );
  }
}

String _$promoControllerHash() => r'3303e6220c3c52945813325500bd41cb322e0f57';

/// Promo controller: apply/remove kode. Validasi pakai subtotal saat apply.

abstract class _$PromoController extends $Notifier<PromoState> {
  PromoState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PromoState, PromoState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PromoState, PromoState>,
              PromoState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Aksi cart (mutasi Hive lewat repository).
/// keepAlive: controller aksi dibaca via `.notifier` lalu dipakai belakangan
/// (di callback tombol / setelah dialog). Kalau autoDispose, notifier keburu
/// di-dispose → `ref.read` di dalamnya lempar "used after disposed" (senyap).

@ProviderFor(CartController)
final cartControllerProvider = CartControllerProvider._();

/// Aksi cart (mutasi Hive lewat repository).
/// keepAlive: controller aksi dibaca via `.notifier` lalu dipakai belakangan
/// (di callback tombol / setelah dialog). Kalau autoDispose, notifier keburu
/// di-dispose → `ref.read` di dalamnya lempar "used after disposed" (senyap).
final class CartControllerProvider
    extends $NotifierProvider<CartController, void> {
  /// Aksi cart (mutasi Hive lewat repository).
  /// keepAlive: controller aksi dibaca via `.notifier` lalu dipakai belakangan
  /// (di callback tombol / setelah dialog). Kalau autoDispose, notifier keburu
  /// di-dispose → `ref.read` di dalamnya lempar "used after disposed" (senyap).
  CartControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartControllerHash();

  @$internal
  @override
  CartController create() => CartController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$cartControllerHash() => r'b85b5fe454a4f88be2529f1ff5126eabf572c453';

/// Aksi cart (mutasi Hive lewat repository).
/// keepAlive: controller aksi dibaca via `.notifier` lalu dipakai belakangan
/// (di callback tombol / setelah dialog). Kalau autoDispose, notifier keburu
/// di-dispose → `ref.read` di dalamnya lempar "used after disposed" (senyap).

abstract class _$CartController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
