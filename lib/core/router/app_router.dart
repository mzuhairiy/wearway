import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/features/address/address_book_screen.dart';
import 'package:wearway_flutter/features/address/address_form_screen.dart';
import 'package:wearway_flutter/features/auth/providers/auth_controller.dart';
import 'package:wearway_flutter/features/auth/screens/login_screen.dart';
import 'package:wearway_flutter/features/auth/screens/register_screen.dart';
import 'package:wearway_flutter/features/cart/cart_screen.dart';
import 'package:wearway_flutter/features/categories/categories_screen.dart';
import 'package:wearway_flutter/features/categories/category_products_screen.dart';
import 'package:wearway_flutter/features/checkout/checkout_screen.dart';
import 'package:wearway_flutter/features/checkout/order_confirmation_screen.dart';
import 'package:wearway_flutter/features/home/home_screen.dart';
import 'package:wearway_flutter/features/order/order_detail_screen.dart';
import 'package:wearway_flutter/features/order/order_history_screen.dart';
import 'package:wearway_flutter/features/product/product_detail_screen.dart';
import 'package:wearway_flutter/features/profile/profile_screen.dart';
import 'package:wearway_flutter/features/search/search_screen.dart';
import 'package:wearway_flutter/features/settings/settings_screen.dart';
import 'package:wearway_flutter/features/shell/scaffold_with_nav_bar.dart';

part 'app_router.g.dart';

// Navigator key root + per-branch → dibutuhkan StatefulShellRoute.
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Route protected: butuh login. Guest yang akses → redirect ke /auth/login.
/// (`/order` tidak menangkap `/order-history` karena cek pakai `/order/`.)
const _protectedPrefixes = <String>[
  '/checkout',
  '/order',
  '/order-confirmation',
  '/order-history',
  '/profile/addresses',
];

/// go_router sebagai provider (keepAlive: dibuat sekali seumur app).
/// Dibungkus provider supaya redirect bisa baca auth state dari Riverpod.
@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  // refreshListenable: router re-evaluasi redirect tiap auth state berubah
  // (mis. logout saat di screen protected → auto balik ke login).
  final authRefresh = ValueNotifier<bool>(
    ref.read(authControllerProvider).value != null,
  );
  ref
    ..listen(authControllerProvider, (_, next) {
      authRefresh.value = next.value != null;
    })
    ..onDispose(authRefresh.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    debugLogDiagnostics: true,
    refreshListenable: authRefresh,
    redirect: (context, state) {
      final loggedIn = ref.read(authControllerProvider).value != null;
      final loc = state.matchedLocation;
      final onAuthPage = loc.startsWith('/auth');
      final isProtected = _protectedPrefixes.any(
        (p) => loc == p || loc.startsWith('$p/'),
      );
      if (!loggedIn && isProtected) {
        final from = Uri.encodeComponent(state.uri.toString());
        return '/auth/login?from=$from';
      }
      // Sudah login tapi buka halaman auth → balik ke tujuan awal / home.
      if (loggedIn && onAuthPage) {
        final from = state.uri.queryParameters['from'];
        return (from != null && from.isNotEmpty) ? from : '/home';
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
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            ProductDetailScreen(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/categories/:slug',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            CategoryProductsScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: '/checkout',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/order-confirmation/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            OrderConfirmationScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/profile/addresses',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddressBookScreen(),
        routes: [
          GoRoute(
            path: 'new',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const AddressFormScreen(),
          ),
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) =>
                AddressFormScreen(existing: state.extra! as AddressModel),
          ),
        ],
      ),
      GoRoute(
        path: '/order-history',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: '/order/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            OrderDetailScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/auth/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
