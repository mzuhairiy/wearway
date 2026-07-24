import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wearway_flutter/data/models/cart_item_model.dart';
import 'package:wearway_flutter/data/repositories/cart_repository.dart';

class _MockBox extends Mock implements Box<CartItemModel> {}

CartItemModel _item({
  required String id,
  String? userId,
  String productId = 'p1',
  String size = 'M',
  String color = 'black',
  int quantity = 1,
}) {
  return CartItemModel(
    id: id,
    userId: userId,
    productId: productId,
    selectedSize: size,
    selectedColor: color,
    quantity: quantity,
    addedAtMs: 0,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(_item(id: 'fallback'));
  });

  late _MockBox box;
  late CartRepository repo;

  setUp(() {
    box = _MockBox();
    repo = CartRepository(box);
    when(
      () => box.put(any<dynamic>(), any<CartItemModel>()),
    ).thenAnswer((_) async {});
    when(() => box.delete(any<dynamic>())).thenAnswer((_) async {});
    when(
      () => box.deleteAll(any<Iterable<dynamic>>()),
    ).thenAnswer((_) async {});
  });

  test('add item baru → put dengan item tsb', () async {
    when(() => box.values).thenReturn([]);
    final item = _item(id: 'c1', quantity: 2);
    await repo.add(item);
    verify(() => box.put('c1', item)).called(1);
  });

  test('add varian yang sama → gabung quantity', () async {
    final existing = _item(id: 'c1', quantity: 2);
    when(() => box.values).thenReturn([existing]);
    await repo.add(_item(id: 'c2', quantity: 3));

    final captured = verify(() => box.put('c1', captureAny())).captured;
    expect((captured.single as CartItemModel).quantity, 5);
  });

  test('updateQty ke 0 → hapus item', () async {
    when(() => box.get('c1')).thenReturn(_item(id: 'c1', quantity: 2));
    await repo.updateQty('c1', 0);
    verify(() => box.delete('c1')).called(1);
    verifyNever(() => box.put(any<dynamic>(), any<CartItemModel>()));
  });

  test('updateQty positif → put quantity baru', () async {
    when(() => box.get('c1')).thenReturn(_item(id: 'c1', quantity: 2));
    await repo.updateQty('c1', 4);
    final captured = verify(() => box.put('c1', captureAny())).captured;
    expect((captured.single as CartItemModel).quantity, 4);
  });

  test('clear guest cart → deleteAll id guest saja', () async {
    when(() => box.values).thenReturn([
      _item(id: 'g1'),
      _item(id: 'u1', userId: 'user_1'),
    ]);
    await repo.clear(null);
    verify(() => box.deleteAll(['g1'])).called(1);
  });

  test('transferGuestToUser → put ulang item guest dengan userId', () async {
    when(() => box.values).thenReturn([
      _item(id: 'g1'),
      _item(id: 'u1', userId: 'user_1'),
    ]);
    await repo.transferGuestToUser('user_2');

    final captured = verify(() => box.put('g1', captureAny())).captured;
    expect((captured.single as CartItemModel).userId, 'user_2');
    // Item milik user lain tidak ikut dipindah.
    verifyNever(() => box.put('u1', any<CartItemModel>()));
  });
}
