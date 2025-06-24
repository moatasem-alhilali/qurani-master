import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/download/data/models/download_task_model.dart';
import 'package:quran_app/features/download/data/repo/download_repo.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc() : super(const DownloadState()) {
    on<LoadDownloadTasksEvent>(_onLoadDownloadTasks);
    on<StartDownloadEvent>(_onStartDownload);
    on<PauseDownloadEvent>(_onPauseDownload);
    on<ResumeDownloadEvent>(_onResumeDownload);
    on<CancelDownloadEvent>(_onCancelDownload);
    on<CancelAllDownloadsEvent>(_onCancelAllDownloads);
    on<RetryDownloadEvent>(_onRetryDownload);
    on<OpenDownloadedFileEvent>(_onOpenDownloadedFile);
    on<RemoveDownloadTaskEvent>(_onRemoveDownloadTask);
    on<LoadTasksByStatusEvent>(_onLoadTasksByStatus);
    on<DownloadProgressUpdateEvent>(_onDownloadProgressUpdate);
    on<DownloadStatusUpdateEvent>(_onDownloadStatusUpdate);

    _initializeDownloadService();
  }
  final DownloadRepo _downloadRepo = DownloadRepo();

  void _initializeDownloadService() {
    _downloadRepo.init();

    // Set up callbacks for real-time updates
    _downloadRepo.onProgress = (taskId, progress) {
      add(DownloadProgressUpdateEvent(taskId: taskId, progress: progress));
    };

    _downloadRepo.onStatusChanged = (taskId, status) {
      add(DownloadStatusUpdateEvent(taskId: taskId, status: status));
    };
  }

  Future<void> _onLoadDownloadTasks(
    LoadDownloadTasksEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      emit(state.copyWith(loadState: RequestState.loading));

      final tasks = await _downloadRepo.loadTasks();

      emit(
        state.copyWith(
          loadState: RequestState.success,
          downloads: tasks,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'Failed to load downloads: $e',
        ),
      );
    }
  }

  Future<void> _onStartDownload(
    StartDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      emit(state.copyWith(loadState: RequestState.loading));

      final taskId = await _downloadRepo.download(
        url: event.url,
        fileName: event.fileName,
        saveInPublicStorage: event.saveInPublicStorage,
        allowCellular: event.allowCellular,
        openFileFromNotification: event.openFileFromNotification,
      );

      if (taskId != null) {
        emit(
          state.copyWith(
            loadState: RequestState.success,
            currentDownloadId: taskId,
          ),
        );

        // Reload tasks to include the new download
        add(LoadDownloadTasksEvent());
      } else {
        emit(
          state.copyWith(
            loadState: RequestState.error,
            errorMessage: 'Failed to start download',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'Failed to start download: $e',
        ),
      );
    }
  }

  Future<void> _onPauseDownload(
    PauseDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      await _downloadRepo.pause(taskId: event.taskId);

      // Update the task status in state
      final updatedTasks = state.downloads.map((task) {
        if (task.taskId == event.taskId) {
          return task.copyWith(status: DownloadTaskStatus.paused);
        }
        return task;
      }).toList();

      emit(state.copyWith(downloads: updatedTasks));
    } catch (e) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'Failed to pause download: $e',
        ),
      );
    }
  }

  Future<void> _onResumeDownload(
    ResumeDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      final newTaskId = await _downloadRepo.resume(taskId: event.taskId);

      if (newTaskId != null) {
        // Reload tasks to get updated information
        add(LoadDownloadTasksEvent());
      }
    } catch (e) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'Failed to resume download: $e',
        ),
      );
    }
  }

  Future<void> _onCancelDownload(
    CancelDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      await _downloadRepo.cancel(taskId: event.taskId);

      // Update the task status in state
      final updatedTasks = state.downloads.map((task) {
        if (task.taskId == event.taskId) {
          return task.copyWith(status: DownloadTaskStatus.canceled);
        }
        return task;
      }).toList();

      emit(state.copyWith(downloads: updatedTasks));
    } catch (e) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'Failed to cancel download: $e',
        ),
      );
    }
  }

  Future<void> _onCancelAllDownloads(
    CancelAllDownloadsEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      await _downloadRepo.cancelAll();

      // Reload tasks to get updated information
      add(LoadDownloadTasksEvent());
    } catch (e) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'Failed to cancel all downloads: $e',
        ),
      );
    }
  }

  Future<void> _onRetryDownload(
    RetryDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      final newTaskId = await _downloadRepo.retry(taskId: event.taskId);

      if (newTaskId != null) {
        // Reload tasks to get updated information
        add(LoadDownloadTasksEvent());
      }
    } catch (e) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'Failed to retry download: $e',
        ),
      );
    }
  }

  Future<void> _onOpenDownloadedFile(
    OpenDownloadedFileEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      final success = await _downloadRepo.open(taskId: event.taskId);

      if (!success) {
        emit(
          state.copyWith(
            loadState: RequestState.error,
            errorMessage: 'Failed to open downloaded file',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'Failed to open file: $e',
        ),
      );
    }
  }

  Future<void> _onRemoveDownloadTask(
    RemoveDownloadTaskEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      if (event.deleteFile) {
        await _downloadRepo.removeTaskWithFile(taskId: event.taskId);
      } else {
        await _downloadRepo.removeTask(taskId: event.taskId);
      }

      // Remove the task from state
      final updatedTasks =
          state.downloads.where((task) => task.taskId != event.taskId).toList();

      emit(state.copyWith(downloads: updatedTasks));
    } catch (e) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'Failed to remove download task: $e',
        ),
      );
    }
  }

  Future<void> _onLoadTasksByStatus(
    LoadTasksByStatusEvent event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      emit(state.copyWith(loadState: RequestState.loading));

      final tasks = await _downloadRepo.getTasksByStatus(event.status);

      emit(
        state.copyWith(
          loadState: RequestState.success,
          downloads: tasks,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'Failed to load tasks by status: $e',
        ),
      );
    }
  }

  void _onDownloadProgressUpdate(
    DownloadProgressUpdateEvent event,
    Emitter<DownloadState> emit,
  ) {
    final updatedProgress = Map<String, int>.from(state.downloadProgress);
    updatedProgress[event.taskId] = event.progress;

    emit(state.copyWith(downloadProgress: updatedProgress));
  }

  void _onDownloadStatusUpdate(
    DownloadStatusUpdateEvent event,
    Emitter<DownloadState> emit,
  ) {
    final updatedTasks = state.downloads.map((task) {
      if (task.taskId == event.taskId) {
        return task.copyWith(status: event.status);
      }
      return task;
    }).toList();

    emit(state.copyWith(downloads: updatedTasks));
  }

  @override
  Future<void> close() {
    _downloadRepo.dispose();
    return super.close();
  }
}
