import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/data/models/order_status.dart';

/// Tampilan (label ID + ikon + urutan) untuk OrderStatus.
/// Dipakai bareng oleh timeline, badge, dan teks notifikasi.
extension OrderStatusDisplay on OrderStatus {
  /// Label pendek Bahasa Indonesia.
  String get label => switch (this) {
    OrderStatus.placed => 'Dipesan',
    OrderStatus.preparing => 'Diproses',
    OrderStatus.shipped => 'Dikirim',
    OrderStatus.delivered => 'Tiba',
    OrderStatus.cancelled => 'Dibatalkan',
  };

  IconData get icon => switch (this) {
    OrderStatus.placed => LucideIcons.receiptText,
    OrderStatus.preparing => LucideIcons.package,
    OrderStatus.shipped => LucideIcons.truck,
    OrderStatus.delivered => LucideIcons.circleCheck,
    OrderStatus.cancelled => LucideIcons.circleX,
  };

  /// Posisi di timeline (cancelled tidak masuk urutan normal → -1).
  int get timelineIndex => switch (this) {
    OrderStatus.placed => 0,
    OrderStatus.preparing => 1,
    OrderStatus.shipped => 2,
    OrderStatus.delivered => 3,
    OrderStatus.cancelled => -1,
  };
}

/// 4 tahap normal untuk timeline (cancelled ditangani terpisah).
const List<OrderStatus> kOrderTimeline = [
  OrderStatus.placed,
  OrderStatus.preparing,
  OrderStatus.shipped,
  OrderStatus.delivered,
];
