import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:wearway_flutter/app.dart';

/// Nama semua Hive box (PROJECT_PLAN section 5). Dibuka saat startup.
const _boxNames = <String>[
  'products',
  'categories',
  'users',
  'addresses',
  'cart_items',
  'orders',
  'settings',
  'meta',
];

Future<void> main() async {
  // Wajib sebelum panggil plugin/async di main (init binding Flutter).
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // TODO(prompt2): register semua TypeAdapter di sini SEBELUM openBox,
  //   contoh: Hive.registerAdapter(ProductModelAdapter());

  // Prompt 1: box dibuka untyped (dynamic) karena model belum ada.
  for (final name in _boxNames) {
    await Hive.openBox<dynamic>(name);
  }

  // TODO(prompt2): panggil SeedManager.initSeed() untuk seed deterministic.

  // Tutup Hive saat app benar-benar dimatikan (rule: JANGAN skip Hive.close()).
  WidgetsBinding.instance.addObserver(_HiveLifecycleObserver());

  // ProviderScope = root wajib Riverpod (menyimpan semua provider state).
  runApp(const ProviderScope(child: WearWayApp()));
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
