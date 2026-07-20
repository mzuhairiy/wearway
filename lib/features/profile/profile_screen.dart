import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/shared/widgets/placeholder_screen.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Tab Profile (placeholder Prompt 1; auth + menu dibangun di Prompt 3).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Profile',
      icon: LucideIcons.user,
      bodyKey: TestKeys.profileScreen,
    );
  }
}
