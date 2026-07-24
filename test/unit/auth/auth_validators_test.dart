import 'package:flutter_test/flutter_test.dart';
import 'package:wearway_flutter/features/auth/auth_validators.dart';

void main() {
  group('AuthValidators.password', () {
    test('kosong → error wajib diisi', () {
      expect(AuthValidators.password(''), isNotNull);
      expect(AuthValidators.password(null), isNotNull);
    });

    test('kurang dari 8 karakter → error', () {
      expect(AuthValidators.password('1234567'), isNotNull);
    });

    test('tepat 8 karakter → valid', () {
      expect(AuthValidators.password('12345678'), isNull);
    });

    test('lebih dari 8 karakter → valid', () {
      expect(AuthValidators.password('Customer123!'), isNull);
    });
  });

  group('AuthValidators.email', () {
    test('format valid → null', () {
      expect(AuthValidators.email('a@b.com'), isNull);
    });

    test('format salah → error', () {
      expect(AuthValidators.email('bukan-email'), isNotNull);
      expect(AuthValidators.email(''), isNotNull);
    });
  });

  group('AuthValidators.confirmPassword', () {
    test('cocok → null, beda → error', () {
      expect(AuthValidators.confirmPassword('abc', 'abc'), isNull);
      expect(AuthValidators.confirmPassword('abc', 'xyz'), isNotNull);
    });
  });

  group('AuthValidators.name', () {
    test('kosong → error', () {
      expect(AuthValidators.name('  '), isNotNull);
      expect(AuthValidators.name('Budi'), isNull);
    });
  });
}
