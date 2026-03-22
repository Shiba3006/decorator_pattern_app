// ─────────────────────────────────────────────
// INJECTION — get_it Registration
// One place, all wiring. Depend on abstractions.
// ─────────────────────────────────────────────

import 'package:get_it/get_it.dart';

import 'data/repositories/notification_repository_impl.dart';
import 'domain/repositories/notification_repository.dart';
import 'presentation/notifiers/notification_builder_notifier.dart';

final getIt = GetIt.instance;

void setupDI() {
  // Data layer
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(),
  );

  // Presentation layer
  // Factory — fresh notifier per page instance
  getIt.registerFactory<NotificationBuilderNotifier>(
    () => NotificationBuilderNotifier(getIt<NotificationRepository>()),
  );
}
