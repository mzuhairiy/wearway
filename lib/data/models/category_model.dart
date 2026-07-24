import 'package:hive_ce/hive_ce.dart';

part 'category_model.g.dart';

/// Kategori produk (T-Shirt, Hoodie, dst.). `iconName` = key lucide icon.
@HiveType(typeId: 1)
class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.iconName,
    required this.order,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String slug;
  @HiveField(3)
  final String iconName;
  @HiveField(4)
  final int order;
}
