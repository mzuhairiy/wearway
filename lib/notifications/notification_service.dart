import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/models/order_status.dart';
import 'package:wearway_flutter/features/order/order_status_display.dart';

part 'notification_service.g.dart';

/// Local push notification untuk simulasi status order.
/// Payload = orderId → tap membuka Order Detail (deep link via go_router).
class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  /// Channel Android untuk update order (importance DEFAULT).
  static const String channelId = 'order_updates';
  static const String _channelName = 'Update Pesanan';
  static const String _channelDesc = 'Notifikasi perubahan status pesanan';

  /// Handler navigasi (di-set oleh app setelah router siap).
  void Function(String orderId)? _onSelectOrder;

  /// Tap yang datang sebelum handler siap (mis. cold launch) → disimpan
  /// lalu di-flush saat [attachNavigation].
  String? _pendingOrderId;
  bool _launchFlushed = false;

  /// Init plugin + channel + tap handler. Dipanggil sekali di main().
  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onResponse,
    );

    // Buat channel Android (idempotent).
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelId,
        _channelName,
        description: _channelDesc,
      ),
    );

    // App dibuka dari tap notifikasi (kondisi terminated) → simpan payload.
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      _pendingOrderId = launch!.notificationResponse?.payload;
    }
  }

  void _onResponse(NotificationResponse response) {
    final orderId = response.payload;
    if (orderId == null || orderId.isEmpty) return;
    final handler = _onSelectOrder;
    if (handler != null) {
      handler(orderId);
    } else {
      _pendingOrderId = orderId; // handler belum siap → simpan.
    }
  }

  /// Wire navigasi tap → order detail. Idempotent (aman dipanggil tiap build).
  void attachNavigation(void Function(String orderId) handler) {
    _onSelectOrder = handler;
    final pending = _pendingOrderId;
    if (pending != null && !_launchFlushed) {
      _launchFlushed = true;
      _pendingOrderId = null;
      // Tunda ke luar fase build (navigate-during-build dilarang).
      scheduleMicrotask(() => handler(pending));
    }
  }

  /// Tampilkan notifikasi perubahan status order.
  Future<void> showOrderStatusNotification({
    required String orderNumber,
    required OrderStatus status,
    required String orderId,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      _channelName,
      channelDescription: _channelDesc,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );
    // id notif = index status → notif status yang sama saling menimpa (rapi).
    await _plugin.show(
      id: status.index,
      title: 'Pesanan ${status.label}',
      body: _body(orderNumber, status),
      notificationDetails: details,
      payload: orderId,
    );
  }

  /// Batalkan semua notifikasi yang tampil (dev menu "clear notifications").
  Future<void> cancelAll() => _plugin.cancelAll();

  String _body(String orderNumber, OrderStatus status) => switch (status) {
    OrderStatus.preparing => 'Pesanan $orderNumber sedang disiapkan penjual.',
    OrderStatus.shipped => 'Pesanan $orderNumber dalam perjalanan.',
    OrderStatus.delivered => 'Pesanan $orderNumber telah sampai. Terima kasih!',
    _ => 'Pesanan $orderNumber: ${status.label}.',
  };
}

/// Provider service. Di-override di main() dengan instance ter-init;
/// throw kalau lupa override (fail fast, bukan diam-diam no-op).
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  throw UnimplementedError(
    'notificationServiceProvider harus di-override di main() '
    'dengan instance yang sudah init()',
  );
}

/// Instance untuk lingkungan test/tanpa init (mis. widget test) — no-op aman.
@visibleForTesting
NotificationService createNoopNotificationService() =>
    NotificationService(FlutterLocalNotificationsPlugin());
