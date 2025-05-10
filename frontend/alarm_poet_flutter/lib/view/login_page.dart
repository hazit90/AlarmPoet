import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/login_vm.dart';
import 'set_alarm_page.dart'; // Import SetAlarmPage

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginVm>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'User Id',
                  ),
                  onChanged: vm.updateUserId,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    vm.login(); // Perform login logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SetAlarmPage(),
                      ),
                    ); // Navigate to SetAlarmPage
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
