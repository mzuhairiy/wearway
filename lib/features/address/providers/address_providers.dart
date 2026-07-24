import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';
import 'package:wearway_flutter/features/auth/providers/auth_controller.dart';

part 'address_providers.g.dart';

/// userId aktif (checkout & address book butuh login → non-null saat dipakai).
@riverpod
String? currentUserId(Ref ref) => ref.watch(authControllerProvider).value?.id;

/// Stream alamat tersimpan milik user aktif (reaktif ke box addresses).
@riverpod
Stream<List<AddressModel>> savedAddresses(Ref ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const []);
  return ref.watch(addressRepositoryProvider).watch(userId);
}

/// Aksi CRUD alamat (mutasi Hive lewat repository).
@riverpod
class AddressController extends _$AddressController {
  @override
  void build() {}

  Future<void> save(AddressModel address) {
    return ref.read(addressRepositoryProvider).create(address);
  }

  Future<void> update(AddressModel address) {
    return ref.read(addressRepositoryProvider).update(address);
  }

  Future<void> delete(String id) {
    return ref.read(addressRepositoryProvider).delete(id);
  }

  Future<void> setDefault(String addressId) {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return Future.value();
    return ref.read(addressRepositoryProvider).setDefault(userId, addressId);
  }
}
