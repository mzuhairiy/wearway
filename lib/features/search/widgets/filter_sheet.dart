import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/providers/catalog_providers.dart';
import 'package:wearway_flutter/features/search/providers/search_controller.dart';
import 'package:wearway_flutter/utils/currency_formatter.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

const double _maxPrice = 1000000;
const List<String> _sizeOptions = ['S', 'M', 'L', 'XL'];

/// Bottom sheet filter pencarian (kategori, size, harga, in-stock).
class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const FilterSheet(),
    );
  }

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late Set<String> _categoryIds;
  late Set<String> _sizes;
  late RangeValues _priceRange;
  late bool _inStockOnly;

  @override
  void initState() {
    super.initState();
    final s = ref.read(searchControllerProvider);
    _categoryIds = s.categoryIds.toSet();
    _sizes = s.sizes.toSet();
    _priceRange = RangeValues(
      (s.minPriceIdr ?? 0).toDouble(),
      (s.maxPriceIdr ?? _maxPrice).toDouble(),
    );
    _inStockOnly = s.inStockOnly;
  }

  void _apply() {
    final min = _priceRange.start.round();
    final max = _priceRange.end.round();
    ref
        .read(searchControllerProvider.notifier)
        .setFilters(
          categoryIds: _categoryIds.toList(),
          sizes: _sizes.toList(),
          minPriceIdr: min > 0 ? min : null,
          maxPriceIdr: max < _maxPrice ? max : null,
          inStockOnly: _inStockOnly,
        );
    Navigator.pop(context);
  }

  void _clear() {
    setState(() {
      _categoryIds = {};
      _sizes = {};
      _priceRange = const RangeValues(0, _maxPrice);
      _inStockOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ref.watch(categoryListProvider).value ?? const [];

    return Padding(
      key: const ValueKey(TestKeys.filterSheet),
      padding: AppSpacing.pagePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.lg),
          Text('Kategori', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final c in categories)
                FilterChip(
                  key: ValueKey(TestKeys.filterCategory(c.slug)),
                  label: Text(c.name),
                  selected: _categoryIds.contains(c.id),
                  onSelected: (sel) => setState(() {
                    if (sel) {
                      _categoryIds.add(c.id);
                    } else {
                      _categoryIds.remove(c.id);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Ukuran', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final size in _sizeOptions)
                FilterChip(
                  key: ValueKey(TestKeys.filterSize(size)),
                  label: Text(size),
                  selected: _sizes.contains(size),
                  onSelected: (sel) => setState(() {
                    if (sel) {
                      _sizes.add(size);
                    } else {
                      _sizes.remove(size);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Rentang Harga', style: theme.textTheme.titleSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CurrencyFormatter.rupiah(_priceRange.start.round()),
                key: const ValueKey(TestKeys.filterPriceMin),
                style: theme.textTheme.bodySmall,
              ),
              Text(
                CurrencyFormatter.rupiah(_priceRange.end.round()),
                key: const ValueKey(TestKeys.filterPriceMax),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          RangeSlider(
            values: _priceRange,
            max: _maxPrice,
            divisions: 20,
            onChanged: (v) => setState(() => _priceRange = v),
          ),
          SwitchListTile(
            key: const ValueKey(TestKeys.filterInStock),
            contentPadding: EdgeInsets.zero,
            title: const Text('Hanya yang tersedia'),
            value: _inStockOnly,
            onChanged: (v) => setState(() => _inStockOnly = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: const ValueKey(TestKeys.filterClear),
                  onPressed: _clear,
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton(
                  key: const ValueKey(TestKeys.filterApply),
                  onPressed: _apply,
                  child: const Text('Terapkan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
