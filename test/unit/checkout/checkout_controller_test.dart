import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/data/models/cart_item_model.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/models/order_status.dart';
import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';
import 'package:wearway_flutter/data/repositories/address_repository.dart';
import 'package:wearway_flutter/data/repositories/cart_repository.dart';
import 'package:wearway_flutter/data/repositories/order_repository.dart';
import 'package:wearway_flutter/features/address/providers/address_providers.dart';
import 'package:wearway_flutter/features/cart/providers/cart_providers.dart';
import 'package:wearway_flutter/features/checkout/providers/checkout_controller.dart';

class _MockOrderRepo extends Mock implements OrderRepository {}

class _MockAddressRepo extends Mock implements AddressRepository {}

class _MockCartRepo extends Mock implements CartRepository {}

ProductModel _product() => const ProductModel(
  id: 'p1',
  slug: 'p1',
  name: 'Classic Tee',
  description: '',
  priceIdr: 100000,
  stock: 10,
  imageUrls: [],
  categoryId: 'c1',
  sizes: ['M'],
  colors: ['black'],
  isFeatured: false,
  rating: 4.5,
  reviewCount: 10,
  badges: [],
  createdAtMs: 0,
);

CartLine _line({int qty = 2}) => CartLine(
  item: CartItemModel(
    id: 'ci1',
    productId: 'p1',
    selectedSize: 'M',
    selectedColor: 'black',
    quantity: qty,
    addedAtMs: 0,
  ),
  product: _product(),
);

CartSummary _cartSummary({int subtotal = 200000, int discount = 0}) =>
    CartSummary(
      subtotalIdr: subtotal,
      discountIdr: discount,
      deliveryFeeIdr: 15000,
      totalIdr: subtotal + 15000 - discount,
      freeShipping: false,
    );

