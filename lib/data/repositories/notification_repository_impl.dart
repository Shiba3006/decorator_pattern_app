// ─────────────────────────────────────────────
// DATA LAYER — Repository Implementation
// Implements the domain contract.
// In a real app this would call an API or DB.
// ─────────────────────────────────────────────

import '../../domain/entities/app_notification.dart';
import '../../domain/notifications/base_notifications.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  // Simulated local data source — replace with API/DB in production
  static const _baseTypes = ['system', 'message', 'payment'];
  static const _decoratorKeys = ['timestamp', 'badge', 'urgent', 'actions'];

  @override
  AppNotification getBase(String type) {
    switch (type) {
      case 'message':
        return MessageNotification();
      case 'payment':
        return PaymentNotification();
      default:
        return SystemNotification();
    }
  }

  @override
  List<String> getBaseTypes() => _baseTypes;

  @override
  List<String> getDecoratorKeys() => _decoratorKeys;
}
