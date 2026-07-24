import 'package:flutter_test/flutter_test.dart';
import 'package:wearway_flutter/features/cart/services/promo_service.dart';

void main() {
  group('PromoService.validate', () {
    test('WEARWAY10 valid → diskon 10%', () {
      final r = PromoService.validate('WEARWAY10', 200000);
      expect(r.isValid, isTrue);
      expect(r.discountIdr, 20000);
      expect(r.code, 'WEARWAY10');
    });

    test('kode lowercase tetap valid (normalisasi)', () {
      final r = PromoService.validate('wearway10', 200000);
      expect(r.isValid, isTrue);
      expect(r.discountIdr, 20000);
    });

    test('WEARWAY10 di bawah minimum → invalid', () {
      final r = PromoService.validate('WEARWAY10', 99999);
      expect(r.isValid, isFalse);
      expect(r.discountIdr, 0);
    });

    test('WELCOMEBACK valid → potongan Rp 20.000 flat', () {
      final r = PromoService.validate('WELCOMEBACK', 150000);
      expect(r.isValid, isTrue);
      expect(r.discountIdr, 20000);
    });

    test('WELCOMEBACK di bawah minimum → invalid', () {
      final r = PromoService.validate('WELCOMEBACK', 149999);
      expect(r.isValid, isFalse);
    });

    test('kode tidak dikenal → invalid', () {
      final r = PromoService.validate('GRATIS100', 500000);
      expect(r.isValid, isFalse);
      expect(r.message, 'Kode promo tidak valid');
    });

    test('kode kosong → invalid', () {
      final r = PromoService.validate('   ', 500000);
      expect(r.isValid, isFalse);
    });

    test('diskon 10% membulat ke bawah (integer)', () {
      final r = PromoService.validate('WEARWAY10', 123455);
      expect(r.discountIdr, 12345); // 123455 * 10 ~/ 100
    });
  });
}
