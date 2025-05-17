import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../static/themes.dart';
import '../viewmodel/set_alarm_vm.dart';

/// Displays the sunrise and alarm time rows.
class AlarmsList extends StatelessWidget {
  const AlarmsList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SetAlarmVm>(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(80),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ─── Sunrise card ───────────────────────────────────────────
            _TimeRow(
              icon: Icons.wb_sunny,
              iconColor: CustomColors.sunYellow,
              background: CustomColors.sunYellow,
              timeText: vm.sunriseString,
            ),
            const SizedBox(height: Insets.small),
            // ─── List of Alarms ────────────────────────────────────────
            if (vm.alarms.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: vm.alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = vm.alarms[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Dismissible(
                        key: Key('alarm-${alarm.id}'),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => vm.cancelAlarm(alarm.id),
                        child: _TimeRow(
                          icon: Icons.alarm,
                          iconColor: CustomColors.alarmRed,
                          background: CustomColors.alarmRed,
                          timeText: DateFormat('HH:mm:ss').format(alarm.time),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (vm.alarms.isEmpty) const SizedBox(height: Insets.huge),
            // ─── Add Alarm Button ────────────────────────────────────────
            ElevatedButton.icon(
              onPressed: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  final now = DateTime.now();
                  final DateTime selectedTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  final newId = DateTime.now().millisecondsSinceEpoch;
                  await vm.setAlarm(
                    id: newId,
                    title: 'Alarm',
                    body: 'Wake up!',
                    alarmTime: selectedTime, // <-- pass the picked time
                  );
                }
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add alarm',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.alarmRed,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
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
