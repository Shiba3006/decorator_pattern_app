// ─────────────────────────────────────────────
// PRESENTATION LAYER — Page
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../notifiers/notification_builder_notifier.dart';
import '../widgets/widgets.dart';

class NotificationBuilderPage extends StatefulWidget {
  final NotificationBuilderNotifier notifier;

  const NotificationBuilderPage({required this.notifier, super.key});

  @override
  State<NotificationBuilderPage> createState() =>
      _NotificationBuilderPageState();
}

class _NotificationBuilderPageState extends State<NotificationBuilderPage> {
  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_onNotifierChange);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onNotifierChange);
    super.dispose();
  }

  void _onNotifierChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final notifier = widget.notifier;
    final isWide = MediaQuery.of(context).size.width > 720;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // ── Header ──────────────────────
          _Header(),

          // ── Body ────────────────────────
          Expanded(
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left panel
                      SizedBox(
                        width: 340,
                        child: _LeftPanel(notifier: notifier),
                      ),
                      // Divider
                      Container(width: 1, color: AppColors.border),
                      // Right panel
                      Expanded(child: _RightPanel(notifier: notifier)),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        _LeftPanel(notifier: notifier),
                        Container(height: 1, color: AppColors.border),
                        _RightPanel(notifier: notifier),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Header ───────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const Text(
            'Decorator Pattern',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: const Text(
              'CHAPTER 3',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.accent,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Head First Design Patterns',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.text3,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

// ── Left Panel ───────────────────────────────
class _LeftPanel extends StatelessWidget {
  final NotificationBuilderNotifier notifier;
  const _LeftPanel({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('1 — base component'),
          BaseSelector(notifier: notifier),
          const SizedBox(height: 28),

          const SectionLabel('2 — stack decorators'),
          DecoratorToggle(notifier: notifier),
          const SizedBox(height: 28),

          const SectionLabel('decoration chain'),
          ChainDisplay(notifier: notifier),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

// ── Right Panel ──────────────────────────────
class _RightPanel extends StatelessWidget {
  final NotificationBuilderNotifier notifier;
  const _RightPanel({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('live preview'),
          NotificationCard(notification: notifier.currentNotification),
          const SizedBox(height: 24),

          const SectionLabel('stats'),
          StatsBar(notifier: notifier),
          const SizedBox(height: 24),

          const SectionLabel('key principles'),
          _Principles(),
        ],
      ),
    );
  }
}

// ── Principles ───────────────────────────────
class _Principles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const principles = [
      (
        '🔒  Open-Closed Principle',
        'Base classes never change. New features = new decorator class only.',
      ),
      (
        '🧩  Composition over inheritance',
        'Behavior added by wrapping, not subclassing.',
      ),
      (
        '🔁  Same type',
        'Every decorator implements AppNotification — callers never know.',
      ),
      (
        '⚡  Runtime flexibility',
        'Combine any decorators at runtime without new classes.',
      ),
    ];

    return Column(
      children: principles
          .map(
            (p) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.$1,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.text,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.$2,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.text2,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'monospace',
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
