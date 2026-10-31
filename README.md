# WearWay (wearway_flutter)

Flutter e-commerce fashion app — **System Under Test** untuk portofolio QA
(target automation: Appium Flutter Driver / Java, di repo terpisah).

Stack: Flutter 3.44 · Dart 3.12 · Riverpod v3 (codegen) · Material 3 ·
go_router · Hive CE · fl_chart · cached_network_image ·
flutter_local_notifications · permission_handler · lucide_icons_flutter.

> Beberapa dependency menyimpang dari rencana awal karena kompatibilitas
> ekosistem (Juli 2026) — lihat [`NOTES.md`](NOTES.md).

## Cara jalankan

```bash
# Prasyarat: Flutter 3.24+ stable, Android Studio + SDK, emulator running.
flutter pub get
dart run build_runner build            # generate *.g.dart (Riverpod/Hive)
flutter run                            # ke device/emulator terkoneksi
```

## Verifikasi cepat

```bash
flutter analyze                        # harus: No issues found!
flutter test                           # smoke test bottom nav
```

## Automation build (Appium Flutter Driver)

This SUT has a **separate automation entrypoint** (`lib/main_automation.dart`)
that enables the Flutter Driver extension. The normal entrypoint (`lib/main.dart`)
is unchanged. Details: [`QA-HANDOFF.md`](QA-HANDOFF.md) §11 & [`docs/APPIUM_READINESS.md`](docs/APPIUM_READINESS.md).

```bash
# Android — instrumented debug APK (for Appium Flutter Driver)
flutter build apk --debug --target=lib/main_automation.dart

# Android — run directly (prints the Dart VM Service URI)
flutter run --debug --target=lib/main_automation.dart

# iOS Simulator (macOS + Xcode ONLY)
flutter build ios --simulator --debug --target=lib/main_automation.dart
```

> Release still uses `lib/main.dart` — DO NOT enable the driver extension in a
> release build. The WebdriverIO framework lives in a separate automation repo.

## Status (Prompt 1 — Foundation)

Scaffold + core setup selesai:

- Material 3 theme (light + dark, seed hijau "eco"), typography & spacing terpusat.
- go_router `StatefulShellRoute` + bottom nav 4 tab (Home, Categories, Cart, Profile)
  + redirect guard untuk protected route.
- Hive CE init + 8 box dibuka saat startup.
- Riverpod v3 codegen (`@riverpod`) aktif.
- Semua widget interaktif punya `ValueKey` (lihat `lib/utils/test_keys.dart`).

## Status (Prompt 2 — Data layer)

Hive data layer + repository + seed deterministic selesai:

- 8 Hive model (`@HiveType`, typeId 0–7) + adapter ter-generate; registrasi
  satu panggilan via `hive_registrar.g.dart`.
- 7 repository (`lib/data/repositories/`) — semua akses Hive lewat sini.
- Password hashing SHA256 + salt (`lib/utils/password_hasher.dart`).
- Seed deterministic: 6 kategori, **60 produk**, 2 user, 2 alamat, 5 order.
  Idempotent by `seed_version` (first launch seed, launch berikutnya skip).
- Riverpod repository + read provider (Stream/Future) untuk katalog.
- 29 unit test hijau (password, product/cart/user repo, seed idempotent).

Login seed (lihat CLAUDE.md): `customer@example.com` / `Customer123!`
(5 order + 2 alamat) · `customer2@example.com` / `Customer123!` (fresh).

## Status (Prompt 3 — Auth + navigation guard)

Autentikasi lokal + guard selesai:

- `AuthController` (AsyncNotifier<UserModel?>) — login/register/logout +
  restore session dari Hive box `meta`. Splash sekali saat cold start.
- Login & Register screen (form + validasi inline, semua input ber-`ValueKey`).
- Router guard: guest akses route protected (`/checkout`, `/order/*`,
  `/order-history`, `/profile/addresses`) → redirect `/auth/login?from=`;
  reaktif via `refreshListenable` (logout auto balik).
- Profile screen: login → info user + menu + logout; guest → prompt login.
  Long-press avatar → dev menu (diisi Prompt 8).
