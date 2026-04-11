import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/features/prayer_time/data/service/athan_alarm_payload_service.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_athan_alert_screen.dart';

class AthanAlarmNotificationRouterService {
  AthanAlarmNotificationRouterService({
    required NotificationService notificationService,
    required AthanAlarmPayloadService payloadService,
  })  : _notificationService = notificationService,
        _payloadService = payloadService;

  final NotificationService _notificationService;
  final AthanAlarmPayloadService _payloadService;

  StreamSubscription<String>? _subscription;
  bool _initialized = false;
  String? _lastPayload;
  DateTime? _lastHandledAt;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    _subscription = selectNotificationSubject.stream.listen(_handlePayload);

    final details =
        await _notificationService.plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      _handlePayload(details?.notificationResponse?.payload ?? '');
    }
  }

  void _handlePayload(String payload) {
    final data = _payloadService.parsePayload(payload);
    if (data == null) {
      return;
    }

    final now = DateTime.now();
    if (_lastPayload == payload &&
        _lastHandledAt != null &&
        now.difference(_lastHandledAt!) < const Duration(seconds: 1)) {
      return;
    }

    _lastPayload = payload;
    _lastHandledAt = now;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = NavigationService.navigatorKey.currentState;
      if (navigator == null) {
        return;
      }

      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => PrayerAthanAlertScreen(
            prayerName: data.prayerName,
            prayerTimeLabel: data.prayerTimeLabel,
          ),
        ),
      );
    });

    selectNotificationSubject.add('');
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}
