import 'package:flutter/foundation.dart';

class PoemGenVm extends ChangeNotifier {
  // Add properties and methods here as needed

  PoemGenVm();

  final List<String> _tags = [];

  List<String> get tags => _tags;

  void addString(String value) {
    _tags.add(value);
    notifyListeners();
  }

  void removeString(String value) {
    _tags.remove(value);
    notifyListeners();
  }
}
