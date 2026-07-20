import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/shared/widgets/placeholder_screen.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Tab Cart (placeholder Prompt 1; cart + swipe-to-delete di Prompt 5).
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Cart',
      icon: LucideIcons.shoppingBag,
      bodyKey: TestKeys.cartScreen,
    );
  }
}
