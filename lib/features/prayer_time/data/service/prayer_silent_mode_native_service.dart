import 'dart:io';

import 'package:adhan/adhan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_silent_mode_settings.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:timezone/timezone.dart' as tz;

class PrayerSilentModeNativeService {
  static const MethodChannel _channel = MethodChannel(
    'com.tamaneena.tamaneena_app/prayer_silent_mode',
  );
  static const int _iosNotificationBaseId = 76800;
  static const int _iosNotificationRange = 8;

  Future<bool> isSupported() async {
    if (Platform.isIOS) {
      return true;
    }
    if (!Platform.isAndroid) {
      return false;
    }
    return await _channel.invokeMethod<bool>('isSupported') ?? false;
  }

  Future<bool> hasNotificationPolicyAccess() async {
    if (!Platform.isAndroid) {
      return false;
    }
    return await _channel.invokeMethod<bool>(
          'hasNotificationPolicyAccess',
        ) ??
        false;
  }

  Future<void> openNotificationPolicySettings() async {
    if (!Platform.isAndroid) {
      return;
    }
    await _channel.invokeMethod<void>('openNotificationPolicySettings');
  }

  Future<void> applySchedule({
    required PrayerSilentModeSettings settings,
    required List<PrayerInfoModel> prayers,
  }) async {
    if (Platform.isIOS) {
      await _applyIosPrayerModeReminders(
        settings: settings,
        prayers: prayers,
      );
      return;
    }

    if (!Platform.isAndroid) {
      return;
    }

    if (!settings.enabled) {
      await cancelSchedule();
      return;
    }

    final windows = prayers
        .where((prayer) => _isPrayerThatCanSilenceDevice(prayer.type))
        .map(
          (prayer) => <String, Object>{
            'id': prayer.id,
            'name': prayer.name,
            'timeMillis': prayer.time.millisecondsSinceEpoch,
          },
        )
        .toList();

    await _channel.invokeMethod<void>(
      'schedule',
      <String, Object>{
        'durationMinutes': settings.durationMinutes,
        'windows': windows,
      },
    );
  }

  Future<void> cancelSchedule() async {
    if (Platform.isIOS) {
      await _cancelIosPrayerModeReminders();
      return;
    }

    if (!Platform.isAndroid) {
      return;
    }
    await _channel.invokeMethod<void>('cancel');
  }

  Future<void> _applyIosPrayerModeReminders({
    required PrayerSilentModeSettings settings,
    required List<PrayerInfoModel> prayers,
  }) async {
    final notificationService = sl<NotificationService>();
    await _cancelIosPrayerModeReminders();

    if (!settings.enabled) {
      return;
    }

    final hasPermission = await notificationService.areNotificationsEnabled() ||
        await notificationService.requestNotificationPermissions();
    if (!hasPermission) {
      return;
    }
    if (!await notificationService.isNotificationAllowed(
      settingKey: NotificationKeys.isNotificationPrayerSilentModeReminder,
    )) {
      return;
    }

    final details = await notificationService.buildNotificationDetails(
      NotificationChannel.athan,
      iosSubtitle: 'وضع الصلاة',
      iosThreadIdentifier: 'prayer_mode_ios_reminders',
      iosCategoryIdentifier: 'islamic_notifications',
      iosInterruptionLevel: InterruptionLevel.timeSensitive,
    );

    final now = DateTime.now();
    final upcomingPrayers = prayers
        .where((prayer) => _isPrayerThatCanSilenceDevice(prayer.type))
        .where((prayer) => prayer.time.isAfter(now))
        .toList()
      ..sort((first, second) => first.time.compareTo(second.time));

    for (var i = 0;
        i < upcomingPrayers.length && i < _iosNotificationRange;
        i++) {
      final prayer = upcomingPrayers[i];
      await notificationService.plugin.zonedSchedule(
        _iosNotificationBaseId + i,
        'حان وقت ${prayer.name}',
        'فعّل وضع الصامت أو التركيز للصلاة، ثم أعده بعد الانتهاء.',
        tz.TZDateTime.from(prayer.time, tz.local),
        details,
        payload: 'prayer_mode_ios:${prayer.type.name}',
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> _cancelIosPrayerModeReminders() async {
    if (!Platform.isIOS) {
      return;
    }
    final notificationService = sl<NotificationService>();
    for (var i = 0; i < _iosNotificationRange; i++) {
      await notificationService.cancelNotificationById(
        id: _iosNotificationBaseId + i,
      );
    }
  }

  bool _isPrayerThatCanSilenceDevice(Prayer prayer) {
    return prayer == Prayer.fajr ||
        prayer == Prayer.dhuhr ||
        prayer == Prayer.asr ||
        prayer == Prayer.maghrib ||
        prayer == Prayer.isha;
  }
}
