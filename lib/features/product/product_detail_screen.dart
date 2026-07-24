import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/data/providers/catalog_providers.dart';
import 'package:wearway_flutter/features/cart/providers/cart_providers.dart';
import 'package:wearway_flutter/shared/utils/app_toast.dart';
import 'package:wearway_flutter/shared/widgets/product_card.dart';
import 'package:wearway_flutter/shared/widgets/product_image.dart';
import 'package:wearway_flutter/utils/currency_formatter.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Detail produk: carousel (pinch-zoom), pilih size/color/qty, add to cart.
class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;

  void _addToCart(ProductModel product) {
    unawaited(
      ref
          .read(cartControllerProvider.notifier)
          .addToCart(
            productId: product.id,
            size: _selectedSize!,
            color: _selectedColor!,
            quantity: _quantity,
          ),
    );
    AppToast.success('Ditambahkan ke keranjang');
  }

  /// Beli langsung: masukkan ke keranjang lalu buka checkout.
  Future<void> _buyNow(ProductModel product) async {
    // Capture router sebelum await (BuildContext lintas async gap).
    final router = GoRouter.of(context);
    await ref
        .read(cartControllerProvider.notifier)
        .addToCart(
          productId: product.id,
          size: _selectedSize!,
          color: _selectedColor!,
          quantity: _quantity,
        );
    unawaited(router.push('/checkout'));
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(widget.productId));

    return Scaffold(
      key: const ValueKey(TestKeys.productDetailScreen),
      appBar: AppBar(),
      body: productAsync.when(
        loading: () => const Center(
          key: ValueKey(TestKeys.loadingIndicator),
          child: CircularProgressIndicator(),
        ),
        error: (_, _) => const Center(
          key: ValueKey(TestKeys.errorState),
          child: Text('Gagal memuat produk'),
        ),
        data: (product) => product == null
            ? const Center(
                key: ValueKey(TestKeys.emptyState),
                child: Text('Produk tidak ditemukan'),
              )
            : _buildDetail(product),
      ),
    );
  }

  Widget _buildDetail(ProductModel product) {
    final theme = Theme.of(context);
    final canAddToCart =
        _selectedSize != null &&
        _selectedColor != null &&
        !product.isOutOfStock;

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              _ImageCarousel(imageUrls: product.imageUrls),
              Padding(
                padding: AppSpacing.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      key: const ValueKey(TestKeys.productName),
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _RatingRow(product: product),
                    const SizedBox(height: AppSpacing.md),
                    _PriceRow(product: product),
                    const SizedBox(height: AppSpacing.sm),
                    _StockIndicator(product: product),
                    const SizedBox(height: AppSpacing.lg),
                    _SelectorLabel('Ukuran', theme: theme),
                    _SizeSelector(
                      sizes: product.sizes,
                      selected: _selectedSize,
                      onSelected: (s) => setState(() => _selectedSize = s),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _SelectorLabel('Warna', theme: theme),
                    _ColorSelector(
                      colors: product.colors,
                      selected: _selectedColor,
                      onSelected: (c) => setState(() => _selectedColor = c),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _SelectorLabel('Jumlah', theme: theme),
                    _QuantityStepper(
                      quantity: _quantity,
                      max: product.stock,
                      onChanged: (q) => setState(() => _quantity = q),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _RelatedProducts(product: product),
                  ],
                ),
              ),
            ],
          ),
        ),
        _AddToCartBar(
          enabled: canAddToCart,
          onAddToCart: () => _addToCart(product),
          onBuyNow: () => unawaited(_buyNow(product)),
        ),
      ],
    );
  }
}

