part of '/quran.dart';

/// خدمة تحميل كسول (lazy) وتسجيل خطوط QCF4 المضغوطة (tajweed).
///
/// الخطوط مخزّنة كملفات `.ttf.gz` في assets. عند الحاجة يتم فك ضغطها
/// وتسجيلها عبر [loadFontFromList]. تُحفظ النسخ المفكوكة على القرص
/// (على المنصات غير الويب) لتسريع التشغيلات اللاحقة.
///
/// **التحميل الكسول**: تُحمّل فقط الصفحات القريبة من الصفحة الحالية،
/// ثم تُكمَل بقية الصفحات في الخلفية تدريجيًا.
class QuranFontsService {
  QuranFontsService._();

  static const int _totalPages = 604;

  /// الصفحات المحمّلة في هذا التشغيل (1-based).
  static final Set<int> _loadedPages = {};

  /// Futures لمنع تكرار تحميل نفس الصفحة عند الاستدعاء المتزامن.
  static final Map<int, Future<void>> _pageLoadFutures = {};

  /// Future واحد لتحميل الخلفية لمنع التكرار.
  static Future<void>? _backgroundLoadFuture;

  /// كاش مجلد الخطوط المفكوكة (يُهيّأ مرة واحدة).
  static Directory? _cacheDir;
  static bool _cacheDirInitialized = false;

  /// هل الصفحة المحددة جاهزة للعرض؟ (1-based)
  static bool isPageReady(int page) => _loadedPages.contains(page);

  /// عدد الصفحات المحمّلة حتى الآن.
  static int get loadedCount => _loadedPages.length;

  /// هل تم تحميل جميع الصفحات؟
  static bool get allLoaded => _loadedPages.length >= _totalPages;

  /// اسم عائلة الخط للصفحة المحددة (page1 .. page604).
  static String getFontFamily(int pageIndex) => 'page${pageIndex + 1}';

  /// اسم عائلة الخط الداكن للصفحة المحددة (page1d .. page604d).
  static String getDarkFontFamily(int pageIndex) => 'page${pageIndex + 1}d';

  /// اسم عائلة الخط بدون تجويد فاتح (page1n .. page604n).
  static String getNoTajweedFontFamily(int pageIndex) =>
      'page${pageIndex + 1}n';

  /// اسم عائلة الخط بدون تجويد داكن (page1nd .. page604nd).
  static String getNoTajweedDarkFontFamily(int pageIndex) =>
      'page${pageIndex + 1}nd';

  /// اسم عائلة الخط الأحمر للخلاف (page1nr .. page604nr).
  static String getRedFontFamily(int pageIndex) => 'page${pageIndex + 1}nr';

  /// مسار الـ asset المضغوط للصفحة (1-based).
  static String _assetPath(int page) {
    final padded = page.toString().padLeft(3, '0');
    return 'packages/quran_library/assets/fonts/quran_fonts_qfc4/'
        'QCF4${padded}_COLOR-Regular.ttf.gz';
  }

  // ---------------------------------------------------------------------------
  // تهيئة مجلد الكاش
  // ---------------------------------------------------------------------------

