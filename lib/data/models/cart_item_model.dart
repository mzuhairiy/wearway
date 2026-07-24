import 'package:hive_ce/hive_ce.dart';

part 'cart_item_model.g.dart';

/// Item di keranjang. `userId` null = guest cart (belum login).
@HiveType(typeId: 4)
class CartItemModel {
  const CartItemModel({
    required this.id,
    required this.productId,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
    required this.addedAtMs,
    this.userId,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? userId;
  @HiveField(2)
  final String productId;
  @HiveField(3)
  final String selectedSize;
  @HiveField(4)
  final String selectedColor;
  @HiveField(5)
  final int quantity;
  @HiveField(6)
  final int addedAtMs;

  CartItemModel copyWith({String? userId, int? quantity}) {
    return CartItemModel(
      id: id,
      userId: userId ?? this.userId,
      productId: productId,
      selectedSize: selectedSize,
      selectedColor: selectedColor,
      quantity: quantity ?? this.quantity,
      addedAtMs: addedAtMs,
    );
  }
}
