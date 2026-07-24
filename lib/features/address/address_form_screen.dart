import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/features/address/providers/address_providers.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Form tambah/edit alamat. `existing == null` → mode tambah.
class AddressFormScreen extends ConsumerStatefulWidget {
  const AddressFormScreen({this.existing, super.key});

  final AddressModel? existing;

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _label;
  late final TextEditingController _recipient;
  late final TextEditingController _phone;
  late final TextEditingController _street;
  late final TextEditingController _city;
  late final TextEditingController _postal;
  late bool _isDefault;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final a = widget.existing;
    _label = TextEditingController(text: a?.label ?? '');
    _recipient = TextEditingController(text: a?.recipientName ?? '');
    _phone = TextEditingController(text: a?.phone ?? '');
    _street = TextEditingController(text: a?.streetAddress ?? '');
    _city = TextEditingController(text: a?.city ?? '');
    _postal = TextEditingController(text: a?.postalCode ?? '');
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    for (final c in [_label, _recipient, _phone, _street, _city, _postal]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final userId = ref.read(currentUserIdProvider)!;
    final controller = ref.read(addressControllerProvider.notifier);
    final base = AddressModel(
      id:
          widget.existing?.id ??
          'addr_${userId}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      label: _label.text.trim(),
      recipientName: _recipient.text.trim(),
      phone: _phone.text.trim(),
      streetAddress: _street.text.trim(),
      city: _city.text.trim(),
      postalCode: _postal.text.trim(),
      isDefault: _isDefault,
    );

    if (_isEdit) {
      // Pertahankan default lama kalau tidak diubah; setDefault tersendiri.
      await controller.update(base);
      if (_isDefault && !widget.existing!.isDefault) {
        await controller.setDefault(base.id);
      }
    } else {
      await controller.save(base);
    }
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey(TestKeys.addressFormScreen),
      appBar: AppBar(title: Text(_isEdit ? 'Edit Alamat' : 'Tambah Alamat')),
      body: Form(
        key: _formKey,
        child: ListView(
          key: const ValueKey(TestKeys.addressForm),
          padding: AppSpacing.pagePadding,
          children: [
            _Field(
              controller: _label,
              fieldKey: TestKeys.addressLabelInput,
              label: 'Label (mis. Rumah, Kantor)',
              validator: _required,
            ),
            _Field(
              controller: _recipient,
              fieldKey: TestKeys.addressRecipientInput,
              label: 'Nama penerima',
              validator: _required,
            ),
            _Field(
              controller: _phone,
              fieldKey: TestKeys.addressPhoneInput,
              label: 'Nomor telepon',
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _required,
            ),
            _Field(
              controller: _street,
              fieldKey: TestKeys.addressStreetInput,
              label: 'Alamat lengkap',
              maxLines: 2,
              validator: _required,
            ),
            _Field(
              controller: _city,
              fieldKey: TestKeys.addressCityInput,
              label: 'Kota',
              validator: _required,
            ),
            _Field(
              controller: _postal,
              fieldKey: TestKeys.addressPostalInput,
              label: 'Kode pos',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _required,
            ),
            CheckboxListTile(
              key: const ValueKey(TestKeys.addressDefaultCheckbox),
              contentPadding: EdgeInsets.zero,
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v ?? false),
              title: const Text('Jadikan alamat utama'),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              key: const ValueKey(TestKeys.addressFormSaveButton),
              onPressed: _saving ? null : () => unawaited(_submit()),
              child: Text(_saving ? 'Menyimpan…' : 'Simpan Alamat'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Field seragam untuk form alamat (padding + border + validator).
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.fieldKey,
    required this.label,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String fieldKey;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        key: ValueKey(fieldKey),
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
