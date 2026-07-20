import 'package:flutter/material.dart';

/// Brand palette WearWay — tema "eco" (hijau segar).
/// Warna mentah HANYA didefinisikan di sini; widget WAJIB pakai
/// `Theme.of(context).colorScheme.*`, bukan hex langsung.
abstract final class AppColors {
  /// Seed color untuk `ColorScheme.fromSeed` — hijau daun segar.
  static const Color seed = Color(0xFF2E7D53);

  // Aksen brand (dipakai buat generate scheme / highlight tertentu).
  static const Color ecoGreen = Color(0xFF2E7D53);
  static const Color ecoGreenLight = Color(0xFF5CB88A);
  static const Color sand = Color(0xFFF4EFE6); // background hangat netral

  // Warna semantik (di luar ColorScheme Material default).
  static const Color success = Color(0xFF2E7D53);
  static const Color warning = Color(0xFFE0A100);
  static const Color danger = Color(0xFFC1352E);
}