- Guest cart transfer ke akun saat login (repo Prompt 2).
- 42 unit/widget test hijau (auth controller, validator, + carry-over Prompt 2).

Diverifikasi di emulator: fresh→guest → login → **session persist saat
kill & re-open** → logout → guest.

## Status (Prompt 4 — Browse: Home + Categories + Product Detail)

- Home: hero banner, grid kategori, produk unggulan (horizontal),
  pull-to-refresh (RefreshIndicator).
- Categories tab: grid kategori + jumlah produk; `/categories/:slug` →
  grid produk per kategori (empty state + pull-to-refresh).
- Product Detail: carousel gambar + pinch-to-zoom (InteractiveViewer),
  harga + diskon (strikethrough), rating, pilih size/color (ChoiceChip),
  qty stepper, stock indicator, add-to-cart (disabled sampai size+color
  dipilih) + snackbar, produk terkait.
- `ProductCard` shared widget (image `cached_network_image`, badge, rating).
- Cart badge di bottom nav (reaktif ke `cartCountProvider`).
- Image sementara `picsum.photos` (asset lokal di Prompt 8).
- 46 test hijau (+ CurrencyFormatter). Diverifikasi di emulator:
  Home → kategori → produk → pilih varian → add to cart → **badge = 1**.

## Status (Prompt 5 — Search + Cart + gesture)

- Search: search bar (debounce 300ms) + filter sheet (kategori, ukuran,
  RangeSlider harga, toggle in-stock) + grid hasil + empty state.
- Cart: daftar item + qty stepper, **swipe-to-delete** (`Dismissible` +
  dialog konfirmasi) + tombol trash backup, ringkasan (subtotal, diskon,
  ongkir, total), promo code, checkout.
- PromoService: `WEARWAY10` (10%, min Rp 100rb), `WELCOMEBACK` (Rp 20rb,
  min Rp 150rb) — case-insensitive. Ongkir gratis kalau subtotal > Rp 300rb.
- 60 test hijau (promo service 8, cart summary 6, + carry-over).
- Diverifikasi di emulator: search "hoodie" → hasil; filter sheet; swipe item
  → dialog konfirmasi; promo min-belanja error.

## Status (Prompt 6 — Checkout multi-step + Runtime Permission)

- Checkout multi-step (`lib/features/checkout/`): indikator 4 step
  (Alamat → Kirim → Bayar → Ulas), butuh login (guard redirect + return URL).
- Step Alamat: "Deteksi alamat saya" (izin lokasi via permission_handler →
  granted = mock geocode Jakarta, denied = SnackBar, permanentlyDenied =
  dialog buka Settings), dropdown alamat tersimpan, atau form manual +
  "Simpan sebagai alamat baru".
- Step Kirim: RadioGroup (Regular Rp 15rb / Express Rp 35rb / Gratis Ongkir
  kalau subtotal > Rp 300rb). Step Bayar: COD / Transfer Bank / GoPay / OVO
  (mock). Step Ulas: ringkasan + checkbox syarat → "Buat Pesanan".
- Place order: minta izin notifikasi (Android 13+ kontekstual) → buat Order +
  OrderItem snapshot ke Hive → clear cart → OrderConfirmation (nomor order,
  total, ETA).
- Address Book (`lib/features/address/`): list alamat tersimpan, tambah/edit
  (form), swipe-to-delete, set default. CRUD via `address_repository`.
- `AddressModel.isSaved` (baru, seed v2): alamat snapshot checkout yang tidak
  disimpan tetap dipersist (agar order bisa referensi) tapi disembunyikan dari
  Address Book.
- `PermissionService` (`lib/permissions/`) — wrapper permission_handler yang
  testable (di-override di test).
- 72 test hijau (checkout summary/placeOrder 8, address repo 4, + carry-over).
- Diverifikasi di emulator: guard → login → checkout 4 step, izin lokasi
  (granted) + izin notifikasi (Android 13+), order tersimpan di Hive,
  OrderConfirmation, Address Book (filter isSaved) + form tambah.

