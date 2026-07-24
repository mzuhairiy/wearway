import 'package:hive_ce/hive_ce.dart';

part 'product_model.g.dart';

/// Produk fashion. `priceIdr` int (Rupiah, no float — rule Hive).
@HiveType(typeId: 0)
class ProductModel {
  // Constructor didahulukan (lint: sort_constructors_first).
  const ProductModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.priceIdr,
    required this.stock,
    required this.imageUrls,
    required this.categoryId,
    required this.sizes,
    required this.colors,
    required this.isFeatured,
    required this.rating,
    required this.reviewCount,
    required this.badges,
    required this.createdAtMs,
    this.discountPercent,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String slug;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final int priceIdr;
  @HiveField(5)
  final int stock;
  @HiveField(6)
  final List<String> imageUrls;
  @HiveField(7)
  final String categoryId;
  @HiveField(8)
  final List<String> sizes;
  @HiveField(9)
  final List<String> colors;
  @HiveField(10)
  final bool isFeatured;
  @HiveField(11)
  final double rating;
  @HiveField(12)
  final int reviewCount;
  @HiveField(13)
  final List<String> badges;
  @HiveField(14)
  final int? discountPercent;
  @HiveField(15)
  final int createdAtMs;

  /// Harga setelah diskon (kalau ada). Tetap int Rupiah (floor).
  int get discountedPriceIdr {
    final percent = discountPercent;
    if (percent == null || percent <= 0) return priceIdr;
    return priceIdr - (priceIdr * percent ~/ 100);
  }

  bool get isOnSale => (discountPercent ?? 0) > 0;

  bool get isOutOfStock => stock <= 0;
}
