import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/services/services_location.dart';

class PermissionService {
  static Future<void> init() async {
    await _requestLocationGeolocator();
    await _requestLocation();
    await handelNotification();
    serviceEnabled = await locationEnabled();
  }

  static Future<void> handelNotification() async {
    final permissionStatus = await Permission.notification.status;
    if (permissionStatus.isDenied) {
      await Permission.notification.request();
    }
  }

  static Future<void> _handleStorage() async {
    final permissionStatus = await Permission.storage.status;
    if (permissionStatus.isDenied) {
      await Permission.storage.request();
      if (permissionStatus.isDenied) {
        // await openAppSettings();
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    } else {}
  }

  static Future<void> _requestLocation() async {
    final permission = await Permission.location.status;

    if (permission == LocationPermission.denied) {
      await Permission.location.request();
    }
  }

  static Future<void> _requestLocationGeolocator() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  static Future<bool> locationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
