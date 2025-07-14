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

/// Event to process download link
class ProcessDownloadLinkEvent extends VersionEvent {
  ProcessDownloadLinkEvent({required this.downloadUrl});

  final String downloadUrl;
}

/// Event to start downloading the new version
class StartDownloadEvent extends VersionEvent {
  StartDownloadEvent({
    required this.downloadLink,
    this.fileName,
  });

  final DownloadLinkModel downloadLink;
  final String? fileName;
}

/// Event to pause download
class PauseDownloadEvent extends VersionEvent {}

/// Event to resume download
class ResumeDownloadEvent extends VersionEvent {}

/// Event to cancel download
class CancelDownloadEvent extends VersionEvent {}

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

/// Event to handle download progress updates
class DownloadProgressUpdateEvent extends VersionEvent {
  DownloadProgressUpdateEvent({
    required this.progress,
    this.downloadedBytes,
    this.totalBytes,
  });

  final int progress;
  final int? downloadedBytes;
  final int? totalBytes;
}

/// Event to handle download status updates
class DownloadStatusUpdateEvent extends VersionEvent {
  DownloadStatusUpdateEvent({required this.status});

  final DownloadStatus status;
}

/// Event to open downloaded file
class OpenDownloadedFileEvent extends VersionEvent {
  OpenDownloadedFileEvent({required this.filePath});

  final String filePath;
}

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
