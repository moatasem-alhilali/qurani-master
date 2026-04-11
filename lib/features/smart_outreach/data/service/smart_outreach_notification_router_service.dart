import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_notification_service.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_alarm_alert_screen.dart';

class SmartOutreachNotificationRouterService with WidgetsBindingObserver {
  SmartOutreachNotificationRouterService({
    required SmartOutreachNotificationService smartOutreachNotificationService,
  }) : _smartOutreachNotificationService = smartOutreachNotificationService;

  final SmartOutreachNotificationService _smartOutreachNotificationService;

  StreamSubscription<String>? _subscription;
  bool _initialized = false;
  int? _lastHandledScheduleId;
  DateTime? _lastHandledAt;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    WidgetsBinding.instance.addObserver(this);
    _subscription = selectNotificationSubject.stream.listen((payload) {
      _handlePayload(payload);
    });

    await _consumePendingNativeAlarmIntent();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_consumePendingNativeAlarmIntent());
    }
  }

  Future<void> _handlePayload(String payload) async {
    final scheduleId =
        _smartOutreachNotificationService.extractScheduleId(payload);
    if (scheduleId == null) {
      return;
    }

    _openAlarmScreen(
      scheduleId: scheduleId,
    );

    // clear behavior subject value to avoid stale replay handling
    selectNotificationSubject.add('');
  }

  Future<void> _consumePendingNativeAlarmIntent() async {
    final scheduleId = await _smartOutreachNotificationService
        .consumePendingScheduleIdFromNativeAlarm();
    if (scheduleId == null) {
      return;
    }

    _openAlarmScreen(
      scheduleId: scheduleId,
    );
  }

  void _openAlarmScreen({
    required int scheduleId,
  }) {
    if (_isDuplicate(scheduleId)) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = NavigationService.navigatorKey.currentState;
      if (navigator == null) {
        return;
      }

      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => SmartOutreachAlarmAlertScreen(
            scheduleId: scheduleId,
          ),
        ),
      );
    });
  }

  bool _isDuplicate(int scheduleId) {
    final now = DateTime.now();
    final isDuplicate = _lastHandledScheduleId == scheduleId &&
        _lastHandledAt != null &&
        now.difference(_lastHandledAt!) < const Duration(seconds: 2);

    _lastHandledScheduleId = scheduleId;
    _lastHandledAt = now;
    return isDuplicate;
  }

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}
