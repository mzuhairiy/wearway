import 'package:flutter/widgets.dart';

/// Spacing scale terpusat (4/8/12/16/24/32) — JANGAN hardcode angka padding
/// di widget, selalu refer ke sini. `abstract final class` = static-only,
/// gak bisa di-instantiate (mirip namespace konstanta di TS).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  // EdgeInsets siap pakai untuk padding umum.
  static const EdgeInsets pagePadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
}

/// Border radius standar aplikasi.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 999;
}
