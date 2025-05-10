import 'package:flutter/material.dart';
import 'package:location/location.dart';

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
        return; // Exit if the user does not enable location services
      }
    }

    // Check for location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _locationName = "Location permission denied";
        notifyListeners();
        return; // Exit if the user does not grant permissions
      }
    }

    // Get the current location
    _locationData = await location.getLocation();

    // Update the location name (you can use reverse geocoding here if needed)
    _locationName =
        "Lat: ${_locationData!.latitude}, Lon: ${_locationData?.longitude}";
    notifyListeners();
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}
