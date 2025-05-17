import 'package:alarm/alarm.dart';
import 'package:alarm_poet_flutter/view/set_alarm_page.dart';
import 'package:alarm_poet_flutter/viewmodel/poem_gen_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/set_alarm_vm.dart';
import 'model/notification_service.dart'; // <-- Add this import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await NotificationService().init(); // <-- Initialize notifications
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => PoemGenVm()), // Provide PoemGenVmPoemGenVm
        ChangeNotifierProvider(
            create: (_) => SetAlarmVm()), // Provide SetAlarmVm
      ],
      child: const MaterialApp(
        home: SetAlarmPage(), // Set LoginPage as the startup page
      ),
    );
  }
}