## Status (Prompt 7 — Push Notification order-status + Order Detail)

- `NotificationService` (`lib/notifications/`): flutter_local_notifications,
  channel `order_updates` (importance DEFAULT), tap payload = orderId → deep
  link ke `/order/:id` via go_router. Di-init di `main()`, di-inject via
  provider override (di-fake di test).
- `OrderStatusScheduler`: simulasi status pakai Timer — 30s Preparing, 60s
  Shipped, 90s Delivered. Tiap tahap: update `order.status` di Hive + tampilkan
  notifikasi. Timer per-order bisa dibatalkan (`Map<orderId, List<Timer>>`).
  Dipanggil dari checkout setelah order dibuat.
- Order Detail (`lib/features/order/order_detail_screen.dart`): header +
  status timeline 4 tahap **reaktif** (watch order via stream Hive → checkmark
  update otomatis saat scheduler menulis), item snapshot, alamat, pembayaran,
  ringkasan biaya, tombol Batalkan Pesanan (status placed/preparing).
- Order History (`order_history_screen.dart`): ListView order terbaru dulu,
  kartu = nomor + tanggal + total + badge status + thumbnail produk pertama,
  tap → detail, empty state.
- 75 test hijau (scheduler 3 via fake_async, + carry-over).
- Diverifikasi di emulator: place order → 30s notif + timeline Diproses (live)
  → 60s Dikirim → 90s Tiba, tap notif → Order Detail (deep link), Order History
  menampilkan seed + order baru.

## Status (Prompt 8 — Assets + polish + dev menu)

- **Asset infra**: seed `imageUrls` → `assets/products/{id}.jpg` (+`_2`),
  `pubspec` include `assets/products/` & `assets/banners/`. Widget
  `ProductImage` terpusat: `assets/` → `Image.asset` + fallback placeholder,
  `http` → `CachedNetworkImage`, kosong → placeholder. Dipakai di ProductCard,
  Product Detail carousel, Cart, Order History. **Gambar asli belum ada** →
  app tampil placeholder (lihat `assets/products/README.md`). seedVersion → 3.
- **Hero banner** berputar (PageView auto-play 5s + dots), fallback gradient
  bermerk kalau `assets/banners/banner_N.jpg` belum ada.
- **Splash & ikon**: logo WearWay = huruf "W" putih dalam lingkaran hijau.
  Splash (native + in-app) background putih, logo **timbul** (gradient 3D +
  shadow); app icon flat. Aset di-generate dari script + `flutter_native_splash`
  & `flutter_launcher_icons`.
- **Dev menu** (long-press avatar Profile): percepat simulasi order (30s→5s),
  skip login (auto-login), bersihkan notifikasi, reset semua data (konfirmasi),
  info seed/app version. State toggle persist di Hive `settings`.
- **Settings**: toggle tema (Terang/Gelap/Sistem) — instan & persist.
- **Dark mode** cohesive di semua screen.
- **Currency** edge-case test (0, negatif, ribuan, miliaran).
- **A11y**: `semanticLabel` di semua gambar produk (via ProductImage).
- 79 test hijau (currency edge case, scheduler, + smoke widget test).
- Diverifikasi di emulator: placeholder fallback, banner berputar, dark mode
  instan, dev menu (reset + toggle) berfungsi.

**Polish lanjutan:**
- Toast: semua notifikasi in-app pakai `toastr_flutter` (wrapper `AppToast`),
  posisi **atas** (topCenter). Success/error/warning/info.
- Gambar **hybrid**: `ProductImage` coba asset lokal → fallback foto network
  (picsum deterministic) → placeholder. Banner & kartu produk tampil foto asli
  tanpa perlu download; drop file ke `assets/products/` untuk pakai lokal.

Prompt berikutnya (QA-HANDOFF.md) ada di
[`PROJECT_PLAN.md`](PROJECT_PLAN.md) section 10.

## Struktur

Feature-first (`lib/features/`), repository pattern untuk data (`lib/data/`),
core (theme/router) di `lib/core/`, shared widget/provider di `lib/shared/`.
Detail: `PROJECT_PLAN.md` section 9.
