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
    this.webBaseUrlGitLab,
    this.minZipSizeBytes = 50 * 1024,
    this.logName,
  }) {
    if (!kIsWeb) {
      unawaited(_verifyFilesInBackground());
    }
  }

  final String storageKey;
  final String zipName;
  final String dirName;
  final List<String> zipUrls;
  final String webBaseUrl;
  final String? webBaseUrlGitLab;
  final int minZipSizeBytes;
  final String? logName;

  /// مسار Documents المخزَّن (مرة واحدة لكل جلسة) كي يمكن فحص وجود
  /// ملفات الاستخراج من داخل [isEnabled] المتزامنة.
  static String? _cachedDocsPath;

  /// نتيجة فحص وجود ملفات لكل مجلد (dirName) في هذه الجلسة.
  static final Map<String, bool> _filesVerifiedByDir = {};

  final Map<int, String> _filePathBySurah = <int, String>{};
  bool _indexReady = false;

  static Future<void> _warmDocsPath() async {
    if (_cachedDocsPath != null) {
      return;
    }
    try {
      _cachedDocsPath = (await getApplicationDocumentsDirectory()).path;
    } catch (_) {
      // المسار يُخزَّن لاحقًا عند أول عملية تنزيل/فهرسة.
    }
  }

  /// فحص خلفي لمرة واحدة في الجلسة: لو كان العلم مفعلاً وملفات الاستخراج
  /// محذوفة (تنظيف مساحة، ترحيل بيانات، ...) يُكتب false في العلم كي
  /// يمكن إعادة التنزيل بدل تعطّل الميزة بصمت.
  Future<void> _verifyFilesInBackground() async {
    await _warmDocsPath();
    final docsPath = _cachedDocsPath;
    if (docsPath == null) return;
    if (_filesVerifiedByDir.containsKey(dirName)) return;
    if (GetStorage().read(storageKey) != true) return;

    final present = await _dirHasFiles(docsPath);
    if (!present) {
      GetStorage().write(storageKey, false);
      log(
        'SuraJsonFilesService: files missing for "$dirName" — flag cleared',
        name: 'SuraJsonFilesService',
      );
    }
    _filesVerifiedByDir[dirName] = present;
  }

  /// لإعادة ضبط حالة الفحص بين الاختبارات.
  @visibleForTesting
  static void debugResetVerificationState() {
    _filesVerifiedByDir.clear();
  }

  bool isEnabled() {
    final enabled = GetStorage().read(storageKey) == true;
    if (!enabled) return false;
    if (kIsWeb) return true;

    // نتيجة الفحص الخلفي إن جهزت؛ وإلا نثق بالعلم مؤقتًا.
    return _filesVerifiedByDir[dirName] ?? true;
  }

  /// هل مجلد الاستخراج `<Documents>/<dirName>` يحوي ملفات فعلًا؟
  Future<bool> _dirHasFiles(String docsPath) async {
    try {
      final dir = Directory('$docsPath/$dirName');
      if (!await dir.exists()) return false;
      await for (final _ in dir.list(recursive: true, followLinks: false)) {
        return true; // يكفي وجود أول ملف.
      }
      return false;
    } catch (_) {
      return true; // فشل فحص — لا نُبطِل العلم على أساسه.
    }
  }

  void markEnabled() {
    GetStorage().write(storageKey, true);
    // التنزيل نجح للتو — الملفات موجودة قطعًا في هذه الجلسة.
    _filesVerifiedByDir[dirName] = true;
  }

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
    _cachedDocsPath ??= baseDir.path;
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
      final fileName = 'sura_${surahNumber.toString().padLeft(3, '0')}.json';
      final urls = <String>[
        '$webBaseUrl/$fileName',
        if (webBaseUrlGitLab != null) '$webBaseUrlGitLab/$fileName',
      ];

      final dio = Dio()
        ..options.connectTimeout = const Duration(seconds: 20)
        ..options.receiveTimeout = const Duration(seconds: 20);

      String? text;
      for (final url in urls) {
        try {
          final response = await dio.get<String>(
            url,
            options: Options(responseType: ResponseType.plain),
          );
          text = response.data;
          if (text != null && text.isNotEmpty) break;
        } catch (_) {
          continue;
        }
      }
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
