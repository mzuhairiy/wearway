import 'package:hive_ce/hive_ce.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/hive_boxes.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/data/models/cart_item_model.dart';
import 'package:wearway_flutter/data/models/category_model.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/data/seed/seed_manager.dart';

part 'dev_providers.g.dart';

/// Kredensial seed untuk fitur dev "skip login" (auto-login).
/// Data demo publik (lihat CLAUDE.md) — dipakai HANYA di jalur dev.
const String kDevEmail = 'customer@example.com';
const String kDevPassword = 'Customer123!';

/// SeedManager sebagai provider (dipakai dev menu "Reset all data").
/// Membangun dari box yang sudah dibuka di main().
@Riverpod(keepAlive: true)
SeedManager seedManager(Ref ref) => SeedManager(
  products: Hive.box<ProductModel>(HiveBoxes.products),
  categories: Hive.box<CategoryModel>(HiveBoxes.categories),
  users: Hive.box<UserModel>(HiveBoxes.users),
  addresses: Hive.box<AddressModel>(HiveBoxes.addresses),
  orders: Hive.box<OrderModel>(HiveBoxes.orders),
  cartItems: Hive.box<CartItemModel>(HiveBoxes.cartItems),
  meta: Hive.box<dynamic>(HiveBoxes.meta),
  settings: Hive.box<dynamic>(HiveBoxes.settings),
);
