import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/features/offline/data/database/database_offline_service.dart';
import 'package:quran_app/features/offline/data/models/offline_file_model.dart';
import 'package:quran_app/main.dart';

class DownloadService {
  Future<void> initialize() async {
    try {
      // 📥 Initialize the FlutterDownloader for background downloading support
      await FlutterDownloader.initialize();
    } catch (e) {
      logger.e('error in download service: $e');
    }
  }

  //
  final ReceivePort _port = ReceivePort();
  final DatabaseOfflineService _offlineService = DatabaseOfflineService();
  static const String portName = 'downloader_send_port';
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

      print(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );
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
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName(portName)?.send([id, status, progress]);
  }

  Future<void> download(String url, String description) async {
    try {
      await _permission();

      final externalDirectory = await getExternalStorageDirectory();

      // final dir =
      //     await Directory('${externalDirectory!.path}/Download').create();
      final di = await getDownloadPath();
      final extension = url.split('/').last.split('.').last;
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch.toString() + description}.$extension';
      ToastServes.showToast(message: 'التنزيل بدأ');

      await FlutterDownloader.enqueue(
        url: url,
        // savedDir: dir.path,
        savedDir: di!,
        saveInPublicStorage: true,
        fileName: fileName,
      ).then((value) => logger.i(value));
      try {
        ToastServes.showToast(message: 'تم التنزيل');

        await _offlineService.insert(
          OfflineFileModel(
            path: '/storage/emulated/0/Download/$fileName',
            type: extension,
            title: description,
            url: url,
            description: description,
            time: DateTime.now().toString(),
          ),
        );
      } catch (e) {
        logger.e(e);
      }
    } catch (e) {
      logger.e('Error during download: $e');
    }
  }

  Future<void> _permission() async {
    final storage = await Permission.storage.status;
    if (storage.isDenied) {
      await Permission.storage.request();
    }
    final manageExternalStorage = await Permission.manageExternalStorage.status;
    if (manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }
  }
}

Future<String?> getDownloadPath() async {
  Directory? directory;
  try {
    directory = Directory('/storage/emulated/0/Download');

    if (!await directory.exists()) {
      directory = await getExternalStorageDirectory();
    }
  } catch (err) {
    print('Cannot get download folder path');
  }
  return directory?.path;
}
