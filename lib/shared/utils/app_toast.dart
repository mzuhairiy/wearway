import 'package:toastr_flutter/toastr_flutter.dart';

/// Wrapper tipis di atas `toastr_flutter` — satu tempat untuk gaya toast app.
/// Posisi (atas) di-set global via [Toastr.configure] di `main()`.
/// Context-free: bisa dipanggil setelah async gap tanpa `BuildContext`.
abstract final class AppToast {
  static void success(String message) => Toastr.success(message);
  static void error(String message) => Toastr.error(message);
  static void warning(String message) => Toastr.warning(message);
  static void info(String message) => Toastr.info(message);
}
