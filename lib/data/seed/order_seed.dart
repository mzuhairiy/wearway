import 'package:wearway_flutter/data/models/order_item_model.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/models/order_status.dart';
import 'package:wearway_flutter/data/seed/address_seed.dart';
import 'package:wearway_flutter/data/seed/product_seed.dart';
import 'package:wearway_flutter/data/seed/seed_constants.dart';
import 'package:wearway_flutter/data/seed/user_seed.dart';

/// 5 order untuk customer utama, mix status (1 placed, 1 preparing, 1 shipped,
/// 2 delivered). Item snapshot diambil dari ProductSeed (harga konsisten).
abstract final class OrderSeed {
  static const int _deliveryFee = 15000;
  static const int _freeShippingThreshold = 300000;

  static List<OrderModel> get all {
    // Lookup produk by id untuk snapshot harga/nama.
    final byId = {for (final p in ProductSeed.all) p.id: p};

    OrderItemModel item(String productId, String size, String color, int qty) {
      final p = byId[productId]!;
      final price = p.discountedPriceIdr;
      return OrderItemModel(
        productId: p.id,
        productName: p.name,
        pricePerUnitIdr: price,
        size: size,
        color: color,
        quantity: qty,
        subtotalIdr: price * qty,
      );
    }

    return [
      _order(
        seq: 1,
        daysAgo: 1,
        status: OrderStatus.placed,
        payment: 'COD',
        addressId: AddressSeed.homeId,
        items: [
          item('prod_tshirt_black_01', 'M', 'black', 2),
          item('prod_accessories_black_01', 'One Size', 'black', 1),
        ],
      ),
      _order(
        seq: 2,
        daysAgo: 3,
        status: OrderStatus.preparing,
        payment: 'Bank Transfer',
        addressId: AddressSeed.homeId,
        items: [
          item('prod_hoodie_white_02', 'L', 'white', 1),
          item('prod_pants_navy_03', 'M', 'navy', 1),
          item('prod_tshirt_navy_03', 'M', 'navy', 3),
        ],
      ),
      _order(
        seq: 3,
        daysAgo: 7,
        status: OrderStatus.shipped,
        payment: 'GoPay',
        addressId: AddressSeed.officeId,
        items: [
          item('prod_shoes_black_01', '42', 'black', 1),
          item('prod_bags_white_02', 'One Size', 'white', 1),
        ],
      ),
      _order(
        seq: 4,
        daysAgo: 20,
        status: OrderStatus.delivered,
        payment: 'COD',
        addressId: AddressSeed.homeId,
        items: [
          item('prod_tshirt_white_02', 'S', 'white', 1),
          item('prod_hoodie_black_01', 'M', 'black', 1),
          item('prod_accessories_navy_03', 'One Size', 'navy', 2),
          item('prod_pants_gray_04', 'L', 'gray', 1),
        ],
      ),
      _order(
        seq: 5,
        daysAgo: 40,
        status: OrderStatus.delivered,
        payment: 'Bank Transfer',
        addressId: AddressSeed.officeId,
        items: [
          item('prod_shoes_navy_03', '41', 'navy', 1),
        ],
      ),
    ];
  }

  static OrderModel _order({
    required int seq,
    required int daysAgo,
    required OrderStatus status,
    required String payment,
    required String addressId,
    required List<OrderItemModel> items,
  }) {
    final placedAt = seedReferenceDate.subtract(Duration(days: daysAgo));
    final subtotal = items.fold<int>(0, (sum, it) => sum + it.subtotalIdr);
    final deliveryFee = subtotal >= _freeShippingThreshold ? 0 : _deliveryFee;
    const discount = 0;
    final total = subtotal + deliveryFee - discount;
    final seqStr = seq.toString().padLeft(5, '0');

    return OrderModel(
      id: 'order_customer_${seq.toString().padLeft(2, '0')}',
      orderNumber: 'ORD-${_ymd(placedAt)}-$seqStr',
      userId: UserSeed.customerId,
      addressId: addressId,
      subtotalIdr: subtotal,
      deliveryFeeIdr: deliveryFee,
      discountIdr: discount,
      totalIdr: total,
      status: status,
      paymentMethod: payment,
      placedAtMs: placedAt.millisecondsSinceEpoch,
      estimatedDeliveryMs: placedAt
          .add(const Duration(days: 3))
          .millisecondsSinceEpoch,
      items: items,
    );
  }

  static String _ymd(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}$m$day';
  }
}
