/// Hasil validasi promo (dipakai UI + cart summary).
class PromoResult {
  const PromoResult({
    required this.isValid,
    required this.discountIdr,
    required this.message,
    this.code,
  });

  const PromoResult.invalid(this.message)
    : isValid = false,
      discountIdr = 0,
      code = null;

  final bool isValid;
  final int discountIdr;
  final String message;
  final String? code;
}

/// Promo hardcoded (local, no backend). Kode di-normalisasi uppercase supaya
/// input `wearway10` / `WEARWAY10` sama-sama valid.
abstract final class PromoService {
  static const int minWearway10 = 100000;
  static const int minWelcomeback = 150000;

  static PromoResult validate(String rawCode, int subtotalIdr) {
    final code = rawCode.trim().toUpperCase();
    if (code.isEmpty) {
      return const PromoResult.invalid('Masukkan kode promo');
    }
    switch (code) {
      case 'WEARWAY10':
        if (subtotalIdr < minWearway10) {
          return const PromoResult.invalid('Min. belanja Rp 100.000');
        }
        return PromoResult(
          isValid: true,
          discountIdr: subtotalIdr * 10 ~/ 100,
          message: 'Diskon 10% diterapkan',
          code: code,
        );
      case 'WELCOMEBACK':
        if (subtotalIdr < minWelcomeback) {
          return const PromoResult.invalid('Min. belanja Rp 150.000');
        }
        return const PromoResult(
          isValid: true,
          discountIdr: 20000,
          message: 'Potongan Rp 20.000 diterapkan',
          code: 'WELCOMEBACK',
        );
      default:
        return const PromoResult.invalid('Kode promo tidak valid');
    }
  }
}
