import 'package:flutter/material.dart';

class LoginVm extends ChangeNotifier {
  String _userId = '';

  String get userId => _userId;

  void updateUserId(String value) {
    _userId = value;
    notifyListeners();
  }

  void login() {
    // Add login logic here (e.g., API call, validation, etc.)
    debugPrint('User $_userId logged in');
  }
}
