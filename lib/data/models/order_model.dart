import 'package:hive_ce/hive_ce.dart';
import 'package:wearway_flutter/data/models/order_item_model.dart';
import 'package:wearway_flutter/data/models/order_status.dart';

part 'order_model.g.dart';

/// Order lengkap. Semua amount int Rupiah. `items` snapshot OrderItemModel.
@HiveType(typeId: 6)
class OrderModel {
  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.addressId,
    required this.subtotalIdr,
    required this.deliveryFeeIdr,
    required this.discountIdr,
    required this.totalIdr,
    required this.status,
    required this.paymentMethod,
    required this.placedAtMs,
    required this.estimatedDeliveryMs,
    required this.items,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String orderNumber;
  @HiveField(2)
  final String userId;
  @HiveField(3)
  final String addressId;
  @HiveField(4)
  final int subtotalIdr;
  @HiveField(5)
  final int deliveryFeeIdr;
  @HiveField(6)
  final int discountIdr;
  @HiveField(7)
  final int totalIdr;
  @HiveField(8)
  final OrderStatus status;
  @HiveField(9)
  final String paymentMethod;
  @HiveField(10)
  final int placedAtMs;
  @HiveField(11)
  final int estimatedDeliveryMs;
  @HiveField(12)
  final List<OrderItemModel> items;

  OrderModel copyWith({OrderStatus? status}) {
    return OrderModel(
      id: id,
      orderNumber: orderNumber,
      userId: userId,
      addressId: addressId,
      subtotalIdr: subtotalIdr,
      deliveryFeeIdr: deliveryFeeIdr,
      discountIdr: discountIdr,
      totalIdr: totalIdr,
      status: status ?? this.status,
      paymentMethod: paymentMethod,
      placedAtMs: placedAtMs,
      estimatedDeliveryMs: estimatedDeliveryMs,
      items: items,
    );
  }
}
