import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:wearway_flutter/data/hive_boxes.dart';
import 'package:wearway_flutter/data/models/cart_item_model.dart';
import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';
import 'package:wearway_flutter/data/repositories/user_repository.dart';
import 'package:wearway_flutter/features/auth/providers/auth_controller.dart';
import 'package:wearway_flutter/hive_registrar.g.dart';

void main() {
  late Directory tempDir;
  late ProviderContainer container;

  setUpAll(() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapters();
    }
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('wearway_auth_test');
    Hive.init(tempDir.path);
    await Hive.openBox<UserModel>(HiveBoxes.users);
    await Hive.openBox<CartItemModel>(HiveBoxes.cartItems);
    await Hive.openBox<dynamic>(HiveBoxes.meta);
    // build() membaca flag skip-login dari settings (Prompt 8).
    await Hive.openBox<dynamic>(HiveBoxes.settings);
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  AuthController notifier() => container.read(authControllerProvider.notifier);

  Future<void> seedUserThenGuest() async {
    final repo = container.read(userRepositoryProvider);
    await repo.register(
      email: 'a@b.com',
      password: 'Secret123!',
      name: 'A',
      createdAtMs: 0,
    );
    await repo.logout();
    await container.read(authControllerProvider.future); // build → guest
  }

  test('build restore session guest → null', () async {
    final user = await container.read(authControllerProvider.future);
    expect(user, isNull);
  });

  test('login happy path → state berisi user', () async {
    await seedUserThenGuest();
    await notifier().login('a@b.com', 'Secret123!');

    final state = container.read(authControllerProvider);
    expect(state.hasError, isFalse);
    expect(state.value?.email, 'a@b.com');
  });

  test('login password salah → AsyncError(wrongPassword)', () async {
    await seedUserThenGuest();
    await notifier().login('a@b.com', 'salah-banget');

    final state = container.read(authControllerProvider);
    expect(state.hasError, isTrue);
    expect(
      state.error,
      isA<AuthException>().having(
        (e) => e.code,
        'code',
        AuthErrorCode.wrongPassword,
      ),
    );
  });

  test('register email duplikat → AsyncError(emailTaken)', () async {
    await container.read(authControllerProvider.future);
    await notifier().register(
      email: 'a@b.com',
      password: 'Secret123!',
      name: 'A',
      createdAtMs: 0,
    );
    expect(container.read(authControllerProvider).value?.email, 'a@b.com');

    await notifier().register(
      email: 'a@b.com',
      password: 'Secret123!',
      name: 'B',
      createdAtMs: 0,
    );

    final state = container.read(authControllerProvider);
    expect(state.hasError, isTrue);
    expect(
      state.error,
      isA<AuthException>().having(
        (e) => e.code,
        'code',
        AuthErrorCode.emailTaken,
      ),
    );
  });

  test('logout → state kembali null', () async {
    await seedUserThenGuest();
    await notifier().login('a@b.com', 'Secret123!');
    await notifier().logout();

    expect(container.read(authControllerProvider).value, isNull);
  });
}
