import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:quran_app/l10n/l10n.dart';

class DownloadTaskModel {
  const DownloadTaskModel({
    required this.taskId,
    required this.url,
    required this.fileName,
    required this.savedDir,
    required this.status,
    required this.progress,
    required this.timeCreated,
    this.allowCellular = true,
  });

  factory DownloadTaskModel.fromDownloadTask(DownloadTask task) {
    return DownloadTaskModel(
      taskId: task.taskId,
      url: task.url,
      fileName: task.filename ?? '',
      savedDir: task.savedDir,
      status: task.status,
      progress: task.progress,
      timeCreated: task.timeCreated,
      allowCellular: task.allowCellular,
    );
  }
  final String taskId;
  final String url;
  final String fileName;
  final String savedDir;
  final DownloadTaskStatus status;
  final int progress;
  final int timeCreated;
  final bool allowCellular;

  DownloadTaskModel copyWith({
    String? taskId,
    String? url,
    String? fileName,
    String? savedDir,
    DownloadTaskStatus? status,
    int? progress,
    int? timeCreated,
    bool? allowCellular,
  }) {
    return DownloadTaskModel(
      taskId: taskId ?? this.taskId,
      url: url ?? this.url,
      fileName: fileName ?? this.fileName,
      savedDir: savedDir ?? this.savedDir,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      timeCreated: timeCreated ?? this.timeCreated,
      allowCellular: allowCellular ?? this.allowCellular,
    );
  }

  String get statusText {
    switch (status) {
      case DownloadTaskStatus.undefined:
        return 'Undefined';
      case DownloadTaskStatus.enqueued:
        return 'Enqueued';
      case DownloadTaskStatus.running:
        return 'Running';
      case DownloadTaskStatus.complete:
        return 'Complete';
      case DownloadTaskStatus.failed:
        return 'Failed';
      case DownloadTaskStatus.canceled:
        return 'Canceled';
      case DownloadTaskStatus.paused:
        return 'Paused';
    }
  }

  /// حالة التنزيل بلغة الواجهة (يبقى [statusText] للسجلات).
  String statusLabel(L10n l10n) {
    switch (status) {
      case DownloadTaskStatus.undefined:
        return l10n.cleanupDownloadStatusUnknown;
      case DownloadTaskStatus.enqueued:
        return l10n.cleanupDownloadStatusQueued;
      case DownloadTaskStatus.running:
        return l10n.downloadStatusActive;
      case DownloadTaskStatus.complete:
        return l10n.downloadStatusCompleted;
      case DownloadTaskStatus.failed:
        return l10n.downloadStatusFailed;
      case DownloadTaskStatus.canceled:
        return l10n.cleanupDownloadStatusCanceled;
      case DownloadTaskStatus.paused:
        return l10n.downloadStatusPaused;
    }
  }

  @override
  String toString() {
    return 'DownloadTaskModel(taskId: $taskId, url: $url, fileName: $fileName, status: $status, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DownloadTaskModel && other.taskId == taskId;
  }

  @override
  int get hashCode => taskId.hashCode;
}
