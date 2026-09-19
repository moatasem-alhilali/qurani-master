import 'dart:io';

import 'package:adhan/adhan.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/core/notification/data/notification_data_const.dart'
    as notification_seed;
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_silent_mode_settings.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_calculation_params.dart';

class PrayerSilentModeNativeService {
  static const MethodChannel _channel = MethodChannel(
    'com.tamaneena.tamaneena_app/prayer_silent_mode',
  );

  /// معرّفات تذكيرات iOS التي كانت النسخ السابقة تجدولها (76800–76807).
  ///
  /// أُلغيت الميزة على iOS: النظام لا يسمح لأيّ تطبيق بتحويل الجهاز إلى الصامت،
  /// فكانت مجرّد إشعار يطلب من المستخدم فعل ذلك بيده. تبقى هذه القيم فقط لإلغاء
  /// ما جدولته النسخ السابقة ولم يُطلق بعد، وإلا لاستمرّ وصوله يومين بعد التحديث.
  static const int _legacyIosReminderBaseId = 76800;
  static const int _legacyIosReminderCount = 8;

  /// أندرويد فقط.
  Future<bool> isSupported() async {
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
      await _cancelLegacyIosReminders();
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
      await _cancelLegacyIosReminders();
      return;
    }

    if (!Platform.isAndroid) {
      return;
    }
    await _channel.invokeMethod<void>('cancel');
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

      final triggerTime = _resolveDeviceInstant(
        prayer.time,
        selectedLocation?.utcOffsetMinutes,
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
      PrayerCalculationParams.build(date: tomorrowAtLocation),
      Duration(minutes: selectedLocation.utcOffsetMinutes),
    );
    return notification_seed.NotificationDataConstSeed()
        .prayerInfoListSeed(prayerTimes);
  }

  /// يحوّل موعد صلاة إلى لحظته الحقيقية على الجهاز.
  ///
  /// **الساعة المقروءة هي الحقيقة، لا علامة UTC.** مواقيت التطبيق كلّها تأتي
  /// من `PrayerTimes.utcOffset`، الذي يفعل (adhan 2.0.0+1، prayer_times.dart:265):
  ///
  ///     _isha = isha.toUtc().add(utcOffset);
  ///
  /// فيخرج `DateTime` بعلامة `isUtc == true` لكن ساعته «19:38» هي توقيت المدينة
  /// المحلي، ولحظته الفعلية 22:38 في الرياض. كان هنا فرع مبكر:
  ///
  ///     if (prayerTime.isUtc) return prayerTime.toLocal();
  ///
  /// يلتقط هذه القيم بالذات فيُزيحها بفرق التوقيت مرّة ثانية — فيدخل الجهاز
  /// الصامت على أندرويد بعد الصلاة بثلاث ساعات، ويصل تذكير iOS متأخرًا.
  ///
  /// الصحيح دائمًا: اقرأ الساعة كتوقيت المدينة واطرح فرقها. وهذا يصحّ أيضًا
  /// لمواعيد UTC حقيقية (فرقها صفر)، ولمواعيد `PrayerTimes.today` المحلّية.
  ///
  /// بلا موقع ([utcOffsetMinutes] فارغ) تُقرأ الساعة بتوقيت الجهاز نفسه.
  DateTime _resolveDeviceInstant(
    DateTime prayerTime,
    int? utcOffsetMinutes,
  ) {
    if (utcOffsetMinutes == null) {
      return DateTime(
        prayerTime.year,
        prayerTime.month,
        prayerTime.day,
        prayerTime.hour,
        prayerTime.minute,
        prayerTime.second,
        prayerTime.millisecond,
        prayerTime.microsecond,
      );
    }

    final locationWallClockAsUtc = DateTime.utc(
      prayerTime.year,
      prayerTime.month,
      prayerTime.day,
      prayerTime.hour,
      prayerTime.minute,
      prayerTime.second,
      prayerTime.millisecond,
      prayerTime.microsecond,
    );
    return locationWallClockAsUtc
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

  Future<void> _cancelLegacyIosReminders() async {
    final notificationService = sl<NotificationService>();
    for (var i = 0; i < _legacyIosReminderCount; i++) {
      await notificationService.cancelNotificationById(
        id: _legacyIosReminderBaseId + i,
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
