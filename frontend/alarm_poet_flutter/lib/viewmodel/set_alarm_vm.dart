import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../model/location_service.dart';
import '../model/sunrise_service.dart';
import '../model/alarm_service.dart'; // <-- Import AlarmService
import 'package:intl/intl.dart' show DateFormat;

class SetAlarmVm extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final SunriseService _sunriseService = SunriseService();
  final AlarmService _alarmService = AlarmService(); // <-- Add AlarmService

  String _locationName = "Fetching location...";
  DateTime _sunriseTime = DateTime.now().subtract(const Duration(hours: 1));
  DateTime _alarmTime = DateTime.now().subtract(const Duration(hours: 1));
  LocationData? _locationData;

  String get locationName => _locationName;
  String get sunriseString => _formatTime(_sunriseTime);
  String get alarmString => _formatTime(_alarmTime);
  DateTime get alarmTime => _alarmTime;

  SetAlarmVm() {
    _initializeLocation();
  }

  void setOffset(Duration offset) {
    _alarmTime = _sunriseTime.add(offset);
    notifyListeners();
  }

  void setAlarmTime(DateTime alarmTime) {
    _alarmTime = alarmTime;
    setAlarm(id: 2478);
    notifyListeners();
  }

  Future<void> setAlarm({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async {
    await _alarmService.setAlarm(
      id: id,
      dateTime: _alarmTime,
      title: title,
      body: body,
      payload: payload,
    );
  }

  Future<void> cancelAlarm(int id) async {
    await _alarmService.cancelAlarm(id);
  }

  Future<void> cancelAllAlarms() async {
    await _alarmService.cancelAllAlarms();
  }

  Future<void> _initializeLocation() async {
    await fetchLocation();
    await _fetchSunriseTime();
  }

  Future<void> fetchLocation() async {
    _locationData = await _locationService.getCurrentLocation();
    if (_locationData == null) {
      _locationName = "Location unavailable";
    } else {
      _locationName =
          "Lat: ${_locationData!.latitude}, Lon: ${_locationData!.longitude}";
    }
    notifyListeners();
  }

  Future<void> _fetchSunriseTime() async {
    if (_locationData == null) return;
    final sunrise = await _sunriseService.getSunriseTime(
      _locationData!.latitude!,
      _locationData!.longitude!,
    );
    if (sunrise != null) {
      _sunriseTime = sunrise;
      _alarmTime = _sunriseTime;
      notifyListeners();
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat("HH:mm:ss").format(time);
  }
}
