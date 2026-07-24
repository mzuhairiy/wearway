import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wearway_flutter/data/models/order_item_model.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/models/order_status.dart';
import 'package:wearway_flutter/data/repositories/order_repository.dart';
import 'package:wearway_flutter/notifications/notification_service.dart';
import 'package:wearway_flutter/notifications/order_status_scheduler.dart';

class _MockOrderRepository extends Mock implements OrderRepository {}

class _MockNotificationService extends Mock implements NotificationService {}

OrderModel _order(OrderStatus status) => OrderModel(
  id: 'order_1',
  orderNumber: 'ORD-20260720-00001',
  userId: 'user_1',
  addressId: 'addr_1',
  subtotalIdr: 100000,
  deliveryFeeIdr: 15000,
  discountIdr: 0,
  totalIdr: 115000,
  status: status,
  paymentMethod: 'COD',
  placedAtMs: 0,
  estimatedDeliveryMs: 0,
  items: const <OrderItemModel>[],
);

void main() {
  setUpAll(() {
    registerFallbackValue(OrderStatus.placed);
  });

  late _MockOrderRepository orders;
  late _MockNotificationService notifications;
  late OrderStatusScheduler scheduler;

  setUp(() {
    orders = _MockOrderRepository();
    notifications = _MockNotificationService();
    scheduler = OrderStatusScheduler(
      orders: orders,
      notifications: notifications,
    );

    when(() => orders.getById(any())).thenAnswer(
      (_) async => _order(OrderStatus.placed),
    );
    when(() => orders.updateStatus(any(), any())).thenAnswer((_) async {});
    when(
      () => notifications.showOrderStatusNotification(
        orderNumber: any(named: 'orderNumber'),
        status: any(named: 'status'),
        orderId: any(named: 'orderId'),
      ),
    ).thenAnswer((_) async {});
  });

  test('menjadwalkan 3 tahap di 30/60/90 detik', () {
    fakeAsync((async) {
      scheduler.scheduleOrderStatusUpdates('order_1');

      // Sebelum 30s: belum ada update.
      async
        ..elapse(const Duration(seconds: 29))
        ..flushMicrotasks();
      verifyNever(() => orders.updateStatus(any(), any()));

      // 30s → preparing.
      async
        ..elapse(const Duration(seconds: 1))
        ..flushMicrotasks();
      verify(
        () => orders.updateStatus('order_1', OrderStatus.preparing),
      ).called(1);

      // 60s → shipped.
      async
        ..elapse(const Duration(seconds: 30))
        ..flushMicrotasks();
      verify(
        () => orders.updateStatus('order_1', OrderStatus.shipped),
      ).called(1);

      // 90s → delivered.
      async
        ..elapse(const Duration(seconds: 30))
        ..flushMicrotasks();
      verify(
        () => orders.updateStatus('order_1', OrderStatus.delivered),
      ).called(1);

      // 3 notifikasi total.
      verify(
        () => notifications.showOrderStatusNotification(
          orderNumber: any(named: 'orderNumber'),
          status: any(named: 'status'),
          orderId: 'order_1',
        ),
      ).called(3);
    });
  });

  test('cancel menghentikan tahap berikutnya', () {
    fakeAsync((async) {
      scheduler
        ..scheduleOrderStatusUpdates('order_1')
        ..cancel('order_1');

      async
        ..elapse(const Duration(seconds: 120))
        ..flushMicrotasks();
      verifyNever(() => orders.updateStatus(any(), any()));
    });
  });

  test('order dibatalkan → tidak lanjut update', () {
    when(
      () => orders.getById(any()),
    ).thenAnswer((_) async => _order(OrderStatus.cancelled));

    fakeAsync((async) {
      scheduler.scheduleOrderStatusUpdates('order_1');
      async
        ..elapse(const Duration(seconds: 30))
        ..flushMicrotasks();
      // getById mengembalikan cancelled → skip updateStatus + notifikasi.
      verifyNever(() => orders.updateStatus(any(), any()));
      verifyNever(
        () => notifications.showOrderStatusNotification(
          orderNumber: any(named: 'orderNumber'),
          status: any(named: 'status'),
          orderId: any(named: 'orderId'),
        ),
      );
    });
  });
}
