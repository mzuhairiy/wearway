# CLAUDE.md — wearway_flutter (SUT)

Flutter e-commerce fashion app sebagai **System Under Test** ke-5 untuk portfolio QA.
**Build from scratch** dengan Flutter untuk career investment di Flutter QA.

Target automation: **Appium Flutter Driver (Java)** — repo terpisah, dikerjain nanti.

## Stack

Flutter (SDK terbaru stable) · Dart 3.5+ · **Riverpod v2 (codegen)** · **Material 3** + optional Shadcn-Flutter accent ·
**go_router** · **Hive v2** · fl_chart · cached_network_image · flutter_local_notifications ·
permission_handler · lucide_icons · intl · crypto (password hashing) · very_good_analysis lint.

## Konteks penting: user baru di Flutter (dari RN background)

Sebelum ini user familiar dengan React Native (Duitku from scratch).
Flutter = bahasa (Dart) + paradigm (widget tree) baru. Konsekuensi untuk agent:
- Kasih **inline comment SINGKAT (1-2 baris)** di konsep pertama kali muncul:
  StatelessWidget vs StatefulWidget, ConsumerWidget (Riverpod), Widget vs component (RN),
  Key vs testID, MaterialApp, Scaffold, hot reload, `const` constructor
- JANGAN paragraph tutorial — cukup pointer supaya user tau "ini apa"
- Kalau ada Dart idiom yang berbeda dari TS (nullable, `late`, `final`, cascade `..`), kasih comment singkat
- Prefer idiomatic Flutter (const constructor, ConsumerWidget, Riverpod pattern)

## Cara jalankan

```bash
# Prasyarat: Flutter SDK 3.24+ stable, Android Studio + SDK, emulator running
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs  # generate .g.dart
flutter run                          # ke connected device/emulator
```

Reset seed: buka app → Profile → long-press avatar → Reset all data.

Login seed:
- `customer@example.com` / `Customer123!` (punya 5 order history)
- `customer2@example.com` / `Customer123!` (fresh)

## Rules

### Flutter / Dart discipline
- ❌ JANGAN StatefulWidget kalau bisa StatelessWidget + Riverpod
- ❌ JANGAN skip `const` constructor (linter enforce)
- ❌ JANGAN nested MaterialApp
- ❌ File widget > 300 baris → split
- ❌ Widget nested > 5 level → refactor jadi named widget
- ✅ Prefer ConsumerWidget (Riverpod) atau StatelessWidget
- ✅ Named widget class daripada helper method yang return Widget

### Riverpod
- ❌ JANGAN StateNotifier legacy — pakai `@riverpod` codegen
- ❌ JANGAN watch provider di build method banyak kali — extract ke variable
- ❌ JANGAN Provider global kalau bisa AutoDispose (v2 codegen default)
- ✅ Provider bergranulasi (satu tanggung jawab per provider)

### Data (Hive)
- ❌ JANGAN akses Hive box langsung dari widget → repository pattern
- ❌ JANGAN random di seed generator
- ❌ JANGAN pakai `DateTime.now()` di seed → SEED_REFERENCE_DATE constant
- ❌ JANGAN pakai `double` untuk amount → `int` Rupiah
- ❌ JANGAN skip `Hive.close()` di app dispose
- ✅ Semua ID deterministic (fixed string)
- ✅ SEED_VERSION versioned + idempotent

### Testability (kontrak ke Appium Flutter Driver)
- ❌ JANGAN skip `ValueKey` di interactive widget — Appium Flutter finder gak bisa locate
- ❌ JANGAN pakai text content sebagai locator utama (pecah saat lokalisasi/theme)
- ❌ JANGAN inconsistent naming
- ✅ Centralize `ValueKey` constants di `lib/utils/test_keys.dart`
- ✅ SEMUA Button, TextField, InkWell, GestureDetector interactive WAJIB ValueKey
- ✅ List items: composite (`product_card_{productId}`, `cart_item_{cartItemId}`)
- ✅ Naming: snake_case
- ✅ Loading/empty/error state punya ValueKey stabil

### UI (Material 3 base + optional Shadcn-Flutter)
- ❌ JANGAN hardcode color hex → `Theme.of(context).colorScheme.*`
- ❌ JANGAN hardcode font size → `Theme.of(context).textTheme.*`
- ❌ JANGAN hardcode spacing → constants dari `lib/core/theme/app_spacing.dart`
- ❌ JANGAN default Container/Text tanpa theme reference
- ❌ JANGAN skip empty/loading/error state
- ✅ Material 3 sebagai base
- ✅ Shadcn-Flutter component hanya kalau memberi uplift visual signifikan (Card, Button CTA, Sheet)
- ✅ Dark mode support di SEMUA screen (test visual)

### Architecture
- ❌ JANGAN campur `go_router` dengan `Navigator.push` (pilih go_router)
- ❌ JANGAN business logic di widget → provider / service / util
- ❌ JANGAN skip loading/error state di async widget
- ✅ Feature-first folder structure (`lib/features/{feature}/`)
- ✅ Repository pattern untuk data access
- ✅ Service layer untuk domain logic (PromoService, NotificationService, PermissionService)

### Security (customer shopping app)
- ❌ JANGAN store password plaintext → SHA256 + salt (crypto package)
- ❌ JANGAN log password / PII ke console
- ✅ Session persist di Hive 'meta' box (userId, bukan password)

### Scope
- ❌ JANGAN tambah backend / Firebase / real API
- ❌ JANGAN tambah role admin/seller (customer only)
- ❌ JANGAN tambah real payment gateway
- ❌ JANGAN tambah deep link (di-drop di v2, konsisten)
- ❌ JANGAN setup Appium/automation di repo ini (repo terpisah)

## Fitur khas mobile (showcase)

1. **Push Notification** — flutter_local_notifications, simulate order status (Placed→Preparing→Shipped→Delivered),
   channel `order_updates`, tap → deep link ke Order Detail (via go_router). POST_NOTIFICATIONS (Android 13+) di-handle.
2. **Runtime Permission** — location di checkout (granted/denied/permanentlyDenied → openAppSettings),
   notification permission kontekstual saat first checkout.
3. **Gesture** — Dismissible swipe-to-delete di cart, RefreshIndicator pull-to-refresh di home/category,
   InteractiveViewer pinch-to-zoom di product image. Semua widget bawaan Flutter.

## Workflow per task

1. Kerjakan HANYA scope prompt yang diminta (build prompts di PROJECT_PLAN section 10)
2. Sebelum lapor selesai:
   - `flutter analyze` bersih (0 warning)
   - `flutter test` hijau (kalau prompt include unit/widget test)
   - Manual test acceptance criteria di emulator
3. Kalau ada Flutter/Dart concept yang non-obvious, kasih inline comment singkat
4. Kalau nemu Flutter quirk, log di note (jangan workaround diam-diam)
5. Jangan scope creep

## Detail lengkap

`PROJECT_PLAN.md`:
- Section 4: halaman & fitur
- Section 5: Hive schema
- Section 6: seed spec
- Section 7: ValueKey inventory
- Section 8: fitur khas mobile
- Section 10: build prompts (9 prompt total dalam 4 fase)
- Section 11: anti-pattern detail
