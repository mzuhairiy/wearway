/// Konstanta seed. Naikkan [seedVersion] kalau struktur/isi seed berubah →
/// SeedManager akan clear + re-seed otomatis.
///
/// Catatan: PROJECT_PLAN menulis `SEED_VERSION`, tapi lint Dart
/// (constant_identifier_names) minta lowerCamelCase → `seedVersion`.
const int seedVersion = 3;

/// Semua timestamp seed relatif ke tanggal ini (JANGAN DateTime.now di seed).
/// Pakai UTC supaya `millisecondsSinceEpoch` deterministic lintas timezone.
final DateTime seedReferenceDate = DateTime.utc(2026);
