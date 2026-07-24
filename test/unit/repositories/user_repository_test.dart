import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:wearway_flutter/data/hive_boxes.dart';
import 'package:wearway_flutter/data/models/user_model.dart';
import 'package:wearway_flutter/data/repositories/user_repository.dart';
import 'package:wearway_flutter/hive_registrar.g.dart';

void main() {
  late Directory tempDir;
  late UserRepository repo;

  setUpAll(() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapters();
    }
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('wearway_user_test');
    Hive.init(tempDir.path);
    await Hive.openBox<UserModel>(HiveBoxes.users);
    await Hive.openBox<dynamic>(HiveBoxes.meta);
    repo = UserRepository(
      usersBox: Hive.box<UserModel>(HiveBoxes.users),
      metaBox: Hive.box<dynamic>(HiveBoxes.meta),
    );
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('register menyimpan user + set sesi (getCurrent)', () async {
    final user = await repo.register(
      email: 'a@b.com',
      password: 'Secret123!',
      name: 'A',
      createdAtMs: 0,
    );
    expect(user.email, 'a@b.com');
    expect(user.passwordHash, isNot(contains('Secret123!')));
    expect((await repo.getCurrent())?.id, user.id);
  });

  test('register email duplikat → AuthException emailTaken', () async {
    await repo.register(
      email: 'a@b.com',
      password: 'Secret123!',
      name: 'A',
      createdAtMs: 0,
    );
    expect(
      () => repo.register(
        email: 'A@B.com', // case-insensitive → tetap dianggap sama.
        password: 'x',
        name: 'B',
        createdAtMs: 0,
      ),
      throwsA(
        isA<AuthException>().having(
          (e) => e.code,
          'code',
          AuthErrorCode.emailTaken,
        ),
      ),
    );
  });

  test('login happy path', () async {
    await repo.register(
      email: 'a@b.com',
      password: 'Secret123!',
      name: 'A',
      createdAtMs: 0,
    );
    await repo.logout();
    final user = await repo.login('a@b.com', 'Secret123!');
    expect(user.email, 'a@b.com');
    expect((await repo.getCurrent())?.id, user.id);
  });

  test('login password salah → AuthException wrongPassword', () async {
    await repo.register(
      email: 'a@b.com',
      password: 'Secret123!',
      name: 'A',
      createdAtMs: 0,
    );
    expect(
      () => repo.login('a@b.com', 'salah'),
      throwsA(
        isA<AuthException>().having(
          (e) => e.code,
          'code',
          AuthErrorCode.wrongPassword,
        ),
      ),
    );
  });

  test('login akun tak ada → AuthException userNotFound', () async {
    expect(
      () => repo.login('ghost@b.com', 'x'),
      throwsA(
        isA<AuthException>().having(
          (e) => e.code,
          'code',
          AuthErrorCode.userNotFound,
        ),
      ),
    );
  });

  test('logout menghapus sesi', () async {
    await repo.register(
      email: 'a@b.com',
      password: 'Secret123!',
      name: 'A',
      createdAtMs: 0,
    );
    await repo.logout();
    expect(await repo.getCurrent(), isNull);
  });
}
