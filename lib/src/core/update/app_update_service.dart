import 'package:in_app_update/in_app_update.dart';
import 'package:quran_app/src/core/update/ios_store_version_service.dart';

/// UI-facing state for the app update flow, shared by both platforms.
sealed class AppUpdateStatus {
  const AppUpdateStatus();
}

/// Nothing to show.
final class AppUpdateIdle extends AppUpdateStatus {
  const AppUpdateIdle();
}

/// Android: a flexible in-app update finished downloading and is ready to be
/// installed (the user is prompted to restart/install).
final class AppUpdateAndroidReady extends AppUpdateStatus {
  const AppUpdateAndroidReady();
}

/// iOS: a newer version is available on the App Store.
///
/// [shouldPrompt] is `false` when the user already chose "later" for this exact
/// [storeVersion] — the home-screen reminder tile still shows, but the launch
/// dialog is suppressed until a newer version ships.
final class AppUpdateIosAvailable extends AppUpdateStatus {
  const AppUpdateIosAvailable({
    required this.storeVersion,
    required this.storeUrl,
    this.releaseNotes,
    this.shouldPrompt = true,
  });

  final String storeVersion;
  final String? storeUrl;
  final String? releaseNotes;
  final bool shouldPrompt;
}

/// Outcome of a user-triggered ("check for updates") manual check.
enum ManualUpdateOutcome {
  /// iOS: a newer store version exists — caller should present the prompt.
  updateAvailableIos,

  /// Android: the native in-app update flow was started by the OS.
  updateStartedAndroid,

  /// Already on the latest version.
  upToDate,

  /// The check itself failed (offline, store lookup error, …).
  error,
}

/// Result of a manual "check for updates" action.
class ManualUpdateResult {
  const ManualUpdateResult(
    this.outcome, {
    this.storeVersion,
    this.storeUrl,
    this.releaseNotes,
  });

  final ManualUpdateOutcome outcome;
  final String? storeVersion;
  final String? storeUrl;
  final String? releaseNotes;
}

/// Thin wrapper around the platform update mechanisms:
///  - Android → Google Play In-App Updates (`in_app_update`).
///  - iOS → App Store version lookup ([IosStoreVersionService]).
class AppUpdateService {
  AppUpdateService({IosStoreVersionService? iosStoreVersionService})
      : _iosStoreVersionService =
            iosStoreVersionService ?? IosStoreVersionService();

  final IosStoreVersionService _iosStoreVersionService;

  // ─────────────────────────── Android (in_app_update) ───────────────────────
  Future<AppUpdateInfo> checkAndroid() => InAppUpdate.checkForUpdate();

  Future<AppUpdateResult> performImmediateUpdate() =>
      InAppUpdate.performImmediateUpdate();

  Future<AppUpdateResult> startFlexibleUpdate() =>
      InAppUpdate.startFlexibleUpdate();

  Future<void> completeFlexibleUpdate() => InAppUpdate.completeFlexibleUpdate();

  Stream<InstallStatus> get installUpdateListener =>
      InAppUpdate.installUpdateListener;

  // ─────────────────────────────── iOS (App Store) ───────────────────────────
  Future<IosStoreVersionResult?> checkIosStore() =>
      _iosStoreVersionService.check();
}
