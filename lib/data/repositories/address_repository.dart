import 'package:hive_ce/hive_ce.dart';
import 'package:wearway_flutter/data/models/address_model.dart';

/// Akses data alamat (CRUD + set default). Semua scoped per userId.
class AddressRepository {
  const AddressRepository(this._box);

  final Box<AddressModel> _box;

  /// Alamat yang tampil di Address Book (hanya `isSaved`).
  Future<List<AddressModel>> list(String userId) async {
    return _box.values
        .where((a) => a.userId == userId && a.isSaved)
        .toList();
  }

  Future<AddressModel?> getById(String id) async => _box.get(id);

  Future<void> create(AddressModel address) async {
    // Snapshot checkout yang tidak disimpan → persist apa adanya (biar order
    // bisa referensi) tanpa ganggu default / daftar Address Book.
    if (!address.isSaved) {
      await _box.put(address.id, address);
      return;
    }
    // Kalau alamat pertama user, otomatis jadi default.
    final existing = await list(address.userId);
    final shouldDefault = address.isDefault || existing.isEmpty;
    if (shouldDefault) {
      await _clearDefault(address.userId);
    }
    await _box.put(address.id, address.copyWith(isDefault: shouldDefault));
  }

  Future<void> update(AddressModel address) async {
    await _box.put(address.id, address);
  }

  Future<void> delete(String id) async => _box.delete(id);

  Future<void> setDefault(String userId, String addressId) async {
    await _clearDefault(userId);
    final target = _box.get(addressId);
    if (target != null) {
      await _box.put(addressId, target.copyWith(isDefault: true));
    }
  }

  Future<AddressModel?> getDefault(String userId) async {
    for (final a in _box.values) {
      if (a.userId == userId && a.isDefault) return a;
    }
    return null;
  }

  Stream<List<AddressModel>> watch(String userId) async* {
    yield await list(userId);
    yield* _box.watch().asyncMap((_) => list(userId));
  }

  Future<void> _clearDefault(String userId) async {
    for (final a in _box.values.where(
      (a) => a.userId == userId && a.isDefault,
    )) {
      await _box.put(a.id, a.copyWith(isDefault: false));
    }
  }
}