class _ImageCarousel extends StatelessWidget {
  const _ImageCarousel({required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: PageView(
        key: const ValueKey(TestKeys.productImageCarousel),
        children: [
          for (var i = 0; i < imageUrls.length; i++)
            // InteractiveViewer = pinch-to-zoom bawaan Flutter.
            InteractiveViewer(
              key: ValueKey(TestKeys.productImage(i)),
              maxScale: 4,
              child: ProductImage(
                imageUrl: imageUrls[i],
                semanticLabel: 'Gambar produk ${i + 1}',
              ),
            ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(LucideIcons.star, size: 18, color: theme.colorScheme.tertiary),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '${product.rating}  •  ${product.reviewCount} ulasan',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSale = product.isOnSale;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          CurrencyFormatter.rupiah(product.discountedPriceIdr),
          key: const ValueKey(TestKeys.productPrice),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: onSale ? theme.colorScheme.error : null,
          ),
        ),
        if (onSale) ...[
          const SizedBox(width: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              CurrencyFormatter.rupiah(product.priceIdr),
              key: const ValueKey(TestKeys.productPriceOriginal),
              style: theme.textTheme.bodyMedium?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            key: const ValueKey(TestKeys.productDiscountBadge),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.error,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              '-${product.discountPercent}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onError,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _StockIndicator extends StatelessWidget {
  const _StockIndicator({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final out = product.isOutOfStock;
    return Text(
      out ? 'Habis' : 'Stok: ${product.stock}',
      key: const ValueKey(TestKeys.stockIndicator),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: out ? theme.colorScheme.error : theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SelectorLabel extends StatelessWidget {
  const _SelectorLabel(this.label, {required this.theme});

  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(label, style: theme.textTheme.titleSmall),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector({
    required this.sizes,
    required this.selected,
    required this.onSelected,
  });

  final List<String> sizes;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        for (final size in sizes)
          ChoiceChip(
            key: ValueKey(TestKeys.sizeSelector(size)),
            label: Text(size),
            selected: selected == size,
            onSelected: (_) => onSelected(size),
          ),
      ],
    );
  }
}

class _ColorSelector extends StatelessWidget {
  const _ColorSelector({
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  final List<String> colors;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        for (final color in colors)
          ChoiceChip(
            key: ValueKey(TestKeys.colorSelector(color)),
            avatar: CircleAvatar(backgroundColor: _colorFromName(color)),
            label: Text(color),
            selected: selected == color,
            onSelected: (_) => onSelected(color),
          ),
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.max,
    required this.onChanged,
  });

  final int quantity;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canDecrement = quantity > 1;
    final canIncrement = quantity < max;
    return Row(
      children: [
        IconButton.filledTonal(
          key: const ValueKey(TestKeys.qtyStepperDecrement),
          onPressed: canDecrement ? () => onChanged(quantity - 1) : null,
          icon: const Icon(LucideIcons.minus),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            '$quantity',
            key: const ValueKey(TestKeys.qtyValue),
            style: theme.textTheme.titleLarge,
          ),
        ),
        IconButton.filledTonal(
          key: const ValueKey(TestKeys.qtyStepperIncrement),
          onPressed: canIncrement ? () => onChanged(quantity + 1) : null,
          icon: const Icon(LucideIcons.plus),
        ),
      ],
    );
  }
}

class _RelatedProducts extends ConsumerWidget {
  const _RelatedProducts({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final related = ref.watch(productsByCategoryProvider(product.categoryId));

    return related.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (items) {
        final others = items.where((p) => p.id != product.id).toList();
        if (others.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Produk Terkait', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 280,
              child: ListView.separated(
                key: const ValueKey(TestKeys.relatedProductsList),
                scrollDirection: Axis.horizontal,
                itemCount: others.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, i) => SizedBox(
                  width: 170,
                  child: ProductCard(product: others[i]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({
    required this.enabled,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  final bool enabled;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.pagePadding,
        // Dua CTA: "Tambah ke Keranjang" (sekunder) + "Beli Sekarang" (primer,
        // langsung ke checkout).
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                key: const ValueKey(TestKeys.addToCartButton),
                onPressed: enabled ? onAddToCart : null,
                icon: const Icon(LucideIcons.shoppingBag),
                label: const Text('Keranjang'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: FilledButton.icon(
                key: const ValueKey(TestKeys.buyNowButton),
                onPressed: enabled ? onBuyNow : null,
                icon: const Icon(LucideIcons.zap),
                label: const Text('Beli Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _colorFromName(String name) {
  return switch (name) {
    'black' => Colors.black,
    'white' => Colors.white,
    'navy' => const Color(0xFF1B2A4A),
    'gray' => Colors.grey,
    'olive' => const Color(0xFF6B7B3A),
    'sand' => const Color(0xFFD9C7A3),
    'maroon' => const Color(0xFF7B2D3A),
    'cream' => const Color(0xFFF3EAD3),
    'blue' => Colors.blue,
    'green' => Colors.green,
    _ => Colors.grey,
  };
}
