import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../static/themes.dart'; // ⬅️ already in your project
import '../viewmodel/set_alarm_vm.dart'; // ⬅️ you’ll implement this VM

/// Displays the “Set alarm” screen shown in the design.
/// ─────────────────────────────────────────────────────────────────────────
/// • Blue rounded-corner background.
/// • Current location row at the top.
/// • Sunrise time card (yellow).
/// • Alarm time card (red) that updates when the user taps an action button.
/// • Three pill-style action buttons pinned to the bottom.
///
class SetAlarmPage extends StatelessWidget {
  const SetAlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SetAlarmVm>(
      builder: (context, vm, _) {
        return Scaffold(
          // Full-screen coloured backdrop with the same radius used elsewhere.
          backgroundColor: CustomColors.lightSkyBlue,
          body: SafeArea(
            child: Column(
              children: [
                // ─── Location ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Insets.large),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on,
                          size: 42, color: CustomColors.pinRed),
                      const SizedBox(width: Insets.small),
                      Flexible(
                        child: Text(
                          vm.locationName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Insets.xxxLarge),

                // ─── Sunrise card ───────────────────────────────────────────
                _TimeRow(
                  icon: Icons.wb_sunny,
                  iconColor: CustomColors.sunYellow,
                  background: CustomColors.sunYellow,
                  timeText: vm.sunriseString,
                ),

                const SizedBox(height: Insets.huge),

                // ─── Alarm card ─────────────────────────────────────────────
                _TimeRow(
                  icon: Icons.alarm,
                  iconColor: CustomColors.alarmRed,
                  background: CustomColors.alarmRed,
                  timeText: vm.alarmString,
                ),

                const Spacer(),

                // ─── Bottom action buttons ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      Insets.large, 0, Insets.large, Insets.large),
                  child: Row(
                    children: [
                      _ActionButton(
                        label: 'At sunrise',
                        onPressed: () => vm.setOffset(const Duration()),
                      ),
                      const SizedBox(width: Insets.medium),
                      _ActionButton(
                        label: '+1 hour',
                        onPressed: () => vm.setOffset(const Duration(hours: 1)),
                      ),
                      const SizedBox(width: Insets.medium),
                      _ActionButton(
                        label: '-1 hour',
                        onPressed: () =>
                            vm.setOffset(const Duration(hours: -1)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Compact wrapper that pairs a large leading icon with a coloured card.
class _TimeRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color background;
  final String timeText;

  const _TimeRow({
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 88, color: iconColor),
        const SizedBox(width: Insets.medium),
        _TimeCard(
          timeText: timeText,
          background: background,
        ),
      ],
    );
  }
}

/// Rounded-rectangle card that mimics the yellow/red boxes in the mock-up.
class _TimeCard extends StatelessWidget {
  final String timeText;
  final Color background;

  const _TimeCard({
    required this.timeText,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 110,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        timeText,
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// White pill-shaped button seen at the bottom of the design.
class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(vertical: Insets.medium),
          textStyle:
              Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 16),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
