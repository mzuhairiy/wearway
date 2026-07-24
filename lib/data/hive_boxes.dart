/// Nama semua Hive box. Satu sumber kebenaran dipakai `main.dart` (openBox)
/// dan provider (Hive.box).
///
/// Tipe value per box:
/// - products   → Box&lt;ProductModel&gt;
/// - categories → Box&lt;CategoryModel&gt;
/// - users      → Box&lt;UserModel&gt;
/// - addresses  → Box&lt;AddressModel&gt;
/// - cart_items → Box&lt;CartItemModel&gt;
/// - orders     → Box&lt;OrderModel&gt;
/// - settings   → Box&lt;dynamic&gt; (theme/currency)
/// - meta       → Box&lt;dynamic&gt; (seed_version, current_user_id)
abstract final class HiveBoxes {
  static const String products = 'products';
  static const String categories = 'categories';
  static const String users = 'users';
  static const String addresses = 'addresses';
  static const String cartItems = 'cart_items';
  static const String orders = 'orders';
  static const String settings = 'settings';
  static const String meta = 'meta';
}

/// Key-key di dalam box `meta`.
abstract final class MetaKeys {
  static const String seedVersion = 'seed_version';
  static const String currentUserId = 'current_user_id';
}

/// Key-key di dalam box `settings`.
abstract final class SettingsKeys {
  static const String themeMode = 'theme_mode';
  static const String currency = 'currency';

  /// Dev flags (dev menu Prompt 8).
  static const String speedUpOrders = 'dev_speed_up_orders';
  static const String skipLogin = 'dev_skip_login';
}
