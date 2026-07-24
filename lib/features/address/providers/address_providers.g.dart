// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// userId aktif (checkout & address book butuh login → non-null saat dipakai).

@ProviderFor(currentUserId)
final currentUserIdProvider = CurrentUserIdProvider._();

/// userId aktif (checkout & address book butuh login → non-null saat dipakai).

final class CurrentUserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// userId aktif (checkout & address book butuh login → non-null saat dipakai).
  CurrentUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentUserIdHash() => r'6bfdba0323af84b41e11b80f5b03fe63219be008';

/// Stream alamat tersimpan milik user aktif (reaktif ke box addresses).

@ProviderFor(savedAddresses)
final savedAddressesProvider = SavedAddressesProvider._();

/// Stream alamat tersimpan milik user aktif (reaktif ke box addresses).

final class SavedAddressesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AddressModel>>,
          List<AddressModel>,
          Stream<List<AddressModel>>
        >
    with
        $FutureModifier<List<AddressModel>>,
        $StreamProvider<List<AddressModel>> {
  /// Stream alamat tersimpan milik user aktif (reaktif ke box addresses).
  SavedAddressesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedAddressesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedAddressesHash();

  @$internal
  @override
  $StreamProviderElement<List<AddressModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AddressModel>> create(Ref ref) {
    return savedAddresses(ref);
  }
}

String _$savedAddressesHash() => r'5d72b1ba55ccdf98b4eb47c9713a48a7f5e605f3';

/// Aksi CRUD alamat (mutasi Hive lewat repository).

@ProviderFor(AddressController)
final addressControllerProvider = AddressControllerProvider._();

/// Aksi CRUD alamat (mutasi Hive lewat repository).
final class AddressControllerProvider
    extends $NotifierProvider<AddressController, void> {
  /// Aksi CRUD alamat (mutasi Hive lewat repository).
  AddressControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressControllerHash();

  @$internal
  @override
  AddressController create() => AddressController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$addressControllerHash() => r'7175459927057564f74415124e743f72b703eff3';

/// Aksi CRUD alamat (mutasi Hive lewat repository).

abstract class _$AddressController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
