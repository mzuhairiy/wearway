import 'package:hive_ce/hive_ce.dart';
import 'package:wearway_flutter/data/models/category_model.dart';

/// Akses data kategori.
class CategoryRepository {
  const CategoryRepository(this._box);

  final Box<CategoryModel> _box;

  /// Semua kategori, terurut berdasarkan `order`.
  Future<List<CategoryModel>> list() async {
    final all = _box.values.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return all;
  }

  Future<CategoryModel?> getById(String id) async => _box.get(id);

  Future<CategoryModel?> getBySlug(String slug) async {
    for (final c in _box.values) {
      if (c.slug == slug) return c;
    }
    return null;
  }
}
