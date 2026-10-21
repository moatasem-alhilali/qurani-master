import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/router/app_router.gr.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_payload_service.dart';

/// يفتح المصحف على الآية التي وصل بها الإشعار.
///
/// يتبع نمط `AthanAlarmNotificationRouterService`: يستمع إلى
/// [selectNotificationSubject]، ويتجاهل أي حمولة ليست حمولته.
class AyahReminderRouterService {
  AyahReminderRouterService({
    required NotificationService notificationService,
    required AyahReminderPayloadService payloadService,
  })  : _notificationService = notificationService,
        _payloadService = payloadService;

  final NotificationService _notificationService;
  final AyahReminderPayloadService _payloadService;

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

    // الحمولة نفسها تصل مرّتين حين يُقلَع التطبيق باللمس: من تفاصيل الإقلاع
    // ومن المجرى. فتُفتح الآية مرّة واحدة.
    final now = DateTime.now();
    if (_lastPayload == payload &&
        _lastHandledAt != null &&
        now.difference(_lastHandledAt!) < const Duration(seconds: 1)) {
      return;
    }

    _lastPayload = payload;
    _lastHandledAt = now;

    final page = data.page;
    if (page == null || page < 1) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = NavigationService.navigatorKey.currentContext;
      if (context == null) {
        return;
      }

      // المصحف يأخذ فهرس الصفحة لا رقمها.
      unawaited(context.router.push(ReadQuranRoute(page: page - 1)));
    });

    selectNotificationSubject.add('');
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}
