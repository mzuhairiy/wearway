import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/order_item_model.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/models/order_status.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';
import 'package:wearway_flutter/features/order/providers/order_providers.dart';
import 'package:wearway_flutter/features/order/widgets/order_status_badge.dart';
import 'package:wearway_flutter/features/order/widgets/order_status_timeline.dart';
import 'package:wearway_flutter/shared/utils/app_toast.dart';
import 'package:wearway_flutter/utils/currency_formatter.dart';
import 'package:wearway_flutter/utils/date_formatter.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Order Detail: header, status timeline reaktif, item, alamat, total.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Stream reaktif: timeline update saat scheduler menulis status baru.
    final orderAsync = ref.watch(orderStreamProvider(orderId));

    return Scaffold(
      key: const ValueKey(TestKeys.orderDetailScreen),
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: orderAsync.when(
        loading: () => const Center(
          key: ValueKey(TestKeys.loadingIndicator),
          child: CircularProgressIndicator(),
        ),
        error: (_, _) => const Center(
          key: ValueKey(TestKeys.errorState),
          child: Text('Gagal memuat pesanan'),
        ),
        data: (order) => order == null
            ? const _NotFound()
            : _OrderDetailBody(order: order),
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey(TestKeys.emptyState),
      child: Text(
        'Pesanan tidak ditemukan',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _OrderDetailBody extends ConsumerWidget {
  const _OrderDetailBody({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final addressAsync = ref.watch(addressByIdProvider(order.addressId));
    final canCancel =
        order.status == OrderStatus.placed ||
        order.status == OrderStatus.preparing;

    return ListView(
      padding: AppSpacing.pagePadding,
      children: [
        // Header: nomor order + tanggal + badge status.
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.orderNumber, style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Dipesan ${DateFormatter.shortMs(order.placedAtMs)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            OrderStatusBadge(status: order.status),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        OrderStatusTimeline(status: order.status),
        const SizedBox(height: AppSpacing.lg),

        _SectionTitle('Item (${order.items.length})'),
        ...order.items.map((item) => _OrderItemTile(item: item)),
        const SizedBox(height: AppSpacing.lg),

        const _SectionTitle('Alamat Pengiriman'),
        Card(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: addressAsync.when(
              loading: () => const Text('Memuat alamat…'),
              error: (_, _) => const Text('Alamat tidak tersedia'),
              data: (address) => address == null
                  ? const Text('Alamat tidak tersedia')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.recipientName,
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(address.phone),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${address.streetAddress}, ${address.city} '
                          '${address.postalCode}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        const _SectionTitle('Pembayaran'),
        Card(
          child: ListTile(
            leading: const Icon(LucideIcons.wallet),
            title: Text(order.paymentMethod),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        const _SectionTitle('Ringkasan'),
        _OrderSummary(order: order),

        if (canCancel) ...[
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            key: const ValueKey(TestKeys.cancelOrderButton),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            onPressed: () => unawaited(_confirmCancel(context, ref)),
            icon: const Icon(LucideIcons.circleX),
            label: const Text('Batalkan Pesanan'),
          ),
        ],
      ],
    );
  }

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pesanan?'),
        content: const Text('Pesanan yang dibatalkan tidak bisa dipulihkan.'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Tidak'),
          ),
          FilledButton(
            onPressed: () => context.pop(true),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref
        .read(orderRepositoryProvider)
        .updateStatus(order.id, OrderStatus.cancelled);
    AppToast.info('Pesanan dibatalkan.');
  }
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({required this.item});

  final OrderItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: ValueKey(TestKeys.orderItem(item.productId)),
      child: ListTile(
        title: Text(item.productName),
        subtitle: Text(
          '${item.size} • ${item.color} • ${item.quantity}x',
          style: theme.textTheme.bodySmall,
        ),
        trailing: Text(
          CurrencyFormatter.rupiah(item.subtotalIdr),
          style: theme.textTheme.titleSmall,
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: const ValueKey(TestKeys.orderSummary),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            _row(theme, 'Subtotal', order.subtotalIdr),
            _row(theme, 'Ongkir', order.deliveryFeeIdr),
            if (order.discountIdr > 0)
              _row(theme, 'Diskon', -order.discountIdr),
            const Divider(),
            _row(theme, 'Total', order.totalIdr, bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(ThemeData theme, String label, int amount, {bool bold = false}) {
    final style = bold
        ? theme.textTheme.titleMedium
        : theme.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(CurrencyFormatter.rupiah(amount), style: style),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
