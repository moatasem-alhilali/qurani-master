import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:quran_app/core/services/directory_service.dart';
import 'package:quran_app/core/services/permission/storgae_permission_service.dart';
import 'package:quran_app/features/download/data/models/download_task_model.dart';
import 'package:quran_app/main.dart';
// open,
// remove,
// retry,
// resume,
// pause,
// cancelAll,
// cancel,
// loadTasksWithRawQuery,
// loadTasks,

typedef DownloadProgressCallback = void Function(String taskId, int progress);
typedef DownloadStatusCallback = void Function(
  String taskId,
  DownloadTaskStatus status,
);

@pragma('vm:entry-point')
class DownloadRepo {
  //
  final ReceivePort _port = ReceivePort();
  static const String portName = 'downloader_send_port';

  DownloadProgressCallback? onProgress;
  DownloadStatusCallback? onStatusChanged;

  void init() {
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback, step: 1);
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      portName,
    );
    if (!isSuccess) {
      remove();
      remove();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as int;
      final progress = data[2] as int;

      logger.i(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );

      // Call callbacks if they exist
      onProgress?.call(taskId, progress);
      onStatusChanged?.call(taskId, DownloadTaskStatus.values[status]);
    });
  }

  void remove() {
    IsolateNameServer.removePortNameMapping(portName);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    int status,
    int progress,
  ) {
    logger.i(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName(portName)?.send([id, status, progress]);
  }

  /// Start a new download
  Future<String?> download({
    required String url,
    String? fileName,
    bool saveInPublicStorage =
        false, // Changed default to false for app-specific storage
    bool allowCellular = true,
    bool openFileFromNotification = false,
  }) async {
    try {
      // Only request storage permissions if using public storage
      if (saveInPublicStorage) {
        await StoragePermissionService.manageExternalStorage();

        // Try to get public downloads path
        final publicPath = await DirectoryService.getPublicDownloadsPath();
        if (publicPath != null) {
          final extension = url.split('/').last.split('.').last;
          final finalFileName =
              fileName ?? '${DateTime.now().millisecondsSinceEpoch}.$extension';

          final taskId = await FlutterDownloader.enqueue(
            url: url,
            savedDir: publicPath,
            saveInPublicStorage: true,
            fileName: finalFileName,
            allowCellular: allowCellular,
            openFileFromNotification: openFileFromNotification,
          );

          logger.i('Download started with taskId: $taskId (public storage)');
          return taskId;
        } else {
          logger.w(
              'Could not access public storage, falling back to app-specific storage');
        }
      }

      // Use app-specific storage (default and fallback)
      final appStoragePath = await DirectoryService.getExternalStoragePath();
      if (appStoragePath == null) {
        throw Exception('Could not get any storage path');
      }

      final extension = url.split('/').last.split('.').last;
      final finalFileName =
          fileName ?? '${DateTime.now().millisecondsSinceEpoch}.$extension';

      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: appStoragePath,
        fileName: finalFileName,
        allowCellular: allowCellular,
        openFileFromNotification: openFileFromNotification,
      );

      logger.i('Download started with taskId: $taskId (app-specific storage)');
      return taskId;
    } catch (e) {
      logger.e('Error during download: $e');
      rethrow;
    }
  }

  /// Load all download tasks
  Future<List<DownloadTaskModel>> loadTasks() async {
    try {
      final tasks = await FlutterDownloader.loadTasks();
      if (tasks == null) return [];

      return tasks.map(DownloadTaskModel.fromDownloadTask).toList();
    } catch (e) {
      logger.e('Error loading tasks: $e');
      return [];
    }
  }

  /// Load download tasks with custom SQL query
  Future<List<DownloadTaskModel>> loadTasksWithRawQuery({
    required String query,
  }) async {
    try {
      final tasks = await FlutterDownloader.loadTasksWithRawQuery(query: query);
      if (tasks == null) return [];

      return tasks.map(DownloadTaskModel.fromDownloadTask).toList();
    } catch (e) {
      logger.e('Error loading tasks with query: $e');
      return [];
    }
  }

  /// Cancel a download task
  Future<void> cancel({required String taskId}) async {
    try {
      await FlutterDownloader.cancel(taskId: taskId);
      logger.i('Download canceled: $taskId');
    } catch (e) {
      logger.e('Error canceling download: $e');
      rethrow;
    }
  }

  /// Cancel all download tasks
  Future<void> cancelAll() async {
    try {
      await FlutterDownloader.cancelAll();
      logger.i('All downloads canceled');
    } catch (e) {
      logger.e('Error canceling all downloads: $e');
      rethrow;
    }
  }

  /// Pause a download task
  Future<void> pause({required String taskId}) async {
    try {
      await FlutterDownloader.pause(taskId: taskId);
      logger.i('Download paused: $taskId');
    } catch (e) {
      logger.e('Error pausing download: $e');
      rethrow;
    }
  }

  /// Resume a paused download task
  Future<String?> resume({required String taskId}) async {
    try {
      final newTaskId = await FlutterDownloader.resume(taskId: taskId);
      logger.i('Download resumed: $taskId -> $newTaskId');
      return newTaskId;
    } catch (e) {
      logger.e('Error resuming download: $e');
      rethrow;
    }
  }

  /// Retry a failed download task
  Future<String?> retry({required String taskId}) async {
    try {
      final newTaskId = await FlutterDownloader.retry(taskId: taskId);
      logger.i('Download retried: $taskId -> $newTaskId');
      return newTaskId;
    } catch (e) {
      logger.e('Error retrying download: $e');
      rethrow;
    }
  }

  /// Open a downloaded file
  Future<bool> open({required String taskId}) async {
    try {
      final success = await FlutterDownloader.open(taskId: taskId);
      logger.i('File opened: $taskId, success: $success');
      return success ?? false;
    } catch (e) {
      logger.e('Error opening file: $e');
      return false;
    }
  }

  /// Remove a download task from database (doesn't delete the file)
  Future<void> removeTask({required String taskId}) async {
    try {
      await FlutterDownloader.remove(taskId: taskId);
      logger.i('Task removed from database: $taskId');
    } catch (e) {
      logger.e('Error removing task: $e');
      rethrow;
    }
  }

  /// Remove a download task and delete the downloaded file
  Future<void> removeTaskWithFile({required String taskId}) async {
    try {
      await FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: true);
      logger.i('Task and file removed: $taskId');
    } catch (e) {
      logger.e('Error removing task with file: $e');
      rethrow;
    }
  }

  /// Get download task by ID
  Future<DownloadTaskModel?> getTaskById(String taskId) async {
    try {
      final tasks = await loadTasks();
      for (final task in tasks) {
        if (task.taskId == taskId) {
          return task;
        }
      }
      return null;
    } catch (e) {
      logger.e('Error getting task by ID: $e');
      return null;
    }
  }

  /// Get download tasks by status
  Future<List<DownloadTaskModel>> getTasksByStatus(
    DownloadTaskStatus status,
  ) async {
    try {
      final tasks = await loadTasks();
      return tasks.where((task) => task.status == status).toList();
    } catch (e) {
      logger.e('Error getting tasks by status: $e');
      return [];
    }
  }

  /// Clean up resources
  void dispose() {
    remove();
    _port.close();
  }
}
