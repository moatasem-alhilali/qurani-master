import 'dart:convert' show utf8;
import 'dart:io' show Directory, File;
import 'dart:typed_data' show Uint8List;

import 'package:archive/archive.dart' show GZipEncoder;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_library/src/service/gzip_json_asset_service.dart';

void main() {
  test('يفك ضغط json.gz (Map) بشكل صحيح', () {
    const jsonText = '{"a":1,"b":[true,"x"]}';
    final gzBytes = const GZipEncoder().encode(utf8.encode(jsonText));

    final decoded = GzipJsonAssetService.decodeGzipJsonBytes(
      Uint8List.fromList(gzBytes),
    );

    expect(decoded, isA<Map>());
    expect(decoded['a'], 1);
    expect(decoded['b'], isA<List>());
  });

  test('يفك ضغط json.gz (List) بشكل صحيح', () {
    const jsonText = '[{"id":1},{"id":2}]';
    final gzBytes = const GZipEncoder().encode(utf8.encode(jsonText));

    final decoded = GzipJsonAssetService.decodeGzipJsonBytes(
      Uint8List.fromList(gzBytes),
    );

    expect(decoded, isA<List>());
    expect((decoded as List).length, 2);
  });

  test('يفك ضغط bytes gzip إلى نص UTF-8', () {
    const text = 'السلام عليكم';
    final gzBytes = const GZipEncoder().encode(utf8.encode(text));

    final decodedText = GzipJsonAssetService.decodeGzipBytesToString(
      Uint8List.fromList(gzBytes),
    );

    expect(decodedText, text);
  });

  test('Disk cache: يقرأ من القرص بدون الرجوع للـ assets', () async {
    final temp = await Directory.systemTemp.createTemp('quran_lib_cache_');
    addTearDown(() async {
      if (await temp.exists()) {
        await temp.delete(recursive: true);
      }
    });

    final service = GzipJsonAssetService(
      enableCacheByDefault: false,
      enableDiskCacheByDefault: true,
      documentsPathProvider: () async => temp.path,
      diskCacheNamespace: 'test',
    );

    const assetPath =
        'packages/quran_library/assets/jsons/definitely_missing.json.gz';

    final cachePath = await service.diskCachePathFor(assetPath);
    expect(cachePath, isNotNull);

    final cacheFile = File(cachePath!);
    await cacheFile.parent.create(recursive: true);
    await cacheFile.writeAsBytes(utf8.encode('{"x": 1}'));

    final decoded = await service.loadJsonMap(assetPath);
    expect(decoded['x'], 1);
  });
}
