import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_overlay_command.dart';

class FloatingAdhkarOverlayController {
  static const int overlayWidth = 250;
  static const int overlayWindowWidth = overlayWidth + 22;
  static const Duration _serviceActivationPollDelay = Duration(
    milliseconds: 150,
  );
  static const int _serviceActivationPollAttempts = 20;

  bool get isSupportedPlatform =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<bool> hasPermission() async {
    if (!isSupportedPlatform) {
      return false;
    }

    try {
      return await FlutterOverlayWindow.isPermissionGranted();
    } on MissingPluginException {
      _debugLog('صلاحية النافذة العائمة غير متاحة بعد لأن الـ plugin لم يجهز.');
      return false;
    } on PlatformException catch (error) {
      _debugLog('تعذر قراءة صلاحية النافذة العائمة: $error');
      return false;
    }
  }

  Future<bool> requestPermission() async {
    if (!isSupportedPlatform) {
      return false;
    }

    try {
      return await FlutterOverlayWindow.requestPermission() ?? false;
    } on MissingPluginException {
      _debugLog('طلب الصلاحية فشل لأن plugin النافذة العائمة لم يجهز بعد.');
      return false;
    } on PlatformException catch (error) {
      _debugLog('طلب صلاحية النافذة العائمة فشل: $error');
      return false;
    }
  }

  Future<bool> isServiceActive() async {
    if (!isSupportedPlatform) {
      return false;
    }

    try {
      return await FlutterOverlayWindow.isActive();
    } on MissingPluginException {
      _debugLog('حالة خدمة الأذكار العائمة غير متاحة بعد.');
      return false;
    } on PlatformException catch (error) {
      _debugLog('تعذر معرفة حالة خدمة الأذكار العائمة: $error');
      return false;
    }
  }

  Future<void> startService() async {
    if (!isSupportedPlatform) {
      return;
    }

    if (await isServiceActive()) {
      return;
    }

    if (!await hasPermission()) {
      _debugLog('لن يتم تشغيل خدمة الأذكار العائمة لأن الصلاحية غير مفعلة.');
      return;
    }

    try {
      await FlutterOverlayWindow.showOverlay(
        overlayTitle: 'الأذكار العشوائية العائمة',
        overlayContent: 'خدمة الأذكار العائمة تعمل في الخلفية',
        width: overlayWindowWidth,
        height: 1,
        alignment: OverlayAlignment.centerRight,
        flag: OverlayFlag.clickThrough,
        visibility: NotificationVisibility.visibilityPublic,
      );
    } on MissingPluginException {
      _debugLog('تعذر تشغيل خدمة الأذكار العائمة لأن plugin لم يجهز بعد.');
      return;
    } on PlatformException catch (error) {
      _debugLog('فشل تشغيل خدمة الأذكار العائمة: $error');
      return;
    }

    await _waitUntilServiceActive();
  }

  Future<void> stopService() async {
    if (!isSupportedPlatform) {
      return;
    }

    if (!await isServiceActive()) {
      return;
    }

    try {
      await FlutterOverlayWindow.closeOverlay();
    } on MissingPluginException {
      _debugLog('تعذر إيقاف خدمة الأذكار العائمة لأن plugin غير متاح.');
    } on PlatformException catch (error) {
      _debugLog('فشل إيقاف خدمة الأذكار العائمة: $error');
    }
  }

  Future<void> sendCommand(FloatingAdhkarOverlayCommand command) async {
    if (!isSupportedPlatform) {
      return;
    }

    if (!await isServiceActive()) {
      final becameActive = await _waitUntilServiceActive();
      if (!becameActive) {
        _debugLog(
          'تم تجاهل أمر ${command.type.name} لأن خدمة الأذكار العائمة '
          'لم تجهز بعد.',
        );
        return;
      }
    }

    try {
      await FlutterOverlayWindow.shareData(command.encode());
    } on MissingPluginException {
      _debugLog(
        'تعذر إرسال الأمر ${command.type.name} لأن plugin غير متاح.',
      );
    } on PlatformException catch (error) {
      _debugLog('فشل إرسال الأمر ${command.type.name}: $error');
    }
  }

  Future<bool> _waitUntilServiceActive() async {
    for (var attempt = 0; attempt < _serviceActivationPollAttempts; attempt++) {
      if (await isServiceActive()) {
        return true;
      }

      await Future<void>.delayed(_serviceActivationPollDelay);
    }

    _debugLog('خدمة الأذكار العائمة لم تصبح جاهزة في الوقت المتوقع.');
    return false;
  }

  void _debugLog(String message) {
    debugPrint('FloatingAdhkarOverlayController: $message');
  }
}
