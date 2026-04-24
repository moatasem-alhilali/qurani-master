part of '../../../tafsir.dart';

typedef TajweedDownloadProgressCallback = void Function(double progress);

class TajweedAyaRepository {
  static const _downloadedKey = 'tajweed_aya_downloaded_v1';
  static const String _zipName = 'tajweed_aya.zip';
  static const String _dirName = 'tajweed_aya';
  static const List<String> _zipUrls = <String>[
    'https://github.com/alheekmahlib/Islamic_database/releases/download/tajweed_aya/tajweed_aya.zip',
  ];
  static const String _webBaseUrl =
      'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/quran_data/tajweed_aya';

  TajweedAyaRepository({SuraJsonFilesService? filesService})
      : _filesService = filesService ??
            SuraJsonFilesService(
              storageKey: _downloadedKey,
              zipName: _zipName,
              dirName: _dirName,
              zipUrls: _zipUrls,
              webBaseUrl: _webBaseUrl,
              minZipSizeBytes: 50 * 1024,
              logName: 'TajweedAyaDownload',
            );

  final SuraJsonFilesService _filesService;

  final Map<int, TajweedSurahAyahs> _cacheBySurah = {};
  final Set<int> _loadingSurahs = <int>{};

  bool isDownloaded() {
    return _filesService.isEnabled();
  }

  Future<void> download({
    required TajweedDownloadProgressCallback onProgress,
  }) async {
    if (isDownloaded()) return;
    _cacheBySurah.clear();
    await _filesService.downloadAndEnable(onProgress: onProgress);
  }

  Future<TajweedAyahInfo?> getAyahInfo({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    if (!isDownloaded()) return null;
    final surah = await _ensureSurahLoaded(surahNumber);
    return surah?.lookup(ayahNumber: ayahNumber);
  }

  Future<void> prewarmSurah(int surahNumber) async {
    if (!isDownloaded()) return;
    if (_cacheBySurah.containsKey(surahNumber)) return;
    if (_loadingSurahs.contains(surahNumber)) return;
    _loadingSurahs.add(surahNumber);
    try {
      await _ensureSurahLoaded(surahNumber);
    } finally {
      _loadingSurahs.remove(surahNumber);
    }
  }

  Future<TajweedSurahAyahs?> _ensureSurahLoaded(int surahNumber) async {
    final cached = _cacheBySurah[surahNumber];
    if (cached != null) return cached;

    final decoded = await _filesService.loadSurahJsonList(surahNumber);
    if (decoded == null) return null;

    final model = TajweedSurahAyahs.fromJson(
      surahNumber: surahNumber,
      jsonList: decoded,
    );
    _cacheBySurah[surahNumber] = model;
    return model;
  }
}
