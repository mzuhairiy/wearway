/// Sumber tunggal `ValueKey` untuk locator Appium Flutter Driver.
/// key ≈ testID di React Native — Appium finder pakai string ini buat locate.
/// SEMUA widget interaktif WAJIB ambil key dari sini (snake_case, konsisten).
abstract final class TestKeys {
  // Bottom navigation (Prompt 1).
  static const String navHome = 'nav_home';
  static const String navCategories = 'nav_categories';
  static const String navCart = 'nav_cart';
  static const String navProfile = 'nav_profile';

  // Root shell scaffold.
  static const String appShell = 'app_shell';
  static const String bottomNavBar = 'bottom_nav_bar';

  // Placeholder screen bodies (sementara, sampai screen asli dibangun).
  static const String homeScreen = 'home_screen';
  static const String categoriesScreen = 'categories_screen';
  static const String cartScreen = 'cart_screen';
  static const String profileScreen = 'profile_screen';
  static const String searchScreen = 'search_screen';
  static const String productDetailScreen = 'product_detail_screen';
  static const String checkoutScreen = 'checkout_screen';
  static const String orderDetailScreen = 'order_detail_screen';
  static const String loginScreen = 'login_screen';
  static const String registerScreen = 'register_screen';
  static const String settingsScreen = 'settings_screen';

  // State generik (loading / empty / error) — reusable across screens.
  static const String loadingIndicator = 'loading_indicator';
  static const String emptyState = 'empty_state';
  static const String errorState = 'error_state';
}
