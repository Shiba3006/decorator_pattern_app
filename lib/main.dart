// ─────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'injection.dart';
import 'presentation/notifiers/notification_builder_notifier.dart';
import 'presentation/pages/notification_builder_page.dart';
import 'presentation/widgets/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait on mobile
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Setup DI — must run before runApp
  setupDI();

  runApp(const DecoratorPatternApp());
}

class DecoratorPatternApp extends StatelessWidget {
  const DecoratorPatternApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decorator Pattern',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          secondary: AppColors.accent2,
          surface: AppColors.surface,
        ),
      ),
      home: NotificationBuilderPage(
        notifier: getIt<NotificationBuilderNotifier>(),
      ),
    );
  }
}
