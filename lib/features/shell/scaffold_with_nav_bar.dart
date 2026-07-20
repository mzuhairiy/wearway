import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Kerangka root dengan bottom navigation Material 3 (NavigationBar).
/// [navigationShell] dari go_router `StatefulShellRoute.indexedStack` —
/// tiap tab punya navigation stack sendiri (state kejaga saat pindah tab).
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = <_NavDestination>[
    _NavDestination(
      key: TestKeys.navHome,
      icon: LucideIcons.home,
      label: 'Home',
    ),
    _NavDestination(
      key: TestKeys.navCategories,
      icon: LucideIcons.layoutGrid,
      label: 'Categories',
    ),
    _NavDestination(
      key: TestKeys.navCart,
      icon: LucideIcons.shoppingBag,
      label: 'Cart',
    ),
    _NavDestination(
      key: TestKeys.navProfile,
      icon: LucideIcons.user,
      label: 'Profile',
    ),
  ];

  void _onTap(int index) {
    // initialLocation:true saat re-tap tab aktif → reset ke root tab tsb.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey(TestKeys.appShell),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        key: const ValueKey(TestKeys.bottomNavBar),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
              key: ValueKey(d.key),
              icon: Icon(d.icon),
              label: d.label,
            ),
        ],
      ),
    );
  }
}

/// Value object internal untuk definisi tiap tab.
class _NavDestination {
  const _NavDestination({
    required this.key,
    required this.icon,
    required this.label,
  });

  final String key;
  final IconData icon;
  final String label;
}
