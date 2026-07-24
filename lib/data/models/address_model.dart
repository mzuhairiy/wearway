import 'package:hive_ce/hive_ce.dart';

part 'address_model.g.dart';

/// Alamat pengiriman milik seorang user.
@HiveType(typeId: 3)
class AddressModel {
  const AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.streetAddress,
    required this.city,
    required this.postalCode,
    required this.isDefault,
    this.isSaved = true,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String label;
  @HiveField(3)
  final String recipientName;
  @HiveField(4)
  final String phone;
  @HiveField(5)
  final String streetAddress;
  @HiveField(6)
  final String city;
  @HiveField(7)
  final String postalCode;
  @HiveField(8)
  final bool isDefault;

  /// `false` = alamat snapshot dari checkout yang tidak disimpan user
  /// (tetap dipersist supaya order bisa referensi, tapi disembunyikan dari
  /// Address Book). `true` = alamat yang tampil di Address Book.
  @HiveField(9)
  final bool isSaved;

  AddressModel copyWith({
    String? label,
    String? recipientName,
    String? phone,
    String? streetAddress,
    String? city,
    String? postalCode,
    bool? isDefault,
    bool? isSaved,
  }) {
    return AddressModel(
      id: id,
      userId: userId,
      label: label ?? this.label,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
