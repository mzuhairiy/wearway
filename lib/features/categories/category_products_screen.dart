import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/category_model.dart';
import 'package:wearway_flutter/data/providers/catalog_providers.dart';
import 'package:wearway_flutter/shared/widgets/product_card.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Daftar produk dalam satu kategori (route /categories/:slug).
class CategoryProductsScreen extends ConsumerWidget {
  const CategoryProductsScreen({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryBySlugProvider(slug));
    final title = category.value?.name ?? 'Kategori';

    return Scaffold(
      key: const ValueKey(TestKeys.categoryProductsScreen),
      appBar: AppBar(
        title: Text(title, key: ValueKey(TestKeys.categoryHeader(slug))),
      ),
      body: category.when(
        loading: () => const Center(
          key: ValueKey(TestKeys.loadingIndicator),
          child: CircularProgressIndicator(),
        ),
        error: (_, _) => const Center(
          key: ValueKey(TestKeys.errorState),
          child: Text('Gagal memuat kategori'),
        ),
        data: (cat) => cat == null
            ? const Center(
                key: ValueKey(TestKeys.emptyState),
                child: Text('Kategori tidak ditemukan'),
              )
            : _ProductGrid(category: cat),
      ),
    );
  }
}

class _ProductGrid extends ConsumerWidget {
  const _ProductGrid({required this.category});

  final CategoryModel category;

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(productsByCategoryProvider(category.id));
    await ref.read(productsByCategoryProvider(category.id).future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsByCategoryProvider(category.id));

    return RefreshIndicator(
      onRefresh: () => _refresh(ref),
      child: products.when(
        loading: () => const Center(
          key: ValueKey(TestKeys.loadingIndicator),
          child: CircularProgressIndicator(),
        ),
        error: (_, _) => ListView(
          children: const [
            SizedBox(height: 200),
            Center(
              key: ValueKey(TestKeys.errorState),
              child: Text('Gagal memuat produk'),
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
                  child: Text('Belum ada produk di kategori ini'),
                ),
              ],
            );
          }
          return GridView.builder(
            key: const ValueKey(TestKeys.productsGrid),
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
      ),
    );
  }
}
