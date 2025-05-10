import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:daylight/daylight.dart';
import 'package:intl/intl.dart' show DateFormat;

class SetAlarmVm extends ChangeNotifier {
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
    notifyListeners();
  }

  Future<void> _initializeLocation() async {
    await fetchLocation();
    await _fetchSunriseTime();
  }

  Future<void> fetchLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        _locationName = "Location services disabled";
        notifyListeners();
        return;
      }
    }

    // Check for location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _locationName = "Location permission denied";
        notifyListeners();
        return;
      }
    }

    // Get the current location
    _locationData = await location.getLocation();

    // Update the location name
    _locationName =
        "Lat: ${_locationData!.latitude}, Lon: ${_locationData!.longitude}";
    notifyListeners();
  }

  Future<void> _fetchSunriseTime() async {
    if (_locationData == null) return;

    // Use the current location to calculate sunrise
    final location = DaylightLocation(
      _locationData!.latitude!,
      _locationData!.longitude!,
    );

    final calculator = DaylightCalculator(location);
    final today = DateTime.now().toUtc();

    // Calculate sunrise for today
    final sunrise = calculator.calculateEvent(
      today,
      Zenith.civil,
      EventType.sunrise,
    );

    if (sunrise != null) {
      _sunriseTime = sunrise.toLocal();
      _alarmTime = _sunriseTime; // Set alarm time to sunrise time
      notifyListeners();
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat("HH:mm:ss").format(time);
  }
}
