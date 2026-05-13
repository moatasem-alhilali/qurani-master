import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';
import 'package:quran_app/features/floating_adhkar/data/repo/floating_adhkar_repository.dart';
import 'package:timezone/timezone.dart' as tz;

class FloatingAdhkarIosReminderService {
  FloatingAdhkarIosReminderService({
    required FloatingAdhkarRepository repository,
    required NotificationService notificationService,
  })  : _repository = repository,
        _notificationService = notificationService;

  static const int _baseNotificationId = 74200;
  static const int _maxPendingReminders = 32;

  final FloatingAdhkarRepository _repository;
  final NotificationService _notificationService;

  bool get isSupportedPlatform =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  Future<bool> hasPermission() async {
    if (!isSupportedPlatform) {
      return false;
    }
    return _notificationService.areNotificationsEnabled();
  }

  Future<bool> requestPermission() async {
    if (!isSupportedPlatform) {
      return false;
    }
    return _notificationService.requestNotificationPermissions();
  }

  Future<void> scheduleReminders(FloatingAdhkarSettings settings) async {
    if (!isSupportedPlatform) {
      return;
    }

    if (!await hasPermission() && !await requestPermission()) {
      return;
    }

    await cancelReminders();

    final selectable = await _repository.loadSelectableItems(settings);
    if (selectable.isEmpty) {
      return;
    }

    final details = await _notificationService.buildNotificationDetails(
      NotificationChannel.randomThikr,
      iosSubtitle: 'الأذكار العشوائية',
      iosThreadIdentifier: 'floating_adhkar_ios_reminders',
      iosCategoryIdentifier: 'islamic_notifications',
      iosInterruptionLevel: InterruptionLevel.active,
    );

    final interval = Duration(minutes: settings.intervalMinutes.clamp(1, 1440));
    var scheduledAt = tz.TZDateTime.now(tz.local).add(interval);

    for (var i = 0; i < _maxPendingReminders; i++) {
      final item = selectable[i % selectable.length];
      await _notificationService.plugin.zonedSchedule(
        _baseNotificationId + i,
        item.title.trim().isEmpty ? 'ذكر عشوائي' : item.title.trim(),
        item.text.trim(),
        scheduledAt,
        details,
        payload: 'floating_adhkar_ios:${item.id}',
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
      scheduledAt = scheduledAt.add(interval);
    }
  }

  Future<void> showPreviewNow(FloatingAdhkarSettings settings) async {
    if (!isSupportedPlatform) {
      return;
    }

    if (!await hasPermission() && !await requestPermission()) {
      return;
    }

    final item = await _repository.pickNextItem(settings: settings);
    if (item == null) {
      return;
    }

    await _notificationService.showNotificationWithId(
      id: _baseNotificationId + _maxPendingReminders,
      title: item.title.trim().isEmpty ? 'ذكر عشوائي' : item.title.trim(),
      body: item.text.trim(),
      channel: NotificationChannel.randomThikr,
      payload: 'floating_adhkar_ios:${item.id}',
    );
    await _repository.recordShownItem(item);
  }

  Future<void> cancelReminders() async {
    if (!Platform.isIOS) {
      return;
    }

    for (var i = 0; i <= _maxPendingReminders; i++) {
      await _notificationService.cancelNotificationById(
        id: _baseNotificationId + i,
      );
    }
  }
}
