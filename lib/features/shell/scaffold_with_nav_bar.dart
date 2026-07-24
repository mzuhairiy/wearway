import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/features/cart/providers/cart_providers.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Kerangka root dengan bottom navigation Material 3 (NavigationBar).
/// [navigationShell] dari go_router `StatefulShellRoute.indexedStack` —
/// tiap tab punya navigation stack sendiri (state kejaga saat pindah tab).
/// ConsumerWidget → bisa watch cart count untuk badge.
class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    // initialLocation:true saat re-tap tab aktif → reset ke root tab tsb.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      key: const ValueKey(TestKeys.appShell),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        key: const ValueKey(TestKeys.bottomNavBar),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: [
          const NavigationDestination(
            key: ValueKey(TestKeys.navHome),
            icon: Icon(LucideIcons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            key: ValueKey(TestKeys.navCategories),
            icon: Icon(LucideIcons.layoutGrid),
            label: 'Categories',
          ),
          NavigationDestination(
            key: const ValueKey(TestKeys.navCart),
            icon: Badge(
              key: const ValueKey(TestKeys.cartBadge),
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(LucideIcons.shoppingBag),
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
            key: ValueKey(TestKeys.navProfile),
            icon: Icon(LucideIcons.user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
