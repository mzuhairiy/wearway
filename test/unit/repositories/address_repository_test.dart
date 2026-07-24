import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/data/repositories/address_repository.dart';

class _MockBox extends Mock implements Box<AddressModel> {}

AddressModel _addr({
  required String id,
  String userId = 'u1',
  bool isDefault = false,
  bool isSaved = true,
}) {
  return AddressModel(
    id: id,
    userId: userId,
    label: 'Rumah',
    recipientName: 'A',
    phone: '0812',
    streetAddress: 'Jl. Test',
    city: 'Jakarta',
    postalCode: '12345',
    isDefault: isDefault,
    isSaved: isSaved,
  );
}

void main() {
  setUpAll(() => registerFallbackValue(_addr(id: 'fallback')));

  late _MockBox box;
  late AddressRepository repo;

  setUp(() {
    box = _MockBox();
    repo = AddressRepository(box);
    when(
      () => box.put(any<dynamic>(), any<AddressModel>()),
    ).thenAnswer((_) async {});
    when(() => box.delete(any<dynamic>())).thenAnswer((_) async {});
  });

  test('list hanya alamat isSaved milik user', () async {
    when(() => box.values).thenReturn([
      _addr(id: 'a1'),
      _addr(id: 'a2', isSaved: false), // snapshot checkout — disembunyikan
      _addr(id: 'a3', userId: 'u2'), // user lain
    ]);
    final result = await repo.list('u1');
    expect(result.map((a) => a.id), ['a1']);
  });

  test('alamat pertama (saved) otomatis jadi default', () async {
    when(() => box.values).thenReturn([]);
    await repo.create(_addr(id: 'a1'));
    final captured =
        verify(() => box.put('a1', captureAny())).captured.single
            as AddressModel;
    expect(captured.isDefault, isTrue);
  });

  test('alamat tidak disimpan (isSaved false) dipersist apa adanya', () async {
    final snapshot = _addr(id: 'snap', isSaved: false);
    await repo.create(snapshot);
    verify(() => box.put('snap', snapshot)).called(1);
    // Tidak menyentuh default / daftar existing.
    verifyNever(() => box.values);
  });

  test('delete meneruskan ke box', () async {
    await repo.delete('a1');
    verify(() => box.delete('a1')).called(1);
  });
}