/// Container hanya untuk uji ringkasan/navigasi (tanpa repo).
ProviderContainer _summaryContainer({int subtotal = 200000, int discount = 0}) {
  final container = ProviderContainer(
    overrides: [
      cartSubtotalProvider.overrideWithValue(subtotal),
      cartSummaryProvider.overrideWithValue(
        _cartSummary(subtotal: subtotal, discount: discount),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const AddressModel(
        id: 'f',
        userId: 'u1',
        label: '',
        recipientName: '',
        phone: '',
        streetAddress: '',
        city: '',
        postalCode: '',
        isDefault: false,
      ),
    );
    registerFallbackValue(
      const OrderModel(
        id: 'f',
        orderNumber: 'f',
        userId: 'u1',
        addressId: 'a1',
        subtotalIdr: 0,
        deliveryFeeIdr: 0,
        discountIdr: 0,
        totalIdr: 0,
        status: OrderStatus.placed,
        paymentMethod: 'COD',
        placedAtMs: 0,
        estimatedDeliveryMs: 0,
        items: [],
      ),
    );
  });

  group('checkoutSummary', () {
    test('default Regular saat subtotal <= 300rb → ongkir 15rb', () {
      final c = _summaryContainer();
      final s = c.read(checkoutSummaryProvider);
      expect(s.deliveryFeeIdr, 15000);
      expect(s.totalIdr, 215000);
    });

    test('pilih Express → ongkir 35rb, total ikut naik', () {
      final c = _summaryContainer();
      c.read(checkoutControllerProvider.notifier).selectDelivery('express');
      final s = c.read(checkoutSummaryProvider);
      expect(s.deliveryFeeIdr, 35000);
      expect(s.totalIdr, 235000);
    });

    test('subtotal > 300rb → default Gratis Ongkir', () {
      final c = _summaryContainer(subtotal: 400000);
      final s = c.read(checkoutSummaryProvider);
      expect(s.deliveryFeeIdr, 0);
      expect(c.read(checkoutControllerProvider).deliveryId, 'free');
    });

    test('diskon promo dikurangkan dari total', () {
      final c = _summaryContainer(discount: 20000);
      final s = c.read(checkoutSummaryProvider);
      expect(s.discountIdr, 20000);
      expect(s.totalIdr, 195000); // 200000 + 15000 - 20000
    });
  });

  group('navigasi & validasi step', () {
    test('next/back di-clamp 0..3', () {
      final c = _summaryContainer(subtotal: 100000);
      final n = c.read(checkoutControllerProvider.notifier)
        ..back(); // tidak boleh < 0
      expect(c.read(checkoutControllerProvider).step, 0);
      n
        ..next()
        ..next()
        ..next()
        ..next(); // tidak boleh > 3
      expect(c.read(checkoutControllerProvider).step, 3);
    });

    test('addressValid: manual butuh semua field, saved otomatis valid', () {
      final c = _summaryContainer(subtotal: 100000);
      final n = c.read(checkoutControllerProvider.notifier);
      expect(c.read(checkoutControllerProvider).addressValid, isFalse);
      n.setAddressFields(
        recipientName: 'A',
        phone: '0812',
        street: 'Jl',
        city: 'Jkt',
        postalCode: '12345',
      );
      expect(c.read(checkoutControllerProvider).addressValid, isTrue);
      n.selectSavedAddress('addr_1');
      expect(c.read(checkoutControllerProvider).addressValid, isTrue);
    });
  });

  group('placeOrder', () {
    late _MockOrderRepo orderRepo;
    late _MockAddressRepo addressRepo;
    late _MockCartRepo cartRepo;

    setUp(() {
      orderRepo = _MockOrderRepo();
      addressRepo = _MockAddressRepo();
      cartRepo = _MockCartRepo();
      when(() => orderRepo.list(any())).thenAnswer((_) async => []);
      when(() => orderRepo.create(any())).thenAnswer((_) async {});
      when(() => addressRepo.create(any())).thenAnswer((_) async {});
      when(() => cartRepo.clear(any())).thenAnswer((_) async {});
    });

    test('buat order dengan total sesuai summary + clear cart', () async {
      final c = ProviderContainer(
        overrides: [
          cartSubtotalProvider.overrideWithValue(200000),
          cartSummaryProvider.overrideWithValue(_cartSummary()),
          currentUserIdProvider.overrideWithValue('u1'),
          currentCartUserIdProvider.overrideWithValue('u1'),
          cartLinesProvider.overrideWithValue([_line()]),
          orderRepositoryProvider.overrideWithValue(orderRepo),
          addressRepositoryProvider.overrideWithValue(addressRepo),
          cartRepositoryProvider.overrideWithValue(cartRepo),
        ],
      );
      addTearDown(c.dispose);

      final notifier = c.read(checkoutControllerProvider.notifier)
        ..setAddressFields(
          recipientName: 'A',
          phone: '0812',
          street: 'Jl',
          city: 'Jkt',
          postalCode: '12345',
        );

      final orderId = await notifier.placeOrder();
      expect(orderId, isNotNull);

      final order =
          verify(() => orderRepo.create(captureAny())).captured.single
              as OrderModel;
      expect(order.status, OrderStatus.placed);
      expect(order.items, hasLength(1));
      expect(order.totalIdr, 215000); // 200000 + 15000 ongkir
      // Alamat manual dipersist supaya order bisa mereferensi.
      verify(() => addressRepo.create(any())).called(1);
      // Cart dibersihkan setelah order.
      verify(() => cartRepo.clear('u1')).called(1);
    });

    test('cart kosong → tidak buat order', () async {
      final c = ProviderContainer(
        overrides: [
          cartSubtotalProvider.overrideWithValue(0),
          cartSummaryProvider.overrideWithValue(_cartSummary(subtotal: 0)),
          currentUserIdProvider.overrideWithValue('u1'),
          cartLinesProvider.overrideWithValue(const []),
          orderRepositoryProvider.overrideWithValue(orderRepo),
        ],
      );
      addTearDown(c.dispose);
      final orderId = await c
          .read(checkoutControllerProvider.notifier)
          .placeOrder();
      expect(orderId, isNull);
      verifyNever(() => orderRepo.create(any()));
    });
  });
}
