// ─────────────────────────────────────────────
// DOMAIN LAYER — Decorator Pattern
//
// Key rules:
// 1. NotificationDecorator extends AppNotification (same type)
// 2. HAS-A AppNotification (wraps it via composition)
// 3. Delegates everything to wrapped object by default
// 4. Each concrete decorator only overrides what it adds
// ─────────────────────────────────────────────

import '../entities/app_notification.dart';

// ── Abstract Decorator ──────────────────────
// Same type as AppNotification (for type compatibility)
// but behavior comes from wrapping, not inheriting.
abstract class NotificationDecorator implements AppNotification {
  final AppNotification _notification;
  const NotificationDecorator(this._notification);

  // Delegate everything to wrapped object by default
  @override
  String get title => _notification.title;
  @override
  String get body => _notification.body;
  @override
  String get appName => _notification.appName;
  @override
  String get icon => _notification.icon;
  @override
  NotificationPriority get priority => _notification.priority;
  @override
  bool get hasTimestamp => _notification.hasTimestamp;
  @override
  bool get hasBadge => _notification.hasBadge;
  @override
  bool get hasActions => _notification.hasActions;
  @override
  int get badgeCount => _notification.badgeCount;
  @override
  DateTime? get sentAt => _notification.sentAt;
}

// ── TimestampDecorator ───────────────────────
// Adds a sent time to the notification.
class TimestampDecorator extends NotificationDecorator {
  final DateTime _time;

  TimestampDecorator(super.notification) : _time = DateTime.now();

  @override
  bool get hasTimestamp => true;
  @override
  DateTime? get sentAt => _time;
}

// ── BadgeDecorator ───────────────────────────
// Adds an unread count badge.
class BadgeDecorator extends NotificationDecorator {
  final int count;

  const BadgeDecorator(super.notification, {this.count = 3});

  @override
  bool get hasBadge => true;
  @override
  int get badgeCount => count;
}

// ── UrgentDecorator ──────────────────────────
// Marks as high priority, prefixes title.
class UrgentDecorator extends NotificationDecorator {
  const UrgentDecorator(super.notification);

  @override
  NotificationPriority get priority => NotificationPriority.urgent;
  @override
  String get title => '🚨 ${_notification.title}';
}

// ── ActionsDecorator ─────────────────────────
// Appends action buttons row.
class ActionsDecorator extends NotificationDecorator {
  const ActionsDecorator(super.notification);

  @override
  bool get hasActions => true;
}
