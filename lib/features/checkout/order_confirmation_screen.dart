import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/features/order/providers/order_providers.dart';
import 'package:wearway_flutter/utils/currency_formatter.dart';
import 'package:wearway_flutter/utils/date_formatter.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Konfirmasi order sukses. Tidak bisa back ke checkout (pakai go, bukan push).
class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final orderAsync = ref.watch(orderByIdProvider(orderId));

    // Tombol home selalu tersedia (juga saat back gesture).
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/home');
      },
      child: Scaffold(
        key: const ValueKey(TestKeys.orderConfirmationScreen),
        body: SafeArea(
          child: orderAsync.when(
            loading: () => const Center(
              key: ValueKey(TestKeys.loadingIndicator),
              child: CircularProgressIndicator(),
            ),
            error: (_, _) => const Center(
              key: ValueKey(TestKeys.errorState),
              child: Text('Gagal memuat pesanan'),
            ),
            data: (order) {
              final eta = order == null
                  ? '-'
                  : DateFormatter.shortMs(order.estimatedDeliveryMs);
              return Padding(
                padding: AppSpacing.pagePadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        LucideIcons.check,
                        size: 44,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Pesanan Berhasil!',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      order?.orderNumber ?? orderId,
                      key: const ValueKey(TestKeys.orderConfirmationNumber),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (order != null) ...[
                      Text(
                        'Total ${CurrencyFormatter.rupiah(order.totalIdr)}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Estimasi tiba: $eta',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        key: const ValueKey(TestKeys.viewOrderDetailButton),
                        // push (bukan go) → Order Detail dapat tombol back
                        // untuk kembali ke layar konfirmasi ini.
                        onPressed: () => context.push('/order/$orderId'),
                        icon: const Icon(LucideIcons.package),
                        label: const Text('Lihat Detail Pesanan'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        key: const ValueKey(TestKeys.backToHomeButton),
                        onPressed: () => context.go('/home'),
                        child: const Text('Kembali ke Beranda'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
