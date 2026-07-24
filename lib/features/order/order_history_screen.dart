import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/providers/catalog_providers.dart';
import 'package:wearway_flutter/features/order/providers/order_providers.dart';
import 'package:wearway_flutter/features/order/widgets/order_status_badge.dart';
import 'package:wearway_flutter/shared/widgets/product_image.dart';
import 'package:wearway_flutter/utils/currency_formatter.dart';
import 'package:wearway_flutter/utils/date_formatter.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Riwayat pesanan: list order terbaru dulu, tap → detail.
class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderHistoryProvider);

    return Scaffold(
      key: const ValueKey(TestKeys.orderHistoryScreen),
      appBar: AppBar(title: const Text('Riwayat Pesanan')),
      body: ordersAsync.when(
        loading: () => const Center(
          key: ValueKey(TestKeys.loadingIndicator),
          child: CircularProgressIndicator(),
        ),
        error: (_, _) => const Center(
          key: ValueKey(TestKeys.errorState),
          child: Text('Gagal memuat riwayat'),
        ),
        data: (orders) => orders.isEmpty
            ? const _EmptyHistory()
            : ListView.builder(
                padding: AppSpacing.pagePadding,
                itemCount: orders.length,
                itemBuilder: (context, i) =>
                    _OrderHistoryCard(order: orders[i]),
              ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      key: const ValueKey(TestKeys.emptyOrderHistory),
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.packageOpen,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Belum ada pesanan', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Pesanan yang kamu buat akan muncul di sini.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => context.go('/home'),
              child: const Text('Mulai Belanja'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  const _OrderHistoryCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemCount = order.items.fold<int>(0, (sum, it) => sum + it.quantity);

    return Card(
      key: ValueKey(TestKeys.orderHistoryItem(order.id)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () => context.push('/order/${order.id}'),
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              _Thumbnail(
                productId: order.items.isNotEmpty
                    ? order.items.first.productId
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            order.orderNumber,
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        OrderStatusBadge(status: order.status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${DateFormatter.shortMs(order.placedAtMs)} • '
                      '$itemCount item',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      CurrencyFormatter.rupiah(order.totalIdr),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thumbnail produk pertama (lookup by id). Fallback ikon kalau tak ada.
class _Thumbnail extends ConsumerWidget {
  const _Thumbnail({required this.productId});

  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final placeholder = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(LucideIcons.shirt, color: theme.colorScheme.onSurfaceVariant),
    );

    final id = productId;
    if (id == null) return placeholder;

    final productAsync = ref.watch(productByIdProvider(id));
    return productAsync.maybeWhen(
      data: (product) {
        final url = product?.imageUrls.isNotEmpty ?? false
            ? product!.imageUrls.first
            : null;
        if (url == null) return placeholder;
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: SizedBox(
            width: 56,
            height: 56,
            child: ProductImage(
              imageUrl: url,
              semanticLabel: product!.name,
            ),
          ),
        );
      },
      orElse: () => placeholder,
    );
  }
}
