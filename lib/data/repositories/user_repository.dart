import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:wearway_flutter/data/hive_boxes.dart';
import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/utils/password_hasher.dart';

/// Error auth yang bisa ditangani UI (bukan crash).
class AuthException implements Exception {
  const AuthException(this.code, this.message);

  final AuthErrorCode code;
  final String message;

  @override
  String toString() => 'AuthException($code): $message';
}

enum AuthErrorCode { emailTaken, userNotFound, wrongPassword }

/// Akses data user + sesi login. Password hashing SHA256 + salt (local only).
class UserRepository {
  const UserRepository({
    required Box<UserModel> usersBox,
    required Box<dynamic> metaBox,
  }) : _users = usersBox,
       _meta = metaBox;

  final Box<UserModel> _users;
  final Box<dynamic> _meta;

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required int createdAtMs,
    String? phone,
  }) async {
    final normalized = email.trim().toLowerCase();
    if (_findByEmail(normalized) != null) {
      throw const AuthException(
        AuthErrorCode.emailTaken,
        'Email sudah terdaftar.',
      );
    }
    final user = UserModel(
      id: _idForEmail(normalized),
      email: normalized,
      // Register pakai salt acak (bukan seed → random OK).
      passwordHash: PasswordHasher.hash(password),
      name: name.trim(),
      phone: phone,
      createdAtMs: createdAtMs,
    );
    await _users.put(user.id, user);
    await _meta.put(MetaKeys.currentUserId, user.id);
    return user;
  }

  Future<UserModel> login(String email, String password) async {
    final user = _findByEmail(email.trim().toLowerCase());
    if (user == null) {
      throw const AuthException(
        AuthErrorCode.userNotFound,
        'Akun tidak ditemukan.',
      );
    }
    if (!PasswordHasher.verify(password, user.passwordHash)) {
      throw const AuthException(
        AuthErrorCode.wrongPassword,
        'Password salah.',
      );
    }
    await _meta.put(MetaKeys.currentUserId, user.id);
    return user;
  }

  Future<void> logout() async => _meta.delete(MetaKeys.currentUserId);

  /// User yang sedang login (null kalau guest).
  Future<UserModel?> getCurrent() async {
    final id = _meta.get(MetaKeys.currentUserId) as String?;
    if (id == null) return null;
    return _users.get(id);
  }

  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? phone,
  }) async {
    final existing = _users.get(userId);
    if (existing == null) {
      throw const AuthException(
        AuthErrorCode.userNotFound,
        'Akun tidak ditemukan.',
      );
    }
    final updated = existing.copyWith(name: name, phone: phone);
    await _users.put(userId, updated);
    return updated;
  }

  UserModel? _findByEmail(String normalizedEmail) {
    for (final u in _users.values) {
      if (u.email == normalizedEmail) return u;
    }
    return null;
  }

  /// ID deterministic per email (unik, tanpa DateTime/random).
  static String _idForEmail(String email) {
    final digest = sha256.convert(utf8.encode(email)).toString();
    return 'user_${digest.substring(0, 12)}';
  }
}
