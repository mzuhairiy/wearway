import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/data/seed/user_seed.dart';

/// 2 alamat untuk customer utama (Rumah default + Kantor).
abstract final class AddressSeed {
  static const String homeId = 'addr_customer_01_home';
  static const String officeId = 'addr_customer_01_office';

  static const List<AddressModel> all = [
    AddressModel(
      id: homeId,
      userId: UserSeed.customerId,
      label: 'Rumah',
      recipientName: 'Customer Utama',
      phone: '081200000001',
      streetAddress: 'Jl. Melati No. 12, RT 03 / RW 05',
      city: 'Jakarta Selatan',
      postalCode: '12140',
      isDefault: true,
    ),
    AddressModel(
      id: officeId,
      userId: UserSeed.customerId,
      label: 'Kantor',
      recipientName: 'Customer Utama',
      phone: '081200000002',
      streetAddress: 'Gedung Cyber 2, Jl. HR Rasuna Said Blok X-5',
      city: 'Jakarta Selatan',
      postalCode: '12950',
      isDefault: false,
    ),
  ];
}
