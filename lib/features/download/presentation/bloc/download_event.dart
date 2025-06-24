part of 'download_bloc.dart';

@immutable
abstract class DownloadEvent {}

class LoadDownloadTasksEvent extends DownloadEvent {}

class StartDownloadEvent extends DownloadEvent {
  final String url;
  final String? fileName;
  final bool saveInPublicStorage;
  final bool allowCellular;
  final bool openFileFromNotification;

  StartDownloadEvent({
    required this.url,
    this.fileName,
    this.saveInPublicStorage = true,
    this.allowCellular = true,
    this.openFileFromNotification = false,
  });
}

class PauseDownloadEvent extends DownloadEvent {
  final String taskId;

  PauseDownloadEvent({required this.taskId});
}

class ResumeDownloadEvent extends DownloadEvent {
  final String taskId;

  ResumeDownloadEvent({required this.taskId});
}

class CancelDownloadEvent extends DownloadEvent {
  final String taskId;

  CancelDownloadEvent({required this.taskId});
}

class CancelAllDownloadsEvent extends DownloadEvent {}

class RetryDownloadEvent extends DownloadEvent {
  final String taskId;

  RetryDownloadEvent({required this.taskId});
}

class OpenDownloadedFileEvent extends DownloadEvent {
  final String taskId;

  OpenDownloadedFileEvent({required this.taskId});
}

class RemoveDownloadTaskEvent extends DownloadEvent {
  final String taskId;
  final bool deleteFile;

  RemoveDownloadTaskEvent({
    required this.taskId,
    this.deleteFile = false,
  });
}

class LoadTasksByStatusEvent extends DownloadEvent {
  final DownloadTaskStatus status;

  LoadTasksByStatusEvent({required this.status});
}

class DownloadProgressUpdateEvent extends DownloadEvent {
  final String taskId;
  final int progress;

  DownloadProgressUpdateEvent({
    required this.taskId,
    required this.progress,
  });
}

class DownloadStatusUpdateEvent extends DownloadEvent {
  final String taskId;
  final DownloadTaskStatus status;

  DownloadStatusUpdateEvent({
    required this.taskId,
    required this.status,
  });
}
