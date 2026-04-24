part of '/quran.dart';

class WordInfoRepository {
  WordInfoRepository();

  static const _downloadedKindsKey = 'word_info_downloaded_kinds';

  static const Map<WordInfoKind, _WordInfoKindConfig> _configs = {
    WordInfoKind.recitations: _WordInfoKindConfig(
      zipName: 'word_qeraat.zip',
      dirName: 'word_qeraat',
      zipUrls: [
        'https://github.com/alheekmahlib/Islamic_database/releases/download/word_qeraat/word_qeraat.zip',
      ],
      webBaseUrl:
          'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/word_qeraat',
    ),
    WordInfoKind.tasreef: _WordInfoKindConfig(
      zipName: 'word_tasreef.zip',
      dirName: 'word_tasreef',
      zipUrls: [
        'https://github.com/alheekmahlib/Islamic_database/releases/download/word_tasreef/word_tasreef.zip',
      ],
      webBaseUrl:
          'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/quran_data/word_tasreef',
    ),
    WordInfoKind.eerab: _WordInfoKindConfig(
      zipName: 'word_eerab.zip',
      dirName: 'word_eerab',
      zipUrls: [
        'https://github.com/alheekmahlib/Islamic_database/releases/download/word_eerab/word_eerab.zip',
      ],
      webBaseUrl:
          'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/quran_data/word_eerab',
    ),
  };

  final Map<WordInfoKind, Map<int, QiraatSurahWords>> _cacheByKind = {
    for (final k in WordInfoKind.values) k: <int, QiraatSurahWords>{},
  };
  final Map<WordInfoKind, Set<int>> _loadingSurahsByKind = {
    for (final k in WordInfoKind.values) k: <int>{},
  };

  final Map<WordInfoKind, Map<int, String>> _filePathBySurahByKind = {
    for (final k in WordInfoKind.values) k: <int, String>{},
  };
  final Map<WordInfoKind, bool> _indexReadyByKind = {
    for (final k in WordInfoKind.values) k: false,
  };

  bool isKindDownloaded(WordInfoKind kind) {
    if (kIsWeb) {
      // في الويب: نعتبرها "مفعلة" بعد ضغط المستخدم على تحميل.
      return _downloadedKinds().contains(kind.name);
    }

    return _downloadedKinds().contains(kind.name);
  }

  Future<void> downloadKind({
    required WordInfoKind kind,
    required ZipDownloadProgressCallback onProgress,
  }) async {
    await _download(kind: kind, onProgress: onProgress);
  }

  Future<QiraatWordInfo?> getWordInfo({
    required WordInfoKind kind,
    required WordRef ref,
  }) async {
    if (!isKindDownloaded(kind)) return null;
    final surah =
        await _ensureSurahLoaded(kind: kind, surahNumber: ref.surahNumber);
    return surah?.lookup(ref);
  }

  Future<bool> prewarmRecitationsSurah(int surahNumber) async {
    if (!isKindDownloaded(WordInfoKind.recitations)) return false;
    final cache = _cacheByKind[WordInfoKind.recitations]!;
    final loading = _loadingSurahsByKind[WordInfoKind.recitations]!;
    // إذا كانت السورة موجودة مسبقًا بالكاش فلا نعتبرها "تحميلًا جديدًا".
    if (cache.containsKey(surahNumber)) return false;
    if (loading.contains(surahNumber)) return false;
    loading.add(surahNumber);
    try {
      await _ensureSurahLoaded(
          kind: WordInfoKind.recitations, surahNumber: surahNumber);
      return cache.containsKey(surahNumber);
    } finally {
      loading.remove(surahNumber);
    }
  }

  QiraatWordInfo? getRecitationWordInfoSync({
    required WordRef ref,
  }) {
    final surah = _cacheByKind[WordInfoKind.recitations]?[ref.surahNumber];
    return surah?.lookup(ref);
  }

