import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/notification/notification_permissions_service.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/services/services_location.dart';

class LocationPermissionService {
  static Future<void> init() async {
    await _requestLocationGeolocator();
    await _requestLocation();
    serviceEnabled = await locationEnabled();

  
  }

  static Future<void> _requestLocation() async {
    final permission = await Permission.location.status;

    if (permission == PermissionStatus.denied) {
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
    return Geolocator.isLocationServiceEnabled();
  }
}
