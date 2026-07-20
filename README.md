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

## Status (Prompt 1 — Foundation)

Scaffold + core setup selesai:

- Material 3 theme (light + dark, seed hijau "eco"), typography & spacing terpusat.
- go_router `StatefulShellRoute` + bottom nav 4 tab (Home, Categories, Cart, Profile)
  + redirect guard untuk protected route.
- Hive CE init + 8 box dibuka saat startup.
- Riverpod v3 codegen (`@riverpod`) aktif.
- Semua widget interaktif punya `ValueKey` (lihat `lib/utils/test_keys.dart`).

Prompt berikutnya (data layer, seed, auth, dst.) ada di
[`PROJECT_PLAN.md`](PROJECT_PLAN.md) section 10.

## Struktur

Feature-first (`lib/features/`), repository pattern untuk data (`lib/data/`),
core (theme/router) di `lib/core/`, shared widget/provider di `lib/shared/`.
Detail: `PROJECT_PLAN.md` section 9.
