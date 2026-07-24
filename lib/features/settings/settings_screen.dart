import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/shared/providers/theme_provider.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Pengaturan: tema (light/dark/system) — instan & persist ke Hive.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mode = ref.watch(themeModeControllerProvider);

    return Scaffold(
      key: const ValueKey(TestKeys.settingsScreen),
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          Text('Tampilan', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          // SegmentedButton = Material 3 single-choice segmented control.
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(
                  LucideIcons.sun,
                  key: ValueKey(TestKeys.themeModeLight),
                ),
                label: Text('Terang'),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(
                  LucideIcons.moon,
                  key: ValueKey(TestKeys.themeModeDark),
                ),
                label: Text('Gelap'),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(
                  LucideIcons.smartphone,
                  key: ValueKey(TestKeys.themeModeSystem),
                ),
                label: Text('Sistem'),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (selection) => ref
                .read(themeModeControllerProvider.notifier)
                .setMode(selection.first),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Tentang', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(LucideIcons.info),
            title: Text('WearWay'),
            subtitle: Text('Versi 1.0.0+1 • demo QA portfolio'),
          ),
        ],
      ),
    );
  }
}
