import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/data/seed/seed_constants.dart';

/// Spec per kategori — dipakai builder untuk generate 10 produk deterministic.
class _CatSpec {
  const _CatSpec({
    required this.categoryId,
    required this.slug,
    required this.noun,
    required this.minPrice,
    required this.maxPrice,
    required this.sizes,
    required this.baseRatingX10,
    required this.baseReviews,
    required this.reviewStep,
    required this.signatureBadge,
  });

  final String categoryId;
  final String slug;
  final String noun;
  final int minPrice;
  final int maxPrice;
  final List<String> sizes;
  final int baseRatingX10;
  final int baseReviews;
  final int reviewStep;
  final String signatureBadge;
}

/// 60 produk fashion deterministic (10 per 6 kategori). Tanpa random/DateTime.
abstract final class ProductSeed {
  // Palet warna & gaya — variasi deterministic via index.
  static const _colors = [
    'black',
    'white',
    'navy',
    'gray',
    'olive',
    'sand',
    'maroon',
    'cream',
    'blue',
    'green',
  ];

  static const _styles = [
    'Classic',
    'Everyday',
    'Premium',
    'Urban',
    'Heritage',
    'Essential',
    'Signature',
    'Relaxed',
    'Tailored',
    'Limited',
  ];

  static const _specs = [
    _CatSpec(
      categoryId: 'cat_tshirt',
      slug: 'tshirt',
      noun: 'Tee',
      minPrice: 89000,
      maxPrice: 149000,
      sizes: ['S', 'M', 'L', 'XL'],
      baseRatingX10: 42,
      baseReviews: 40,
      reviewStep: 6,
      signatureBadge: 'Organic Cotton',
    ),
    _CatSpec(
      categoryId: 'cat_hoodie',
      slug: 'hoodie',
      noun: 'Hoodie',
      minPrice: 199000,
      maxPrice: 349000,
      sizes: ['S', 'M', 'L', 'XL'],
      baseRatingX10: 43,
      baseReviews: 55,
      reviewStep: 7,
      signatureBadge: 'Fleece',
    ),
    _CatSpec(
      categoryId: 'cat_pants',
      slug: 'pants',
      noun: 'Chinos',
      minPrice: 179000,
      maxPrice: 399000,
      sizes: ['S', 'M', 'L', 'XL'],
      baseRatingX10: 41,
      baseReviews: 35,
      reviewStep: 5,
      signatureBadge: 'Stretch Fit',
    ),
    _CatSpec(
      categoryId: 'cat_shoes',
      slug: 'shoes',
      noun: 'Sneakers',
      minPrice: 299000,
      maxPrice: 799000,
      sizes: ['39', '40', '41', '42', '43'],
      baseRatingX10: 45,
      baseReviews: 120,
      reviewStep: 15,
      signatureBadge: 'Bestseller',
    ),
    _CatSpec(
      categoryId: 'cat_bags',
      slug: 'bags',
      noun: 'Tote',
      minPrice: 149000,
      maxPrice: 599000,
      sizes: ['One Size'],
      baseRatingX10: 44,
      baseReviews: 60,
      reviewStep: 8,
      signatureBadge: 'Water Resistant',
    ),
    _CatSpec(
      categoryId: 'cat_accessories',
      slug: 'accessories',
      noun: 'Cap',
      minPrice: 69000,
      maxPrice: 199000,
      sizes: ['One Size'],
      baseRatingX10: 40,
      baseReviews: 25,
      reviewStep: 4,
      signatureBadge: 'New Arrival',
    ),
  ];

  /// Semua 60 produk (dihitung sekali, deterministic).
  static List<ProductModel> get all {
    final products = <ProductModel>[];
    for (var c = 0; c < _specs.length; c++) {
      final spec = _specs[c];
      for (var i = 0; i < 10; i++) {
        products.add(_build(spec, c, i));
      }
    }
    return products;
  }

  static ProductModel _build(_CatSpec spec, int catIndex, int i) {
    final globalIndex = catIndex * 10 + i;
    final nn = (i + 1).toString().padLeft(2, '0');
    final primaryColor = _colors[i % _colors.length];
    final id = 'prod_${spec.slug}_${primaryColor}_$nn';

    // Harga deterministic: interpolasi linear, dibulatkan ke ribuan.
    final span = spec.maxPrice - spec.minPrice;
    final rawPrice = spec.minPrice + (span * i ~/ 9);
    final priceIdr = (rawPrice / 1000).round() * 1000;

    // 3–5 warna, mulai dari index i (deterministic).
    final colorCount = 3 + (i % 3);
    final colors = List<String>.generate(
      colorCount,
      (k) => _colors[(i + k) % _colors.length],
    );

    final isFeatured = i % 5 == 0; // index 0 & 5 → 2 per kategori.
    final hasDiscount = i % 4 == 0; // index 0,4,8 → 3 per kategori.
    final discountPercent = hasDiscount ? 10 + (i % 3) * 5 : null;
    final stock = i == 3 ? 0 : 5 + i * 3; // index 3 → out of stock.

    final ratingX10 = (spec.baseRatingX10 + (i % 6)).clamp(0, 49);
    final reviewCount = spec.baseReviews + i * spec.reviewStep;

    final badges = <String>[
      if (i < 2) 'New',
      if (hasDiscount) 'Sale',
      spec.signatureBadge,
    ];

    final createdAtMs = seedReferenceDate
        .subtract(Duration(days: globalIndex))
        .millisecondsSinceEpoch;

    return ProductModel(
      id: id,
      slug: '${spec.slug}-$primaryColor-$nn',
      name: '${_styles[i]} ${spec.noun}',
      description:
          'WearWay ${_styles[i]} ${spec.noun.toLowerCase()} — bahan '
          'berkualitas, nyaman dipakai harian. Warna $primaryColor.',
      priceIdr: priceIdr,
      stock: stock,
      // Asset lokal (Prompt 8): file `assets/products/{id}.jpg` &
      // `{id}_2.jpg`. Kalau belum ada, ProductImage fallback ke placeholder.
      imageUrls: [
        'assets/products/$id.jpg',
        'assets/products/${id}_2.jpg',
      ],
      categoryId: spec.categoryId,
      sizes: spec.sizes,
      colors: colors,
      isFeatured: isFeatured,
      rating: ratingX10 / 10,
      reviewCount: reviewCount,
      badges: badges,
      discountPercent: discountPercent,
      createdAtMs: createdAtMs,
    );
  }
}
