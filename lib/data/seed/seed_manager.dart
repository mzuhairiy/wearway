import 'package:hive_ce/hive_ce.dart';
import 'package:wearway_flutter/data/hive_boxes.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/data/models/cart_item_model.dart';
import 'package:wearway_flutter/data/models/category_model.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/data/seed/address_seed.dart';
import 'package:wearway_flutter/data/seed/category_seed.dart';
import 'package:wearway_flutter/data/seed/order_seed.dart';
import 'package:wearway_flutter/data/seed/product_seed.dart';
import 'package:wearway_flutter/data/seed/seed_constants.dart';
import 'package:wearway_flutter/data/seed/user_seed.dart';

// Named param + field privat tidak bisa pakai initializing formal (named param
// dilarang diawali underscore), jadi assign manual di constructor SeedManager.
// ignore_for_file: prefer_initializing_formals

/// Hasil operasi seed (untuk logging & test).
class SeedResult {
  const SeedResult({
    required this.didSeed,
    required this.products,
    required this.categories,
    required this.users,
    required this.addresses,
    required this.orders,
  });

  final bool didSeed;
  final int products;
  final int categories;
  final int users;
  final int addresses;
  final int orders;

  @override
  String toString() {
    final verb = didSeed ? 'Seeded' : 'Seed skipped (up-to-date):';
    return '$verb $products products, $categories categories, '
        '$users users, $orders orders, $addresses addresses';
  }
}

/// Mengelola seed deterministic: idempotent by `seed_version` di box meta.
class SeedManager {
  const SeedManager({
    required Box<ProductModel> products,
    required Box<CategoryModel> categories,
    required Box<UserModel> users,
    required Box<AddressModel> addresses,
    required Box<OrderModel> orders,
    required Box<CartItemModel> cartItems,
    required Box<dynamic> meta,
    required Box<dynamic> settings,
  }) : _products = products,
       _categories = categories,
       _users = users,
       _addresses = addresses,
       _orders = orders,
       _cartItems = cartItems,
       _meta = meta,
       _settings = settings;

  final Box<ProductModel> _products;
  final Box<CategoryModel> _categories;
  final Box<UserModel> _users;
  final Box<AddressModel> _addresses;
  final Box<OrderModel> _orders;
  final Box<CartItemModel> _cartItems;
  final Box<dynamic> _meta;
  final Box<dynamic> _settings;

  /// Seed hanya kalau versi berbeda (idempotent). Aman dipanggil tiap startup.
  Future<SeedResult> initSeed() async {
    final current = _meta.get(MetaKeys.seedVersion) as int?;
    if (current == seedVersion) {
      return _result(didSeed: false);
    }
    await _seedCatalog();
    await _meta.put(MetaKeys.seedVersion, seedVersion);
    return _result(didSeed: true);
  }

  /// Reset penuh (dev menu): hapus SEMUA data + re-seed dari nol.
  Future<SeedResult> resetSeed() async {
    await Future.wait([
      _cartItems.clear(),
      _settings.clear(),
      _meta.clear(),
    ]);
    await _seedCatalog();
    await _meta.put(MetaKeys.seedVersion, seedVersion);
    return _result(didSeed: true);
  }

  /// Tulis ulang katalog + user + alamat + order (clear dulu → idempotent).
  Future<void> _seedCatalog() async {
    await Future.wait([
      _products.clear(),
      _categories.clear(),
      _users.clear(),
      _addresses.clear(),
      _orders.clear(),
    ]);

    await _categories.putAll({for (final c in CategorySeed.all) c.id: c});
    await _products.putAll({for (final p in ProductSeed.all) p.id: p});
    await _users.putAll({for (final u in UserSeed.all) u.id: u});
    await _addresses.putAll({for (final a in AddressSeed.all) a.id: a});
    await _orders.putAll({for (final o in OrderSeed.all) o.id: o});
  }

  SeedResult _result({required bool didSeed}) {
    return SeedResult(
      didSeed: didSeed,
      products: _products.length,
      categories: _categories.length,
      users: _users.length,
      addresses: _addresses.length,
      orders: _orders.length,
    );
  }
}
