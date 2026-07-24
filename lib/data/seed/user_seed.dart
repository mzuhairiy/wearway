import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/data/seed/seed_constants.dart';
import 'package:wearway_flutter/utils/password_hasher.dart';

/// 2 user seed. Password hash pakai salt FIXED (deterministic — no random
/// di seed). Kredensial: lihat CLAUDE.md (`Customer123!`).
abstract final class UserSeed {
  /// ID user utama (punya address + order history) — dipakai seed lain.
  static const String customerId = 'user_customer_01';
  static const String customer2Id = 'user_customer_02';

  /// Salt tetap khusus seed (registrasi asli tetap pakai salt acak).
  static const String _seedSalt = 'wearway_seed_salt_v1';

  static const String _seedPassword = 'Customer123!';

  static List<UserModel> get all => [
    UserModel(
      id: customerId,
      email: 'customer@example.com',
      passwordHash: PasswordHasher.hash(_seedPassword, salt: _seedSalt),
      name: 'Customer Utama',
      phone: '081200000001',
      createdAtMs: seedReferenceDate.millisecondsSinceEpoch,
    ),
    UserModel(
      id: customer2Id,
      email: 'customer2@example.com',
      passwordHash: PasswordHasher.hash(_seedPassword, salt: _seedSalt),
      name: 'Customer Baru',
      createdAtMs: seedReferenceDate.millisecondsSinceEpoch,
    ),
  ];
}
