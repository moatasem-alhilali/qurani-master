import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_notification_service.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_alarm_alert_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmartOutreachNotificationRouterService {
  SmartOutreachNotificationRouterService({
    required SmartOutreachNotificationService smartOutreachNotificationService,
  }) : _smartOutreachNotificationService = smartOutreachNotificationService;

  final SmartOutreachNotificationService _smartOutreachNotificationService;

  StreamSubscription<String>? _subscription;
  bool _initialized = false;
  int? _lastHandledScheduleId;
  DateTime? _lastHandledAt;

  static const String _lastHandledPayloadKey =
      'smart_outreach_last_handled_payload';
  static const String _lastHandledAtKey = 'smart_outreach_last_handled_at_ms';

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    _subscription = selectNotificationSubject.stream.listen((payload) {
      _handlePayload(payload);
    });
  }

  Future<void> _handlePayload(String payload) async {
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

    if (await _isDuplicateAcrossAppLaunches(payload)) {
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

    // clear last payload value to avoid re-processing stale behavior subject data
    selectNotificationSubject.add('');
  }

  Future<bool> _isDuplicateAcrossAppLaunches(String payload) async {
    final prefs = await SharedPreferences.getInstance();
    final lastPayload = prefs.getString(_lastHandledPayloadKey);
    final lastHandledAtMs = prefs.getInt(_lastHandledAtKey);
    final now = DateTime.now();
    final todayKey = _dayKey(now);

    if (lastPayload == payload && lastHandledAtMs != null) {
      final lastHandledAt =
          DateTime.fromMillisecondsSinceEpoch(lastHandledAtMs);
      if (_dayKey(lastHandledAt) == todayKey) {
        return true;
      }
    }

    await prefs.setString(_lastHandledPayloadKey, payload);
    await prefs.setInt(_lastHandledAtKey, now.millisecondsSinceEpoch);
    return false;
  }

  String _dayKey(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day';
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}
