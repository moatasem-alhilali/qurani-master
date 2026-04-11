import 'dart:io';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SmartOutreachCommunicationService {
  static const MethodChannel _channel = MethodChannel(
    'com.tamaneena.tamaneena_app/smart_outreach',
  );

  Future<bool> launchCallDialer(String phone) async {
    final normalized = _normalizePhone(phone);
    if (normalized.isEmpty) {
      return false;
    }

    if (Platform.isAndroid) {
      final phonePermission = await Permission.phone.request();
      if (!phonePermission.isGranted) {
        return false;
      }

      final bool? result =
          await FlutterPhoneDirectCaller.callNumber(normalized);
      return result ?? false;
    }

    final uri = Uri(scheme: 'tel', path: normalized);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<bool> launchSmsComposer({
    required String phone,
    String? message,
  }) async {
    final normalized = _normalizePhone(phone);
    if (normalized.isEmpty) {
      return false;
    }

    final cleanMessage = (message ?? '').trim();

    if (Platform.isAndroid) {
      final smsPermission = await Permission.sms.request();
      if (!smsPermission.isGranted) {
        return false;
      }

      try {
        final sent = await _channel.invokeMethod<bool>(
          'sendSmsDirect',
          <String, dynamic>{
            'phone': normalized,
            'message': cleanMessage,
          },
        );
        return sent ?? false;
      } on PlatformException {
        return false;
      }
    }

    final uri = Uri(
      scheme: 'sms',
      path: normalized,
      queryParameters: {
        if (cleanMessage.isNotEmpty) 'body': cleanMessage,
      },
    );

    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _normalizePhone(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    var cleaned = trimmed.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleaned.startsWith('+')) {
      cleaned = '+${cleaned.substring(1).replaceAll('+', '')}';
    } else {
      cleaned = cleaned.replaceAll('+', '');
    }

    return cleaned;
  }
}
