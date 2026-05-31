import 'package:in_app_update/in_app_update.dart';

sealed class AppUpdateStatus {
  const AppUpdateStatus();
}

final class AppUpdateIdle extends AppUpdateStatus {
  const AppUpdateIdle();
}

final class AppUpdateAndroidReady extends AppUpdateStatus {
  const AppUpdateAndroidReady();
}

class AppUpdateService {
  Future<AppUpdateInfo> checkAndroid() {
    return InAppUpdate.checkForUpdate();
  }

  Future<AppUpdateResult> performImmediateUpdate() {
    return InAppUpdate.performImmediateUpdate();
  }

  Future<AppUpdateResult> startFlexibleUpdate() {
    return InAppUpdate.startFlexibleUpdate();
  }

  Future<void> completeFlexibleUpdate() {
    return InAppUpdate.completeFlexibleUpdate();
  }

  Stream<InstallStatus> get installUpdateListener {
    return InAppUpdate.installUpdateListener;
  }
}
