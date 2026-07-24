import 'package:hive_ce/hive_ce.dart';

part 'user_model.g.dart';

/// User customer. `passwordHash` = format "salt:sha256" (lihat PasswordHasher).
@HiveType(typeId: 2)
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.name,
    required this.createdAtMs,
    this.phone,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String passwordHash;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final String? phone;
  @HiveField(5)
  final int createdAtMs;

  UserModel copyWith({String? name, String? phone}) {
    return UserModel(
      id: id,
      email: email,
      passwordHash: passwordHash,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAtMs: createdAtMs,
    );
  }
}
