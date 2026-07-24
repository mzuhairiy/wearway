// Smoke test WearWay shell: bottom nav tampil & tab bisa dipindah.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wearway_flutter/app.dart';
import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/features/auth/providers/auth_controller.dart';
import 'package:wearway_flutter/notifications/notification_service.dart';
import 'package:wearway_flutter/shared/providers/theme_provider.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Fake auth: guest (null) tanpa menyentuh Hive → smoke test tak perlu init DB.
class _FakeAuthController extends AuthController {
  @override
  Future<UserModel?> build() async => null;
}

/// Fake theme: system, tanpa baca Hive settings (Prompt 8).
class _FakeThemeController extends ThemeModeController {
  @override
  ThemeMode build() => ThemeMode.system;
}

void main() {
  testWidgets('renders 4-tab bottom nav and switches tabs', (tester) async {
    // ProviderScope wajib membungkus app yang pakai Riverpod.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(_FakeAuthController.new),
          themeModeControllerProvider.overrideWith(_FakeThemeController.new),
          // notificationServiceProvider throw kalau tak di-override → beri
          // instance no-op (smoke test tidak menyentuh notifikasi).
          notificationServiceProvider.overrideWithValue(
            createNoopNotificationService(),
          ),
        ],
        child: const WearWayApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Shell + bottom nav ada.
    expect(find.byKey(const ValueKey(TestKeys.bottomNavBar)), findsOneWidget);
    expect(find.byKey(const ValueKey(TestKeys.homeScreen)), findsOneWidget);

    // Pindah ke tab Cart → body cart muncul.
    await tester.tap(find.byKey(const ValueKey(TestKeys.navCart)));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey(TestKeys.cartScreen)), findsOneWidget);
  });
}
