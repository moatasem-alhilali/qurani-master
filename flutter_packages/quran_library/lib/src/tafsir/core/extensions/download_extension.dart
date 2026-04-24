part of '../../tafsir.dart';

extension DownloadExtension on TafsirCtrl {
  Future<bool> downloadFile(String path, String url) async {
    Dio dio = Dio();
    cancelToken = CancelToken();
    try {
      try {
        await Directory(dirname(path)).create(recursive: true);
        isDownloading.value = true;
        onDownloading.value = true;
        progressString.value = "0";
        progress.value = 0;

        await dio.download(url, path, onReceiveProgress: (rec, total) {
          progressString.value =
              ((rec / (total == -1 ? 50000000 : total)) * 100)
                  .toStringAsFixed(0);
          progress.value =
              (rec / (total == -1 ? (total == -1 ? 50000000 : total) : total))
                  .toDouble();
          log('progress: ${progressString.value}');
          log('Received: $rec, Total: $total');
        }, cancelToken: cancelToken);

        // إذا كان الملف مضغوطًا (gzip)، فك الضغط مرة واحدة واكتب النص كناتج.
        try {
          final file = File(path);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            final isGzip =
                bytes.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b;
            if (isGzip || url.toLowerCase().endsWith('.gz')) {
              final text = GzipJsonAssetService.decodeGzipBytesToString(
                Uint8List.fromList(bytes),
              );
              await file.writeAsString(text, flush: true);
            }
          }
        } catch (e) {
          log('Failed to decompress downloaded file: $e');
        }
      } catch (e) {
        if (e is DioException && e.type == DioExceptionType.cancel) {
          log('Download canceled');
          // Delete the partially downloaded file
          try {
            final file = File(path);
            if (await file.exists()) {
              await file.delete();
              onDownloading.value = false;
              log('Partially downloaded file deleted');
            }
          } catch (e) {
            log('Error deleting partially downloaded file: $e');
          }
          return false;
        } else {
          log('Error: $e');
        }
      }
      progress.value = 1;
      await Future.delayed(Durations.medium1);
      onDownloading.value = false;
      progressString.value = "100";
      log("Download completed for $path");
      update(['tafsirs_menu_list']);
      return true;
    } catch (e) {
      log("Error isDownloading: $e");
    }
    return false;
  }
}
