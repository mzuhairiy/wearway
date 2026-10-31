// AUTOMATION-ONLY entrypoint (Appium Flutter Driver) — not for release.
//
// Unlike `main.dart`, this enables the Flutter Driver extension
// (`ext.flutter.driver` on the Dart VM Service) so Appium Flutter Driver can
// attach and locate widgets by ValueKey. Build / run it with:
//   flutter build apk --debug --target=lib/main_automation.dart
//   flutter run   --debug --target=lib/main_automation.dart
//
// `enableFlutterDriverExtension()` runs BEFORE `app.main()` on purpose: the
// extension must be registered before any incompatible Flutter binding is
// initialized. `app.main()` stays the single source of startup (Hive, adapter
// registration, 8 boxes, seed, ProviderScope, NotificationService, Toastr,
// lifecycle observer, router, theme, session restore) — nothing is duplicated.

// `flutter_driver` is a dev_dependency imported from `lib/` on purpose, only
// for this automation entrypoint (never shipped in a release build), so the
// `depend_on_referenced_packages` lint is ignored right on the import below.
// ignore: depend_on_referenced_packages
import 'package:flutter_driver/driver_extension.dart';
import 'package:wearway_flutter/main.dart' as app;

Future<void> main() async {
  // Enable the `ext.flutter.driver` VM Service extension for Appium.
  enableFlutterDriverExtension();

  // Delegate the whole bootstrap to the normal entrypoint (unmodified).
  await app.main();
}