  Future<QiraatSurahWords?> _ensureSurahLoaded({
    required WordInfoKind kind,
    required int surahNumber,
  }) async {
    final cache = _cacheByKind[kind]!;
    final cached = cache[surahNumber];
    if (cached != null) return cached;

    final config = _configs[kind]!;

    if (kIsWeb) {
      final url =
          '${config.webBaseUrl}/sura_${surahNumber.toString().padLeft(3, '0')}.json';
      final dio = Dio()
        ..options.connectTimeout = const Duration(seconds: 20)
        ..options.receiveTimeout = const Duration(seconds: 20);

      final response = await dio.get<String>(url);
      final text = response.data;
      if (text == null || text.isEmpty) return null;

      final decoded = jsonDecode(text);
      if (decoded is! List) return null;
      final model = QiraatSurahWords.fromJson(
        surahNumber: surahNumber,
        jsonList: decoded,
      );
      cache[surahNumber] = model;
      return model;
    }

    await _ensureIndex(kind);
    final path = _filePathBySurahByKind[kind]?[surahNumber];
    if (path == null) return null;

    final file = File(path);
    final text = await file.readAsString();
    final decoded = jsonDecode(text);
    if (decoded is! List) return null;

    final model = QiraatSurahWords.fromJson(
      surahNumber: surahNumber,
      jsonList: decoded,
    );
    cache[surahNumber] = model;
    return model;
  }

  Future<void> _download({
    required WordInfoKind kind,
    required ZipDownloadProgressCallback onProgress,
  }) async {
    if (isKindDownloaded(kind)) return;

    final config = _configs[kind]!;

    if (kIsWeb) {
      // في الويب لا يوجد zip؛ نعتبر الضغط على زر تحميل تفعيلًا للميزة.
      _markKindDownloaded(kind);
      onProgress(100.0);
      return;
    }

    final baseDir = await getApplicationDocumentsDirectory();
    final destDir = Directory('${baseDir.path}/${config.dirName}');
    final zipFile = File('${baseDir.path}/${config.zipName}');

    // إعادة تعيين الفهرس/الكاش بعد التحميل لضمان التقاط أي بنية مجلدات داخل zip.
    _indexReadyByKind[kind] = false;
    _filePathBySurahByKind[kind]?.clear();
    _cacheByKind[kind]?.clear();

    await ZipDownloadService.downloadAndExtract(
      urls: config.zipUrls,
      zipFile: zipFile,
      destinationDir: destDir,
      onProgress: onProgress,
      logName: 'WordInfoDownload:${kind.name}',
      minZipSizeBytes: 50 * 1024, // الملفات صغيرة نسبيًا
    );

    await _ensureIndex(kind);
    if (_filePathBySurahByKind[kind]?.isEmpty ?? true) {
      throw Exception(
        'تم التحميل لكن لم يتم العثور على ملفات sura_###.json بعد فك الضغط',
      );
    }

    _markKindDownloaded(kind);
  }

  Future<Directory> _getKindDir(WordInfoKind kind) async {
    final config = _configs[kind]!;
    final baseDir = await getApplicationDocumentsDirectory();
    return Directory('${baseDir.path}/${config.dirName}');
  }

  Future<void> _ensureIndex(WordInfoKind kind) async {
    if (_indexReadyByKind[kind] == true) return;
    _indexReadyByKind[kind] = true;

    final dir = await _getKindDir(kind);
    if (!await dir.exists()) return;

    final regex = RegExp(r'^sura_(\d{3})\.json$');
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final name = entity.path.split(Platform.pathSeparator).last;
      final match = regex.firstMatch(name);
      if (match == null) continue;
      final surahNumber = int.tryParse(match.group(1) ?? '');
      if (surahNumber == null) continue;
      _filePathBySurahByKind[kind]?[surahNumber] = entity.path;
    }
  }

  Set<String> _downloadedKinds() {
    final raw = GetStorage().read(_downloadedKindsKey);
    if (raw is List) {
      return raw.map((e) => e.toString()).toSet();
    }
    return <String>{};
  }

  void _markKindDownloaded(WordInfoKind kind) {
    final set = _downloadedKinds();
    set.add(kind.name);
    GetStorage().write(_downloadedKindsKey, set.toList());
  }
}

class _WordInfoKindConfig {
  final String zipName;
  final String dirName;
  final List<String> zipUrls;
  final String webBaseUrl;

  const _WordInfoKindConfig({
    required this.zipName,
    required this.dirName,
    required this.zipUrls,
    required this.webBaseUrl,
  });
}
