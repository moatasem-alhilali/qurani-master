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

  // Timer لتأخير بث حالة الانقطاع (debounce) لتجنب الأحداث المؤقتة الكاذبة
  static const _disconnectDebounce = Duration(seconds: 3);
  Timer? _disconnectTimer;

  // دالة التهيئة الأولية — يجب استدعاؤها مع await قبل استخدام الخدمة
  Future<void> init() async {
    // الاستماع للتغيرات في الاتصال
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);

    // التحقق من الحالة الحالية عند بدء التشغيل
    final initialResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(initialResult);
  }

  // دالة خاصة لتحديث الحالة وبثها عبر الـ Stream
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final newStatus = _resolveStatus(result);

    if (newStatus != ConnectivityStatus.disconnected) {
      // اتصال فعلي: ألغِ أي timer انقطاع معلّق وحدّث فوراً
      _disconnectTimer?.cancel();
      _disconnectTimer = null;
      _applyStatus(newStatus);
    } else {
      // انقطاع محتمل: انتظر قبل البث لتجنّب الأحداث المؤقتة
      if (_disconnectTimer?.isActive ?? false) return; // timer قيد الانتظار
      _disconnectTimer = Timer(_disconnectDebounce, () {
        _applyStatus(ConnectivityStatus.disconnected);
        _disconnectTimer = null;
      });
    }
  }

  // تحليل قائمة ConnectivityResult إلى حالة واحدة
  // الأولوية: فحص وجود اتصال فعلي أولاً، ثم الانقطاع
  ConnectivityStatus _resolveStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn)) {
      return ConnectivityStatus.connected;
    } else if (result.contains(ConnectivityResult.mobile)) {
      return ConnectivityStatus.phoneData;
    }
    return ConnectivityStatus.disconnected;
  }

  // بث الحالة الجديدة فقط إذا تغيرت عن الحالة السابقة
  void _applyStatus(ConnectivityStatus newStatus) {
    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _connectionStatusController.add(newStatus);
      debugPrint('Connectivity status updated: $newStatus');
    }
  }

  // دالة لإغلاق الـ StreamController والاشتراك عند عدم الحاجة للخدمة
  void dispose() {
    _disconnectTimer?.cancel();
    _connectivitySubscription.cancel();
    _connectionStatusController.close();
  }
}
