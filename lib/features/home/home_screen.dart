import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/category_model.dart';
import 'package:wearway_flutter/data/providers/catalog_providers.dart';
import 'package:wearway_flutter/features/categories/category_icon.dart';
import 'package:wearway_flutter/features/home/widgets/hero_banner.dart';
import 'package:wearway_flutter/shared/widgets/product_card.dart';
import 'package:wearway_flutter/shared/widgets/skeleton_box.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Tab Home: hero banner + grid kategori + produk unggulan + pull-to-refresh.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref
      ..invalidate(categoryListProvider)
      ..invalidate(featuredProductsProvider)
      ..invalidate(productListProvider);
    await ref.read(featuredProductsProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryListProvider);
    final featured = ref.watch(featuredProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WearWay'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      // RefreshIndicator = pull-to-refresh bawaan Flutter (gesture mobile).
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          key: const ValueKey(TestKeys.homeScreen),
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          children: [
            const HeroBanner(),
            const _SectionTitle('Kategori'),
            categories.when(
              loading: () => const _SectionLoader(),
              error: (_, _) => const _SectionError(),
              data: (items) => _CategoryGrid(categories: items),
            ),
            const _SectionTitle('Produk Unggulan'),
            featured.when(
              loading: () => const _FeaturedSkeleton(),
              error: (_, _) => const _SectionError(),
              data: (products) => SizedBox(
                height: 280,
                child: ListView.separated(
                  key: const ValueKey(TestKeys.featuredProductsList),
                  scrollDirection: Axis.horizontal,
                  padding: AppSpacing.pagePadding,
                  itemCount: products.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, i) => SizedBox(
                    width: 170,
                    child: ProductCard(product: products[i]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      key: const ValueKey(TestKeys.categoryGrid),
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: AppSpacing.pagePadding,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 2.6,
      children: [
        for (final category in categories) _CategoryTile(category: category),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        key: ValueKey(TestKeys.categoryItem(category.slug)),
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => context.push('/categories/${category.slug}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(
                categoryIcon(category.iconName),
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  category.name,
                  style: theme.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _SectionLoader extends StatelessWidget {
  const _SectionLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Center(
        key: ValueKey(TestKeys.loadingIndicator),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Skeleton horizontal produk unggulan (loading state konsisten).
class _FeaturedSkeleton extends StatelessWidget {
  const _FeaturedSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        key: const ValueKey(TestKeys.loadingIndicator),
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.pagePadding,
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, _) =>
            const SizedBox(width: 170, child: ProductCardSkeleton()),
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Center(
        key: ValueKey(TestKeys.errorState),
        child: Text('Gagal memuat data'),
      ),
    );
  }
}
