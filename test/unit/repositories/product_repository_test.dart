import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wearway_flutter/data/models/product_model.dart';
import 'package:wearway_flutter/data/repositories/product_repository.dart';

class _MockBox extends Mock implements Box<ProductModel> {}

ProductModel _product({
  required String id,
  required String categoryId,
  int priceIdr = 100000,
  int stock = 5,
  bool isFeatured = false,
  String name = 'Sample',
  List<String> sizes = const ['M'],
}) {
  return ProductModel(
    id: id,
    slug: id,
    name: name,
    description: 'desc',
    priceIdr: priceIdr,
    stock: stock,
    imageUrls: const [],
    categoryId: categoryId,
    sizes: sizes,
    colors: const ['black'],
    isFeatured: isFeatured,
    rating: 4.5,
    reviewCount: 10,
    badges: const [],
    createdAtMs: 0,
  );
}

void main() {
  late _MockBox box;
  late ProductRepository repo;

  final catalog = [
    _product(
      id: 'p1',
      categoryId: 'cat_a',
      isFeatured: true,
      name: 'Kaos Biru',
    ),
    _product(id: 'p2', categoryId: 'cat_a', priceIdr: 200000),
    _product(id: 'p3', categoryId: 'cat_b', stock: 0, name: 'Sepatu Lari'),
  ];

  setUp(() {
    box = _MockBox();
    repo = ProductRepository(box);
    when(() => box.values).thenReturn(catalog);
    for (final p in catalog) {
      when(() => box.get(p.id)).thenReturn(p);
    }
    when(() => box.get('missing')).thenReturn(null);
  });

  test('getById mengembalikan produk yang benar / null', () async {
    expect((await repo.getById('p2'))?.id, 'p2');
    expect(await repo.getById('missing'), isNull);
  });

  test('findByCategory memfilter per kategori', () async {
    final result = await repo.findByCategory('cat_a');
    expect(result.map((p) => p.id), ['p1', 'p2']);
  });

  test('findFeatured hanya produk featured', () async {
    final result = await repo.findFeatured();
    expect(result.map((p) => p.id), ['p1']);
  });

  test('search case-insensitive by name/description', () async {
    expect((await repo.search('kaos')).map((p) => p.id), ['p1']);
    expect(await repo.search('   '), isEmpty);
  });

  test('list dengan filter harga + inStockOnly', () async {
    final result = await repo.list(
      filters: const ProductFilters(maxPriceIdr: 150000, inStockOnly: true),
    );
    // p2 kena filter harga, p3 out of stock → sisa p1.
    expect(result.map((p) => p.id), ['p1']);
  });

  test('list tanpa filter mengembalikan semua', () async {
    expect((await repo.list()).length, 3);
  });
}
