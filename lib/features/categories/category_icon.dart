import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Map `iconName` (slug kategori dari seed) → IconData Lucide.
/// Dipisah dari widget supaya reusable (home & categories).
IconData categoryIcon(String iconName) {
  return switch (iconName) {
    'tshirt' => LucideIcons.shirt,
    'hoodie' => LucideIcons.shirt,
    'pants' => LucideIcons.shirt,
    'shoes' => LucideIcons.footprints,
    'bags' => LucideIcons.shoppingBag,
    'accessories' => LucideIcons.watch,
    _ => LucideIcons.shirt,
  };
}
