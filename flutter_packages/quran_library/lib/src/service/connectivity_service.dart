import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

// enum لتسهيل التعامل مع حالات الاتصال
enum ConnectivityStatus {
  connected,
  phoneData,
  disconnected,
}

class InternetConnectionService {
  // StreamController لبث التغيرات في حالة الاتصال
  final StreamController<ConnectivityStatus> _connectionStatusController =
      StreamController<ConnectivityStatus>.broadcast();

  // Stream يمكن للـ Controllers الأخرى الاستماع إليه
  Stream<ConnectivityStatus> get connectionStream =>
      _connectionStatusController.stream;

  // متغير للاحتفاظ بآخر حالة اتصال معروفة
  ConnectivityStatus _currentStatus = ConnectivityStatus.disconnected;
  ConnectivityStatus get currentStatus => _currentStatus;

  // اشتراك لمراقبة التغيرات من مكتبة connectivity_plus
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  InternetConnectionService() {
    _initialize();
  }

  // دالة للتهيئة الأولية وبدء الاستماع
  Future<void> _initialize() async {
    // الاستماع للتغيرات في الاتصال
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);

    // التحقق من الحالة الحالية عند بدء التشغيل
    List<ConnectivityResult> initialResult =
        await Connectivity().checkConnectivity();
    _updateConnectionStatus(initialResult);
  }

  // دالة خاصة لتحديث الحالة وبثها عبر الـ Stream
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    ConnectivityStatus newStatus;
    // التحقق مما إذا كانت النتيجة تحتوي على 'none'
    if (result.contains(ConnectivityResult.none)) {
      newStatus = ConnectivityStatus.disconnected;
    } else if (result.contains(ConnectivityResult.mobile)) {
      newStatus = ConnectivityStatus.phoneData;
    } else {
      newStatus = ConnectivityStatus.connected;
    }

    // بث الحالة الجديدة فقط إذا تغيرت عن الحالة السابقة
    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _connectionStatusController.add(newStatus);
      debugPrint('Connectivity status updated: $newStatus');
    }
  }

  // دالة لإغلاق الـ StreamController والاشتراك عند عدم الحاجة للخدمة
  void dispose() {
    _connectivitySubscription.cancel();
    _connectionStatusController.close();
  }
}
