import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:quran_app/main.dart';
import 'package:quran_app/src/core/update/app_update_service.dart';

class AppUpdateCubit extends Cubit<AppUpdateStatus> {
  AppUpdateCubit({
    AppUpdateService? service,
  })  : _service = service ?? AppUpdateService(),
        super(const AppUpdateIdle());

  final AppUpdateService _service;
  StreamSubscription<InstallStatus>? _installSubscription;

  Future<void> checkForUpdate() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      final info = await _service.checkAndroid();
      final hasUpdate =
          info.updateAvailability == UpdateAvailability.updateAvailable ||
              info.updateAvailability ==
                  UpdateAvailability.developerTriggeredUpdateInProgress;

      if (!hasUpdate) {
        return;
      }

      if (info.immediateUpdateAllowed) {
        await _service.performImmediateUpdate();
        return;
      }

      if (info.flexibleUpdateAllowed) {
        await _listenForFlexibleUpdate();
        await _service.startFlexibleUpdate();
      }
    } catch (e) {
      logger.w('In-app update check failed silently: $e');
    }
  }

  Future<void> installAndroidUpdate() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      await _service.completeFlexibleUpdate();
    } catch (e) {
      logger.w('Completing flexible update failed silently: $e');
    }
  }

  Future<void> _listenForFlexibleUpdate() async {
    await _installSubscription?.cancel();
    _installSubscription = _service.installUpdateListener.listen(
      (status) {
        if (status == InstallStatus.downloaded) {
          emit(const AppUpdateAndroidReady());
        }
      },
      onError: (Object error) {
        logger.w('In-app update listener failed silently: $error');
      },
    );
  }

  @override
  Future<void> close() async {
    await _installSubscription?.cancel();
    return super.close();
  }
}
