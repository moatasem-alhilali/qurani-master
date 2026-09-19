import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/l10n/l10n.dart';

class ServicesLocation {
  /// [requestPermission]: `false` في مسارات الخلفية والإقلاع — لا نافذة إذن
  /// لم يطلبها المستخدم.
  static Future<Position> determinePosition({
    bool requestPermission = true,
  }) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ToastServes.showToast(
          message: L10nService.current.coreLocationServiceDisabled);

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && requestPermission) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ToastServes.showToast(
            message: L10nService.current.coreLocationPermissionDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ToastServes.showToast(
          message: L10nService.current.coreLocationPermissionDeniedForever);

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }

  static Future<bool> isLocationEnabled() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    return serviceEnabled;
  }
}

bool serviceEnabled = false;
