import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Hashing password lokal (SHA256 + salt). Format tersimpan: `salt:hashHex`.
///
/// Ini BUKAN untuk backend production — cukup untuk local mock app supaya
/// password tidak plaintext di Hive (rule security CLAUDE.md).
abstract final class PasswordHasher {
  /// Hash [password]. Kalau [salt] null → generate salt acak (untuk register).
  /// Untuk seed WAJIB kirim salt fixed supaya deterministic (no random).
  static String hash(String password, {String? salt}) {
    final effectiveSalt = salt ?? _randomSalt();
    final digest = sha256.convert(utf8.encode('$effectiveSalt$password'));
    return '$effectiveSalt:$digest';
  }

  /// Verifikasi [password] terhadap nilai tersimpan (`salt:hash`).
  static bool verify(String password, String stored) {
    final parts = stored.split(':');
    if (parts.length != 2) return false;
    final salt = parts.first;
    final expected = parts.last;
    final actual = sha256.convert(utf8.encode('$salt$password')).toString();
    // Bandingkan konstan-ish (panjang sama) — cukup untuk local app.
    return _constantTimeEquals(actual, expected);
  }

  static String _randomSalt() {
    final rng = Random.secure();
    // 16 byte salt → hex.
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}
