import 'package:flutter/services.dart';

class PlatformDeviceIdService {
  factory PlatformDeviceIdService() => _instance;
  PlatformDeviceIdService._internal();

  static final PlatformDeviceIdService _instance =
      PlatformDeviceIdService._internal();

  static const MethodChannel _channel = MethodChannel(
    'com.tamaneena.tamaneena_app/device_identity',
  );

  Future<String?> getPlatformDeviceId() async {
    try {
      final id = await _channel.invokeMethod<String>('getDeviceId');
      final sanitized = id?.trim();
      if (sanitized == null ||
          sanitized.isEmpty ||
          sanitized.toLowerCase() == 'unknown') {
        return null;
      }
      return sanitized;
    } on PlatformException {
      return null;
    }
  }
}
