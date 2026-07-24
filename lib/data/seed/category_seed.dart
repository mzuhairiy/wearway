import 'package:wearway_flutter/data/models/category_model.dart';

/// 6 kategori deterministic.
/// `iconName` = slug (di-map ke IconData di Prompt 4).
abstract final class CategorySeed {
  static const List<CategoryModel> all = [
    CategoryModel(
      id: 'cat_tshirt',
      name: 'T-Shirt',
      slug: 'tshirt',
      iconName: 'tshirt',
      order: 0,
    ),
    CategoryModel(
      id: 'cat_hoodie',
      name: 'Hoodie',
      slug: 'hoodie',
      iconName: 'hoodie',
      order: 1,
    ),
    CategoryModel(
      id: 'cat_pants',
      name: 'Pants',
      slug: 'pants',
      iconName: 'pants',
      order: 2,
    ),
    CategoryModel(
      id: 'cat_shoes',
      name: 'Shoes',
      slug: 'shoes',
      iconName: 'shoes',
      order: 3,
    ),
    CategoryModel(
      id: 'cat_bags',
      name: 'Bags',
      slug: 'bags',
      iconName: 'bags',
      order: 4,
    ),
    CategoryModel(
      id: 'cat_accessories',
      name: 'Accessories',
      slug: 'accessories',
      iconName: 'accessories',
      order: 5,
    ),
  ];
}
