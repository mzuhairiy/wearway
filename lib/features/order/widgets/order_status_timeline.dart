import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/order_status.dart';
import 'package:wearway_flutter/features/order/order_status_display.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Timeline 4 tahap (Placed → Preparing → Shipped → Delivered).
/// Tahap ≤ status sekarang = selesai (check); tahap aktif = highlight.
class OrderStatusTimeline extends StatelessWidget {
  const OrderStatusTimeline({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Order dibatalkan → tampilkan state khusus, bukan timeline normal.
    if (status == OrderStatus.cancelled) {
      return Card(
        key: const ValueKey(TestKeys.orderStatusTimeline),
        color: theme.colorScheme.errorContainer,
        child: ListTile(
          leading: Icon(
            LucideIcons.circleX,
            color: theme.colorScheme.onErrorContainer,
          ),
          title: Text(
            'Pesanan Dibatalkan',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
        ),
      );
    }

    final currentIndex = status.timelineIndex;

    return Card(
      key: const ValueKey(TestKeys.orderStatusTimeline),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            for (var i = 0; i < kOrderTimeline.length; i++)
              _TimelineStep(
                status: kOrderTimeline[i],
                done: i <= currentIndex,
                active: i == currentIndex,
                isLast: i == kOrderTimeline.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.status,
    required this.done,
    required this.active,
    required this.isLast,
  });

  final OrderStatus status;
  final bool done;
  final bool active;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final onColor = done ? cs.onPrimary : cs.onSurfaceVariant;
    final circleColor = done ? cs.primary : cs.surfaceContainerHighest;

    return IntrinsicHeight(
      child: Row(
        key: ValueKey(TestKeys.orderStatusStep(status.name)),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Kolom ikon + garis penghubung.
          Column(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: circleColor,
                child: Icon(
                  done ? LucideIcons.check : status.icon,
                  size: 18,
                  color: onColor,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: done ? cs.primary : cs.outlineVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.sm,
                bottom: AppSpacing.lg,
              ),
              child: Text(
                status.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  color: done ? cs.onSurface : cs.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
