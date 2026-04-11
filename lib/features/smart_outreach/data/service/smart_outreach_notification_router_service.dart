import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_notification_service.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_execution_screen.dart';

class SmartOutreachNotificationRouterService {
  SmartOutreachNotificationRouterService({
    required NotificationService notificationService,
    required SmartOutreachNotificationService smartOutreachNotificationService,
  })  : _notificationService = notificationService,
        _smartOutreachNotificationService = smartOutreachNotificationService;

  final NotificationService _notificationService;
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

    _subscription = selectNotificationSubject.stream.listen(_handlePayload);

    final details =
        await _notificationService.plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      _handlePayload(details?.notificationResponse?.payload ?? '');
    }
  }

  void _handlePayload(String payload) {
    final scheduleId =
        _smartOutreachNotificationService.extractScheduleId(payload);
    if (scheduleId == null) {
      return;
    }

    final now = DateTime.now();
    if (_lastHandledScheduleId == scheduleId &&
        _lastHandledAt != null &&
        now.difference(_lastHandledAt!) < const Duration(seconds: 1)) {
      return;
    }

    _lastHandledScheduleId = scheduleId;
    _lastHandledAt = now;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = NavigationService.navigatorKey.currentState;
      if (navigator == null) {
        return;
      }

      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => SmartOutreachExecutionScreen(
            scheduleId: scheduleId,
            launchedFromNotification: true,
          ),
        ),
      );
    });

    // clear last payload value to avoid re-processing stale behavior subject data
    selectNotificationSubject.add('');
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}
