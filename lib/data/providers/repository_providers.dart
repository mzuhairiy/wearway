import 'package:hive_ce/hive_ce.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/hive_boxes.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/data/models/cart_item_model.dart';
import 'package:wearway_flutter/data/models/category_model.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/data/repositories/address_repository.dart';
import 'package:wearway_flutter/data/repositories/cart_repository.dart';
import 'package:wearway_flutter/data/repositories/category_repository.dart';
import 'package:wearway_flutter/data/repositories/order_repository.dart';
import 'package:wearway_flutter/data/repositories/product_repository.dart';
import 'package:wearway_flutter/data/repositories/settings_repository.dart';
import 'package:wearway_flutter/data/repositories/user_repository.dart';

part 'repository_providers.g.dart';

// Repository provider = keepAlive (satu instance lintas app,
// wrap box singleton).

@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) =>
    ProductRepository(Hive.box<ProductModel>(HiveBoxes.products));

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) =>
    CategoryRepository(Hive.box<CategoryModel>(HiveBoxes.categories));

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) => UserRepository(
  usersBox: Hive.box<UserModel>(HiveBoxes.users),
  metaBox: Hive.box<dynamic>(HiveBoxes.meta),
);

@Riverpod(keepAlive: true)
AddressRepository addressRepository(Ref ref) =>
    AddressRepository(Hive.box<AddressModel>(HiveBoxes.addresses));

@Riverpod(keepAlive: true)
CartRepository cartRepository(Ref ref) =>
    CartRepository(Hive.box<CartItemModel>(HiveBoxes.cartItems));

@Riverpod(keepAlive: true)
OrderRepository orderRepository(Ref ref) =>
    OrderRepository(Hive.box<OrderModel>(HiveBoxes.orders));

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepository(Hive.box<dynamic>(HiveBoxes.settings));
