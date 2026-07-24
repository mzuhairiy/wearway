import 'package:hive_ce/hive_ce.dart';

part 'order_item_model.g.dart';

/// Baris item di dalam order. Semua field snapshot (harga & nama saat beli).
@HiveType(typeId: 7)
class OrderItemModel {
  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.pricePerUnitIdr,
    required this.size,
    required this.color,
    required this.quantity,
    required this.subtotalIdr,
  });

  @HiveField(0)
  final String productId;
  @HiveField(1)
  final String productName;
  @HiveField(2)
  final int pricePerUnitIdr;
  @HiveField(3)
  final String size;
  @HiveField(4)
  final String color;
  @HiveField(5)
  final int quantity;
  @HiveField(6)
  final int subtotalIdr;
}
