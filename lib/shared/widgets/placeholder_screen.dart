import 'package:flutter/material.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';

/// Placeholder generik untuk screen yang dibangun di prompt berikutnya.
/// StatelessWidget = widget tanpa state internal (mirip functional component RN
/// tanpa hooks). `const` constructor biar bisa di-cache Flutter.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.title,
    required this.icon,
    required this.bodyKey,
    this.showAppBar = true,
    super.key,
  });

  final String title;
  final IconData icon;

  /// ValueKey untuk body — dipakai Appium locate screen ini.
  final String bodyKey;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    // Extract sekali; jangan panggil Theme.of berkali-kali di tree.
    final theme = Theme.of(context);

    final body = Center(
      key: ValueKey(bodyKey),
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Coming soon',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );

    // Scaffold = kerangka layar Material (app bar + body + dll).
    if (!showAppBar) return Scaffold(body: body);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
    );
  }
}
