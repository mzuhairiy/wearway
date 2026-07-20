# Engineering Notes — WearWay Flutter

Catatan quirk / keputusan teknis yang menyimpang dari `PROJECT_PLAN.md`,
supaya tidak "silent workaround" (sesuai CLAUDE.md workflow rule 4).

## Environment (Prompt 1)

- Flutter **3.44.7 stable**, Dart **3.12.2** (di-install via `brew install --cask flutter`).
- Target: Android (emulator Pixel 8). iOS shell ikut di-generate (bonus).

## Deviasi dependency dari PROJECT_PLAN (dipaksa ekosistem, Juli 2026)

Semua deviasi di bawah disebabkan Dart 3.12 **menghapus fitur eksperimen
`macros`**, sehingga analyzer versi 6.5–7.2 (yang depend ke package `_macros`
dari SDK) jadi tidak bisa di-install. Semua tooling wajib pakai `analyzer >=7.3`.

### 1. Hive → **Hive CE** (Community Edition)
- Plan: `hive`, `hive_flutter`, `hive_generator`.
- Aktual: `hive_ce`, `hive_ce_flutter`, `hive_ce_generator`.
- Alasan: `hive_generator` (2.0.1) tidak dirawat lagi & pin analyzer lama →
  bentrok dengan codegen modern. `hive_ce` adalah fork aktif, API-compatible
  (`Hive.initFlutter`, box, `@HiveType`/`@HiveField` sama persis).

### 2. Riverpod v2 → **v3** (codegen)
- Plan: "Riverpod v2 (codegen)".
- Aktual: `flutter_riverpod ^3.3.2` + `riverpod_annotation ^4.0.3` +
  `riverpod_generator ^4.0.4` (versi stable terbaru yang ditarik `pub add`).
- Alasan: v3 = penerus stabil v2; API `@riverpod` codegen identik untuk
  kebutuhan kita (Notifier, function provider). Signature ref generic sekarang
  cukup `Ref` (bukan `FooRef` per-provider).

### 3. Drop `custom_lint` + `riverpod_lint` (sementara)
- Plan: dev deps termasuk `custom_lint`, `riverpod_lint`.
- Aktual: dihapus dulu.
- Alasan: `riverpod_generator 4.0.4` sudah pindah ke `analyzer ^12`, tapi
  `custom_lint`/`riverpod_lint` rilis terbaru masih di `analyzer ^8` →
  version solving gagal. Keduanya cuma plugin lint opsional, tidak dibutuhkan
  untuk build / codegen / kriteria "analyze bersih" (di-cover `very_good_analysis`).
- Rencana: tambahkan lagi begitu plugin lint sudah support analyzer 12.

### 4. `lucide_icons` → **`lucide_icons_flutter`**
- Plan: `lucide_icons`.
- Aktual: `lucide_icons_flutter ^3.1.15`.
- Alasan: `lucide_icons` 0.257.0 `extends IconData`, padahal di Flutter 3.44
  `IconData` sudah `final class` → gagal compile. `lucide_icons_flutter` adalah
  fork aktif; nama ikon identik (`LucideIcons.home`, `.shirt`, dst.), cuma
  path import beda.

## Catatan lain

- `flutter_lints` dihapus (digantikan `very_good_analysis`).
- `public_member_api_docs` dinonaktifkan di `analysis_options.yaml` — rule ini
  untuk published package, bukan aplikasi. Rule strict lainnya tetap aktif.
- Rule `sort_pub_dependencies` ikut mengurutkan SDK dep (`flutter`,
  `flutter_test`), jadi posisinya ditaruh alfabetis di antara dep lain.
