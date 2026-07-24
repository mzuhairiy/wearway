import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/features/address/providers/address_providers.dart';
import 'package:wearway_flutter/features/checkout/providers/checkout_controller.dart';
import 'package:wearway_flutter/permissions/permission_service.dart';
import 'package:wearway_flutter/shared/utils/app_toast.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Step 1: alamat pengiriman. Detect (location permission) / alamat tersimpan /
/// isi manual. Field manual sinkron ke CheckoutController.
class StepAddress extends ConsumerStatefulWidget {
  const StepAddress({super.key});

  @override
  ConsumerState<StepAddress> createState() => _StepAddressState();
}

class _StepAddressState extends ConsumerState<StepAddress> {
  final _recipient = TextEditingController();
  final _phone = TextEditingController();
  final _street = TextEditingController();
  final _city = TextEditingController();
  final _postal = TextEditingController();
  bool _detecting = false;

  @override
  void initState() {
    super.initState();
    final s = ref.read(checkoutControllerProvider);
    _recipient.text = s.recipientName;
    _phone.text = s.phone;
    _street.text = s.street;
    _city.text = s.city;
    _postal.text = s.postalCode;
  }

  @override
  void dispose() {
    for (final c in [_recipient, _phone, _street, _city, _postal]) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncFields() {
    ref
        .read(checkoutControllerProvider.notifier)
        .setAddressFields(
          recipientName: _recipient.text,
          phone: _phone.text,
          street: _street.text,
          city: _city.text,
          postalCode: _postal.text,
        );
  }

  void _fillFrom(AddressModel a) {
    _recipient.text = a.recipientName;
    _phone.text = a.phone;
    _street.text = a.streetAddress;
    _city.text = a.city;
    _postal.text = a.postalCode;
  }

  Future<void> _detectAddress() async {
    setState(() => _detecting = true);
    final outcome = await ref.read(permissionServiceProvider).requestLocation();
    if (!mounted) return;
    setState(() => _detecting = false);

    switch (outcome) {
      case PermissionOutcome.granted:
        // Mock geocode → alamat Jakarta dummy.
        if (_recipient.text.isEmpty) _recipient.text = 'Penerima';
        _street.text = 'Jl. Jenderal Sudirman No. 52-53';
        _city.text = 'Jakarta Pusat';
        _postal.text = '10210';
        ref.read(checkoutControllerProvider.notifier).selectSavedAddress(null);
        _syncFields();
        AppToast.success('Lokasi terdeteksi — alamat diisi otomatis.');
      case PermissionOutcome.denied:
      case PermissionOutcome.restricted:
        AppToast.warning('Izin lokasi ditolak. Isi alamat manual.');
      case PermissionOutcome.permanentlyDenied:
        await _showSettingsDialog();
    }
  }

  Future<void> _showSettingsDialog() async {
    final open = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Izin lokasi dimatikan'),
        content: const Text(
          'Izin lokasi diblokir permanen. Buka Settings untuk mengaktifkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Nanti'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Buka Settings'),
          ),
        ],
      ),
    );
    if (open ?? false) {
      await ref.read(permissionServiceProvider).openSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addressesAsync = ref.watch(savedAddressesProvider);
    final selectedId = ref.watch(
      checkoutControllerProvider.select((s) => s.selectedAddressId),
    );
    final saveAddress = ref.watch(
      checkoutControllerProvider.select((s) => s.saveAddress),
    );
    final saved = addressesAsync.value ?? const <AddressModel>[];

    return ListView(
      padding: AppSpacing.pagePadding,
      children: [
        OutlinedButton.icon(
          key: const ValueKey(TestKeys.locationPermissionButton),
          onPressed: _detecting ? null : () => unawaited(_detectAddress()),
          icon: const Icon(LucideIcons.mapPin),
          label: Text(_detecting ? 'Mendeteksi…' : 'Deteksi alamat saya'),
        ),
        if (saved.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<String>(
            key: const ValueKey(TestKeys.savedAddressDropdown),
            initialValue: selectedId,
            decoration: const InputDecoration(
              labelText: 'Pakai alamat tersimpan',
            ),
            items: [
              for (final a in saved)
                DropdownMenuItem(
                  key: ValueKey(TestKeys.useSavedAddress(a.id)),
                  value: a.id,
                  child: Text('${a.label} • ${a.city}'),
                ),
            ],
            onChanged: (id) {
              ref
                  .read(checkoutControllerProvider.notifier)
                  .selectSavedAddress(id);
              final match = saved.where((a) => a.id == id).firstOrNull;
              if (match != null) _fillFrom(match);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'atau isi alamat baru di bawah',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        _AddressField(
          controller: _recipient,
          fieldKey: TestKeys.addressRecipientInput,
          label: 'Nama penerima',
          onChanged: _syncFields,
        ),
        _AddressField(
          controller: _phone,
          fieldKey: TestKeys.addressPhoneInput,
          label: 'Nomor telepon',
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: _syncFields,
        ),
        _AddressField(
          controller: _street,
          fieldKey: TestKeys.addressStreetInput,
          label: 'Alamat lengkap',
          maxLines: 2,
          onChanged: _syncFields,
        ),
        _AddressField(
          controller: _city,
          fieldKey: TestKeys.addressCityInput,
          label: 'Kota',
          onChanged: _syncFields,
        ),
        _AddressField(
          controller: _postal,
          fieldKey: TestKeys.addressPostalInput,
          label: 'Kode pos',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: _syncFields,
        ),
        CheckboxListTile(
          key: const ValueKey(TestKeys.addressSaveCheckbox),
          contentPadding: EdgeInsets.zero,
          value: saveAddress,
          onChanged: (v) => ref
              .read(checkoutControllerProvider.notifier)
              .setSaveAddress(value: v ?? false),
          title: const Text('Simpan sebagai alamat baru'),
        ),
      ],
    );
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField({
    required this.controller,
    required this.fieldKey,
    required this.label,
    required this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String fieldKey;
  final String label;
  final VoidCallback onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextField(
        key: ValueKey(fieldKey),
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        onChanged: (_) => onChanged(),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
