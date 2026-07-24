import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_service.g.dart';

/// Hasil request permission yang disederhanakan (decouple dari plugin →
/// gampang di-mock di test & di-branch di UI).
enum PermissionOutcome { granted, denied, permanentlyDenied, restricted }

extension on PermissionStatus {
  PermissionOutcome get outcome {
    if (isGranted || isLimited) return PermissionOutcome.granted;
    if (isPermanentlyDenied) return PermissionOutcome.permanentlyDenied;
    if (isRestricted) return PermissionOutcome.restricted;
    return PermissionOutcome.denied;
  }
}

/// Wrapper tipis di atas permission_handler. Semua request runtime permission
/// lewat sini → satu tempat untuk mock di test dan konsisten di app.
class PermissionService {
  const PermissionService();

  /// Location (dipakai "Detect My Address" di checkout).
  Future<PermissionOutcome> requestLocation() async {
    final status = await Permission.location.request();
    return status.outcome;
  }

  /// Notification (Android 13+ POST_NOTIFICATIONS, kontekstual saat checkout).
  Future<PermissionOutcome> requestNotification() async {
    final status = await Permission.notification.request();
    return status.outcome;
  }

  /// Buka halaman Settings app (untuk kasus permanentlyDenied).
  Future<bool> openSettings() => openAppSettings();
}

/// Provider service → bisa di-override dengan fake di test.
@Riverpod(keepAlive: true)
PermissionService permissionService(Ref ref) => const PermissionService();
