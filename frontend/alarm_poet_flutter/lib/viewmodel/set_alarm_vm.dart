import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../model/location_service.dart';
import '../model/sunrise_service.dart';
import '../model/alarm_service.dart';
import 'package:intl/intl.dart' show DateFormat;

class AlarmData {
  final int id;
  final DateTime time;
  final String? title;
  final String? body;
  final String? payload;

  AlarmData({
    required this.id,
    required this.time,
    this.title,
    this.body,
    this.payload,
  });
}

class SetAlarmVm extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final SunriseService _sunriseService = SunriseService();
  final AlarmService _alarmService = AlarmService();

  String _locationName = "Fetching location...";
  DateTime _sunriseTime = DateTime.now().subtract(const Duration(hours: 1));
  DateTime _alarmTime = DateTime.now().subtract(const Duration(hours: 1));
  LocationData? _locationData;
  final List<AlarmData> _alarms = [];

  String get locationName => _locationName;
  String get sunriseString => _formatTime(_sunriseTime);
  String get alarmString => _formatTime(_alarmTime);
  DateTime get alarmTime => _alarmTime;
  List<AlarmData> get alarms => List.unmodifiable(_alarms);

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
    DateTime? alarmTime, // <-- add this parameter
  }) async {
    final DateTime timeToSet = alarmTime ?? _alarmTime;
    await _alarmService.setAlarm(
      id: id,
      dateTime: timeToSet,
      title: title,
      body: body,
      payload: payload,
    );

    _alarms.add(AlarmData(
      id: id,
      time: timeToSet,
      title: title,
      body: body,
      payload: payload,
    ));
    notifyListeners();
  }

  Future<void> cancelAlarm(int id) async {
    await _alarmService.cancelAlarm(id);
    _alarms.removeWhere((alarm) => alarm.id == id);
    notifyListeners();
  }

  Future<void> cancelAllAlarms() async {
    await _alarmService.cancelAllAlarms();
    _alarms.clear();
    notifyListeners();
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
