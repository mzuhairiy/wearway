import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/shared/widgets/placeholder_screen.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Tab Categories (placeholder Prompt 1; grid kategori dibangun di Prompt 4).
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Categories',
      icon: LucideIcons.layoutGrid,
      bodyKey: TestKeys.categoriesScreen,
    );
  }
}
