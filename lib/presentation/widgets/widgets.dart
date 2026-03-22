// ─────────────────────────────────────────────
// PRESENTATION LAYER — Widgets
// Pure UI — only knows about the notifier.
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../notifiers/notification_builder_notifier.dart';
import '../../domain/entities/app_notification.dart';

// ── App Theme ────────────────────────────────
class AppColors {
  static const bg = Color(0xFF0A0A0F);
  static const surface = Color(0xFF111118);
  static const surface2 = Color(0xFF18181F);
  static const border = Color(0xFF2A2A35);
  static const accent = Color(0xFF7C6AF7);
  static const accent2 = Color(0xFFF76A8F);
  static const accent3 = Color(0xFF6AF7C8);
  static const text = Color(0xFFE8E6F0);
  static const text2 = Color(0xFF8884A0);
  static const text3 = Color(0xFF4A4860);
}

// ── NotificationCard ─────────────────────────
class NotificationCard extends StatelessWidget {
  final AppNotification notification;

  const NotificationCard({required this.notification, super.key});

  @override
  Widget build(BuildContext context) {
    final isUrgent = notification.priority == NotificationPriority.urgent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent
              ? AppColors.accent2.withOpacity(0.6)
              : AppColors.border,
          width: isUrgent ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          // Urgent stripe
          if (isUrgent) _UrgentStripe(),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardTop(notification: notification),
                const SizedBox(height: 10),
                _CardBody(notification: notification),
                if (notification.hasTimestamp) ...[
                  const SizedBox(height: 8),
                  _Timestamp(sentAt: notification.sentAt),
                ],
                if (notification.hasActions) ...[
                  const SizedBox(height: 14),
                  const _ActionButtons(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UrgentStripe extends StatefulWidget {
  @override
  State<_UrgentStripe> createState() => _UrgentStripeState();
}

class _UrgentStripeState extends State<_UrgentStripe>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          color: AppColors.accent2,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
    );
  }
}

class _CardTop extends StatelessWidget {
  final AppNotification notification;
  const _CardTop({required this.notification});

  @override
  Widget build(BuildContext context) {
    final isUrgent = notification.priority == NotificationPriority.urgent;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App icon
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(notification.icon, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(width: 12),

        // Title + app name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    notification.appName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.text2,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                      fontFamily: 'monospace',
                    ),
                  ),
                  if (isUrgent) ...[const SizedBox(width: 8), _UrgentPill()],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                notification.title,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        // Badge
        if (notification.hasBadge) _Badge(count: notification.badgeCount),
      ],
    );
  }
}

class _UrgentPill extends StatefulWidget {
  @override
  State<_UrgentPill> createState() => _UrgentPillState();
}

class _UrgentPillState extends State<_UrgentPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.accent2.withOpacity(0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.accent2.withOpacity(0.4)),
        ),
        child: const Text(
          'URGENT',
          style: TextStyle(
            fontSize: 9,
            color: AppColors.accent2,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: AppColors.accent2,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  final AppNotification notification;
  const _CardBody({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Text(
      notification.body,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.text2,
        height: 1.6,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

class _Timestamp extends StatelessWidget {
  final DateTime? sentAt;
  const _Timestamp({this.sentAt});

  @override
  Widget build(BuildContext context) {
    final time = sentAt ?? DateTime.now();
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');

    return Text(
      '⏱  Just now · $h:$m',
      style: const TextStyle(
        fontSize: 11,
        color: AppColors.text3,
        fontFamily: 'monospace',
      ),
    );
  }
}

class _ActionButtons extends StatefulWidget {
  const _ActionButtons();

  @override
  State<_ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<_ActionButtons> {
  bool _dismissed = false;
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionBtn(
              label: _dismissed ? '✓ Done' : 'Dismiss',
              isPrimary: false,
              onTap: () => setState(() => _dismissed = true),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ActionBtn(
              label: _opened ? '✓ Opened' : 'Open',
              isPrimary: true,
              onTap: () => setState(() => _opened = true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isPrimary ? AppColors.accent : AppColors.border,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isPrimary ? Colors.white : AppColors.text2,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}

// ── BaseSelector ─────────────────────────────
class BaseSelector extends StatelessWidget {
  final NotificationBuilderNotifier notifier;

  const BaseSelector({required this.notifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: NotificationBuilderNotifier.bases.map((base) {
        final isActive = notifier.selectedBase == base.key;
        final color = Color(base.color);

        return GestureDetector(
          onTap: () => notifier.selectBase(base.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? color.withOpacity(0.08) : AppColors.surface2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive ? color.withOpacity(0.7) : AppColors.border,
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(base.emoji, style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        base.label,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        base.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.text2,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                if (isActive)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── DecoratorToggle ───────────────────────────
class DecoratorToggle extends StatelessWidget {
  final NotificationBuilderNotifier notifier;

  const DecoratorToggle({required this.notifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: NotificationBuilderNotifier.decorators.map((dec) {
        final isOn = notifier.isDecoratorActive(dec.key);
        final color = Color(dec.color);

        return GestureDetector(
          onTap: () => notifier.toggleDecorator(dec.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isOn ? color.withOpacity(0.08) : AppColors.surface2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isOn ? color.withOpacity(0.7) : AppColors.border,
                width: isOn ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                // Dot indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isOn ? color : AppColors.text3,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dec.name,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        dec.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.text2,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),

                // Cost pill
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isOn ? color.withOpacity(0.12) : AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isOn ? color.withOpacity(0.5) : AppColors.border,
                    ),
                  ),
                  child: Text(
                    dec.cost,
                    style: TextStyle(
                      fontSize: 11,
                      color: isOn ? color : AppColors.text2,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── ChainDisplay ─────────────────────────────
class ChainDisplay extends StatelessWidget {
  final NotificationBuilderNotifier notifier;

  const ChainDisplay({required this.notifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        notifier.chainString,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.text2,
          fontFamily: 'monospace',
          height: 1.7,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

// ── StatsBar ─────────────────────────────────
class StatsBar extends StatelessWidget {
  final NotificationBuilderNotifier notifier;

  const StatsBar({required this.notifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(label: 'Base', value: '1', color: AppColors.accent),
        const SizedBox(width: 10),
        _Stat(
          label: 'Decorators',
          value: '${notifier.decoratorCount}',
          color: AppColors.accent3,
        ),
        const SizedBox(width: 10),
        _Stat(
          label: 'With pattern',
          value: '${notifier.classesWithPattern}',
          color: AppColors.text,
        ),
        const SizedBox(width: 10),
        _Stat(
          label: 'Without pattern',
          value: '${notifier.classesWithoutPattern}',
          color: AppColors.accent2,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 9,
                color: AppColors.text3,
                letterSpacing: 1,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── SectionLabel ─────────────────────────────
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          color: AppColors.text3,
          letterSpacing: 2,
          fontWeight: FontWeight.w500,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
