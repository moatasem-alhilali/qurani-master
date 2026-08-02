part of '/quran.dart';

class WordInfoRepository {
  WordInfoRepository();

  static const _downloadedKindsKey = 'word_info_downloaded_kinds';

  static const String _glPkg =
      'https://gitlab.com/api/v4/projects/haozo89%2Fislamic_database/packages/generic';
  static const String _glRaw =
      'https://gitlab.com/haozo89/islamic_database/-/raw/main';

  static const Map<WordInfoKind, _WordInfoKindConfig> _configs = {
    WordInfoKind.recitations: _WordInfoKindConfig(
      zipName: 'word_qeraat.zip',
      dirName: 'word_qeraat',
      zipUrls: [
        'https://github.com/alheekmahlib/Islamic_database/releases/download/word_qeraat/word_qeraat.zip',
        '$_glPkg/word_qeraat/1.0.0/word_qeraat.zip',
      ],
      webBaseUrl:
          'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/word_qeraat',
      webBaseUrlGitLab:
          '$_glRaw/quran_database/Quran%20Font/word_qeraat?ref_type=heads',
    ),
    WordInfoKind.tasreef: _WordInfoKindConfig(
      zipName: 'word_tasreef.zip',
      dirName: 'word_tasreef',
      zipUrls: [
        'https://github.com/alheekmahlib/Islamic_database/releases/download/word_tasreef/word_tasreef.zip',
        '$_glPkg/word_tasreef/1.0.0/word_tasreef.zip',
      ],
      webBaseUrl:
          'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/quran_data/word_tasreef',
      webBaseUrlGitLab:
          '$_glRaw/quran_database/quran_data/word_tasreef?ref_type=heads',
    ),
    WordInfoKind.eerab: _WordInfoKindConfig(
      zipName: 'word_eerab.zip',
      dirName: 'word_eerab',
      zipUrls: [
        'https://github.com/alheekmahlib/Islamic_database/releases/download/word_eerab/word_eerab.zip',
        '$_glPkg/word_eerab/1.0.0/word_eerab.zip',
      ],
      webBaseUrl:
          'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/quran_data/word_eerab',
      webBaseUrlGitLab:
          '$_glRaw/quran_database/quran_data/word_eerab?ref_type=heads',
    ),
    WordInfoKind.meaning: _WordInfoKindConfig(
      zipName: 'meaning-word-oldv.json.zip',
      dirName: 'meaning-word-oldv',
      zipUrls: [
        'https://github.com/alheekmahlib/Islamic_database/releases/download/meaning-word-oldv.json.zip/meaning-word-oldv.json.zip',
        '$_glPkg/meaning-word-oldv.json.zip/1.0.0/meaning-word-oldv.json.zip',
      ],
      webBaseUrl:
          'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/quran_data/meaning_word',
      webBaseUrlGitLab:
          '$_glRaw/quran_database/quran_data/meaning_word?ref_type=heads',
      // في الويب، المعاني تأتي في ملف JSON واحد كبير بدل 114 ملف sura_NNN.json.
      webBundledFileName: 'meaning-word-oldv.json',
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

  // في الويب، الأنواع ذات webBundledFileName تُجلَب كملف واحد كبير ثم
  // تُقطَّع لكل سورة عند الطلب. نخزّن هنا عهد التحميل لتفادي الجلب المتزامن؛
  // والنتيجة تُحفظ في _cacheByKind كما في بقية الأنواع.
  final Map<WordInfoKind, Future<void>> _webBundledLoadByKind = {};

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
      if (config.webBundledFileName != null) {
        // الأنواع ذات الملف المجمّع (مثل meaning): نجلب الملف الكبير مرة واحدة،
        // نقطّعه لكل السور، ونخزّنها في الكاش. الطلبات المتزامنة تنتظر نفس العهد.
        // لاحظ: الدالة المساعدة لا ترمي؛ عند الفشل تزيل نفسها من الخريطة
        // للسماح بإعادة المحاولة لاحقًا.
        final load = _webBundledLoadByKind.putIfAbsent(
          kind,
          () => _loadWebBundledSurahs(kind: kind, config: config),
        );
        await load;
        return cache[surahNumber];
      }

      final fileName = 'sura_${surahNumber.toString().padLeft(3, '0')}.json';
      final urls = <String>[
        '${config.webBaseUrl}/$fileName',
        if (config.webBaseUrlGitLab != null)
          '${config.webBaseUrlGitLab}/$fileName',
      ];

      final dio = Dio()
        ..options.connectTimeout = const Duration(seconds: 20)
        ..options.receiveTimeout = const Duration(seconds: 20);

      String? text;
      for (final url in urls) {
        try {
          final response = await dio.get<String>(url);
          text = response.data;
          if (text != null && text.isNotEmpty) break;
        } catch (_) {
          continue;
        }
      }
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

  /// يحمّل الملف الويبي المجمّع (مثل meaning-word-oldv.json) مرة واحدة،
  /// يفكّك قائمة `words` المسطّحة، ويملأ _cacheByKind[kind] لكل السور.
  /// لا يرمي استثناءً: عند الفشل يزيل العهد من الخريطة للسماح بإعادة المحاولة.
  /// هذا يعيد استخدام نفس نمط التقطيع في _normalizeExtractedLayout على الويب.
  Future<void> _loadWebBundledSurahs({
    required WordInfoKind kind,
    required _WordInfoKindConfig config,
  }) async {
    try {
      final urls = <String>[
        '${config.webBaseUrl}/${config.webBundledFileName}',
        if (config.webBaseUrlGitLab != null)
          '${config.webBaseUrlGitLab}/${config.webBundledFileName}',
      ];

      final dio = Dio()
        ..options.connectTimeout = const Duration(seconds: 20)
        ..options.receiveTimeout = const Duration(minutes: 2);

      String? text;
      for (final url in urls) {
        try {
          final response = await dio.get<String>(url);
          text = response.data;
          if (text != null && text.isNotEmpty) break;
        } catch (_) {
          continue;
        }
      }
      if (text == null || text.isEmpty) return;

      final decoded = jsonDecode(text);
      if (decoded is! Map) return;

      final words = decoded['words'];
      if (words is! List) return;

      final cache = _cacheByKind[kind]!;

      // جمّع: sura_number → aya_number → قائمة كائنات الكلمات.
      final bySurah = <int, Map<int, List<Map<String, dynamic>>>>{};
      for (final raw in words) {
        if (raw is! Map) continue;
        final surah = (raw['sura_number'] as num?)?.toInt();
        final ayah = (raw['aya_number'] as num?)?.toInt();
        if (surah == null || ayah == null) continue;
        final casted = Map<String, dynamic>.from(raw);
        (bySurah[surah] ??= <int, List<Map<String, dynamic>>>{})[ayah] ??=
            <Map<String, dynamic>>[];
        bySurah[surah]![ayah]!.add(casted);
      }

      // اكتب كل سورة إلى الكاش بصيغة List من كائنات الآيات المتوقعة.
      for (final entry in bySurah.entries) {
        final surahNumber = entry.key;
        final ayahs = entry.value;
        final ayahList = ayahs.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));
        final jsonList = ayahList
            .map((e) => <String, dynamic>{
                  'aya_number': e.key,
                  'words': e.value,
                })
            .toList();
        cache[surahNumber] = QiraatSurahWords.fromJson(
          surahNumber: surahNumber,
          jsonList: jsonList,
        );
      }
    } finally {
      // أزِل العهد دائمًا: إن نجح فالكاش مملوء ولا داعي لإعادة التحميل،
      // وإن فشل فنسمح بإعادة المحاولة في طلب لاحق.
      _webBundledLoadByKind.remove(kind);
    }
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

    // بعض الأنواع (مثل meaning) تأتي في ملف JSON واحد كبير بدل 114 ملف
    // sura_NNN.json. نطبّع التخطيط إلى الصيغة المتوقعة قبل الفهرسة.
    await _normalizeExtractedLayout(kind: kind, destDir: destDir);

    await _ensureIndex(kind);
    if (_filePathBySurahByKind[kind]?.isEmpty ?? true) {
      throw Exception(
        'تم التحميل لكن لم يتم العثور على ملفات sura_###.json بعد فك الضغط',
      );
    }

    _markKindDownloaded(kind);
  }

