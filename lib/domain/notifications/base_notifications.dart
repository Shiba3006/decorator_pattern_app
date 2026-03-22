// ─────────────────────────────────────────────
// DOMAIN LAYER — Concrete Base Components
// These are the core objects before decoration.
// ─────────────────────────────────────────────

import '../entities/app_notification.dart';

class SystemNotification implements AppNotification {
  @override
  String get title => 'New notification';
  @override
  String get body => 'You have a new update waiting for you.';
  @override
  String get appName => 'My App';
  @override
  String get icon => '🔔';
  @override
  NotificationPriority get priority => NotificationPriority.normal;
  @override
  bool get hasTimestamp => false;
  @override
  bool get hasBadge => false;
  @override
  bool get hasActions => false;
  @override
  int get badgeCount => 0;
  @override
  DateTime? get sentAt => null;
}

class MessageNotification implements AppNotification {
  @override
  String get title => 'Ahmed sent you a message';
  @override
  String get body => 'Hey! Are you free to review the PR tomorrow morning?';
  @override
  String get appName => 'Messages';
  @override
  String get icon => '💬';
  @override
  NotificationPriority get priority => NotificationPriority.normal;
  @override
  bool get hasTimestamp => false;
  @override
  bool get hasBadge => false;
  @override
  bool get hasActions => false;
  @override
  int get badgeCount => 0;
  @override
  DateTime? get sentAt => null;
}

class PaymentNotification implements AppNotification {
  @override
  String get title => 'Payment received';
  @override
  String get body => 'EGP 1,200.00 from Omar Hassan has been credited.';
  @override
  String get appName => 'Clyns Pay';
  @override
  String get icon => '💳';
  @override
  NotificationPriority get priority => NotificationPriority.normal;
  @override
  bool get hasTimestamp => false;
  @override
  bool get hasBadge => false;
  @override
  bool get hasActions => false;
  @override
  int get badgeCount => 0;
  @override
  DateTime? get sentAt => null;
}
