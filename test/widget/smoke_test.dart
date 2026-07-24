// Smoke test tambahan (Prompt 8): navigasi tab + entry point login (guest).
// Pre-Appium sanity — tanpa Hive (auth di-fake, notif no-op).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wearway_flutter/app.dart';
import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/features/auth/providers/auth_controller.dart';
import 'package:wearway_flutter/notifications/notification_service.dart';
import 'package:wearway_flutter/shared/providers/theme_provider.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Fake auth: guest (null) tanpa menyentuh Hive.
class _FakeAuthController extends AuthController {
  @override
  Future<UserModel?> build() async => null;
}

/// Fake theme: system, tanpa baca Hive settings.
class _FakeThemeController extends ThemeModeController {
  @override
  ThemeMode build() => ThemeMode.system;
}

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authControllerProvider.overrideWith(_FakeAuthController.new),
        themeModeControllerProvider.overrideWith(_FakeThemeController.new),
        notificationServiceProvider.overrideWithValue(
          createNoopNotificationService(),
        ),
      ],
      child: const WearWayApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  // Catatan: tab Home/Categories butuh data Hive (katalog) → dites di
  // emulator / integration test, bukan di widget smoke ini yang bebas-Hive.
  testWidgets('tab Cart bisa dibuka dari nav', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(const ValueKey(TestKeys.navCart)));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey(TestKeys.cartScreen)), findsOneWidget);
  });

  testWidgets('guest → Profile menampilkan prompt login', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(const ValueKey(TestKeys.navProfile)));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey(TestKeys.loginPromptButton)),
      findsOneWidget,
    );
  });
}
