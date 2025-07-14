part of 'version_bloc.dart';

@immutable
class VersionState {
  const VersionState({
    this.versionCheckState = RequestState.initial,
    this.currentVersion,
    this.latestVersionInfo,
    this.downloadFilePath,
    this.errorMessage,
    this.isConnected = true,
    this.isListening = false,
  });

  final RequestState versionCheckState;
  final String? currentVersion;
  final AppVersionModel? latestVersionInfo;
  final String? downloadFilePath;
  final String? errorMessage;
  final bool isConnected;
  final bool isListening;

  VersionState copyWith({
    RequestState? versionCheckState,
    String? currentVersion,
    AppVersionModel? latestVersionInfo,
    String? downloadFilePath,
    String? errorMessage,
    bool? isConnected,
    bool? isListening,
  }) {
    return VersionState(
      versionCheckState: versionCheckState ?? this.versionCheckState,
      currentVersion: currentVersion ?? this.currentVersion,
      latestVersionInfo: latestVersionInfo ?? this.latestVersionInfo,
      downloadFilePath: downloadFilePath ?? this.downloadFilePath,
      errorMessage: errorMessage,
      isConnected: isConnected ?? this.isConnected,
      isListening: isListening ?? this.isListening,
    );
  }

  /// Helper getters
  bool get hasUpdateAvailable => latestVersionInfo?.isUpdateAvailable ?? false;
  bool get isUpdateRequired => latestVersionInfo?.isUpdateRequired ?? false;
  bool get canDownload => latestVersionInfo?.downloadUrl.isNotEmpty ?? false;
  String get downloadSizeText => latestVersionInfo?.downloadSize ?? 'غير محدد';

  @override
  List<Object?> get props => [
        versionCheckState,
        currentVersion,
        latestVersionInfo,
        downloadFilePath,
        errorMessage,
        isConnected,
        isListening,
      ];
}
