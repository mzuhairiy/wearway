import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';

// `part` menyambung ke file hasil codegen (build_runner). Analog: file .g.dart
// berisi provider yang di-generate dari anotasi @riverpod di bawah.
part 'theme_provider.g.dart';

/// Controller ThemeMode global (light/dark/system), persist di Hive `settings`.
/// keepAlive: dibaca di root app (WearWayApp) → hidup selama app.
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() => ref.read(settingsRepositoryProvider).getTheme();

  /// Ganti tema → update state (instant, tanpa restart) + persist ke Hive.
  void setMode(ThemeMode mode) {
    state = mode;
    unawaited(ref.read(settingsRepositoryProvider).setTheme(mode));
  }
}
