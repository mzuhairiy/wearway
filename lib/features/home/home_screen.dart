import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/shared/widgets/placeholder_screen.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Tab Home (placeholder Prompt 1; browse experience dibangun di Prompt 4).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'WearWay',
      icon: LucideIcons.shirt,
      bodyKey: TestKeys.homeScreen,
    );
  }
}
