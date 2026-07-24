import 'package:hive_ce/hive_ce.dart';
import 'package:wearway_flutter/data/models/cart_item_model.dart';

/// Akses data cart. `userId` null = guest cart (persist, transfer saat login).
class CartRepository {
  const CartRepository(this._box);

  final Box<CartItemModel> _box;

  Future<List<CartItemModel>> list(String? userId) async {
    return _box.values.where((c) => c.userId == userId).toList();
  }

  /// Tambah item. Kalau produk+size+color sama sudah ada → gabung qty.
  Future<void> add(CartItemModel item) async {
    final existing = _findSameVariant(item);
    if (existing != null) {
      await _box.put(
        existing.id,
        existing.copyWith(quantity: existing.quantity + item.quantity),
      );
      return;
    }
    await _box.put(item.id, item);
  }

  Future<void> updateQty(String cartItemId, int quantity) async {
    final item = _box.get(cartItemId);
    if (item == null) return;
    if (quantity <= 0) {
      await _box.delete(cartItemId);
      return;
    }
    await _box.put(cartItemId, item.copyWith(quantity: quantity));
  }

  Future<void> remove(String cartItemId) async => _box.delete(cartItemId);

  /// Kosongkan cart milik [userId] (null = guest).
  Future<void> clear(String? userId) async {
    final ids = _box.values
        .where((c) => c.userId == userId)
        .map((c) => c.id)
        .toList();
    await _box.deleteAll(ids);
  }

  /// Pindahkan guest cart (userId null) ke [userId] setelah login.
  Future<void> transferGuestToUser(String userId) async {
    final guestItems = _box.values.where((c) => c.userId == null).toList();
    for (final item in guestItems) {
      await _box.put(item.id, item.copyWith(userId: userId));
    }
  }

  Stream<List<CartItemModel>> watch(String? userId) async* {
    yield await list(userId);
    yield* _box.watch().asyncMap((_) => list(userId));
  }

  CartItemModel? _findSameVariant(CartItemModel item) {
    for (final c in _box.values) {
      if (c.userId == item.userId &&
          c.productId == item.productId &&
          c.selectedSize == item.selectedSize &&
          c.selectedColor == item.selectedColor) {
        return c;
      }
    }
    return null;
  }
}
