import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/util/toast_manager.dart';

class ServicesLocation {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ToastServes.showToast(
          message:
              "Location permissions are permanently denied, we cannot request permissions");

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ToastServes.showToast(
            message:
                "Location permissions are permanently denied, we cannot request permissions");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ToastServes.showToast(
          message:
              "Location permissions are permanently denied, we cannot request permissions");

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
