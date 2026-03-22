# Decorator Pattern — Notification Builder 🔔

> A Flutter app demonstrating the **Decorator Pattern** from *Head First Design Patterns* (Freeman & Robson, O'Reilly), built with **Clean Architecture** and **get_it** dependency injection.

---

## The Problem This Solves

Imagine you have 3 notification types and 4 optional features:

| Base Types | Optional Features |
|---|---|
| SystemNotification | TimestampDecorator |
| MessageNotification | BadgeDecorator |
| PaymentNotification | UrgentDecorator |
| | ActionsDecorator |

**Without** the Decorator Pattern → you need a class for every combination:
`UrgentPaymentNotificationWithBadgeAndActions`, `TimestampedMessageNotificationWithActions`...

That's **3 × 2⁴ = 48 classes** — and it grows exponentially with every new feature.

**With** the Decorator Pattern → you need exactly **7 classes. Forever.**

```dart
// Compose any combination at runtime — no new classes needed
AppNotification notif = PaymentNotification();
notif = BadgeDecorator(notif, count: 3);
notif = UrgentDecorator(notif);
notif = ActionsDecorator(notif);

// Caller just sees AppNotification — no idea what's wrapped inside
notif.render();
```

---

## App Demo

The app has two panels:

- **Left** — pick a base notification, toggle decorators on/off
- **Right** — live notification preview, decoration chain, stats & principles

The stats bar shows in real time how many classes you'd need *without* the pattern vs. with it.

---

## Architecture

This project follows **Clean Architecture** with strict dependency rules:

```
lib/
├── main.dart                                    ← entry point
├── injection.dart                               ← get_it registration

├── domain/                                      ← pure Dart, no Flutter SDK
│   ├── entities/
│   │   └── app_notification.dart               ← abstract entity
│   ├── notifications/
│   │   └── base_notifications.dart             ← System, Message, Payment
│   ├── decorators/
│   │   └── notification_decorators.dart        ← all 4 decorators
│   └── repositories/
│       └── notification_repository.dart        ← interface contract only

├── data/
│   ├── models/
│   │   └── notification_model.dart             ← fromJson / toJson / toEntity()
│   └── repositories/
│       └── notification_repository_impl.dart   ← implements domain contract

└── presentation/
    ├── notifiers/
    │   └── notification_builder_notifier.dart  ← ChangeNotifier state
    ├── pages/
    │   └── notification_builder_page.dart      ← main screen
    └── widgets/
        └── widgets.dart                        ← all UI components
```

### Dependency Rule

```
Presentation → Domain ← Data
```

- The **domain layer** knows nothing about Flutter, JSON, or `get_it`
- The **data layer** knows the domain — `NotificationModel.toEntity()` bridges them
- The **domain layer** is never imported by itself — nothing above it touches JSON

---

## Design Patterns Used

### 1. Decorator Pattern (Chapter 3)

The core of the app. `NotificationDecorator` is an abstract class that:
- **Implements** `AppNotification` (same type — for transparency to callers)
- **Has-A** `AppNotification` (wraps it via composition)
- Delegates everything to the wrapped object by default
- Each concrete decorator only overrides what it adds

```dart
abstract class NotificationDecorator implements AppNotification {
  final AppNotification _notification;
  const NotificationDecorator(this._notification);

  // delegate everything by default
  @override String get title => _notification.title;
  // ...
}

class UrgentDecorator extends NotificationDecorator {
  const UrgentDecorator(super.notification);

  @override NotificationPriority get priority => NotificationPriority.urgent;
  @override String get title => '🚨 ${_notification.title}'; // adds behavior
}
```

### 2. Observer Pattern (Chapter 2)

`NotificationBuilderNotifier extends ChangeNotifier` — when the user toggles a decorator or switches the base, `notifyListeners()` fires and all listening widgets rebuild automatically.

### 3. Strategy Pattern (Chapter 1)

`NotificationRepository` is an abstraction registered in `get_it`. `NotificationBuilderNotifier` depends on the interface — never on `NotificationRepositoryImpl`. Swap the data source by changing one line in `injection.dart`.

---

## Open-Closed Principle

> Classes should be **open for extension** but **closed for modification.**

Adding a new feature — say `SoundDecorator` or `ImageDecorator` — is:

1. Create one new class extending `NotificationDecorator`
2. Add one `if` block in `_rebuildNotification()`

Zero changes to existing classes. Zero changes to the UI. Zero changes to the domain entity.

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`

### Run

```bash
git clone https://github.com/YOUR_USERNAME/decorator_pattern_app
cd decorator_pattern_app
flutter pub get
flutter run
```

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get_it: ^7.6.4
```

---

## Layer Responsibilities

| Layer | Responsibility | Imports Flutter? | Imports get_it? |
|---|---|---|---|
| Domain | Business logic, entities, decorators | ❌ | ❌ |
| Data | JSON parsing, repository implementation | ❌ | ❌ |
| Presentation | UI, state management | ✅ | ✅ |
| Injection | DI wiring | ❌ | ✅ |

---

## Key Files

| File | What it does |
|---|---|
| `domain/entities/app_notification.dart` | The abstract component — every class in the system implements this |
| `domain/decorators/notification_decorators.dart` | All 4 decorators — the heart of the pattern |
| `domain/notifications/base_notifications.dart` | 3 concrete base components |
| `presentation/notifiers/notification_builder_notifier.dart` | Builds the decoration chain, exposes state |
| `injection.dart` | Wires everything with `get_it` |

---

## Learning Resources

- 📖 [Head First Design Patterns](https://www.oreilly.com/library/view/head-first-design/9781492077992/) — Freeman & Robson, O'Reilly
- 📖 [Effective Dart](https://dart.dev/effective-dart)
- 📦 [get_it package](https://pub.dev/packages/get_it)
- 🏗️ [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)

---

## Related Projects

- [Strategy Pattern + get_it](https://github.com/Shiba3006/strategy_pattern_app) — Chapter 1

---

## Author

**Ahmed Shiba** — Flutter Developer
- GitHub: [@Shiba3006](https://github.com/Shiba3006)
- LinkedIn: [Ahmed Shiba](https://linkedin.com/in/your-profile)

---

## License

MIT License — feel free to use this as a reference for your own projects.
