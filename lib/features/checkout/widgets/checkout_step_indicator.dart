import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Indikator 4 step checkout di atas (Address→Delivery→Payment→Review).
/// Step selesai = check, aktif = highlight, belum = redup.
class CheckoutStepIndicator extends StatelessWidget {
  const CheckoutStepIndicator({required this.currentStep, super.key});

  final int currentStep;

  static const List<String> _labels = ['Alamat', 'Kirim', 'Bayar', 'Ulas'];
  static const List<String> _keys = [
    TestKeys.checkoutStepAddress,
    TestKeys.checkoutStepDelivery,
    TestKeys.checkoutStepPayment,
    TestKeys.checkoutStepReview,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      key: const ValueKey(TestKeys.checkoutStepIndicator),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++) ...[
            _StepDot(
              stepKey: _keys[i],
              index: i,
              label: _labels[i],
              currentStep: currentStep,
            ),
            if (i < _labels.length - 1)
              Expanded(
                child: Divider(
                  color: i < currentStep
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.stepKey,
    required this.index,
    required this.label,
    required this.currentStep,
  });

  final String stepKey;
  final int index;
  final String label;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final done = index < currentStep;
    final active = index == currentStep;
    final color = (done || active)
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest;
    final fg = (done || active)
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurfaceVariant;

    return Column(
      key: ValueKey(stepKey),
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color,
          child: done
              ? Icon(LucideIcons.check, size: 16, color: fg)
              : Text(
                  '${index + 1}',
                  style: theme.textTheme.labelMedium?.copyWith(color: fg),
                ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: active
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: active ? FontWeight.bold : null,
          ),
        ),
      ],
    );
  }
}
