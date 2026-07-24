import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/features/cart/providers/cart_providers.dart';
import 'package:wearway_flutter/features/checkout/providers/checkout_controller.dart';
import 'package:wearway_flutter/features/checkout/widgets/checkout_step_indicator.dart';
import 'package:wearway_flutter/features/checkout/widgets/step_address.dart';
import 'package:wearway_flutter/features/checkout/widgets/step_delivery.dart';
import 'package:wearway_flutter/features/checkout/widgets/step_payment.dart';
import 'package:wearway_flutter/features/checkout/widgets/step_review.dart';
import 'package:wearway_flutter/notifications/order_status_scheduler.dart';
import 'package:wearway_flutter/permissions/permission_service.dart';
import 'package:wearway_flutter/shared/utils/app_toast.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Checkout multi-step: Address → Delivery → Payment → Review → place order.
/// Route protected (butuh login, guard di app_router).
class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(checkoutControllerProvider.select((s) => s.step));
    final lines = ref.watch(cartLinesProvider);

    // Cart kosong (mis. setelah order) → jangan tampilkan form checkout.
    if (lines.isEmpty) {
      return Scaffold(
        key: const ValueKey(TestKeys.checkoutScreen),
        appBar: AppBar(title: const Text('Checkout')),
        body: const _EmptyCheckout(),
      );
    }

    return Scaffold(
      key: const ValueKey(TestKeys.checkoutScreen),
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(
        children: [
          CheckoutStepIndicator(currentStep: step),
          const Divider(height: 1),
          Expanded(child: _StepBody(step: step)),
          const _CheckoutBottomBar(),
        ],
      ),
    );
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return switch (step) {
      0 => const StepAddress(),
      1 => const StepDelivery(),
      2 => const StepPayment(),
      _ => const StepReview(),
    };
  }
}

class _EmptyCheckout extends StatelessWidget {
  const _EmptyCheckout();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      key: const ValueKey(TestKeys.emptyState),
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.shoppingCart,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Keranjang kosong', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => context.go('/home'),
              child: const Text('Belanja Dulu'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutBottomBar extends ConsumerWidget {
  const _CheckoutBottomBar();

  Future<void> _placeOrder(BuildContext context, WidgetRef ref) async {
    // Ambil router SEBELUM await: placeOrder mengosongkan cart →
    // CheckoutScreen beralih ke empty-state → widget ini unmount, jadi
    // `context` tak lagi valid. GoRouter (keepAlive) tetap hidup.
    // (Toast context-free, jadi tak perlu capture messenger.)
    final router = GoRouter.of(context);

    // Kontekstual: minta izin notifikasi (Android 13+) sebelum buat order.
    // Order tetap dibuat apapun hasil izinnya (notif dijadwalkan di Prompt 7).
    await ref.read(permissionServiceProvider).requestNotification();
    final orderId = await ref
        .read(checkoutControllerProvider.notifier)
        .placeOrder();
    if (orderId != null) {
      // Mulai simulasi status (Preparing 30s → Shipped 60s → Delivered 90s).
      ref
          .read(orderStatusSchedulerProvider)
          .scheduleOrderStatusUpdates(orderId);
      router.go('/order-confirmation/$orderId');
    } else {
      AppToast.error('Gagal membuat pesanan.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkoutControllerProvider);
    final controller = ref.read(checkoutControllerProvider.notifier);
    final isReview = state.step == 3;

    final canProceed = switch (state.step) {
      0 => state.addressValid,
      3 => state.termsAccepted && !state.isPlacing,
      _ => true,
    };

    return SafeArea(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Row(
          children: [
            if (state.step > 0)
              Expanded(
                child: OutlinedButton(
                  key: const ValueKey(TestKeys.checkoutBackButton),
                  onPressed: state.isPlacing ? null : controller.back,
                  child: const Text('Kembali'),
                ),
              ),
            if (state.step > 0) const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 2,
              child: isReview
                  ? FilledButton(
                      key: const ValueKey(TestKeys.placeOrderButton),
                      onPressed: canProceed
                          ? () => unawaited(_placeOrder(context, ref))
                          : null,
                      child: Text(
                        state.isPlacing ? 'Memproses…' : 'Buat Pesanan',
                      ),
                    )
                  : FilledButton(
                      key: const ValueKey(TestKeys.checkoutNextButton),
                      onPressed: canProceed ? controller.next : null,
                      child: const Text('Lanjut'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
