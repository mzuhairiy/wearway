import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/models/cart_item_model.dart';
import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/data/providers/catalog_providers.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';
import 'package:wearway_flutter/features/auth/providers/auth_controller.dart';
import 'package:wearway_flutter/features/cart/services/promo_service.dart';

part 'cart_providers.g.dart';

const int _deliveryFeeIdr = 15000;
const int _freeShippingThresholdIdr = 300000;

/// userId pemilik cart aktif (null = guest). Reaktif ke login/logout.
@riverpod
String? currentCartUserId(Ref ref) {
  return ref.watch(authControllerProvider).value?.id;
}

/// Stream cart items milik user/guest aktif (reaktif ke perubahan box).
@riverpod
Stream<List<CartItemModel>> cartItems(Ref ref) {
  final userId = ref.watch(currentCartUserIdProvider);
  return ref.watch(cartRepositoryProvider).watch(userId);
}

/// Total kuantitas item di cart (untuk badge bottom nav).
@riverpod
int cartCount(Ref ref) {
  final items = ref.watch(cartItemsProvider).value ?? const [];
  return items.fold(0, (sum, item) => sum + item.quantity);
}

/// Baris cart siap-tampil: cart item + produknya + subtotal baris.
class CartLine {
  const CartLine({required this.item, required this.product});

  final CartItemModel item;
  final ProductModel product;

  int get unitPriceIdr => product.discountedPriceIdr;
  int get lineSubtotalIdr => unitPriceIdr * item.quantity;
}

/// Gabungan cart items + data produk (skip item yang produknya hilang).
@riverpod
List<CartLine> cartLines(Ref ref) {
  final items = ref.watch(cartItemsProvider).value ?? const [];
  final products = ref.watch(productListProvider).value ?? const [];
  final byId = {for (final p in products) p.id: p};
  final lines = <CartLine>[];
  for (final item in items) {
    final product = byId[item.productId];
    if (product != null) lines.add(CartLine(item: item, product: product));
  }
  return lines;
}

/// Subtotal (tanpa promo/ongkir) — dasar validasi promo & summary.
@riverpod
int cartSubtotal(Ref ref) {
  final lines = ref.watch(cartLinesProvider);
  return lines.fold(0, (sum, line) => sum + line.lineSubtotalIdr);
}

/// State promo yang diterapkan (code) + pesan error terakhir.
class PromoState {
  const PromoState({this.code, this.error});

  final String? code;
  final String? error;
}

/// Ringkasan biaya cart (subtotal, diskon, ongkir, total).
class CartSummary {
  const CartSummary({
    required this.subtotalIdr,
    required this.discountIdr,
    required this.deliveryFeeIdr,
    required this.totalIdr,
    required this.freeShipping,
    this.promoCode,
  });

  final int subtotalIdr;
  final int discountIdr;
  final int deliveryFeeIdr;
  final int totalIdr;
  final bool freeShipping;
  final String? promoCode;
}

@riverpod
CartSummary cartSummary(Ref ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final promoCode = ref.watch(promoControllerProvider).code;

  var discount = 0;
  if (promoCode != null) {
    final result = PromoService.validate(promoCode, subtotal);
    if (result.isValid) discount = result.discountIdr;
  }

  final freeShipping = subtotal > _freeShippingThresholdIdr;
  final delivery = subtotal <= 0 || freeShipping ? 0 : _deliveryFeeIdr;
  final total = (subtotal + delivery - discount).clamp(0, 1 << 31);

  return CartSummary(
    subtotalIdr: subtotal,
    discountIdr: discount,
    deliveryFeeIdr: delivery,
    totalIdr: total,
    freeShipping: freeShipping,
    promoCode: discount > 0 ? promoCode : null,
  );
}

/// Promo controller: apply/remove kode. Validasi pakai subtotal saat apply.
@Riverpod(keepAlive: true)
class PromoController extends _$PromoController {
  @override
  PromoState build() => const PromoState();

  PromoResult apply(String code) {
    final subtotal = ref.read(cartSubtotalProvider);
    final result = PromoService.validate(code, subtotal);
    state = result.isValid
        ? PromoState(code: result.code)
        : PromoState(error: result.message);
    return result;
  }

  void remove() => state = const PromoState();
}

/// Aksi cart (mutasi Hive lewat repository).
/// keepAlive: controller aksi dibaca via `.notifier` lalu dipakai belakangan
/// (di callback tombol / setelah dialog). Kalau autoDispose, notifier keburu
/// di-dispose → `ref.read` di dalamnya lempar "used after disposed" (senyap).
@Riverpod(keepAlive: true)
class CartController extends _$CartController {
  @override
  void build() {}

  Future<void> addToCart({
    required String productId,
    required String size,
    required String color,
    required int quantity,
  }) async {
    final userId = ref.read(currentCartUserIdProvider);
    final ownerKey = userId ?? 'guest';
    final item = CartItemModel(
      // id komposit stabil per varian → repo gabung qty kalau sudah ada.
      id: 'cart_${ownerKey}_${productId}_${size}_$color',
      userId: userId,
      productId: productId,
      selectedSize: size,
      selectedColor: color,
      quantity: quantity,
      addedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    await ref.read(cartRepositoryProvider).add(item);
  }

  Future<void> updateQty(String cartItemId, int quantity) {
    return ref.read(cartRepositoryProvider).updateQty(cartItemId, quantity);
  }

  Future<void> removeItem(String cartItemId) {
    return ref.read(cartRepositoryProvider).remove(cartItemId);
  }

  Future<void> clearCart() {
    final userId = ref.read(currentCartUserIdProvider);
    return ref.read(cartRepositoryProvider).clear(userId);
  }
}
