import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/shared/widgets/product_image.dart';
import 'package:wearway_flutter/utils/currency_formatter.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Kartu produk reusable (home featured, category grid, search, related).
/// Tap → /product/:id. ValueKey komposit: product_card_{productId}.
class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSale = product.isOnSale;

    return Card(
      key: ValueKey(TestKeys.productCard(product.id)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push('/product/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded → gambar mengisi sisa tinggi kartu (anti-overflow di
            // berbagai tinggi container: featured row / grid).
            Expanded(child: _Thumbnail(product: product)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.star,
                        size: 14,
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${product.rating} (${product.reviewCount})',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    CurrencyFormatter.rupiah(product.discountedPriceIdr),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: onSale ? theme.colorScheme.error : null,
                    ),
                  ),
                  if (onSale)
                    Text(
                      CurrencyFormatter.rupiah(product.priceIdr),
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gambar 1:1 + badge (Sale / New) di pojok kanan atas.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final badgeLabel = _badgeLabel();

    return SizedBox(
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ProductImage(
            imageUrl: product.imageUrls.isNotEmpty
                ? product.imageUrls.first
                : '',
            semanticLabel: product.name,
          ),
          if (badgeLabel != null)
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: _Badge(label: badgeLabel),
            ),
        ],
      ),
    );
  }

  String? _badgeLabel() {
    if (product.isOnSale) return '-${product.discountPercent}%';
    if (product.badges.contains('New')) return 'New';
    return null;
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.error,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onError,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
