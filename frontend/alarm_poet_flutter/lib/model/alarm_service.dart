import 'dart:io' show Platform;
import 'package:alarm/alarm.dart';
import 'package:alarm/model/volume_settings.dart';
import 'notification_service.dart';

class AlarmService {
  bool get _isMobilePlatform => Platform.isAndroid || Platform.isIOS;

  /// Schedules a new alarm at the specified [dateTime].
  /// [id] should be unique for each alarm.
  /// [title] and [body] are optional notification details.
  Future<void> setAlarm({
    required int id,
    required DateTime dateTime,
    String? title,
    String? body,
    String assetAudioPath = 'assets/alarm.mp3', // Update as needed
    double volume = 0.8,
    bool loopAudio = true,
    bool vibrate = true,
    bool warningNotificationOnKill = true,
    bool androidFullScreenIntent = true,
    bool allowAlarmOverlap = false,
    bool iOSBackgroundAudio = true,
    String? payload,
  }) async {
    if (!_isMobilePlatform) {
      // Schedule a notification for non-mobile platforms
      final now = DateTime.now();
      final delay = dateTime.difference(now);
      if (delay.isNegative) {
        // If the time is in the past, do not schedule
        return;
      }
      Future.delayed(delay, () {
        NotificationService().showNotification(
          id: id,
          title: title ?? 'Alarm',
          body: body ?? 'Your alarm is ringing!',
          payload: payload,
        );
      });
      return;
    }
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      assetAudioPath: assetAudioPath,
      volumeSettings: VolumeSettings.fixed(
        volume: volume,
        volumeEnforced: false,
      ),
      notificationSettings: NotificationSettings(
        title: title ?? 'Alarm',
        body: body ?? 'Your alarm is ringing!',
      ),
      loopAudio: loopAudio,
      vibrate: vibrate,
      warningNotificationOnKill: warningNotificationOnKill,
      androidFullScreenIntent: androidFullScreenIntent,
      allowAlarmOverlap: allowAlarmOverlap,
      iOSBackgroundAudio: iOSBackgroundAudio,
      payload: payload,
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  /// Cancels the alarm with the given [id].
  Future<void> cancelAlarm(int id) async {
    if (!_isMobilePlatform) {
      // Optionally, you could cancel a scheduled notification here if you keep track of timers
      print('alarm service only supports android and ios');
      return;
    }
    await Alarm.stop(id);
  }

  /// Cancels all scheduled alarms.
  Future<void> cancelAllAlarms() async {
    if (!_isMobilePlatform) {
      print('alarm service only supports android and ios');
      return;
    }
    await Alarm.stopAll();
  }

  /// Returns a list of all scheduled alarms.
  Future<List<AlarmSettings>> getAlarms() async {
    if (!_isMobilePlatform) {
      print('alarm service only supports android and ios');
      return [];
    }
    return await Alarm.getAlarms();
  }
}
