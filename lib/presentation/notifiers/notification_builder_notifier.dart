// ─────────────────────────────────────────────
// PRESENTATION LAYER — Notifier
// Observer Pattern (ChangeNotifier) +
// Decorator Pattern working together.
// ─────────────────────────────────────────────

import 'package:flutter/foundation.dart';

import '../../domain/decorators/notification_decorators.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

class DecoratorInfo {
  final String key;
  final String name;
  final String description;
  final String cost;
  final int color; // ARGB int for Color()

  const DecoratorInfo({
    required this.key,
    required this.name,
    required this.description,
    required this.cost,
    required this.color,
  });
}

class BaseInfo {
  final String key;
  final String label;
  final String description;
  final String emoji;
  final int color;

  const BaseInfo({
    required this.key,
    required this.label,
    required this.description,
    required this.emoji,
    required this.color,
  });
}

class NotificationBuilderNotifier extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationBuilderNotifier(this._repository) {
    _rebuildNotification();
  }

  // ── State ────────────────────────────────
  String _selectedBase = 'system';
  final Set<String> _activeDecorators = {};
  late AppNotification _currentNotification;

  // ── Getters ──────────────────────────────
  String get selectedBase => _selectedBase;
  Set<String> get activeDecorators => Set.unmodifiable(_activeDecorators);
  AppNotification get currentNotification => _currentNotification;
  int get decoratorCount => _activeDecorators.length;

  // ── Static metadata ──────────────────────
  static const bases = [
    BaseInfo(
      key: 'system',
      label: 'SystemNotification',
      description: 'Default app alert',
      emoji: '🔔',
      color: 0xFF7C6AF7,
    ),
    BaseInfo(
      key: 'message',
      label: 'MessageNotification',
      description: 'Direct message alert',
      emoji: '💬',
      color: 0xFFF76A8F,
    ),
    BaseInfo(
      key: 'payment',
      label: 'PaymentNotification',
      description: 'Transaction alert',
      emoji: '💳',
      color: 0xFF6AF7C8,
    ),
  ];

  static const decorators = [
    DecoratorInfo(
      key: 'timestamp',
      name: 'TimestampDecorator',
      description: 'Adds sent time to notification',
      cost: '+time',
      color: 0xFF7C6AF7,
    ),
    DecoratorInfo(
      key: 'badge',
      name: 'BadgeDecorator',
      description: 'Shows unread count badge',
      cost: '+badge',
      color: 0xFFF7C86A,
    ),
    DecoratorInfo(
      key: 'urgent',
      name: 'UrgentDecorator',
      description: 'Marks as high priority',
      cost: '+priority',
      color: 0xFFF76A8F,
    ),
    DecoratorInfo(
      key: 'actions',
      name: 'ActionsDecorator',
      description: 'Adds action buttons',
      cost: '+actions',
      color: 0xFF6AF7C8,
    ),
  ];

  // ── Actions ──────────────────────────────
  void selectBase(String key) {
    if (_selectedBase == key) return;
    _selectedBase = key;
    _rebuildNotification();
    notifyListeners();
  }

  void toggleDecorator(String key) {
    if (_activeDecorators.contains(key)) {
      _activeDecorators.remove(key);
    } else {
      _activeDecorators.add(key);
    }
    _rebuildNotification();
    notifyListeners();
  }

  bool isDecoratorActive(String key) => _activeDecorators.contains(key);

  // ── Decoration chain builder ─────────────
  // This is the core of the Decorator Pattern:
  // we start with a base and wrap it layer by layer.
  void _rebuildNotification() {
    AppNotification notif = _repository.getBase(_selectedBase);

    // Stack decorators in order — each wraps the previous
    if (_activeDecorators.contains('timestamp')) {
      notif = TimestampDecorator(notif);
    }
    if (_activeDecorators.contains('badge')) {
      notif = BadgeDecorator(notif, count: 3);
    }
    if (_activeDecorators.contains('urgent')) {
      notif = UrgentDecorator(notif);
    }
    if (_activeDecorators.contains('actions')) {
      notif = ActionsDecorator(notif);
    }

    _currentNotification = notif;
  }

  // ── Chain string for display ─────────────
  String get chainString {
    if (_activeDecorators.isEmpty) {
      return '${_baseLabel()}()';
    }
    final decs = _activeDecorators.toList();
    final names = {
      'timestamp': 'TimestampDecorator',
      'badge': 'BadgeDecorator',
      'urgent': 'UrgentDecorator',
      'actions': 'ActionsDecorator',
    };
    final opening = decs.map((d) => '${names[d]}(').join('\n  ');
    final closing = List.filled(decs.length, ')').join('');
    return '$opening\n    ${_baseLabel()}()\n  $closing';
  }

  // ── Stats ────────────────────────────────
  int get classesWithPattern => 3 + 4 + 1; // bases + decorators + abstract
  int get classesWithoutPattern {
    // Without pattern: every combination = 2^decorators × bases
    return (1 << _activeDecorators.length) * 3;
  }

  String _baseLabel() {
    return bases.firstWhere((b) => b.key == _selectedBase).label;
  }
}
