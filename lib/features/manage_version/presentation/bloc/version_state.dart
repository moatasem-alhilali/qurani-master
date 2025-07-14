part of 'version_bloc.dart';

@immutable
class VersionState {
  const VersionState({
    this.versionCheckState = RequestState.initial,
    this.downloadState = RequestState.initial,
    this.currentVersion,
    this.latestVersionInfo,
    this.downloadLink,
    this.downloadProgress = 0,
    this.downloadStatus = DownloadStatus.none,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.downloadFilePath,
    this.errorMessage,
    this.isUpdateDialogVisible = false,
    this.isConnected = true,
    this.isListening = false,
  });

  final RequestState versionCheckState;
  final RequestState downloadState;
  final String? currentVersion;
  final AppVersionModel? latestVersionInfo;
  final DownloadLinkModel? downloadLink;
  final int downloadProgress;
  final DownloadStatus downloadStatus;
  final int downloadedBytes;
  final int totalBytes;
  final String? downloadFilePath;
  final String? errorMessage;
  final bool isUpdateDialogVisible;
  final bool isConnected;
  final bool isListening;

  VersionState copyWith({
    RequestState? versionCheckState,
    RequestState? downloadState,
    String? currentVersion,
    AppVersionModel? latestVersionInfo,
    DownloadLinkModel? downloadLink,
    int? downloadProgress,
    DownloadStatus? downloadStatus,
    int? downloadedBytes,
    int? totalBytes,
    String? downloadFilePath,
    String? errorMessage,
    bool? isUpdateDialogVisible,
    bool? isConnected,
    bool? isListening,
  }) {
    return VersionState(
      versionCheckState: versionCheckState ?? this.versionCheckState,
      downloadState: downloadState ?? this.downloadState,
      currentVersion: currentVersion ?? this.currentVersion,
      latestVersionInfo: latestVersionInfo ?? this.latestVersionInfo,
      downloadLink: downloadLink ?? this.downloadLink,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      downloadFilePath: downloadFilePath ?? this.downloadFilePath,
      errorMessage: errorMessage,
      isUpdateDialogVisible:
          isUpdateDialogVisible ?? this.isUpdateDialogVisible,
      isConnected: isConnected ?? this.isConnected,
      isListening: isListening ?? this.isListening,
    );
  }

  /// Helper getters
  bool get hasUpdateAvailable => latestVersionInfo?.isUpdateAvailable ?? false;
  bool get isUpdateRequired => latestVersionInfo?.isUpdateRequired ?? false;
  bool get isDownloading => downloadStatus == DownloadStatus.downloading;
  bool get isDownloadComplete => downloadStatus == DownloadStatus.completed;
  bool get canDownload => latestVersionInfo?.downloadUrl.isNotEmpty ?? false;
  String get downloadSizeText => latestVersionInfo?.downloadSize ?? 'غير محدد';

  String get downloadProgressText {
    if (totalBytes > 0) {
      final downloadedMB = (downloadedBytes / (1024 * 1024)).toStringAsFixed(1);
      final totalMB = (totalBytes / (1024 * 1024)).toStringAsFixed(1);
      return '$downloadedMB MB / $totalMB MB';
    }
    return '$downloadProgress%';
  }

  @override
  List<Object?> get props => [
        versionCheckState,
        downloadState,
        currentVersion,
        latestVersionInfo,
        downloadLink,
        downloadProgress,
        downloadStatus,
        downloadedBytes,
        totalBytes,
        downloadFilePath,
        errorMessage,
        isUpdateDialogVisible,
        isConnected,
        isListening,
      ];
}

/// Download status enum
enum DownloadStatus {
  none,
  initializing,
  downloading,
  paused,
  completed,
  failed,
  cancelled;

  /// Get display text for the status
  String get displayText {
    switch (this) {
      case DownloadStatus.none:
        return 'غير محدد';
      case DownloadStatus.initializing:
        return 'جاري التحضير';
      case DownloadStatus.downloading:
        return 'جاري التحميل';
      case DownloadStatus.paused:
        return 'متوقف مؤقتاً';
      case DownloadStatus.completed:
        return 'مكتمل';
      case DownloadStatus.failed:
        return 'فشل';
      case DownloadStatus.cancelled:
        return 'ملغي';
    }
  }

  /// Check if download can be resumed
  bool get canResume =>
      this == DownloadStatus.paused || this == DownloadStatus.failed;

  /// Check if download can be paused
  bool get canPause => this == DownloadStatus.downloading;

  /// Check if download can be cancelled
  bool get canCancel =>
      this == DownloadStatus.downloading ||
      this == DownloadStatus.paused ||
      this == DownloadStatus.initializing;
}
