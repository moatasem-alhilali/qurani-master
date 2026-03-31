import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';

import 'connectivity_service.dart';

class InternetConnectionController extends GetxController {
  static InternetConnectionController get instance =>
      Get.isRegistered<InternetConnectionController>()
          ? Get.find<InternetConnectionController>()
          : Get.put<InternetConnectionController>(
              InternetConnectionController(),
              permanent: true);

  final InternetConnectionService _connectivityService = Get.find();
  late StreamSubscription<ConnectivityStatus> _subscription;

  // .obs للمراقبة في الواجهة
  final Rx<ConnectivityStatus> connectionStatus =
      ConnectivityStatus.disconnected.obs;

  bool get isConnected =>
      connectionStatus.value == ConnectivityStatus.connected ||
      connectionStatus.value == ConnectivityStatus.phoneData;

  bool get isPhoneData =>
      connectionStatus.value == ConnectivityStatus.phoneData;

  @override
  void onInit() {
    super.onInit();
    // الحصول على الحالة الأولية
    connectionStatus.value = _connectivityService.currentStatus;

    // بدء الاستماع للتغيرات
    _subscription = _connectivityService.connectionStream.listen((status) {
      log("Status changed in Controller: $status"); // للتأكد من وصول الحدث
      connectionStatus.value = status;

      // if (status == ConnectivityStatus.connected) {
      //   ToastUtils().showToast(context, "تم استعادة الاتصال بالإنترنت بنجاح.");
      // } else {
      //   Get.snackbar("انقطاع الاتصال", "لقد فقدت الاتصال بالإنترنت.");
      // }
    });
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
