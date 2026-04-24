part of '/quran.dart';

/// خدمة صغيرة لإدارة ملفات `sura_###.json`:
/// - تنزيل ZIP (غير الويب)
/// - تفعيل في الويب عبر زر التحميل
/// - فهرسة الملفات محليًا (recursive)
/// - قراءة JSON لسورة محددة (Web أو Local)
class SuraJsonFilesService {
  SuraJsonFilesService({
    required this.storageKey,
    required this.zipName,
    required this.dirName,
    required this.zipUrls,
    required this.webBaseUrl,
    this.minZipSizeBytes = 50 * 1024,
    this.logName,
  });

  final String storageKey;
  final String zipName;
  final String dirName;
  final List<String> zipUrls;
  final String webBaseUrl;
  final int minZipSizeBytes;
  final String? logName;

  final Map<int, String> _filePathBySurah = <int, String>{};
  bool _indexReady = false;

  bool isEnabled() => GetStorage().read(storageKey) == true;

  void markEnabled() => GetStorage().write(storageKey, true);

  Future<void> downloadAndEnable({
    required ZipDownloadProgressCallback onProgress,
  }) async {
    if (isEnabled()) return;

    if (kIsWeb) {
      markEnabled();
      onProgress(100.0);
      return;
    }

    final baseDir = await getApplicationDocumentsDirectory();
    final destDir = Directory('${baseDir.path}/$dirName');
    final zipFile = File('${baseDir.path}/$zipName');

    _indexReady = false;
    _filePathBySurah.clear();

    await ZipDownloadService.downloadAndExtract(
      urls: zipUrls,
      zipFile: zipFile,
      destinationDir: destDir,
      onProgress: onProgress,
      logName: logName ?? 'SuraJsonDownload:$dirName',
      minZipSizeBytes: minZipSizeBytes,
    );

    await _ensureIndex();
    if (_filePathBySurah.isEmpty) {
      throw Exception('تم التحميل لكن لم يتم العثور على ملفات sura_###.json');
    }

    markEnabled();
  }

  Future<List<dynamic>?> loadSurahJsonList(int surahNumber) async {
    if (!isEnabled()) return null;

    if (kIsWeb) {
      final url =
          '$webBaseUrl/sura_${surahNumber.toString().padLeft(3, '0')}.json';
      final dio = Dio()
        ..options.connectTimeout = const Duration(seconds: 20)
        ..options.receiveTimeout = const Duration(seconds: 20);

      final response = await dio.get<String>(
        url,
        options: Options(responseType: ResponseType.plain),
      );
      final text = response.data;
      if (text == null || text.isEmpty) return null;

      final decoded = jsonDecode(text);
      return decoded is List ? decoded : null;
    }

    await _ensureIndex();
    final path = _filePathBySurah[surahNumber];
    if (path == null) return null;

    final text = await File(path).readAsString();
    final decoded = jsonDecode(text);
    return decoded is List ? decoded : null;
  }

  Future<void> _ensureIndex() async {
    if (_indexReady) return;
    _indexReady = true;

    final baseDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${baseDir.path}/$dirName');
    if (!await dir.exists()) return;

    final regex = RegExp(r'^sura_(\d{3})\.json$');
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final name = entity.path.split(Platform.pathSeparator).last;
      final match = regex.firstMatch(name);
      if (match == null) continue;
      final surahNumber = int.tryParse(match.group(1) ?? '');
      if (surahNumber == null) continue;
      _filePathBySurah[surahNumber] = entity.path;
    }
  }
}
