import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/models/order_status.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';
import 'package:wearway_flutter/data/repositories/order_repository.dart';
import 'package:wearway_flutter/notifications/notification_service.dart';

part 'order_status_scheduler.g.dart';

/// Menjadwalkan simulasi progres status order (Placed → … → Delivered)
/// pakai Timer. Tiap tahap: update status di Hive + tampilkan notifikasi.
class OrderStatusScheduler {
  // Named param privat tidak bisa jadi initializing formal (`this._orders`) →
  // assign manual (lint prefer_initializing_formals di-ignore untuk ini).
  // ignore_for_file: prefer_initializing_formals
  OrderStatusScheduler({
    required OrderRepository orders,
    required NotificationService notifications,
    this.stepInterval = const Duration(seconds: 30),
  }) : _orders = orders,
       _notifications = notifications;

  final OrderRepository _orders;
  final NotificationService _notifications;

  /// Jeda antar tahap (30s default; dev menu Prompt 8 bisa percepat).
  final Duration stepInterval;

  /// Timer aktif per order → bisa dibatalkan (mis. order di-cancel).
  final Map<String, List<Timer>> _timers = {};

  /// Tahap simulasi berurutan (placed sudah tercatat saat order dibuat).
  static const List<OrderStatus> _steps = [
    OrderStatus.preparing,
    OrderStatus.shipped,
    OrderStatus.delivered,
  ];

  /// Jadwalkan update untuk [orderId]. Idempotent — jadwal lama dibatalkan.
  /// orderNumber diambil dari order saat tiap tahap dieksekusi.
  void scheduleOrderStatusUpdates(String orderId) {
    cancel(orderId);
    final timers = <Timer>[];
    for (var i = 0; i < _steps.length; i++) {
      final status = _steps[i];
      final delay = stepInterval * (i + 1); // 30s, 60s, 90s
      timers.add(Timer(delay, () => unawaited(_advance(orderId, status))));
    }
    _timers[orderId] = timers;
  }

  Future<void> _advance(String orderId, OrderStatus status) async {
    // Order sudah tidak ada / dibatalkan → jangan lanjutkan.
    final current = await _orders.getById(orderId);
    if (current == null || current.status == OrderStatus.cancelled) {
      cancel(orderId);
      return;
    }
    await _orders.updateStatus(orderId, status);
    await _notifications.showOrderStatusNotification(
      orderNumber: current.orderNumber,
      status: status,
      orderId: orderId,
    );
  }

  /// Batalkan semua timer untuk satu order.
  void cancel(String orderId) {
    final timers = _timers.remove(orderId);
    if (timers == null) return;
    for (final t in timers) {
      t.cancel();
    }
  }

  /// Batalkan semua (dev menu: clear notifications / reset data).
  void cancelAll() {
    for (final timers in _timers.values) {
      for (final t in timers) {
        t.cancel();
      }
    }
    _timers.clear();
  }
}

/// Provider scheduler (keepAlive → timer bertahan lintas rebuild widget).
/// Interval 5s kalau dev "speed up" aktif, else 30s. Setelah toggle speed-up,
/// dev menu meng-`invalidate` provider ini supaya order berikut pakai interval
/// baru (timer order yang sudah berjalan tidak terpengaruh).
@Riverpod(keepAlive: true)
OrderStatusScheduler orderStatusScheduler(Ref ref) {
  final speedUp = ref.watch(settingsRepositoryProvider).getSpeedUpOrders();
  return OrderStatusScheduler(
    orders: ref.watch(orderRepositoryProvider),
    notifications: ref.watch(notificationServiceProvider),
    stepInterval: Duration(seconds: speedUp ? 5 : 30),
  );
}
