// ─────────────────────────────────────────────
// DOMAIN LAYER — Entity
// Pure Dart. No Flutter. No JSON.
// ─────────────────────────────────────────────

enum NotificationPriority { normal, urgent }

abstract class AppNotification {
  String get title;
  String get body;
  String get appName;
  String get icon;
  NotificationPriority get priority;
  bool get hasTimestamp;
  bool get hasBadge;
  bool get hasActions;
  int get badgeCount;
  DateTime? get sentAt;
}
