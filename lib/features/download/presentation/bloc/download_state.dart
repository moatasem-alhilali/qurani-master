// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'download_bloc.dart';

@immutable
class DownloadState {
  final RequestState loadState;
  final List<DownloadTaskModel> downloads;
  final String? errorMessage;
  final Map<String, int> downloadProgress;
  final String? currentDownloadId;

  const DownloadState({
    this.loadState = RequestState.initial,
    this.downloads = const [],
    this.errorMessage,
    this.downloadProgress = const {},
    this.currentDownloadId,
  });

  DownloadState copyWith({
    RequestState? loadState,
    List<DownloadTaskModel>? downloads,
    String? errorMessage,
    Map<String, int>? downloadProgress,
    String? currentDownloadId,
  }) {
    return DownloadState(
      loadState: loadState ?? this.loadState,
      downloads: downloads ?? this.downloads,
      errorMessage: errorMessage,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      currentDownloadId: currentDownloadId,
    );
  }

  // Helper getters
  List<DownloadTaskModel> get activeDownloads => downloads
      .where(
        (task) =>
            task.status == DownloadTaskStatus.running ||
            task.status == DownloadTaskStatus.enqueued,
      )
      .toList();

  List<DownloadTaskModel> get completedDownloads => downloads
      .where((task) => task.status == DownloadTaskStatus.complete)
      .toList();

  List<DownloadTaskModel> get pausedDownloads => downloads
      .where((task) => task.status == DownloadTaskStatus.paused)
      .toList();

  List<DownloadTaskModel> get failedDownloads => downloads
      .where((task) => task.status == DownloadTaskStatus.failed)
      .toList();

  int getProgressForTask(String taskId) => downloadProgress[taskId] ?? 0;

  DownloadTaskModel? getTaskById(String taskId) {
    try {
      return downloads.firstWhere((task) => task.taskId == taskId);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'DownloadState(loadState: $loadState, downloads: ${downloads.length}, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DownloadState &&
        other.loadState == loadState &&
        other.downloads == downloads &&
        other.errorMessage == errorMessage &&
        other.downloadProgress == downloadProgress &&
        other.currentDownloadId == currentDownloadId;
  }

  @override
  int get hashCode {
    return loadState.hashCode ^
        downloads.hashCode ^
        errorMessage.hashCode ^
        downloadProgress.hashCode ^
        currentDownloadId.hashCode;
  }
}
