import 'dart:convert' show utf8, jsonDecode;
import 'dart:typed_data' show Uint8List;

import 'package:archive/archive.dart' show GZipDecoder;
import 'package:flutter/services.dart' show rootBundle;

/// نسخة Web/Stub:
/// - تفك ضغط `.json.gz` في الذاكرة
/// - تدعم Memory Cache
/// - لا تدعم Disk Cache (لا يوجد dart:io على الويب)
class GzipJsonAssetService {
  const GzipJsonAssetService({
    this.enableCacheByDefault = true,
    this.enableDiskCacheByDefault = false,
    this.diskCacheNamespace = 'v1',
    this.diskCacheDirName = 'quran_library_json_cache',
    this.documentsPathProvider,
  });

  final bool enableCacheByDefault;

  /// موجود للتوافق مع نسخة IO، لكنه غير مستخدم هنا.
  final bool enableDiskCacheByDefault;

  /// موجود للتوافق مع نسخة IO، لكنه غير مستخدم هنا.
  final String diskCacheNamespace;

  /// موجود للتوافق مع نسخة IO، لكنه غير مستخدم هنا.
  final String diskCacheDirName;

  /// موجود للتوافق مع نسخة IO، لكنه غير مستخدم هنا.
  final Future<String> Function()? documentsPathProvider;

  static final Map<String, Object?> _cache = <String, Object?>{};

  /// على الويب لا يوجد مسار قرصي.
  Future<String?> diskCachePathFor(String assetPath) async => null;

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

    try {
      final text = await _loadAndDecodeText(assetPath);
      if (useCache) _cache[cacheKey] = text;
      return text;
    } catch (e) {
      if (fallbackPlainAssetPath == null) rethrow;
      final text = await _loadAndDecodeText(fallbackPlainAssetPath);
      if (useCache) _cache[cacheKey] = text;
      return text;
    }
  }

  static void clearCache() => _cache.clear();

  Future<String> _loadAndDecodeText(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    if (assetPath.endsWith('.gz')) {
      return decodeGzipBytesToString(bytes);
    }

    return utf8.decode(bytes);
  }
}
