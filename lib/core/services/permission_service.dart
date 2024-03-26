import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static void init() async {
    handelNotification();
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

  static void _requestLocation() async {
    final permission = await Permission.location.status;

    if (permission == LocationPermission.denied) {
      await Permission.location.request();
    }
  }

  static void _requestLocationGeolocator() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  static Future<bool> locationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
