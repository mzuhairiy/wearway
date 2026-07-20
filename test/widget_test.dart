// Smoke test WearWay shell: bottom nav tampil & tab bisa dipindah.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wearway_flutter/app.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

void main() {
  testWidgets('renders 4-tab bottom nav and switches tabs', (tester) async {
    // ProviderScope wajib membungkus app yang pakai Riverpod.
    await tester.pumpWidget(const ProviderScope(child: WearWayApp()));
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
