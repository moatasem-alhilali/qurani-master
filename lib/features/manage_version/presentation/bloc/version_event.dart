part of 'version_bloc.dart';

@immutable
abstract class VersionEvent {}

/// Event to check for app updates
class CheckForUpdatesEvent extends VersionEvent {
  CheckForUpdatesEvent({
    this.forceRefresh = false,
    this.isManualCheck = false,
  });

  final bool forceRefresh;
  final bool isManualCheck;
}

/// Event to get cached version information
class GetCachedVersionEvent extends VersionEvent {}

/// Event to get current app version
class GetCurrentVersionEvent extends VersionEvent {}

/// Event to open download link in browser
class OpenDownloadLinkEvent extends VersionEvent {
  OpenDownloadLinkEvent({required this.downloadUrl});

  final String downloadUrl;
}

/// Event to mark a version as skipped by user
class SkipVersionEvent extends VersionEvent {
  SkipVersionEvent({required this.version});

  final String version;
}

/// Event to clear skipped version
class ClearSkippedVersionEvent extends VersionEvent {}

/// Event to clear version cache
class ClearVersionCacheEvent extends VersionEvent {}

/// Event to initialize version management
class InitializeVersionManagementEvent extends VersionEvent {}

/// Event to reset version state
class ResetVersionStateEvent extends VersionEvent {}

/// Event to handle connectivity changes
class ConnectivityChangedEvent extends VersionEvent {
  ConnectivityChangedEvent({required this.isConnected});

  final bool isConnected;
}

/// Event to handle remote config changes
class ConfigChangedEvent extends VersionEvent {
  ConfigChangedEvent({required this.versionModel});

  final AppVersionModel versionModel;
}