  /// يطبّع تخطيط الملفات المستخرجة إلى الصيغة المعيارية المتوقعة
  /// (ملف sura_NNN.json لكل سورة، كلٌّ منها JSON List من كائنات الآيات).
  ///
  /// حاليًا يحتاجها نوع `meaning` فقط: يأتي كملف JSON واحد كبير يحوي
  /// قائمة `words` مسطّحة (77432 كلمة). نقسمها هنا إلى 114 ملفًا.
  /// الأنواع الأخرى تأتي أصلًا على هذه الصيغة فلا تحتاج أي معالجة.
  Future<void> _normalizeExtractedLayout({
    required WordInfoKind kind,
    required Directory destDir,
  }) async {
    if (kind != WordInfoKind.meaning) return;
    if (!await destDir.exists()) return;

    final regex = RegExp(r'^sura_(\d{3})\.json$');

    // ابحث عن ملف JSON لا يطابق نمط sura_NNN.json (أي الملف المجمّع).
    File? bundledFile;
    await for (final entity
        in destDir.list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final name = entity.path.split(Platform.pathSeparator).last;
      if (name.toLowerCase().endsWith('.json') && !regex.hasMatch(name)) {
        bundledFile = entity as File;
        break;
      }
    }
    if (bundledFile == null) return; // لا ملف مجمّع → لا شيء لنفعله.

    final decoded = jsonDecode(await bundledFile.readAsString());
    if (decoded is! Map) return;

    final words = decoded['words'];
    if (words is! List) return;

    // جمّع: sura_number → aya_number → قائمة كائنات الكلمات.
    final bySurah = <int, Map<int, List<Map<String, dynamic>>>>{};
    for (final raw in words) {
      if (raw is! Map) continue;
      final surah = (raw['sura_number'] as num?)?.toInt();
      final ayah = (raw['aya_number'] as num?)?.toInt();
      if (surah == null || ayah == null) continue;
      final casted = Map<String, dynamic>.from(raw);
      (bySurah[surah] ??= <int, List<Map<String, dynamic>>>{})[ayah] ??=
          <Map<String, dynamic>>[];
      bySurah[surah]![ayah]!.add(casted);
    }

    // اكتب ملف sura_NNN.json لكل سورة بصيغة List من كائنات الآيات،
    // وهي الصيغة التي تتوقعها QiraatAyahWords.fromJson.
    for (final entry in bySurah.entries) {
      final surahNumber = entry.key;
      final ayahs = entry.value;
      final ayahList = ayahs.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      final out = ayahList
          .map((e) => <String, dynamic>{
                'aya_number': e.key,
                'words': e.value,
              })
          .toList();
      final file = File(
          '${destDir.path}/sura_${surahNumber.toString().padLeft(3, '0')}.json');
      await file.writeAsString(jsonEncode(out));
    }

    // احذف الملف المجمّع الكبير لتوفير المساحة (~20MB).
    try {
      await bundledFile.delete();
    } catch (_) {}
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
  final String? webBaseUrlGitLab;

  /// إن لم يكن null، فإنّ نوع البيانات على الويب يأتي في ملف واحد كبير
  /// (JSON Object فيه قائمة `words` مسطّحة) بدل ملف sura_NNN.json لكل سورة.
  /// يُستخدم لتقطيع الملف الواحد عند الطلب.
  final String? webBundledFileName;

  const _WordInfoKindConfig({
    required this.zipName,
    required this.dirName,
    required this.zipUrls,
    required this.webBaseUrl,
    this.webBaseUrlGitLab,
    this.webBundledFileName,
  });
}
