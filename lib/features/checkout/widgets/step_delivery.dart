import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/features/checkout/providers/checkout_controller.dart';
import 'package:wearway_flutter/utils/currency_formatter.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

const int _freeShippingThresholdIdr = 300000;

/// Step 2: pilih metode pengiriman (RadioListTile). Gratis ongkir hanya muncul
/// kalau subtotal eligible.
class StepDelivery extends ConsumerWidget {
  const StepDelivery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = ref.watch(
      checkoutControllerProvider.select((s) => s.deliveryId),
    );
    final subtotal = ref.watch(checkoutSummaryProvider).subtotalIdr;
    final controller = ref.read(checkoutControllerProvider.notifier);
    final eligibleFree = subtotal > _freeShippingThresholdIdr;

    final methods = kDeliveryMethods
        .where((m) => m.id != kDeliveryFree.id || eligibleFree)
        .toList();

    // RadioGroup (Flutter 3.32+) mengelola nilai grup → RadioListTile cukup
    // deklarasi `value` saja (hindari deprecated groupValue/onChanged).
    return RadioGroup<String>(
      groupValue: selected,
      onChanged: (v) => controller.selectDelivery(v!),
      child: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          for (final m in methods)
            Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: RadioListTile<String>(
                key: ValueKey(TestKeys.deliveryMethod(m.id)),
                value: m.id,
                title: Text(m.label, style: theme.textTheme.titleMedium),
                subtitle: Text(m.subtitle),
                secondary: Text(
                  m.feeIdr == 0 ? 'Gratis' : CurrencyFormatter.rupiah(m.feeIdr),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
