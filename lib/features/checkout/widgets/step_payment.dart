import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/features/checkout/providers/checkout_controller.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Step 3: pilih metode pembayaran (mock). Bank transfer menampilkan
/// instruksi dummy saat dipilih.
class StepPayment extends ConsumerWidget {
  const StepPayment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = ref.watch(
      checkoutControllerProvider.select((s) => s.paymentId),
    );
    final controller = ref.read(checkoutControllerProvider.notifier);

    return RadioGroup<String>(
      groupValue: selected,
      onChanged: (v) => controller.selectPayment(v!),
      child: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          for (final m in kPaymentMethods)
            Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: RadioListTile<String>(
                key: ValueKey(TestKeys.paymentMethod(m.id)),
                value: m.id,
                title: Text(m.label, style: theme.textTheme.titleMedium),
                subtitle: Text(m.subtitle),
              ),
            ),
          if (selected == 'bank_transfer')
            Card(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(LucideIcons.info, color: theme.colorScheme.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Transfer ke Virtual Account 8808 0000 1234 5678 '
                        '(a.n. WearWay). Contoh mock — tidak diproses.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
