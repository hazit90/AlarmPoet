import 'package:daylight/daylight.dart';

class SunriseService {
  Future<DateTime?> getSunriseTime(double latitude, double longitude) async {
    final location = DaylightLocation(latitude, longitude);
    final calculator = DaylightCalculator(location);
    final today = DateTime.now().toUtc();

    final sunrise = calculator.calculateEvent(
      today,
      Zenith.civil,
      EventType.sunrise,
    );

    return sunrise?.toLocal();
  }
}
