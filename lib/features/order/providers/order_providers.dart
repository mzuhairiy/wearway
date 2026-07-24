import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';
import 'package:wearway_flutter/features/address/providers/address_providers.dart';

part 'order_providers.g.dart';

/// Satu order by id, sekali baca (dipakai Order Confirmation).
@riverpod
Future<OrderModel?> orderById(Ref ref, String orderId) {
  return ref.watch(orderRepositoryProvider).getById(orderId);
}

/// Satu order reaktif (dipakai Order Detail: status timeline update otomatis
/// saat scheduler menulis status baru ke Hive).
@riverpod
Stream<OrderModel?> orderStream(Ref ref, String orderId) {
  return ref.watch(orderRepositoryProvider).watchById(orderId);
}

/// Alamat by id (ringkasan alamat di Order Detail).
@riverpod
Future<AddressModel?> addressById(Ref ref, String addressId) {
  return ref.watch(addressRepositoryProvider).getById(addressId);
}

/// Riwayat pesanan user aktif, reaktif, terurut terbaru dulu.
@riverpod
Stream<List<OrderModel>> orderHistory(Ref ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const []);
  return ref.watch(orderRepositoryProvider).watch(userId);
}
