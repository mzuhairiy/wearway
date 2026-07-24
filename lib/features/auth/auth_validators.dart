/// Validasi form auth — dipisah dari widget supaya bisa di-unit-test.
abstract final class AuthValidators {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Minimal panjang password (dipakai UI & test).
  static const int minPasswordLength = 8;

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email wajib diisi';
    if (!_emailPattern.hasMatch(v)) return 'Format email tidak valid';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password wajib diisi';
    if (v.length < minPasswordLength) {
      return 'Password minimal $minPasswordLength karakter';
    }
    return null;
  }

  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Nama wajib diisi';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if ((value ?? '') != original) return 'Konfirmasi password tidak cocok';
    return null;
  }
}
