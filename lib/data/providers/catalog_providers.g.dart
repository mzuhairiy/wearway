// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Semua kategori (terurut).

@ProviderFor(categoryList)
final categoryListProvider = CategoryListProvider._();

/// Semua kategori (terurut).

final class CategoryListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategoryModel>>,
          List<CategoryModel>,
          Stream<List<CategoryModel>>
        >
    with
        $FutureModifier<List<CategoryModel>>,
        $StreamProvider<List<CategoryModel>> {
  /// Semua kategori (terurut).
  CategoryListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryListHash();

  @$internal
  @override
  $StreamProviderElement<List<CategoryModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CategoryModel>> create(Ref ref) {
    return categoryList(ref);
  }
}

String _$categoryListHash() => r'1be4bbcdd4f429094136d2fb5a1a4443cca9841a';

/// Semua produk, reaktif terhadap perubahan box products.

@ProviderFor(productList)
final productListProvider = ProductListProvider._();

/// Semua produk, reaktif terhadap perubahan box products.

final class ProductListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductModel>>,
          List<ProductModel>,
          Stream<List<ProductModel>>
        >
    with
        $FutureModifier<List<ProductModel>>,
        $StreamProvider<List<ProductModel>> {
  /// Semua produk, reaktif terhadap perubahan box products.
  ProductListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productListHash();

  @$internal
  @override
  $StreamProviderElement<List<ProductModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ProductModel>> create(Ref ref) {
    return productList(ref);
  }
}

String _$productListHash() => r'4d048bfce96ed3d6cba2b35eabcb3f710b122cbc';

/// Produk unggulan (home featured row).

@ProviderFor(featuredProducts)
final featuredProductsProvider = FeaturedProductsProvider._();

/// Produk unggulan (home featured row).

final class FeaturedProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductModel>>,
          List<ProductModel>,
          FutureOr<List<ProductModel>>
        >
    with
        $FutureModifier<List<ProductModel>>,
        $FutureProvider<List<ProductModel>> {
  /// Produk unggulan (home featured row).
  FeaturedProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featuredProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featuredProductsHash();

  @$internal
  @override
  $FutureProviderElement<List<ProductModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProductModel>> create(Ref ref) {
    return featuredProducts(ref);
  }
}

String _$featuredProductsHash() => r'59313ba855184feaade33aa17e9eb01306797cda';

/// Detail satu produk by id.

@ProviderFor(productById)
final productByIdProvider = ProductByIdFamily._();

/// Detail satu produk by id.

final class ProductByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProductModel?>,
          ProductModel?,
          FutureOr<ProductModel?>
        >
    with $FutureModifier<ProductModel?>, $FutureProvider<ProductModel?> {
  /// Detail satu produk by id.
  ProductByIdProvider._({
    required ProductByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productByIdHash();

  @override
  String toString() {
    return r'productByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProductModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProductModel?> create(Ref ref) {
    final argument = this.argument as String;
    return productById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productByIdHash() => r'3f9a325b7ce96d5fd16847bf527181918942540c';

/// Detail satu produk by id.

final class ProductByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProductModel?>, String> {
  ProductByIdFamily._()
    : super(
        retry: null,
        name: r'productByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Detail satu produk by id.

  ProductByIdProvider call(String id) =>
      ProductByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'productByIdProvider';
}

/// Produk dalam satu kategori.

@ProviderFor(productsByCategory)
final productsByCategoryProvider = ProductsByCategoryFamily._();

/// Produk dalam satu kategori.

final class ProductsByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductModel>>,
          List<ProductModel>,
          FutureOr<List<ProductModel>>
        >
    with
        $FutureModifier<List<ProductModel>>,
        $FutureProvider<List<ProductModel>> {
  /// Produk dalam satu kategori.
  ProductsByCategoryProvider._({
    required ProductsByCategoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productsByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productsByCategoryHash();

  @override
  String toString() {
    return r'productsByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProductModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProductModel>> create(Ref ref) {
    final argument = this.argument as String;
    return productsByCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsByCategoryHash() =>
    r'8ad184d687c402729d26e6a3d2b8d749308e38b8';

/// Produk dalam satu kategori.

final class ProductsByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ProductModel>>, String> {
  ProductsByCategoryFamily._()
    : super(
        retry: null,
        name: r'productsByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Produk dalam satu kategori.

  ProductsByCategoryProvider call(String categoryId) =>
      ProductsByCategoryProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'productsByCategoryProvider';
}

/// Kategori by slug (dipakai Category Products screen dari route /categories/:slug).

@ProviderFor(categoryBySlug)
final categoryBySlugProvider = CategoryBySlugFamily._();

/// Kategori by slug (dipakai Category Products screen dari route /categories/:slug).

final class CategoryBySlugProvider
    extends
        $FunctionalProvider<
          AsyncValue<CategoryModel?>,
          CategoryModel?,
          FutureOr<CategoryModel?>
        >
    with $FutureModifier<CategoryModel?>, $FutureProvider<CategoryModel?> {
  /// Kategori by slug (dipakai Category Products screen dari route /categories/:slug).
  CategoryBySlugProvider._({
    required CategoryBySlugFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'categoryBySlugProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryBySlugHash();

  @override
  String toString() {
    return r'categoryBySlugProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CategoryModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CategoryModel?> create(Ref ref) {
    final argument = this.argument as String;
    return categoryBySlug(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryBySlugProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryBySlugHash() => r'58dab7c701fe19a082e5024d65a379dde518d980';

/// Kategori by slug (dipakai Category Products screen dari route /categories/:slug).

final class CategoryBySlugFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CategoryModel?>, String> {
  CategoryBySlugFamily._()
    : super(
        retry: null,
        name: r'categoryBySlugProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kategori by slug (dipakai Category Products screen dari route /categories/:slug).

  CategoryBySlugProvider call(String slug) =>
      CategoryBySlugProvider._(argument: slug, from: this);

  @override
  String toString() => r'categoryBySlugProvider';
}
