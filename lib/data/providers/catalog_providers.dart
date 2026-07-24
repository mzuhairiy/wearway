import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/models/category_model.dart';
import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';

part 'catalog_providers.g.dart';

// Read-side providers untuk katalog. Widget watch ini (bukan repo langsung).
// StreamProvider = reaktif (auto-update saat box berubah, mis. setelah reset).

/// Semua kategori (terurut).
@riverpod
Stream<List<CategoryModel>> categoryList(Ref ref) async* {
  final repo = ref.watch(categoryRepositoryProvider);
  yield await repo.list();
}

/// Semua produk, reaktif terhadap perubahan box products.
@riverpod
Stream<List<ProductModel>> productList(Ref ref) {
  return ref.watch(productRepositoryProvider).watchAll();
}

/// Produk unggulan (home featured row).
@riverpod
Future<List<ProductModel>> featuredProducts(Ref ref) {
  return ref.watch(productRepositoryProvider).findFeatured();
}

/// Detail satu produk by id.
@riverpod
Future<ProductModel?> productById(Ref ref, String id) {
  return ref.watch(productRepositoryProvider).getById(id);
}

/// Produk dalam satu kategori.
@riverpod
Future<List<ProductModel>> productsByCategory(Ref ref, String categoryId) {
  return ref.watch(productRepositoryProvider).findByCategory(categoryId);
}

/// Kategori by slug (dipakai Category Products screen dari route /categories/:slug).
@riverpod
Future<CategoryModel?> categoryBySlug(Ref ref, String slug) {
  return ref.watch(categoryRepositoryProvider).getBySlug(slug);
}
