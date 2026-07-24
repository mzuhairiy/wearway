import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wearway_flutter/features/cart/providers/cart_providers.dart';

ProviderContainer _containerWithSubtotal(int subtotal) {
  final container = ProviderContainer(
    overrides: [cartSubtotalProvider.overrideWithValue(subtotal)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('cartSummary', () {
    test('subtotal > 300rb → gratis ongkir', () {
      final c = _containerWithSubtotal(400000);
      final s = c.read(cartSummaryProvider);
      expect(s.freeShipping, isTrue);
      expect(s.deliveryFeeIdr, 0);
      expect(s.discountIdr, 0);
      expect(s.totalIdr, 400000);
    });

    test('subtotal <= 300rb → ongkir Rp 15.000', () {
      final c = _containerWithSubtotal(100000);
      final s = c.read(cartSummaryProvider);
      expect(s.freeShipping, isFalse);
      expect(s.deliveryFeeIdr, 15000);
      expect(s.totalIdr, 115000);
    });

    test('cart kosong → ongkir 0, total 0', () {
      final c = _containerWithSubtotal(0);
      final s = c.read(cartSummaryProvider);
      expect(s.deliveryFeeIdr, 0);
      expect(s.totalIdr, 0);
    });

    test('apply WEARWAY10 → diskon 10% + total turun', () {
      final c = _containerWithSubtotal(400000);
      final result = c
          .read(promoControllerProvider.notifier)
          .apply('wearway10');
      expect(result.isValid, isTrue);

      final s = c.read(cartSummaryProvider);
      expect(s.discountIdr, 40000);
      expect(s.promoCode, 'WEARWAY10');
      expect(s.totalIdr, 360000); // 400000 + 0 ongkir - 40000
    });

    test('apply promo invalid → tidak ada diskon, ada error', () {
      final c = _containerWithSubtotal(50000);
      final result = c
          .read(promoControllerProvider.notifier)
          .apply('WEARWAY10'); // di bawah min 100rb
      expect(result.isValid, isFalse);

      expect(c.read(promoControllerProvider).error, isNotNull);
      final s = c.read(cartSummaryProvider);
      expect(s.discountIdr, 0);
    });

    test('remove promo → diskon hilang', () {
      final c = _containerWithSubtotal(400000);
      final notifier = c.read(promoControllerProvider.notifier)
        ..apply('wearway10');
      expect(c.read(cartSummaryProvider).discountIdr, 40000);

      notifier.remove();
      expect(c.read(cartSummaryProvider).discountIdr, 0);
    });
  });
}
