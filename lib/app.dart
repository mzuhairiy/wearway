import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wearway_flutter/core/router/app_router.dart';
import 'package:wearway_flutter/core/theme/app_theme.dart';
import 'package:wearway_flutter/shared/providers/theme_provider.dart';

/// Root aplikasi. ConsumerWidget = StatelessWidget yang bisa `ref.watch`
/// provider Riverpod (tanpa perlu StatefulWidget).
class WearWayApp extends ConsumerWidget {
  const WearWayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Extract provider ke variable (jangan watch berulang di build).
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeControllerProvider);

    // MaterialApp.router = entry point Material + integrasi go_router.
    return MaterialApp.router(
      title: 'WearWay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
