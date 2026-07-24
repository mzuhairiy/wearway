import 'package:hive_ce/hive_ce.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/models/order_status.dart';

/// Akses data order. List terurut terbaru dulu (placedAt DESC).
class OrderRepository {
  const OrderRepository(this._box);

  final Box<OrderModel> _box;

  Future<List<OrderModel>> list(String userId) async {
    final orders = _box.values.where((o) => o.userId == userId).toList()
      ..sort((a, b) => b.placedAtMs.compareTo(a.placedAtMs));
    return orders;
  }

  Future<OrderModel?> getById(String id) async => _box.get(id);

  Future<void> create(OrderModel order) async {
    await _box.put(order.id, order);
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    final order = _box.get(orderId);
    if (order == null) return;
    await _box.put(orderId, order.copyWith(status: status));
  }

  /// Stream reaktif satu order (dipakai status timeline di Prompt 7).
  Stream<OrderModel?> watchById(String orderId) async* {
    yield _box.get(orderId);
    yield* _box.watch(key: orderId).map((_) => _box.get(orderId));
  }

  Stream<List<OrderModel>> watch(String userId) async* {
    yield await list(userId);
    yield* _box.watch().asyncMap((_) => list(userId));
  }
}
