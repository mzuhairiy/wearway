import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:wearway_flutter/data/hive_boxes.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/data/models/cart_item_model.dart';
import 'package:wearway_flutter/data/models/category_model.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/data/seed/seed_manager.dart';
import 'package:wearway_flutter/hive_registrar.g.dart';

void main() {
  late Directory tempDir;

  setUpAll(() {
    // Adapter global — daftar sekali per isolate test.
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapters();
    }
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('wearway_seed_test');
    Hive.init(tempDir.path);
    await Future.wait([
      Hive.openBox<ProductModel>(HiveBoxes.products),
      Hive.openBox<CategoryModel>(HiveBoxes.categories),
      Hive.openBox<UserModel>(HiveBoxes.users),
      Hive.openBox<AddressModel>(HiveBoxes.addresses),
      Hive.openBox<CartItemModel>(HiveBoxes.cartItems),
      Hive.openBox<OrderModel>(HiveBoxes.orders),
      Hive.openBox<dynamic>(HiveBoxes.settings),
      Hive.openBox<dynamic>(HiveBoxes.meta),
    ]);
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  SeedManager buildManager() {
    return SeedManager(
      products: Hive.box<ProductModel>(HiveBoxes.products),
      categories: Hive.box<CategoryModel>(HiveBoxes.categories),
      users: Hive.box<UserModel>(HiveBoxes.users),
      addresses: Hive.box<AddressModel>(HiveBoxes.addresses),
      orders: Hive.box<OrderModel>(HiveBoxes.orders),
      cartItems: Hive.box<CartItemModel>(HiveBoxes.cartItems),
      meta: Hive.box<dynamic>(HiveBoxes.meta),
      settings: Hive.box<dynamic>(HiveBoxes.settings),
    );
  }

  test('initSeed mengisi jumlah data sesuai spec', () async {
    final result = await buildManager().initSeed();
    expect(result.didSeed, isTrue);
    expect(result.products, 60);
    expect(result.categories, 6);
    expect(result.users, 2);
    expect(result.addresses, 2);
    expect(result.orders, 5);
  });

  test(
    'initSeed idempotent (panggil 2x → tidak duplikat, versi skip)',
    () async {
      final manager = buildManager();
      await manager.initSeed();
      final second = await manager.initSeed();

      expect(second.didSeed, isFalse); // versi sudah cocok → skip.
      expect(Hive.box<ProductModel>(HiveBoxes.products).length, 60);
      expect(Hive.box<OrderModel>(HiveBoxes.orders).length, 5);
    },
  );

  test('resetSeed mengosongkan cart + re-seed katalog', () async {
    final manager = buildManager();
    await manager.initSeed();

    final cart = Hive.box<CartItemModel>(HiveBoxes.cartItems);
    await cart.put(
      'c1',
      const CartItemModel(
        id: 'c1',
        productId: 'prod_tshirt_black_01',
        selectedSize: 'M',
        selectedColor: 'black',
        quantity: 1,
        addedAtMs: 0,
      ),
    );
    expect(cart.length, 1);

    final result = await manager.resetSeed();
    expect(result.products, 60);
    expect(cart.length, 0); // cart dibersihkan saat reset.
  });

  test('seed deterministic: order pertama punya orderNumber stabil', () async {
    await buildManager().initSeed();
    final order = Hive.box<OrderModel>(
      HiveBoxes.orders,
    ).get('order_customer_01');
    expect(order, isNotNull);
    expect(order!.orderNumber, startsWith('ORD-'));
    // customer utama punya 5 order.
    final mine = Hive.box<OrderModel>(
      HiveBoxes.orders,
    ).values.where((o) => o.userId == 'user_customer_01');
    expect(mine.length, 5);
  });
}
