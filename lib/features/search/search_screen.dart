import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/features/search/providers/search_controller.dart';
import 'package:wearway_flutter/features/search/widgets/filter_sheet.dart';
import 'package:wearway_flutter/shared/widgets/product_card.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Layar Search: search bar (debounce 300ms) + filter sheet + grid hasil.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(searchControllerProvider).query;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchControllerProvider.notifier).setQuery(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchControllerProvider);
    final filterCount = state.activeFilterCount;

    return Scaffold(
      key: const ValueKey(TestKeys.searchScreen),
      appBar: AppBar(title: const Text('Cari')),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.pagePadding,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const ValueKey(TestKeys.searchInput),
                    controller: _controller,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    onChanged: _onQueryChanged,
                    decoration: const InputDecoration(
                      hintText: 'Cari produk...',
                      prefixIcon: Icon(LucideIcons.search),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Badge(
                  isLabelVisible: filterCount > 0,
                  label: Text('$filterCount'),
                  child: IconButton.filledTonal(
                    key: const ValueKey(TestKeys.filterButton),
                    onPressed: () => FilterSheet.show(context),
                    icon: const Icon(LucideIcons.slidersHorizontal),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.hasCriteria
                ? const _Results()
                : const _InitialPrompt(),
          ),
        ],
      ),
    );
  }
}

class _InitialPrompt extends StatelessWidget {
  const _InitialPrompt();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      key: const ValueKey(TestKeys.emptySearchState),
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.search,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Ketik nama produk atau atur filter untuk mulai mencari.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchControllerProvider).query;
    final results = ref.watch(searchResultsProvider);

    return results.when(
      loading: () => const Center(
        key: ValueKey(TestKeys.loadingIndicator),
        child: CircularProgressIndicator(),
      ),
      error: (_, _) => const Center(
        key: ValueKey(TestKeys.errorState),
        child: Text('Gagal memuat hasil'),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Center(
            key: const ValueKey(TestKeys.emptySearchState),
            child: Padding(
              padding: AppSpacing.pagePadding,
              child: Text(
                query.trim().isEmpty
                    ? 'Tidak ada produk yang cocok dengan filter.'
                    : "Tidak ada hasil untuk '$query'.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }
        return GridView.builder(
          key: const ValueKey(TestKeys.searchResults),
          padding: AppSpacing.pagePadding,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.62,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) => ProductCard(product: items[i]),
        );
      },
    );
  }
}
