import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastr_flutter/toastr_flutter.dart';
import 'package:wearway_flutter/core/router/app_router.dart';
import 'package:wearway_flutter/core/theme/app_colors.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/core/theme/app_theme.dart';
import 'package:wearway_flutter/features/auth/providers/auth_controller.dart';
import 'package:wearway_flutter/notifications/notification_service.dart';
import 'package:wearway_flutter/shared/providers/theme_provider.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Root aplikasi. ConsumerWidget = StatelessWidget yang bisa `ref.watch`
/// provider Riverpod (tanpa perlu StatefulWidget).
class WearWayApp extends ConsumerWidget {
  const WearWayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Extract provider ke variable (jangan watch berulang di build).
    final themeMode = ref.watch(themeModeControllerProvider);

    // Splash hanya saat restore session pertama (appBootstrap sekali jalan).
    // login/logout berikutnya tidak menyentuh provider ini → tak ada splash.
    final isRestoring = ref.watch(appBootstrapProvider).isLoading;

    if (isRestoring) {
      return MaterialApp(
        title: 'WearWay',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        home: const _SplashView(),
      );
    }

    // MaterialApp.router = entry point Material + integrasi go_router.
    final router = ref.watch(goRouterProvider);

    // Wire tap notifikasi → deep link ke Order Detail (idempotent).
    ref
        .read(notificationServiceProvider)
        .attachNavigation((orderId) => router.go('/order/$orderId'));

    return MaterialApp.router(
      title: 'WearWay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
      // Overlay untuk toastr_flutter (go_router / nested navigator).
      builder: Toastr.builder,
    );
  }
}

/// Splash saat restore session pertama — logo 3D di tengah, background putih
/// (brand splash, sinkron dgn native splash). Warna brand fixed (bukan tema).
class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // Background putih tetap (brand splash, tak ikut dark mode).
      backgroundColor: Colors.white,
      body: Center(
        key: const ValueKey(TestKeys.splashScreen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WearWayLogo(size: 132),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'WearWay',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppColors.seed,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}

/// Logo WearWay: huruf "W" putih dalam lingkaran hijau timbul (gradient 3D +
/// shadow). [elevated] = efek 3D (splash); false = flat (mis. header).
class WearWayLogo extends StatelessWidget {
  const WearWayLogo({required this.size, this.elevated = true, super.key});

  final double size;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    // Gradient dari seed (atas lebih terang, bawah lebih gelap) = kesan timbul.
    final top = Color.lerp(AppColors.seed, Colors.white, 0.24)!;
    final bottom = Color.lerp(AppColors.seed, Colors.black, 0.26)!;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: elevated
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [top, bottom],
              )
            : null,
        color: elevated ? null : AppColors.seed,
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: AppColors.seed.withValues(alpha: 0.35),
                  blurRadius: size * 0.18,
                  offset: Offset(0, size * 0.08),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          'W',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.5,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ),
    );
  }
}