  static Future<Directory?> _ensureCacheDir() async {
    if (_cacheDirInitialized) return _cacheDir;
    _cacheDirInitialized = true;
    if (kIsWeb) return null;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dir = Directory('${appDir.path}/quran_fonts_cache');
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      _cacheDir = dir;
    } catch (e) {
      log('QuranFontsService: failed to create cache dir: $e',
          name: 'QuranFontsService');
      _cacheDir = null;
    }
    return _cacheDir;
  }

  // ---------------------------------------------------------------------------
  // التحميل الكسول: تحميل صفحات قريبة فقط
  // ---------------------------------------------------------------------------

  /// تحميل الصفحات القريبة من [centerPage] (1-based) بنصف قطر [radius].
  ///
  /// مثال: `ensurePagesLoaded(100, radius: 10)` يحمّل الصفحات 90–110.
  /// يتم تخطّي الصفحات المحمّلة مسبقًا. يُنتظر حتى انتهاء التحميل.
  static Future<void> ensurePagesLoaded(
    int centerPage, {
    int radius = 10,
  }) async {
    final cacheDir = await _ensureCacheDir();
    final start = (centerPage - radius).clamp(1, _totalPages);
    final end = (centerPage + radius).clamp(1, _totalPages);

    final futures = <Future<void>>[];
    for (int p = start; p <= end; p++) {
      if (!_loadedPages.contains(p)) {
        futures.add(_loadSinglePage(p, cacheDir));
      }
    }

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  /// تحميل بقية الصفحات في الخلفية بترتيب يبدأ من [startNearPage].
  ///
  /// تُحدّث [progress] (0.0–1.0) و[ready] عند الانتهاء الكامل.
  /// لا تُنتظر — تعمل بشكل غير متزامن.
  static Future<void> loadRemainingInBackground({
    required int startNearPage,
    required RxDouble progress,
    required RxBool ready,
  }) {
    if (allLoaded) {
      progress.value = 1.0;
      ready.value = true;
      return Future.value();
    }
    // منع التكرار
    _backgroundLoadFuture ??= _doLoadRemaining(
      startNearPage: startNearPage,
      progress: progress,
      ready: ready,
    );
    return _backgroundLoadFuture!;
  }

  static Future<void> _doLoadRemaining({
    required int startNearPage,
    required RxDouble progress,
    required RxBool ready,
  }) async {
    final cacheDir = await _ensureCacheDir();
    final loadOrder = _buildLoadOrder(startNearPage);

    for (final page in loadOrder) {
      if (_loadedPages.contains(page)) continue;
      await _loadSinglePage(page, cacheDir);
      progress.value = _loadedPages.length / _totalPages;
    }

    progress.value = 1.0;
    ready.value = true;
  }

  /// بناء ترتيب التحميل: يبدأ من [startPage] ويتوسع للخارج.
  ///
  /// مثلاً لو startPage=100: 100، 101، 99، 102، 98، 103، 97 ...
  static List<int> _buildLoadOrder(int startPage) {
    final order = <int>[];
    final start = startPage.clamp(1, _totalPages);
    order.add(start);

    for (int delta = 1; delta < _totalPages; delta++) {
      final after = start + delta;
      final before = start - delta;
      if (after <= _totalPages) order.add(after);
      if (before >= 1) order.add(before);
    }

    return order;
  }

  // ---------------------------------------------------------------------------
  // تحميل صفحة واحدة مع كل المتغيرات (4 خطوط)
  // ---------------------------------------------------------------------------

  /// تحميل صفحة واحدة (1-based) مع متغيراتها الأربعة.
  ///
  /// - `page{N}` — فاتح مع تجويد
  /// - `page{N}d` — داكن مع تجويد (CPAL: أسود→أبيض)
  /// - `page{N}n` — فاتح بدون تجويد (CPAL: كل الألوان→أسود)
  /// - `page{N}nd` — داكن بدون تجويد (CPAL: كل الألوان→أبيض)
  static Future<void> _loadSinglePage(int page, Directory? cacheDir) {
    // منع التكرار عند الاستدعاء المتزامن لنفس الصفحة
    return _pageLoadFutures.putIfAbsent(page, () async {
      try {
        Uint8List fontBytes;
        final familyName = 'page$page';

        // جرّب قراءة الكاش أولاً
        if (cacheDir != null) {
          final cachedFile = File('${cacheDir.path}/$familyName.ttf');
          if (cachedFile.existsSync()) {
            fontBytes = Uint8List.fromList(await cachedFile.readAsBytes());
          } else {
            fontBytes = await _decompressFromAsset(page);
            try {
              await cachedFile.writeAsBytes(fontBytes, flush: true);
            } catch (e) {
              log('QuranFontsService: cache write failed for page $page: $e',
                  name: 'QuranFontsService');
            }
          }
        } else {
          fontBytes = await _decompressFromAsset(page);
        }

        // 1. خط فاتح أصلي
        await loadFontFromList(fontBytes, fontFamily: familyName);

        // 2. خط داكن: CPAL أسود → أبيض
        final darkBytes = _modifyCpalBaseColor(
          Uint8List.fromList(fontBytes),
          const Color(0xFFFFFFFF),
        );
        await loadFontFromList(darkBytes, fontFamily: '${familyName}d');

        // 3. بدون تجويد فاتح: كل الألوان → أسود
        final ntBytes = _modifyCpalAllColors(
          Uint8List.fromList(fontBytes),
          const Color(0xFF000000),
        );
        await loadFontFromList(ntBytes, fontFamily: '${familyName}n');

        // 4. بدون تجويد داكن: كل الألوان → أبيض
        final ntdBytes = _modifyCpalAllColors(
          Uint8List.fromList(fontBytes),
          const Color(0xFFFFFFFF),
        );
        await loadFontFromList(ntdBytes, fontFamily: '${familyName}nd');

        // 5. أحمر للخلاف (القراءات العشر): كل الألوان → أحمر
        final nrBytes = _modifyCpalAllColors(
          Uint8List.fromList(fontBytes),
          const Color(0xFFFF0000),
        );
        await loadFontFromList(nrBytes, fontFamily: '${familyName}nr');

        _loadedPages.add(page);
      } catch (e, st) {
        log('QuranFontsService: failed to load font page $page: $e',
            name: 'QuranFontsService', stackTrace: st);
      }
    });
  }

  /// فك ضغط ملف `.ttf.gz` من الـ assets.
  static Future<Uint8List> _decompressFromAsset(int page) async {
    final data = await rootBundle.load(_assetPath(page));
    final gzBytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final decompressed = const GZipDecoder().decodeBytes(gzBytes);
    return Uint8List.fromList(decompressed);
  }

  // ---------------------------------------------------------------------------
  // تعديل جدول CPAL في ملف TTF/OTF
  // ---------------------------------------------------------------------------

  /// يبحث عن جدول `CPAL` في بيانات الخط ويستبدل اللون الأسود الأساسي
  /// (الطبقة الأساسية لنص القرآن) بـ [newBaseColor].
  ///
  /// ألوان التجويد (أحمر، أخضر، أزرق، إلخ) تبقى كما هي تماماً.
  /// إذا لم يُعثر على جدول CPAL، تُرجع البيانات بدون تعديل.
  static Uint8List _modifyCpalBaseColor(
      Uint8List fontBytes, Color newBaseColor) {
    final bd = ByteData.view(
        fontBytes.buffer, fontBytes.offsetInBytes, fontBytes.lengthInBytes);

    if (fontBytes.length < 12) return fontBytes;
    final numTables = bd.getUint16(4);

    int? cpalOffset;
    int? cpalLength;
    const cpalTag = 0x4350414C; // 'CPAL' in ASCII
    for (int t = 0; t < numTables; t++) {
      final recordOffset = 12 + t * 16;
      if (recordOffset + 16 > fontBytes.length) break;
      final tag = bd.getUint32(recordOffset);
      if (tag == cpalTag) {
        cpalOffset = bd.getUint32(recordOffset + 8);
        cpalLength = bd.getUint32(recordOffset + 12);
        break;
      }
    }

    if (cpalOffset == null || cpalLength == null) return fontBytes;
    if (cpalOffset + cpalLength > fontBytes.length) return fontBytes;

    if (cpalOffset + 12 > fontBytes.length) return fontBytes;
    final numColorRecords = bd.getUint16(cpalOffset + 6);
    final colorRecordsArrayOffset = bd.getUint32(cpalOffset + 8);

    final absColorRecordsOffset = cpalOffset + colorRecordsArrayOffset;

    final newR = (newBaseColor.r * 255).round();
    final newG = (newBaseColor.g * 255).round();
    final newB = (newBaseColor.b * 255).round();
    final newA = (newBaseColor.a * 255).round();

    for (int c = 0; c < numColorRecords; c++) {
      final colorOffset = absColorRecordsOffset + c * 4;
      if (colorOffset + 4 > fontBytes.length) break;

      final b = fontBytes[colorOffset];
      final g = fontBytes[colorOffset + 1];
      final r = fontBytes[colorOffset + 2];
      final a = fontBytes[colorOffset + 3];

      // اكتشاف اللون الأسود: RGB ≤ 30 و Alpha ≥ 200
      if (r <= 30 && g <= 30 && b <= 30 && a >= 200) {
        fontBytes[colorOffset] = newB;
        fontBytes[colorOffset + 1] = newG;
        fontBytes[colorOffset + 2] = newR;
        fontBytes[colorOffset + 3] = newA;
      }
    }

    return fontBytes;
  }

  /// يستبدل **جميع** ألوان CPAL بلون واحد موحّد.
  ///
  /// يُستخدم لإنشاء نسخة "بدون تجويد" حيث يُرسم كل شيء بلون واحد.
  static Uint8List _modifyCpalAllColors(Uint8List fontBytes, Color color) {
    final bd = ByteData.view(
        fontBytes.buffer, fontBytes.offsetInBytes, fontBytes.lengthInBytes);

    if (fontBytes.length < 12) return fontBytes;
    final numTables = bd.getUint16(4);

    int? cpalOffset;
    int? cpalLength;
    const cpalTag = 0x4350414C;
    for (int t = 0; t < numTables; t++) {
      final recordOffset = 12 + t * 16;
      if (recordOffset + 16 > fontBytes.length) break;
      final tag = bd.getUint32(recordOffset);
      if (tag == cpalTag) {
        cpalOffset = bd.getUint32(recordOffset + 8);
        cpalLength = bd.getUint32(recordOffset + 12);
        break;
      }
    }

    if (cpalOffset == null || cpalLength == null) return fontBytes;
    if (cpalOffset + cpalLength > fontBytes.length) return fontBytes;
    if (cpalOffset + 12 > fontBytes.length) return fontBytes;

    final numColorRecords = bd.getUint16(cpalOffset + 6);
    final colorRecordsArrayOffset = bd.getUint32(cpalOffset + 8);
    final absColorRecordsOffset = cpalOffset + colorRecordsArrayOffset;

    final newR = (color.r * 255).round();
    final newG = (color.g * 255).round();
    final newB = (color.b * 255).round();
    final newA = (color.a * 255).round();

    for (int c = 0; c < numColorRecords; c++) {
      final colorOffset = absColorRecordsOffset + c * 4;
      if (colorOffset + 4 > fontBytes.length) break;
      fontBytes[colorOffset] = newB;
      fontBytes[colorOffset + 1] = newG;
      fontBytes[colorOffset + 2] = newR;
      fontBytes[colorOffset + 3] = newA;
    }

    return fontBytes;
  }

  /// حذف كاش الخطوط من القرص.
  static Future<void> clearCache() async {
    if (kIsWeb) return;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${appDir.path}/quran_fonts_cache');
      if (cacheDir.existsSync()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {
      log('QuranFontsService: clearCache failed: $e',
          name: 'QuranFontsService');
    }
    _loadedPages.clear();
    _pageLoadFutures.clear();
    _backgroundLoadFuture = null;
    _cacheDir = null;
    _cacheDirInitialized = false;
  }
}
