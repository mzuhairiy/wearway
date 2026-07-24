import 'package:flutter_test/flutter_test.dart';
import 'package:wearway_flutter/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter.rupiah', () {
    test('ribuan diberi titik', () {
      expect(CurrencyFormatter.rupiah(199000), 'Rp 199.000');
      expect(CurrencyFormatter.rupiah(89000), 'Rp 89.000');
    });

    test('jutaan', () {
      expect(CurrencyFormatter.rupiah(1250000), 'Rp 1.250.000');
    });

    test('nol & di bawah seribu', () {
      expect(CurrencyFormatter.rupiah(0), 'Rp 0');
      expect(CurrencyFormatter.rupiah(500), 'Rp 500');
    });

    test('negatif', () {
      expect(CurrencyFormatter.rupiah(-15000), '-Rp 15.000');
      expect(CurrencyFormatter.rupiah(-2500000), '-Rp 2.500.000');
    });

    test('batas ribuan (1000)', () {
      expect(CurrencyFormatter.rupiah(1000), 'Rp 1.000');
      expect(CurrencyFormatter.rupiah(999), 'Rp 999');
    });

    test('angka besar (miliaran)', () {
      expect(CurrencyFormatter.rupiah(1000000000), 'Rp 1.000.000.000');
    });
  });
}
