import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:toastr_flutter/toastr_flutter.dart';
import 'package:wearway_flutter/app.dart';
import 'package:wearway_flutter/data/hive_boxes.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/data/models/cart_item_model.dart';
import 'package:wearway_flutter/data/models/category_model.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/data/seed/seed_manager.dart';
import 'package:wearway_flutter/hive_registrar.g.dart';
import 'package:wearway_flutter/notifications/notification_service.dart';

Future<void> main() async {
  // Wajib sebelum panggil plugin/async di main (init binding Flutter).
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Registrasi semua TypeAdapter dalam satu panggilan (hive_ce registrar).
  Hive.registerAdapters();

  // Box bertipe model + box primitif (settings/meta) dibuka saat startup.
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

  // Seed deterministic (idempotent — hanya jalan kalau versi beda).
  final seedResult = await _buildSeedManager().initSeed();
  debugPrint('[WearWay seed] $seedResult');

  // Toast global: posisi atas (bukan bawah) untuk semua notifikasi in-app.
  Toastr.configure(position: ToastrPosition.topCenter);

  // Local notification: init plugin + channel + tap handler sebelum runApp.
  final notificationService = NotificationService(
    FlutterLocalNotificationsPlugin(),
  );
  await notificationService.init();

  // Tutup Hive saat app benar-benar dimatikan (rule: JANGAN skip Hive.close()).
  WidgetsBinding.instance.addObserver(_HiveLifecycleObserver());

  // ProviderScope = root wajib Riverpod (menyimpan semua provider state).
  // Override notificationService dengan instance ter-init dari main.
  runApp(
    ProviderScope(
      overrides: [
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const WearWayApp(),
    ),
  );
}

SeedManager _buildSeedManager() {
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

/// Observer lifecycle tanpa StatefulWidget — tutup Hive saat proses detached.
class _HiveLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      unawaited(Hive.close());
    }
  }
}
