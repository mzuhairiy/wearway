import 'package:hive_ce/hive_ce.dart';
import 'package:wearway_flutter/data/models/product_model.dart';

/// Filter opsional untuk query produk (dipakai Search di Prompt 5).
class ProductFilters {
  const ProductFilters({
    this.query,
    this.categoryIds = const [],
    this.sizes = const [],
    this.minPriceIdr,
    this.maxPriceIdr,
    this.inStockOnly = false,
  });

  final String? query;
  final List<String> categoryIds;
  final List<String> sizes;
  final int? minPriceIdr;
  final int? maxPriceIdr;
  final bool inStockOnly;
}

/// Akses data produk. Semua lewat sini (repository pattern —
/// no Hive di widget).
class ProductRepository {
  const ProductRepository(this._box);

  final Box<ProductModel> _box;

  Future<List<ProductModel>> list({ProductFilters? filters}) async {
    final all = _box.values.toList();
    if (filters == null) return all;
    return all.where((p) => _matches(p, filters)).toList();
  }

  Future<ProductModel?> getById(String id) async => _box.get(id);

  Future<List<ProductModel>> findByCategory(String categoryId) async {
    return _box.values.where((p) => p.categoryId == categoryId).toList();
  }

  Future<List<ProductModel>> findFeatured() async {
    return _box.values.where((p) => p.isFeatured).toList();
  }

  Future<List<ProductModel>> search(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _box.values.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();
  }

  /// Stream reaktif (dipakai StreamProvider) — emit tiap ada perubahan box.
  Stream<List<ProductModel>> watchAll() async* {
    yield _box.values.toList();
    yield* _box.watch().map((_) => _box.values.toList());
  }

  bool _matches(ProductModel p, ProductFilters f) {
    final query = f.query?.trim().toLowerCase();
    if (query != null && query.isNotEmpty) {
      final hit =
          p.name.toLowerCase().contains(query) ||
          p.description.toLowerCase().contains(query);
      if (!hit) return false;
    }
    if (f.categoryIds.isNotEmpty && !f.categoryIds.contains(p.categoryId)) {
      return false;
    }
    if (f.sizes.isNotEmpty && !f.sizes.any(p.sizes.contains)) return false;
    if (f.minPriceIdr != null && p.priceIdr < f.minPriceIdr!) return false;
    if (f.maxPriceIdr != null && p.priceIdr > f.maxPriceIdr!) return false;
    if (f.inStockOnly && p.isOutOfStock) return false;
    return true;
  }
}
