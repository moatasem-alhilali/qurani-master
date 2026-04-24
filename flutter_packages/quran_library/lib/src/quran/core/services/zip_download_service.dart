part of '/quran.dart';

typedef ZipDownloadProgressCallback = void Function(double percent);

class ZipDownloadService {
  const ZipDownloadService._();

  static Future<void> downloadAndExtract({
    required List<String> urls,
    required File zipFile,
    required Directory destinationDir,
    required ZipDownloadProgressCallback onProgress,
    Duration connectTimeout = const Duration(seconds: 20),
    Duration receiveTimeout = const Duration(minutes: 2),
    Map<String, String>? headers,
    int minZipSizeBytes = 1024 * 1024,
    String logName = 'ZipDownload',
  }) async {
    if (urls.isEmpty) {
      throw ArgumentError('urls must not be empty');
    }

    if (!await destinationDir.exists()) {
      await destinationDir.create(recursive: true);
    }

    final dio = Dio()
      ..options.connectTimeout = connectTimeout
      ..options.receiveTimeout = receiveTimeout;

    final effectiveHeaders = <String, String>{
      'User-Agent': 'Flutter/Quran-Library',
      'Accept': '*/*',
      'Accept-Encoding': 'identity',
      ...?headers,
    };

    bool extractionSucceeded = false;

    for (final url in urls) {
      try {
        log('Attempting to download from: $url', name: logName);

        final response = await dio.get(
          url,
          options: Options(
            responseType: ResponseType.stream,
            followRedirects: true,
            sendTimeout: const Duration(seconds: 30),
            headers: effectiveHeaders,
          ),
        );

        if (response.statusCode != 200) {
          log('Failed to connect to $url: ${response.statusCode}',
              name: logName);
          continue;
        }

        final contentType =
            response.headers.value(Headers.contentTypeHeader) ?? '';
        final headerLenStr =
            response.headers.value(Headers.contentLengthHeader);
        final headerLen = int.tryParse(headerLenStr ?? '0') ?? 0;

        if (contentType.startsWith('text/') || contentType.contains('html')) {
          log(
            'Rejected $url due to suspicious content-type: $contentType',
            name: logName,
          );
          continue;
        }

        if (headerLen > 0 && headerLen < minZipSizeBytes) {
          log(
            'Rejected $url due to too small content-length: $headerLen',
            name: logName,
          );
          continue;
        }

        final sink = zipFile.openWrite();
        int downloaded = 0;
        final completer = Completer<void>();

        (response.data as ResponseBody).stream.listen(
          (chunk) {
            downloaded += chunk.length;
            sink.add(chunk);
            if (headerLen > 0) {
              onProgress(downloaded / headerLen * 100);
            }
          },
          onDone: () async {
            await sink.flush();
            await sink.close();
            completer.complete();
          },
          onError: (e) async {
            await sink.close();
            completer.completeError(e);
          },
          cancelOnError: true,
        );

        await completer.future;

        final size = await zipFile.length();
        log('Downloaded ZIP file size: $size bytes', name: logName);
        if (size < minZipSizeBytes) {
          log('Zip too small, trying next mirror...', name: logName);
          try {
            await zipFile.delete();
          } catch (_) {}
          continue;
        }

        try {
          final bytes = await zipFile.readAsBytes();
          final archive = ZipDecoder().decodeBytes(bytes);
          if (archive.isEmpty) {
            throw const FormatException(
              'Failed to extract ZIP file: Archive is empty',
            );
          }

          for (final file in archive) {
            final filename = '${destinationDir.path}/${file.name}';
            if (file.isFile) {
              final out = File(filename);
              await out.create(recursive: true);
              await out.writeAsBytes(file.content as List<int>);
            }
          }

          extractionSucceeded = true;
          break;
        } catch (e) {
          log('Failed to extract ZIP from $url: $e', name: logName);
          try {
            await zipFile.delete();
          } catch (_) {}
          continue;
        }
      } catch (e) {
        log('Download error with URL, trying next: $e', name: logName);
        try {
          if (await zipFile.exists()) await zipFile.delete();
        } catch (_) {}
        continue;
      }
    }

    if (!extractionSucceeded) {
      throw Exception(
          'All mirrors failed to provide a valid ZIP or extraction failed');
    }

    onProgress(100.0);
  }
}
