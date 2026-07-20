import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// `part` menyambung ke file hasil codegen (build_runner). Analog: file .g.dart
// berisi provider yang di-generate dari anotasi @riverpod di bawah.
part 'theme_provider.g.dart';

/// Controller ThemeMode global (light/dark/system).
/// `@riverpod` + Notifier = state provider, AutoDispose default.
/// Settings prompt nanti bakal persist pilihan ini ke Hive box 'settings'.
@riverpod
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() => ThemeMode.system; // default ikut tema OS

  // Notifier butuh method eksplisit (bukan setter) untuk mutasi state.
  // ignore: use_setters_to_change_properties
  void setMode(ThemeMode mode) => state = mode;
}
