import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';
import 'package:wearway_flutter/data/repositories/product_repository.dart';

part 'search_controller.g.dart';

/// State pencarian: query + filter aktif.
class SearchState {
  const SearchState({
    this.query = '',
    this.categoryIds = const [],
    this.sizes = const [],
    this.minPriceIdr,
    this.maxPriceIdr,
    this.inStockOnly = false,
  });

  final String query;
  final List<String> categoryIds;
  final List<String> sizes;
  final int? minPriceIdr;
  final int? maxPriceIdr;
  final bool inStockOnly;

  bool get hasActiveFilters =>
      categoryIds.isNotEmpty ||
      sizes.isNotEmpty ||
      minPriceIdr != null ||
      maxPriceIdr != null ||
      inStockOnly;

  bool get hasCriteria => query.trim().isNotEmpty || hasActiveFilters;

  int get activeFilterCount =>
      (categoryIds.isNotEmpty ? 1 : 0) +
      (sizes.isNotEmpty ? 1 : 0) +
      (minPriceIdr != null || maxPriceIdr != null ? 1 : 0) +
      (inStockOnly ? 1 : 0);

  SearchState copyWith({String? query}) {
    return SearchState(
      query: query ?? this.query,
      categoryIds: categoryIds,
      sizes: sizes,
      minPriceIdr: minPriceIdr,
      maxPriceIdr: maxPriceIdr,
      inStockOnly: inStockOnly,
    );
  }
}

@riverpod
class SearchController extends _$SearchController {
  @override
  SearchState build() => const SearchState();

  void setQuery(String query) => state = state.copyWith(query: query);

  void setFilters({
    required List<String> categoryIds,
    required List<String> sizes,
    required int? minPriceIdr,
    required int? maxPriceIdr,
    required bool inStockOnly,
  }) {
    state = SearchState(
      query: state.query,
      categoryIds: categoryIds,
      sizes: sizes,
      minPriceIdr: minPriceIdr,
      maxPriceIdr: maxPriceIdr,
      inStockOnly: inStockOnly,
    );
  }

  void clearFilters() => state = SearchState(query: state.query);
}

/// Hasil pencarian berdasarkan state aktif.
@riverpod
Future<List<ProductModel>> searchResults(Ref ref) {
  final s = ref.watch(searchControllerProvider);
  return ref
      .watch(productRepositoryProvider)
      .list(
        filters: ProductFilters(
          query: s.query,
          categoryIds: s.categoryIds,
          sizes: s.sizes,
          minPriceIdr: s.minPriceIdr,
          maxPriceIdr: s.maxPriceIdr,
          inStockOnly: s.inStockOnly,
        ),
      );
}
