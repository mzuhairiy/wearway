import 'package:flutter/material.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/order_status.dart';
import 'package:wearway_flutter/features/order/order_status_display.dart';

/// Chip status order (dipakai di kartu Order History & header detail).
class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final (bg, fg) = switch (status) {
      OrderStatus.delivered => (cs.primaryContainer, cs.onPrimaryContainer),
      OrderStatus.cancelled => (cs.errorContainer, cs.onErrorContainer),
      _ => (cs.secondaryContainer, cs.onSecondaryContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        status.label,
        style: theme.textTheme.labelMedium?.copyWith(color: fg),
      ),
    );
  }
}
