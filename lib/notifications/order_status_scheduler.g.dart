// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_scheduler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider scheduler (keepAlive → timer bertahan lintas rebuild widget).
/// Interval 5s kalau dev "speed up" aktif, else 30s. Setelah toggle speed-up,
/// dev menu meng-`invalidate` provider ini supaya order berikut pakai interval
/// baru (timer order yang sudah berjalan tidak terpengaruh).

@ProviderFor(orderStatusScheduler)
final orderStatusSchedulerProvider = OrderStatusSchedulerProvider._();

/// Provider scheduler (keepAlive → timer bertahan lintas rebuild widget).
/// Interval 5s kalau dev "speed up" aktif, else 30s. Setelah toggle speed-up,
/// dev menu meng-`invalidate` provider ini supaya order berikut pakai interval
/// baru (timer order yang sudah berjalan tidak terpengaruh).

final class OrderStatusSchedulerProvider
    extends
        $FunctionalProvider<
          OrderStatusScheduler,
          OrderStatusScheduler,
          OrderStatusScheduler
        >
    with $Provider<OrderStatusScheduler> {
  /// Provider scheduler (keepAlive → timer bertahan lintas rebuild widget).
  /// Interval 5s kalau dev "speed up" aktif, else 30s. Setelah toggle speed-up,
  /// dev menu meng-`invalidate` provider ini supaya order berikut pakai interval
  /// baru (timer order yang sudah berjalan tidak terpengaruh).
  OrderStatusSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderStatusSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderStatusSchedulerHash();

  @$internal
  @override
  $ProviderElement<OrderStatusScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OrderStatusScheduler create(Ref ref) {
    return orderStatusScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderStatusScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderStatusScheduler>(value),
    );
  }
}

String _$orderStatusSchedulerHash() =>
    r'fed289d9724971c872decbcb9c48942320b7b479';
