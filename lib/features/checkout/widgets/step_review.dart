import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/features/address/providers/address_providers.dart';
import 'package:wearway_flutter/features/cart/providers/cart_providers.dart';
import 'package:wearway_flutter/features/checkout/providers/checkout_controller.dart';
import 'package:wearway_flutter/utils/currency_formatter.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Step 4: ringkasan pesanan + checkbox terms sebelum place order.
class StepReview extends ConsumerWidget {
  const StepReview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkoutControllerProvider);
    final summary = ref.watch(checkoutSummaryProvider);
    final lines = ref.watch(cartLinesProvider);
    final controller = ref.read(checkoutControllerProvider.notifier);

    return ListView(
      padding: AppSpacing.pagePadding,
      children: [
        _Section(
          title: 'Alamat Pengiriman',
          child: _AddressSummary(state: state),
        ),
        _Section(
          title: 'Pengiriman',
          child: Text('${state.delivery.label} • ${state.delivery.subtitle}'),
        ),
        _Section(
          title: 'Pembayaran',
          child: Text(state.payment.label),
        ),
        _Section(
          title: 'Item (${lines.length})',
          child: Column(
            children: [
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${line.product.name} '
                          '(${line.item.selectedSize}/'
                          '${line.item.selectedColor}) '
                          '×${line.item.quantity}',
                        ),
                      ),
                      Text(CurrencyFormatter.rupiah(line.lineSubtotalIdr)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        _Section(
          title: 'Rincian Biaya',
          child: Column(
            children: [
              _Row('Subtotal', summary.subtotalIdr),
              if (summary.discountIdr > 0) _Row('Diskon', -summary.discountIdr),
              _Row('Ongkir', summary.deliveryFeeIdr),
              const Divider(),
              _Row('Total', summary.totalIdr, bold: true),
            ],
          ),
        ),
        CheckboxListTile(
          key: const ValueKey(TestKeys.checkoutTermsCheckbox),
          contentPadding: EdgeInsets.zero,
          value: state.termsAccepted,
          onChanged: (v) => controller.setTerms(value: v ?? false),
          title: const Text('Saya setuju dengan syarat & ketentuan WearWay.'),
        ),
      ],
    );
  }
}

class _AddressSummary extends ConsumerWidget {
  const _AddressSummary({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.usingSavedAddress) {
      final saved = ref.watch(savedAddressesProvider).value ?? const [];
      final match = saved
          .where((a) => a.id == state.selectedAddressId)
          .cast<AddressModel?>()
          .firstWhere((a) => true, orElse: () => null);
      if (match != null) {
        return Text(
          '${match.recipientName} • ${match.phone}\n'
          '${match.streetAddress}, ${match.city} ${match.postalCode}',
        );
      }
    }
    return Text(
      '${state.recipientName} • ${state.phone}\n'
      '${state.street}, ${state.city} ${state.postalCode}',
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          child,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.amountIdr, {this.bold = false});

  final String label;
  final int amountIdr;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = bold
        ? theme.textTheme.titleMedium
        : theme.textTheme.bodyMedium;
    final style = base?.copyWith(fontWeight: bold ? FontWeight.bold : null);
    final text = amountIdr < 0
        ? '-${CurrencyFormatter.rupiah(-amountIdr)}'
        : CurrencyFormatter.rupiah(amountIdr);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(text, style: style),
        ],
      ),
    );
  }
}
