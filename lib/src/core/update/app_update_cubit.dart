import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/main.dart';
import 'package:quran_app/src/core/update/app_update_service.dart';

/// Single source of truth for app updates on both platforms:
///  - Android: Google Play In-App Updates (immediate or flexible).
///  - iOS: App Store version lookup + an in-app prompt that opens the store.
///
/// This intentionally replaces the old Remote Config based version management.
class AppUpdateCubit extends Cubit<AppUpdateStatus> {
  AppUpdateCubit({
    AppUpdateService? service,
    CacheService? cacheService,
  })  : _service = service ?? AppUpdateService(),
        _cacheService = cacheService ?? CacheService(),
        super(const AppUpdateIdle());

  final AppUpdateService _service;
  final CacheService _cacheService;
  StreamSubscription<InstallStatus>? _installSubscription;

  /// SharedPreferences key remembering the iOS store version the user dismissed
  /// with "later", so we don't nag on every launch (until a newer one ships).
  static const String _iosSkippedVersionKey = 'ios_skipped_store_version';

  // ───────────────────────────── Automatic (launch) ──────────────────────────

  /// Runs the passive, launch-time update check. Android surfaces Google's own
  /// UI; iOS emits [AppUpdateIosAvailable] which the UI turns into a prompt.
  Future<void> checkForUpdate() async {
    if (Platform.isAndroid) {
      await _checkAndroid();
    } else if (Platform.isIOS) {
      await _checkIosForLaunch();
    }
  }

  Future<void> _checkAndroid() async {
    try {
      final info = await _service.checkAndroid();
      if (!_androidHasUpdate(info)) return;

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

  Future<void> _checkIosForLaunch() async {
    try {
      final result = await _service.checkIosStore();
      if (result == null || !result.isUpdateAvailable) return;

      final skipped = _cacheService.getString(_iosSkippedVersionKey);
      emit(
        AppUpdateIosAvailable(
          storeVersion: result.storeVersion,
          storeUrl: result.storeUrl,
          releaseNotes: result.releaseNotes,
          // Suppress the dialog (but keep the home tile) if the user already
          // said "later" for exactly this version.
          shouldPrompt: skipped != result.storeVersion,
        ),
      );
    } catch (e) {
      logger.w('iOS store version check failed silently: $e');
    }
  }

  // ─────────────────────────────── Manual (settings) ─────────────────────────

  /// Runs a user-triggered check and returns a result the caller renders itself
  /// (a dialog on iOS, a snackbar for "up to date"/errors). Ignores the skipped
  /// version because the user explicitly asked.
  Future<ManualUpdateResult> checkNow() async {
    try {
      if (Platform.isAndroid) {
        final info = await _service.checkAndroid();
        if (!_androidHasUpdate(info)) {
          return const ManualUpdateResult(ManualUpdateOutcome.upToDate);
        }
        if (info.immediateUpdateAllowed) {
          await _service.performImmediateUpdate();
        } else if (info.flexibleUpdateAllowed) {
          await _listenForFlexibleUpdate();
          await _service.startFlexibleUpdate();
        }
        return const ManualUpdateResult(
          ManualUpdateOutcome.updateStartedAndroid,
        );
      }

      if (Platform.isIOS) {
        final result = await _service.checkIosStore();
        if (result == null || !result.isUpdateAvailable) {
          return const ManualUpdateResult(ManualUpdateOutcome.upToDate);
        }
        // Reflect availability in state too so the home reminder tile appears.
        emit(
          AppUpdateIosAvailable(
            storeVersion: result.storeVersion,
            storeUrl: result.storeUrl,
            releaseNotes: result.releaseNotes,
            shouldPrompt: false,
          ),
        );
        return ManualUpdateResult(
          ManualUpdateOutcome.updateAvailableIos,
          storeVersion: result.storeVersion,
          storeUrl: result.storeUrl,
          releaseNotes: result.releaseNotes,
        );
      }

      return const ManualUpdateResult(ManualUpdateOutcome.upToDate);
    } catch (e) {
      logger.w('Manual update check failed: $e');
      return const ManualUpdateResult(ManualUpdateOutcome.error);
    }
  }

  // ───────────────────────────────── Actions ─────────────────────────────────

  /// Android: install the flexible update that finished downloading.
  Future<void> installAndroidUpdate() async {
    if (!Platform.isAndroid) return;
    try {
      await _service.completeFlexibleUpdate();
    } catch (e) {
      logger.w('Completing flexible update failed silently: $e');
    }
  }

  /// iOS: remember that the user dismissed this store version with "later".
  Future<void> skipIosVersion(String storeVersion) async {
    try {
      await _cacheService.setString(_iosSkippedVersionKey, storeVersion);
    } catch (e) {
      logger.w('Persisting skipped iOS version failed silently: $e');
    }
  }

  // ───────────────────────────────── Internals ───────────────────────────────

  bool _androidHasUpdate(AppUpdateInfo info) =>
      info.updateAvailability == UpdateAvailability.updateAvailable ||
      info.updateAvailability ==
          UpdateAvailability.developerTriggeredUpdateInProgress;

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
