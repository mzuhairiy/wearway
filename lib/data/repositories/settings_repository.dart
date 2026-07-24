import 'package:flutter/material.dart' show ThemeMode;
import 'package:hive_ce/hive_ce.dart';
import 'package:wearway_flutter/data/hive_boxes.dart';

/// Akses preferensi app (theme, currency) di box `settings`.
class SettingsRepository {
  const SettingsRepository(this._box);

  final Box<dynamic> _box;

  ThemeMode getTheme() {
    final raw = _box.get(SettingsKeys.themeMode) as String?;
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setTheme(ThemeMode mode) async {
    await _box.put(SettingsKeys.themeMode, mode.name);
  }

  /// Currency code (default 'IDR'). Disiapkan untuk Settings di Prompt 8.
  String getCurrency() {
    return _box.get(SettingsKeys.currency, defaultValue: 'IDR') as String;
  }

  Future<void> setCurrency(String currency) async {
    await _box.put(SettingsKeys.currency, currency);
  }

  // --- Dev flags (dev menu Prompt 8) ---

  /// Speed up simulasi status order (30s → 5s per tahap) untuk E2E test.
  bool getSpeedUpOrders() {
    return _box.get(SettingsKeys.speedUpOrders, defaultValue: false) as bool;
  }

  Future<void> setSpeedUpOrders({required bool value}) async {
    await _box.put(SettingsKeys.speedUpOrders, value);
  }

  /// Auto-login sebagai customer@example.com saat startup (dev testing).
  bool getSkipLogin() {
    return _box.get(SettingsKeys.skipLogin, defaultValue: false) as bool;
  }

  Future<void> setSkipLogin({required bool value}) async {
    await _box.put(SettingsKeys.skipLogin, value);
  }
}
