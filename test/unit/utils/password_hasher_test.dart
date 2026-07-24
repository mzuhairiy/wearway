import 'package:flutter_test/flutter_test.dart';
import 'package:wearway_flutter/utils/password_hasher.dart';

void main() {
  group('PasswordHasher', () {
    test('hash tidak sama dengan plaintext', () {
      final stored = PasswordHasher.hash('Customer123!');
      expect(stored, isNot(contains('Customer123!')));
      expect(stored, contains(':')); // format salt:hash
    });

    test('verify true untuk password benar', () {
      final stored = PasswordHasher.hash('Customer123!');
      expect(PasswordHasher.verify('Customer123!', stored), isTrue);
    });

    test('verify false untuk password salah', () {
      final stored = PasswordHasher.hash('Customer123!');
      expect(PasswordHasher.verify('wrong-pass', stored), isFalse);
    });

    test('salt fixed → hash deterministic (untuk seed)', () {
      final a = PasswordHasher.hash('Customer123!', salt: 'seed_salt');
      final b = PasswordHasher.hash('Customer123!', salt: 'seed_salt');
      expect(a, equals(b));
    });

    test('salt acak → dua hash berbeda untuk password sama', () {
      final a = PasswordHasher.hash('Customer123!');
      final b = PasswordHasher.hash('Customer123!');
      expect(a, isNot(equals(b)));
      // Tapi keduanya tetap verify benar.
      expect(PasswordHasher.verify('Customer123!', a), isTrue);
      expect(PasswordHasher.verify('Customer123!', b), isTrue);
    });

    test('verify false untuk stored yang malformed', () {
      expect(PasswordHasher.verify('x', 'no-colon-format'), isFalse);
    });
  });
}
