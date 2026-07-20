import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/features/cart/cart_screen.dart';
import 'package:wearway_flutter/features/categories/categories_screen.dart';
import 'package:wearway_flutter/features/home/home_screen.dart';
import 'package:wearway_flutter/features/profile/profile_screen.dart';
import 'package:wearway_flutter/features/shell/scaffold_with_nav_bar.dart';
import 'package:wearway_flutter/shared/providers/session_provider.dart';
import 'package:wearway_flutter/shared/widgets/placeholder_screen.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

part 'app_router.g.dart';

// Navigator key root + per-branch → dibutuhkan StatefulShellRoute.
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Route protected: butuh login. Guest yang akses → redirect ke /auth/login.
const _protectedPrefixes = <String>['/checkout', '/order'];

/// go_router sebagai provider (keepAlive: dibuat sekali seumur app).
/// Dibungkus provider supaya redirect bisa baca auth state dari Riverpod.
@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final loggedIn = ref.read(isLoggedInProvider);
      final loc = state.matchedLocation;
      final isProtected = _protectedPrefixes.any(
        (p) => loc == p || loc.startsWith('$p/'),
      );
      if (isProtected && !loggedIn) {
        return '/auth/login?from=$loc';
      }
      return null;
    },
    routes: [
      // Bottom-nav shell: 4 branch, tiap tab punya stack sendiri.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                builder: (context, state) => const CategoriesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Route top-level (di atas shell, full screen). Placeholder Prompt 1.
      GoRoute(
        path: '/search',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PlaceholderScreen(
          title: 'Search',
          icon: LucideIcons.search,
          bodyKey: TestKeys.searchScreen,
        ),
      ),
      GoRoute(
        path: '/product/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => PlaceholderScreen(
          title: 'Product ${state.pathParameters['id']}',
          icon: LucideIcons.shirt,
          bodyKey: TestKeys.productDetailScreen,
        ),
      ),
      GoRoute(
        path: '/checkout',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PlaceholderScreen(
          title: 'Checkout',
          icon: LucideIcons.creditCard,
          bodyKey: TestKeys.checkoutScreen,
        ),
      ),
      GoRoute(
        path: '/order/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => PlaceholderScreen(
          title: 'Order ${state.pathParameters['id']}',
          icon: LucideIcons.package,
          bodyKey: TestKeys.orderDetailScreen,
        ),
      ),
      GoRoute(
        path: '/auth/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PlaceholderScreen(
          title: 'Login',
          icon: LucideIcons.logIn,
          bodyKey: TestKeys.loginScreen,
        ),
      ),
      GoRoute(
        path: '/auth/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PlaceholderScreen(
          title: 'Register',
          icon: LucideIcons.userPlus,
          bodyKey: TestKeys.registerScreen,
        ),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PlaceholderScreen(
          title: 'Settings',
          icon: LucideIcons.settings,
          bodyKey: TestKeys.settingsScreen,
        ),
      ),
    ],
  );
}
