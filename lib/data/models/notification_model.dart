// ─────────────────────────────────────────────
// DATA LAYER — Model
// Knows JSON. Knows how to map to domain entity.
// ─────────────────────────────────────────────

import '../../domain/entities/app_notification.dart';
import '../../domain/notifications/base_notifications.dart';

class NotificationModel {
  final String type;
  final String title;
  final String body;
  final String appName;
  final String icon;

  const NotificationModel({
    required this.type,
    required this.title,
    required this.body,
    required this.appName,
    required this.icon,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        type: json['type'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        appName: json['app_name'] as String,
        icon: json['icon'] as String,
      );

  Map<String, dynamic> toJson() => {
    'type': type,
    'title': title,
    'body': body,
    'app_name': appName,
    'icon': icon,
  };

  AppNotification toEntity() {
    switch (type) {
      case 'message':
        return MessageNotification();
      case 'payment':
        return PaymentNotification();
      default:
        return SystemNotification();
    }
  }
}
