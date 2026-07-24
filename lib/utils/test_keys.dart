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

  // Splash saat restore session (Prompt 3).
  static const String splashScreen = 'splash_screen';

  // Auth — Login (Prompt 3).
  static const String loginEmailInput = 'login_email_input';
  static const String loginPasswordInput = 'login_password_input';
  static const String loginSubmitButton = 'login_submit_button';
  static const String loginErrorMessage = 'login_error_message';
  static const String loginRegisterLink = 'login_register_link';

  // Auth — Register (Prompt 3).
  static const String registerEmailInput = 'register_email_input';
  static const String registerPasswordInput = 'register_password_input';
  static const String registerConfirmInput = 'register_confirm_password_input';
  static const String registerNameInput = 'register_name_input';
  static const String registerSubmitButton = 'register_submit_button';
  static const String registerErrorMessage = 'register_error_message';

  // Profile (Prompt 3).
  static const String profileAvatar = 'profile_avatar';
  static const String profileEmail = 'profile_email';
  static const String profileName = 'profile_name';
  static const String loginPromptButton = 'login_prompt_button';
  static const String logoutButton = 'logout_button';
  static const String profileAddressesLink = 'profile_addresses_link';
  static const String profileOrdersLink = 'profile_orders_link';
  static const String profileSettingsLink = 'profile_settings_link';

  /// Long-press avatar → dev menu (Prompt 8).
  static const String devMenuTrigger = 'dev_menu_trigger';

  // Dev menu (Prompt 8).
  static const String devSpeedUpToggle = 'dev_speed_up_toggle';
  static const String devSkipLoginToggle = 'dev_skip_login_toggle';
  static const String devClearNotifButton = 'dev_clear_notif_button';
  static const String devResetButton = 'dev_reset_button';

  // Settings (Prompt 8).
  static const String themeModeLight = 'theme_mode_light';
  static const String themeModeDark = 'theme_mode_dark';
  static const String themeModeSystem = 'theme_mode_system';

  // Home (Prompt 4).
  static const String heroBanner = 'hero_banner';
  static const String categoryGrid = 'category_grid';
  static const String featuredProductsList = 'featured_products_list';

  // Categories (Prompt 4).
  static const String categoryProductsScreen = 'category_products_screen';
  static const String productsGrid = 'products_grid';

  // Product Detail (Prompt 4).
  static const String productImageCarousel = 'product_image_carousel';
  static const String productName = 'product_name';
  static const String productPrice = 'product_price';
  static const String productPriceOriginal = 'product_price_original';
  static const String productDiscountBadge = 'product_discount_badge';
  static const String stockIndicator = 'stock_indicator';
  static const String qtyStepperDecrement = 'qty_stepper_decrement';
  static const String qtyStepperIncrement = 'qty_stepper_increment';
  static const String qtyValue = 'qty_value';
  static const String addToCartButton = 'add_to_cart_button';
  static const String buyNowButton = 'buy_now_button';
  static const String addToCartSnackbar = 'add_to_cart_snackbar';
  static const String relatedProductsList = 'related_products_list';

  // Cart badge di bottom nav (Prompt 4).
  static const String cartBadge = 'cart_badge';

  // Search (Prompt 5).
  static const String searchInput = 'search_input';
  static const String filterButton = 'filter_button';
  static const String filterSheet = 'filter_sheet';
  static const String filterPriceMin = 'filter_price_min';
  static const String filterPriceMax = 'filter_price_max';
  static const String filterInStock = 'filter_in_stock';
  static const String filterApply = 'filter_apply';
  static const String filterClear = 'filter_clear';
  static const String searchResults = 'search_results';
  static const String emptySearchState = 'empty_search_state';

  // Checkout (Prompt 6).
  static const String checkoutStepIndicator = 'checkout_step_indicator';
  static const String checkoutStepAddress = 'checkout_step_address';
  static const String checkoutStepDelivery = 'checkout_step_delivery';
  static const String checkoutStepPayment = 'checkout_step_payment';
  static const String checkoutStepReview = 'checkout_step_review';
  static const String checkoutNextButton = 'checkout_next_button';
  static const String checkoutBackButton = 'checkout_back_button';
  static const String placeOrderButton = 'place_order_button';
  static const String checkoutTermsCheckbox = 'checkout_terms_checkbox';

  // Checkout — Address form (Prompt 6).
  static const String addressForm = 'address_form';
  static const String addressRecipientInput = 'address_recipient_input';
  static const String addressPhoneInput = 'address_phone_input';
  static const String addressStreetInput = 'address_street_input';
  static const String addressCityInput = 'address_city_input';
  static const String addressPostalInput = 'address_postal_input';
  static const String addressLabelInput = 'address_label_input';
  static const String addressSaveCheckbox = 'address_save_checkbox';
  static const String addressDefaultCheckbox = 'address_default_checkbox';
  static const String locationPermissionButton = 'location_permission_button';
  static const String savedAddressDropdown = 'saved_address_dropdown';

  // Address Book (Prompt 6).
  static const String addressBookScreen = 'address_book_screen';
  static const String addressFormScreen = 'address_form_screen';
  static const String addAddressButton = 'add_address_button';
  static const String addressFormSaveButton = 'address_form_save_button';

  // Order Confirmation (Prompt 6).
  static const String orderConfirmationScreen = 'order_confirmation_screen';
  static const String orderConfirmationNumber = 'order_confirmation_number';
  static const String viewOrderDetailButton = 'view_order_detail_button';
  static const String backToHomeButton = 'back_to_home_button';

  // Order Detail (Prompt 7).
  static const String orderStatusTimeline = 'order_status_timeline';
  static const String orderSummary = 'order_summary';
  static const String cancelOrderButton = 'cancel_order_button';

  // Order History (Prompt 7).
  static const String orderHistoryScreen = 'order_history_screen';
  static const String emptyOrderHistory = 'empty_order_history';

  // Cart (Prompt 5).
  static const String cartSubtotal = 'cart_subtotal';
  static const String cartDiscount = 'cart_discount';
  static const String cartDeliveryFee = 'cart_delivery_fee';
  static const String cartTotal = 'cart_total';
  static const String promoCodeInput = 'promo_code_input';
  static const String promoCodeApply = 'promo_code_apply';
  static const String promoCodeRemove = 'promo_code_remove';
  static const String promoCodeError = 'promo_code_error';
  static const String checkoutButton = 'checkout_button';
  static const String cartEmptyState = 'cart_empty_state';

  // --- Composite key (list item / varian) — WAJIB pola stabil untuk Appium.
  static String productCard(String productId) => 'product_card_$productId';
  static String categoryItem(String slug) => 'category_item_$slug';
  static String categoryGridItem(String slug) => 'category_grid_item_$slug';
  static String categoryHeader(String slug) => 'category_header_$slug';
  static String productImage(int index) => 'product_image_$index';
  static String sizeSelector(String size) => 'size_selector_$size';
  static String colorSelector(String color) => 'color_selector_$color';

  // Search filter (Prompt 5).
  static String filterCategory(String slug) => 'filter_category_$slug';
  static String filterSize(String size) => 'filter_size_$size';

  // Cart item (Prompt 5).
  static String cartItem(String cartItemId) => 'cart_item_$cartItemId';
  static String cartItemQty(String cartItemId) => 'cart_item_qty_$cartItemId';
  static String cartItemRemove(String cartItemId) =>
      'cart_item_remove_$cartItemId';

  // Checkout / Address composite (Prompt 6).
  static String useSavedAddress(String addressId) =>
      'use_saved_address_$addressId';
  static String deliveryMethod(String id) => 'delivery_method_$id';
  static String paymentMethod(String id) => 'payment_method_$id';
  static String addressItem(String addressId) => 'address_item_$addressId';
  static String addressItemEdit(String addressId) =>
      'address_item_edit_$addressId';
  static String addressItemDefault(String addressId) =>
      'address_item_default_$addressId';

  // Order composite (Prompt 7).
  static String orderStatusStep(String status) => 'order_status_$status';
  static String orderItem(String productId) => 'order_item_$productId';
  static String orderHistoryItem(String orderId) =>
      'order_history_item_$orderId';
}
