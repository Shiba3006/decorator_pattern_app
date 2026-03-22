// ─────────────────────────────────────────────
// DOMAIN LAYER — Repository Interface
// Contract only. No implementation here.
// ─────────────────────────────────────────────

import '../entities/app_notification.dart';

abstract class NotificationRepository {
  /// Returns a base notification by type key.
  AppNotification getBase(String type);

  /// Returns all available base type keys.
  List<String> getBaseTypes();

  /// Returns all available decorator keys.
  List<String> getDecoratorKeys();
}
