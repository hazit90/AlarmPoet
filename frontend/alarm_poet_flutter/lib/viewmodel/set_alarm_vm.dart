import 'package:flutter/material.dart';

class SetAlarmVm extends ChangeNotifier {
  String _locationName = "Current Location";
  //e.g Tomomoroe at 6:38 am
  DateTime _sunriseTime = DateTime.now().subtract(const Duration(hours: 1));
  DateTime _alarmTime = DateTime.now().subtract(const Duration(hours: 1));

  String get locationName => _locationName;

  String get sunriseString => _formatTime(_sunriseTime);

  String get alarmString => _formatTime(_alarmTime);

  void setOffset(Duration offset) {
    _alarmTime = _sunriseTime.add(offset);
    notifyListeners();
  }

  Future<void> updateLocationName() async {
    //dummy code
    _locationName = "Current Location";
    notifyListeners(); // Notify listeners to rebuild UI
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}
