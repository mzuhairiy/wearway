import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/features/auth/providers/auth_controller.dart';
import 'package:wearway_flutter/features/dev/dev_menu_sheet.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Tab Profile. Login → info user + menu; guest → prompt login.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: authState.when(
        loading: () => const Center(
          key: ValueKey(TestKeys.loadingIndicator),
          child: CircularProgressIndicator(),
        ),
        error: (_, _) => const Center(
          key: ValueKey(TestKeys.errorState),
          child: Text('Gagal memuat profil'),
        ),
        data: (user) =>
            user == null ? const _GuestView() : _ProfileView(user: user),
      ),
    );
  }
}

/// Tampilan guest (belum login).
class _GuestView extends StatelessWidget {
  const _GuestView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      key: const ValueKey(TestKeys.profileScreen),
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.userRound,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Belum masuk', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Login untuk mulai belanja, checkout, dan lihat pesanan.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              key: const ValueKey(TestKeys.loginPromptButton),
              onPressed: () => context.go('/auth/login'),
              icon: const Icon(LucideIcons.logIn),
              label: const Text('Masuk / Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tampilan user login.
class _ProfileView extends ConsumerWidget {
  const _ProfileView({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return ListView(
      key: const ValueKey(TestKeys.profileScreen),
      padding: AppSpacing.pagePadding,
      children: [
        Row(
          children: [
            // Long-press avatar → dev menu (kontrak testability Prompt 8).
            GestureDetector(
              key: const ValueKey(TestKeys.devMenuTrigger),
              onLongPress: () => _showDevMenu(context),
              child: CircleAvatar(
                key: const ValueKey(TestKeys.profileAvatar),
                radius: 32,
                child: Text(initial, style: theme.textTheme.headlineSmall),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    key: const ValueKey(TestKeys.profileName),
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    user.email,
                    key: const ValueKey(TestKeys.profileEmail),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Card(
          child: Column(
            children: [
              ListTile(
                key: const ValueKey(TestKeys.profileAddressesLink),
                leading: const Icon(LucideIcons.mapPin),
                title: const Text('Alamat Tersimpan'),
                trailing: const Icon(LucideIcons.chevronRight),
                // push (bukan go) → AppBar Address Book dapat tombol back.
                onTap: () => context.push('/profile/addresses'),
              ),
              ListTile(
                key: const ValueKey(TestKeys.profileOrdersLink),
                leading: const Icon(LucideIcons.package),
                title: const Text('Riwayat Pesanan'),
                trailing: const Icon(LucideIcons.chevronRight),
                // push (bukan go) → AppBar Riwayat Pesanan dapat tombol back.
                onTap: () => context.push('/order-history'),
              ),
              ListTile(
                key: const ValueKey(TestKeys.profileSettingsLink),
                leading: const Icon(LucideIcons.settings),
                title: const Text('Pengaturan'),
                trailing: const Icon(LucideIcons.chevronRight),
                // push → AppBar Settings dapat tombol back.
                onTap: () => context.push('/settings'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        OutlinedButton.icon(
          key: const ValueKey(TestKeys.logoutButton),
          onPressed: () =>
              unawaited(ref.read(authControllerProvider.notifier).logout()),
          icon: const Icon(LucideIcons.logOut),
          label: const Text('Keluar'),
        ),
      ],
    );
  }

  void _showDevMenu(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) => const DevMenuSheet(),
      ),
    );
  }
}
