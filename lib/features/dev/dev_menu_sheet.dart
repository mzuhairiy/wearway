import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/providers/catalog_providers.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';
import 'package:wearway_flutter/data/seed/seed_constants.dart';
import 'package:wearway_flutter/features/auth/providers/auth_controller.dart';
import 'package:wearway_flutter/features/dev/dev_providers.dart';
import 'package:wearway_flutter/notifications/notification_service.dart';
import 'package:wearway_flutter/notifications/order_status_scheduler.dart';
import 'package:wearway_flutter/shared/providers/theme_provider.dart';
import 'package:wearway_flutter/shared/utils/app_toast.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Versi app (build info) — sinkron dengan `pubspec.yaml` version.
const String _kAppVersion = '1.0.0+1';

/// Dev menu (long-press avatar Profile). Reset data, speed-up simulasi,
/// clear notif, skip login, info versi. State toggle disimpan di Hive settings.
class DevMenuSheet extends ConsumerStatefulWidget {
  const DevMenuSheet({super.key});

  @override
  ConsumerState<DevMenuSheet> createState() => _DevMenuSheetState();
}

class _DevMenuSheetState extends ConsumerState<DevMenuSheet> {
  late bool _speedUp;
  late bool _skipLogin;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsRepositoryProvider);
    _speedUp = settings.getSpeedUpOrders();
    _skipLogin = settings.getSkipLogin();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dev Menu', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),

            // Speed up simulasi status order (30s → 5s).
            SwitchListTile(
              key: const ValueKey(TestKeys.devSpeedUpToggle),
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(LucideIcons.gauge),
              title: const Text('Percepat simulasi order'),
              subtitle: const Text('30s → 5s per tahap (untuk E2E test)'),
              value: _speedUp,
              onChanged: _onSpeedUpChanged,
            ),

            // Auto-login sebagai user seed saat startup.
            SwitchListTile(
              key: const ValueKey(TestKeys.devSkipLoginToggle),
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(LucideIcons.logIn),
              title: const Text('Skip login (auto-login)'),
              subtitle: const Text('Login otomatis sbg customer@example.com'),
              value: _skipLogin,
              onChanged: _onSkipLoginChanged,
            ),

            const Divider(),

            ListTile(
              key: const ValueKey(TestKeys.devClearNotifButton),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.bellOff),
              title: const Text('Bersihkan notifikasi terjadwal'),
              onTap: () => unawaited(_clearNotifications()),
            ),
            ListTile(
              key: const ValueKey(TestKeys.devResetButton),
              contentPadding: EdgeInsets.zero,
              leading: Icon(LucideIcons.trash2, color: theme.colorScheme.error),
              title: Text(
                'Reset semua data',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              subtitle: const Text('Hapus & seed ulang (keluar dari akun)'),
              onTap: () => unawaited(_resetData()),
            ),

            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                'Seed v$seedVersion • App $_kAppVersion',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSpeedUpChanged(bool value) async {
    await ref.read(settingsRepositoryProvider).setSpeedUpOrders(value: value);
    // Order berikut pakai interval baru (scheduler dibangun ulang).
    ref.invalidate(orderStatusSchedulerProvider);
    if (mounted) setState(() => _speedUp = value);
  }

  Future<void> _onSkipLoginChanged(bool value) async {
    await ref.read(settingsRepositoryProvider).setSkipLogin(value: value);
    if (mounted) setState(() => _skipLogin = value);
  }

  Future<void> _clearNotifications() async {
    ref.read(orderStatusSchedulerProvider).cancelAll();
    await ref.read(notificationServiceProvider).cancelAll();
    if (!mounted) return;
    Navigator.of(context).pop();
    AppToast.success('Notifikasi terjadwal dibersihkan.');
  }

  Future<void> _resetData() async {
    final navigator = Navigator.of(context);
    final router = GoRouter.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset semua data?'),
        content: const Text(
          'Semua data (order, alamat, keranjang, sesi) dihapus dan '
          'di-seed ulang. Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => context.pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    ref.read(orderStatusSchedulerProvider).cancelAll();
    await ref.read(notificationServiceProvider).cancelAll();
    await ref.read(seedManagerProvider).resetSeed();

    // Refresh state yang bergantung ke data/settings yang baru di-clear.
    ref
      ..invalidate(authControllerProvider)
      ..invalidate(themeModeControllerProvider)
      ..invalidate(productListProvider)
      ..invalidate(featuredProductsProvider)
      ..invalidate(categoryListProvider);

    navigator.pop();
    router.go('/home');
    AppToast.success('Data di-reset ke kondisi awal.');
  }
}
