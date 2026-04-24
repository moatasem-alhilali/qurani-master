import 'dart:convert' show base64Url, jsonDecode, utf8;
import 'dart:io' show Directory, File;
import 'dart:typed_data' show Uint8List;

import 'package:archive/archive.dart' show GZipDecoder;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

/// نسخة IO:
/// - تفك ضغط `.json.gz` مرة واحدة ثم تحفظ النص المفكوك على القرص
/// - في المرات القادمة: القراءة تكون من Disk Cache (ثم Memory Cache)
///
/// ملاحظة:
/// - على الويب سيتم استخدام نسخة Stub تلقائيًا.
class GzipJsonAssetService {
  const GzipJsonAssetService({
    this.enableCacheByDefault = true,
    this.enableDiskCacheByDefault = true,
    this.diskCacheNamespace = 'v1',
    this.diskCacheDirName = 'quran_library_json_cache',
    this.documentsPathProvider,
  });

  /// كاش الذاكرة (ضمن نفس تشغيل التطبيق)
  final bool enableCacheByDefault;

  /// كاش القرص (يبقى بعد إغلاق التطبيق)
  final bool enableDiskCacheByDefault;

  /// لتغيير النسخة/تفريغ الكاش تلقائيًا عند تحديث البيانات.
  /// مثال: غيّرها إلى "v2" عند تغيير محتوى الملفات.
  final String diskCacheNamespace;

  /// اسم مجلد الكاش داخل Documents.
  final String diskCacheDirName;

  /// مفيد للاختبارات: مرّر مسار ثابت (بدون الاعتماد على path_provider).
  ///
  /// إن لم يُمرر، سيُستخدم `getApplicationDocumentsDirectory().path`.
  final Future<String> Function()? documentsPathProvider;

  static final Map<String, Object?> _cache = <String, Object?>{};
  static final Map<String, Future<String>> _inflightText =
      <String, Future<String>>{};

  /// إرجاع مسار ملف الكاش للـ asset (أو null إن كان Disk Cache معطّل).
  ///
  /// هذا مفيد أيضًا للاختبارات.
  Future<String?> diskCachePathFor(String assetPath) async {
    if (!enableDiskCacheByDefault) return null;
    final file = await _diskCacheFileFor(assetPath);
    return file.path;
  }

  static String decodeGzipBytesToString(Uint8List gzBytes) {
    final decodedBytes = const GZipDecoder().decodeBytes(gzBytes);
    return utf8.decode(decodedBytes);
  }

  static dynamic decodeGzipJsonBytes(Uint8List gzBytes) {
    final text = decodeGzipBytesToString(gzBytes);
    return jsonDecode(text);
  }

  Future<dynamic> loadJsonDynamic(
    String assetPath, {
    String? fallbackPlainAssetPath,
    bool? cache,
  }) async {
    final text = await loadText(
      assetPath,
      fallbackPlainAssetPath: fallbackPlainAssetPath,
      cache: cache,
    );
    return jsonDecode(text);
  }

  Future<List<dynamic>> loadJsonList(
    String assetPath, {
    String? fallbackPlainAssetPath,
    bool? cache,
  }) async {
    final decoded = await loadJsonDynamic(
      assetPath,
      fallbackPlainAssetPath: fallbackPlainAssetPath,
      cache: cache,
    );

    if (decoded is List) return decoded;
    throw FormatException('Expected JSON List in $assetPath');
  }

  Future<Map<String, dynamic>> loadJsonMap(
    String assetPath, {
    String? fallbackPlainAssetPath,
    bool? cache,
  }) async {
    final decoded = await loadJsonDynamic(
      assetPath,
      fallbackPlainAssetPath: fallbackPlainAssetPath,
      cache: cache,
    );

    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw FormatException('Expected JSON Map in $assetPath');
  }

  Future<String> loadText(
    String assetPath, {
    String? fallbackPlainAssetPath,
    bool? cache,
  }) async {
    final useCache = cache ?? enableCacheByDefault;
    final cacheKey = '$assetPath::text';

    if (useCache) {
      final cached = _cache[cacheKey];
      if (cached is String) return cached;
    }

    // منع تكرار فك الضغط/الكتابة عند عدة استدعاءات متزامنة لنفس الملف.
    final inflight = _inflightText[cacheKey];
    if (inflight != null) return inflight;

    final future = _loadTextInternal(
      assetPath,
      fallbackPlainAssetPath: fallbackPlainAssetPath,
      useDiskCache: enableDiskCacheByDefault,
    );

    _inflightText[cacheKey] = future;

    try {
      final text = await future;
      if (useCache) _cache[cacheKey] = text;
      return text;
    } finally {
      _inflightText.remove(cacheKey);
    }
  }

  static void clearCache() => _cache.clear();

  Future<void> clearDiskCache() async {
    final dir = await _diskCacheDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  Future<String> _loadTextInternal(
    String assetPath, {
    required String? fallbackPlainAssetPath,
    required bool useDiskCache,
  }) async {
    if (useDiskCache) {
      final cached = await _tryReadFromDisk(assetPath);
      if (cached != null) return cached;
    }

    try {
      final text = await _loadAndDecodeTextFromAssets(assetPath);
      if (useDiskCache) {
        await _writeToDisk(assetPath, text);
      }
      return text;
    } catch (e) {
      if (fallbackPlainAssetPath == null) rethrow;
      if (useDiskCache) {
        final cached = await _tryReadFromDisk(assetPath);
        if (cached != null) return cached;
      }

      final text = await _loadAndDecodeTextFromAssets(fallbackPlainAssetPath);
      if (useDiskCache) {
        // نكتب تحت مفتاح assetPath الأصلي حتى لو استخدمنا fallback.
        await _writeToDisk(assetPath, text);
      }
      return text;
    }
  }

  Future<String?> _tryReadFromDisk(String assetPath) async {
    try {
      final file = await _diskCacheFileFor(assetPath);
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return null;
      return utf8.decode(bytes);
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeToDisk(String assetPath, String text) async {
    try {
      final file = await _diskCacheFileFor(assetPath);
      final dir = file.parent;
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      await file.writeAsBytes(utf8.encode(text), flush: true);
    } catch (_) {
      // تجاهل أخطاء الكتابة حتى لا نكسر التحميل الأساسي.
    }
  }

  Future<Directory> _diskCacheDir() async {
    final docsPath = documentsPathProvider != null
        ? await documentsPathProvider!()
        : (await getApplicationDocumentsDirectory()).path;
    return Directory('$docsPath/$diskCacheDirName/$diskCacheNamespace');
  }

  Future<File> _diskCacheFileFor(String assetPath) async {
    final dir = await _diskCacheDir();
    final safeName = _safeFileName(assetPath);
    // نحفظ كنص JSON (حتى لو الأصل gz)
    return File('${dir.path}/$safeName.json');
  }

  String _safeFileName(String assetPath) {
    final bytes = utf8.encode(assetPath);
    // base64Url آمن لأسماء الملفات
    return base64Url.encode(bytes);
  }

  Future<String> _loadAndDecodeTextFromAssets(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    if (assetPath.endsWith('.gz')) {
      return decodeGzipBytesToString(bytes);
    }

    return utf8.decode(bytes);
  }
}
