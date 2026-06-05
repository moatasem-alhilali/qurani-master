import 'dart:io';

import 'package:adhan/adhan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/data/notification_data_const.dart'
    as notification_seed;
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';
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
    PrayerLocationSelection? selectedLocation,
  }) async {
    if (Platform.isIOS) {
      await _applyIosPrayerModeReminders(
        settings: settings,
        prayers: _buildSchedulePrayers(
          prayers: prayers,
          selectedLocation: selectedLocation,
        ),
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

    final windows = _buildScheduleWindows(
      prayers: prayers,
      selectedLocation: selectedLocation,
      durationMinutes: settings.durationMinutes,
    );

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

  List<PrayerInfoModel> _buildSchedulePrayers({
    required List<PrayerInfoModel> prayers,
    PrayerLocationSelection? selectedLocation,
  }) {
    final schedulePrayers = <PrayerInfoModel>[
      ...prayers,
      if (selectedLocation != null)
        ..._buildPrayersForTomorrow(selectedLocation),
    ];

    return schedulePrayers
      ..sort((first, second) => first.time.compareTo(second.time));
  }

  List<Map<String, Object>> _buildScheduleWindows({
    required List<PrayerInfoModel> prayers,
    required int durationMinutes,
    PrayerLocationSelection? selectedLocation,
  }) {
    final now = DateTime.now();
    final duration = Duration(minutes: durationMinutes.clamp(1, 360));
    final schedulePrayers = _buildSchedulePrayers(
      prayers: prayers,
      selectedLocation: selectedLocation,
    );
    final seenKeys = <String>{};
    final windows = <Map<String, Object>>[];

    for (final prayer in schedulePrayers) {
      if (!_isPrayerThatCanSilenceDevice(prayer.type)) {
        continue;
      }

      final triggerTime = selectedLocation == null
          ? prayer.time
          : _resolveDeviceInstant(
              prayer.time,
              selectedLocation.utcOffsetMinutes,
            );
      final endTime = triggerTime.add(duration);
      if (!endTime.isAfter(now)) {
        continue;
      }

      final key = '${prayer.type.name}_${triggerTime.toIso8601String()}';
      if (!seenKeys.add(key)) {
        continue;
      }

      windows.add(<String, Object>{
        'id': prayer.id,
        'requestCode': _requestCodeFor(prayer.type, triggerTime),
        'name': prayer.name,
        'type': prayer.type.name,
        'timeMillis': triggerTime.millisecondsSinceEpoch,
        'endMillis': endTime.millisecondsSinceEpoch,
      });
    }

    windows.sort(
      (first, second) =>
          _windowTimeMillis(first).compareTo(_windowTimeMillis(second)),
    );
    return windows.take(10).toList();
  }

  int _windowTimeMillis(Map<String, Object> window) {
    final value = window['timeMillis'];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return 0;
  }

  List<PrayerInfoModel> _buildPrayersForTomorrow(
    PrayerLocationSelection selectedLocation,
  ) {
    final params = CalculationMethod.muslim_world_league.getParameters()
      ..madhab = Madhab.shafi;
    final locationNow = DateTime.now().toUtc().add(
          Duration(minutes: selectedLocation.utcOffsetMinutes),
        );
    final tomorrowAtLocation = DateTime(
      locationNow.year,
      locationNow.month,
      locationNow.day,
    ).add(const Duration(days: 1));
    final prayerTimes = PrayerTimes.utcOffset(
      Coordinates(selectedLocation.latitude, selectedLocation.longitude),
      DateComponents.from(tomorrowAtLocation),
      params,
      Duration(minutes: selectedLocation.utcOffsetMinutes),
    );
    return notification_seed.NotificationDataConstSeed()
        .prayerInfoListSeed(prayerTimes);
  }

  DateTime _resolveDeviceInstant(
    DateTime prayerTime,
    int utcOffsetMinutes,
  ) {
    if (prayerTime.isUtc) {
      return prayerTime.toLocal();
    }

    final locationLocalTimeAsUtc = DateTime.utc(
      prayerTime.year,
      prayerTime.month,
      prayerTime.day,
      prayerTime.hour,
      prayerTime.minute,
      prayerTime.second,
      prayerTime.millisecond,
      prayerTime.microsecond,
    );
    return locationLocalTimeAsUtc
        .subtract(Duration(minutes: utcOffsetMinutes))
        .toLocal();
  }

  int _requestCodeFor(Prayer prayer, DateTime triggerTime) {
    final order = switch (prayer) {
      Prayer.fajr => 1,
      Prayer.dhuhr => 2,
      Prayer.asr => 3,
      Prayer.maghrib => 4,
      Prayer.isha => 5,
      _ => 0,
    };
    final dateCode = (triggerTime.year % 100) * 10000 +
        triggerTime.month * 100 +
        triggerTime.day;
    return 630000 + dateCode * 10 + order;
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
