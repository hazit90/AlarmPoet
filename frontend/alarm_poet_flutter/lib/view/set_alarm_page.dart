import 'package:alarm_poet_flutter/view/poem_tags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../static/themes.dart'; // ⬅️ already in your project
import '../viewmodel/set_alarm_vm.dart'; // ⬅️ you’ll implement this VM
import '../viewmodel/poem_gen_vm.dart'; // Add this import
import 'alarms_list.dart'; // import the new widget

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PoemGenVm()),
        ChangeNotifierProvider(create: (_) => SetAlarmVm()),
      ],
      child: Consumer2<SetAlarmVm, PoemGenVm>(
        builder: (context, alarmVm, poemVm, _) {
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
                            alarmVm.locationName,
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

                  // ─── Alarms List ───────────────────────────────────────────
                  const Expanded(child: AlarmsList()),

                  // // ─── Bottom pills that hold hashtags with poem generation
                  PoemTags(),
                ],
              ),
            ),
          );
        },
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
