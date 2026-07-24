import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/category_model.dart';
import 'package:wearway_flutter/data/providers/catalog_providers.dart';
import 'package:wearway_flutter/features/categories/category_icon.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Tab Categories: grid semua kategori + jumlah produk per kategori.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref
      ..invalidate(categoryListProvider)
      ..invalidate(productListProvider);
    await ref.read(categoryListProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryListProvider);
    // Hitung jumlah produk per kategori dari daftar produk (reaktif).
    final products = ref.watch(productListProvider).value ?? const [];
    final countByCategory = <String, int>{};
    for (final p in products) {
      countByCategory[p.categoryId] = (countByCategory[p.categoryId] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Kategori')),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: categories.when(
          loading: () => const Center(
            key: ValueKey(TestKeys.loadingIndicator),
            child: CircularProgressIndicator(),
          ),
          error: (_, _) => ListView(
            children: const [
              SizedBox(height: 200),
              Center(
                key: ValueKey(TestKeys.errorState),
                child: Text('Gagal memuat kategori'),
              ),
            ],
          ),
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(
                    key: ValueKey(TestKeys.emptyState),
                    child: Text('Belum ada kategori'),
                  ),
                ],
              );
            }
            return GridView.count(
              key: const ValueKey(TestKeys.categoryGrid),
              crossAxisCount: 2,
              padding: AppSpacing.pagePadding,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.3,
              children: [
                for (final category in items)
                  _CategoryGridItem(
                    category: category,
                    productCount: countByCategory[category.id] ?? 0,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  const _CategoryGridItem({required this.category, required this.productCount});

  final CategoryModel category;
  final int productCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        key: ValueKey(TestKeys.categoryGridItem(category.slug)),
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => context.push('/categories/${category.slug}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                categoryIcon(category.iconName),
                size: 40,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(category.name, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '$productCount produk',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
