import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/features/cart/providers/cart_providers.dart';
import 'package:wearway_flutter/shared/widgets/product_image.dart';
import 'package:wearway_flutter/utils/currency_formatter.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Tab Cart: daftar item (swipe-to-delete), promo, ringkasan, checkout.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartItemsProvider);
    final lines = ref.watch(cartLinesProvider);

    return Scaffold(
      key: const ValueKey(TestKeys.cartScreen),
      appBar: AppBar(title: const Text('Keranjang')),
      body: cartAsync.when(
        loading: () => const Center(
          key: ValueKey(TestKeys.loadingIndicator),
          child: CircularProgressIndicator(),
        ),
        error: (_, _) => const Center(
          key: ValueKey(TestKeys.errorState),
          child: Text('Gagal memuat keranjang'),
        ),
        data: (_) {
          if (lines.isEmpty) return const _EmptyCart();
          return Column(
            // stretch → Card ringkasan dapat lebar penuh (hindari unbounded
            // width pada Row promo di dalamnya).
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.separated(
                  padding: AppSpacing.pagePadding,
                  itemCount: lines.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, i) => _CartItemTile(line: lines[i]),
                ),
              ),
              const _CartSummaryCard(),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      key: const ValueKey(TestKeys.cartEmptyState),
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.shoppingBag,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Keranjang kosong', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Yuk mulai belanja koleksi WearWay.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(LucideIcons.store),
              label: const Text('Mulai Belanja'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  const _CartItemTile({required this.line});

  final CartLine line;

  Future<bool> _confirmRemove(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus item?'),
        content: Text('Hapus ${line.product.name} dari keranjang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final item = line.item;
    final controller = ref.read(cartControllerProvider.notifier);

    // Dismissible = swipe-to-delete bawaan Flutter (gesture khas mobile).
    // Penghapusan dilakukan di confirmDismiss lalu return false → item hilang
    // lewat update data (bukan state Dismissible), menghindari widget
    // "dismissed" yang nyangkut di tree saat data belum sinkron.
    return Dismissible(
      key: ValueKey('dismiss_${item.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        if (await _confirmRemove(context)) {
          await controller.removeItem(item.id);
        }
        return false;
      },
      background: ColoredBox(
        color: theme.colorScheme.errorContainer,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: AppSpacing.xl),
            child: Icon(LucideIcons.trash2),
          ),
        ),
      ),
      child: Card(
        key: ValueKey(TestKeys.cartItem(item.id)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: ProductImage(
                    imageUrl: line.product.imageUrls.isNotEmpty
                        ? line.product.imageUrls.first
                        : '',
                    semanticLabel: line.product.name,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      '${item.selectedSize} • ${item.selectedColor}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      CurrencyFormatter.rupiah(line.lineSubtotalIdr),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _QtyRow(line: line, controller: controller),
                  ],
                ),
              ),
              IconButton(
                key: ValueKey(TestKeys.cartItemRemove(item.id)),
                onPressed: () async {
                  if (await _confirmRemove(context)) {
                    await controller.removeItem(item.id);
                  }
                },
                icon: const Icon(LucideIcons.trash2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyRow extends StatelessWidget {
  const _QtyRow({required this.line, required this.controller});

  final CartLine line;
  final CartController controller;

  @override
  Widget build(BuildContext context) {
    final item = line.item;
    final qty = item.quantity;
    final canIncrement = qty < line.product.stock;
    return Row(
      key: ValueKey(TestKeys.cartItemQty(item.id)),
      children: [
        IconButton.filledTonal(
          visualDensity: VisualDensity.compact,
          onPressed: qty > 1
              ? () => unawaited(controller.updateQty(item.id, qty - 1))
              : null,
          icon: const Icon(LucideIcons.minus, size: 16),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('$qty', style: Theme.of(context).textTheme.titleMedium),
        ),
        IconButton.filledTonal(
          visualDensity: VisualDensity.compact,
          onPressed: canIncrement
              ? () => unawaited(controller.updateQty(item.id, qty + 1))
              : null,
          icon: const Icon(LucideIcons.plus, size: 16),
        ),
      ],
    );
  }
}

class _CartSummaryCard extends ConsumerWidget {
  const _CartSummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(cartSummaryProvider);

    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _PromoField(),
            const SizedBox(height: AppSpacing.md),
            _SummaryRow(
              label: 'Subtotal',
              value: CurrencyFormatter.rupiah(summary.subtotalIdr),
              valueKey: TestKeys.cartSubtotal,
            ),
            if (summary.discountIdr > 0)
              _SummaryRow(
                label: 'Diskon',
                value: '-${CurrencyFormatter.rupiah(summary.discountIdr)}',
                valueKey: TestKeys.cartDiscount,
                highlight: true,
              ),
            _SummaryRow(
              label: 'Ongkir',
              value: summary.freeShipping
                  ? 'Gratis'
                  : CurrencyFormatter.rupiah(summary.deliveryFeeIdr),
              valueKey: TestKeys.cartDeliveryFee,
            ),
            const Divider(height: AppSpacing.xl),
            _SummaryRow(
              label: 'Total',
              value: CurrencyFormatter.rupiah(summary.totalIdr),
              valueKey: TestKeys.cartTotal,
              bold: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const ValueKey(TestKeys.checkoutButton),
                onPressed: () => context.go('/checkout'),
                child: const Text('Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.valueKey,
    this.bold = false,
    this.highlight = false,
  });

  final String label;
  final String value;
  final String valueKey;
  final bool bold;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style =
        (bold ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium)
            ?.copyWith(
              fontWeight: bold ? FontWeight.bold : null,
              color: highlight ? theme.colorScheme.primary : null,
            );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, key: ValueKey(valueKey), style: style),
        ],
      ),
    );
  }
}

class _PromoField extends ConsumerStatefulWidget {
  const _PromoField();

  @override
  ConsumerState<_PromoField> createState() => _PromoFieldState();
}

class _PromoFieldState extends ConsumerState<_PromoField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _apply() {
    final result = ref
        .read(promoControllerProvider.notifier)
        .apply(_controller.text);
    if (result.isValid) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final promo = ref.watch(promoControllerProvider);
    final appliedCode = promo.code;

    if (appliedCode != null) {
      return Row(
        children: [
          Icon(LucideIcons.badgeCheck, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Promo $appliedCode diterapkan',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Lebar eksplisit → button tidak diukur infinite width di dalam Row
          // (menghindari assert _RenderInputPadding di FilledButton/TextButton).
          SizedBox(
            width: 96,
            child: TextButton(
              key: const ValueKey(TestKeys.promoCodeRemove),
              onPressed: () =>
                  ref.read(promoControllerProvider.notifier).remove(),
              child: const Text('Hapus'),
            ),
          ),
        ],
      );
    }

    // Layout vertikal (field lalu tombol full-width) → hindari button sebagai
    // child non-flex di Row (yang memicu "infinite width" saat diukur).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const ValueKey(TestKeys.promoCodeInput),
          controller: _controller,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Kode promo',
            isDense: true,
          ),
        ),
        if (promo.error != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              promo.error!,
              key: const ValueKey(TestKeys.promoCodeError),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
        FilledButton.tonal(
          key: const ValueKey(TestKeys.promoCodeApply),
          onPressed: _apply,
          child: const Text('Pakai Kode Promo'),
        ),
      ],
    );
  }
}
