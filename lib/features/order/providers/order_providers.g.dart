// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Satu order by id, sekali baca (dipakai Order Confirmation).

@ProviderFor(orderById)
final orderByIdProvider = OrderByIdFamily._();

/// Satu order by id, sekali baca (dipakai Order Confirmation).

final class OrderByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrderModel?>,
          OrderModel?,
          FutureOr<OrderModel?>
        >
    with $FutureModifier<OrderModel?>, $FutureProvider<OrderModel?> {
  /// Satu order by id, sekali baca (dipakai Order Confirmation).
  OrderByIdProvider._({
    required OrderByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderByIdHash();

  @override
  String toString() {
    return r'orderByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<OrderModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OrderModel?> create(Ref ref) {
    final argument = this.argument as String;
    return orderById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderByIdHash() => r'24be32c36bfc40e4d1e5f9b17b0fd2c7e56f23ee';

/// Satu order by id, sekali baca (dipakai Order Confirmation).

final class OrderByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<OrderModel?>, String> {
  OrderByIdFamily._()
    : super(
        retry: null,
        name: r'orderByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Satu order by id, sekali baca (dipakai Order Confirmation).

  OrderByIdProvider call(String orderId) =>
      OrderByIdProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderByIdProvider';
}

/// Satu order reaktif (dipakai Order Detail: status timeline update otomatis
/// saat scheduler menulis status baru ke Hive).

@ProviderFor(orderStream)
final orderStreamProvider = OrderStreamFamily._();

/// Satu order reaktif (dipakai Order Detail: status timeline update otomatis
/// saat scheduler menulis status baru ke Hive).

final class OrderStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrderModel?>,
          OrderModel?,
          Stream<OrderModel?>
        >
    with $FutureModifier<OrderModel?>, $StreamProvider<OrderModel?> {
  /// Satu order reaktif (dipakai Order Detail: status timeline update otomatis
  /// saat scheduler menulis status baru ke Hive).
  OrderStreamProvider._({
    required OrderStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderStreamHash();

  @override
  String toString() {
    return r'orderStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<OrderModel?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<OrderModel?> create(Ref ref) {
    final argument = this.argument as String;
    return orderStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderStreamHash() => r'f0fa87b238d2d8ef01e11a1174ff5afa387279b7';

/// Satu order reaktif (dipakai Order Detail: status timeline update otomatis
/// saat scheduler menulis status baru ke Hive).

final class OrderStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<OrderModel?>, String> {
  OrderStreamFamily._()
    : super(
        retry: null,
        name: r'orderStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Satu order reaktif (dipakai Order Detail: status timeline update otomatis
  /// saat scheduler menulis status baru ke Hive).

  OrderStreamProvider call(String orderId) =>
      OrderStreamProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderStreamProvider';
}

/// Alamat by id (ringkasan alamat di Order Detail).

@ProviderFor(addressById)
final addressByIdProvider = AddressByIdFamily._();

/// Alamat by id (ringkasan alamat di Order Detail).

final class AddressByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<AddressModel?>,
          AddressModel?,
          FutureOr<AddressModel?>
        >
    with $FutureModifier<AddressModel?>, $FutureProvider<AddressModel?> {
  /// Alamat by id (ringkasan alamat di Order Detail).
  AddressByIdProvider._({
    required AddressByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'addressByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addressByIdHash();

  @override
  String toString() {
    return r'addressByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AddressModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AddressModel?> create(Ref ref) {
    final argument = this.argument as String;
    return addressById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AddressByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addressByIdHash() => r'2444e78c351b48ec3b137c9ede3646336462bcde';

/// Alamat by id (ringkasan alamat di Order Detail).

final class AddressByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AddressModel?>, String> {
  AddressByIdFamily._()
    : super(
        retry: null,
        name: r'addressByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Alamat by id (ringkasan alamat di Order Detail).

  AddressByIdProvider call(String addressId) =>
      AddressByIdProvider._(argument: addressId, from: this);

  @override
  String toString() => r'addressByIdProvider';
}

/// Riwayat pesanan user aktif, reaktif, terurut terbaru dulu.

@ProviderFor(orderHistory)
final orderHistoryProvider = OrderHistoryProvider._();

/// Riwayat pesanan user aktif, reaktif, terurut terbaru dulu.

final class OrderHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderModel>>,
          List<OrderModel>,
          Stream<List<OrderModel>>
        >
    with $FutureModifier<List<OrderModel>>, $StreamProvider<List<OrderModel>> {
  /// Riwayat pesanan user aktif, reaktif, terurut terbaru dulu.
  OrderHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<OrderModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<OrderModel>> create(Ref ref) {
    return orderHistory(ref);
  }
}

String _$orderHistoryHash() => r'd8a8592290190ae264413364478649ddecfd146d';
