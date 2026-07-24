import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/features/address/providers/address_providers.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Address Book: daftar alamat tersimpan. Tap → edit, swipe → hapus,
/// tombol → tandai default. FAB → tambah alamat baru.
class AddressBookScreen extends ConsumerWidget {
  const AddressBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(savedAddressesProvider);

    return Scaffold(
      key: const ValueKey(TestKeys.addressBookScreen),
      appBar: AppBar(title: const Text('Alamat Tersimpan')),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey(TestKeys.addAddressButton),
        onPressed: () => context.push('/profile/addresses/new'),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Tambah'),
      ),
      body: addressesAsync.when(
        loading: () => const Center(
          key: ValueKey(TestKeys.loadingIndicator),
          child: CircularProgressIndicator(),
        ),
        error: (_, _) => const Center(
          key: ValueKey(TestKeys.errorState),
          child: Text('Gagal memuat alamat'),
        ),
        data: (addresses) {
          if (addresses.isEmpty) return const _EmptyAddresses();
          return ListView.separated(
            padding: AppSpacing.pagePadding,
            itemCount: addresses.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) => _AddressCard(address: addresses[i]),
          );
        },
      ),
    );
  }
}

class _EmptyAddresses extends StatelessWidget {
  const _EmptyAddresses();

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
              LucideIcons.mapPin,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Belum ada alamat', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tambahkan alamat untuk mempercepat checkout.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  const _AddressCard({required this.address});

  final AddressModel address;

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus alamat?'),
        content: Text('Hapus alamat "${address.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.read(addressControllerProvider.notifier);

    // Swipe-to-delete: hapus di confirmDismiss → return false (item hilang
    // lewat update stream, bukan state Dismissible).
    return Dismissible(
      key: ValueKey('dismiss_addr_${address.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        if (await _confirmDelete(context)) {
          await controller.delete(address.id);
        }
        return false;
      },
      background: ColoredBox(
        color: theme.colorScheme.errorContainer,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: AppSpacing.xl),
            child: Icon(LucideIcons.trash2),
          ),
        ),
      ),
      child: Card(
        key: ValueKey(TestKeys.addressItem(address.id)),
        margin: EdgeInsets.zero,
        child: InkWell(
          key: ValueKey(TestKeys.addressItemEdit(address.id)),
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: () => context.push(
            '/profile/addresses/edit',
            extra: address,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(address.label, style: theme.textTheme.titleMedium),
                    const SizedBox(width: AppSpacing.sm),
                    if (address.isDefault)
                      Chip(
                        label: const Text('Utama'),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        side: BorderSide.none,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${address.recipientName} • ${address.phone}',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  '${address.streetAddress}, ${address.city} '
                  '${address.postalCode}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (!address.isDefault)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      key: ValueKey(TestKeys.addressItemDefault(address.id)),
                      onPressed: () =>
                          unawaited(controller.setDefault(address.id)),
                      icon: const Icon(LucideIcons.star, size: 16),
                      label: const Text('Jadikan utama'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
