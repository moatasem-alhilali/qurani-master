import 'dart:io' as io show Directory, File;

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:quran_library/quran.dart';

class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.docsPath);

  final String docsPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => docsPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late io.Directory docs;

  setUp(() async {
    docs = await io.Directory.systemTemp.createTemp('quran_lib_fonts_docs_');
    PathProviderPlatform.instance = _FakePathProvider(docs.path);
    // إعادة ضبط حالة الخدمة الثابتة بين الاختبارات.
    await QuranFontsService.clearCache();
  });

  tearDown(() async {
    await QuranFontsService.clearCache();
    if (await docs.exists()) {
      await docs.delete(recursive: true);
    }
  });

  io.Directory cacheDir() => io.Directory('${docs.path}/quran_fonts_cache');

  io.File versionFile() => io.File('${cacheDir().path}/cache_version.txt');

  test('تثبيت قديم بلا ملف إصدار: يُبطَل الكاش وتُعاد الخطوط من الـ assets',
      () async {
    cacheDir().createSync(recursive: true);
    io.File('${cacheDir().path}/stale_marker.txt').writeAsStringSync('قديم');
    io.File('${cacheDir().path}/page1.ttf').writeAsBytesSync([1, 2, 3]);

    await QuranFontsService.ensurePagesLoaded(1, radius: 0);

    expect(versionFile().readAsStringSync().trim(), '2');
    expect(
      io.File('${cacheDir().path}/stale_marker.txt').existsSync(),
      isFalse,
      reason: 'الكاش القديم (قبل آلية الإصدار) يجب أن يُفرَّغ',
    );
    expect(
      io.File('${cacheDir().path}/page1.ttf').lengthSync(),
      greaterThan(10000),
      reason: 'الخط يُعاد فكه من الـ asset المحدث بعد التفريغ',
    );
  });

  test('إصدار قديم (1): يُفرَّغ الكاش ويُحدَّث إلى الإصدار الحالي', () async {
    cacheDir().createSync(recursive: true);
    versionFile().writeAsStringSync('1');
    io.File('${cacheDir().path}/page2.ttf').writeAsBytesSync([4, 5, 6]);

    await QuranFontsService.ensurePagesLoaded(1, radius: 0);

    expect(versionFile().readAsStringSync().trim(), '2');
    expect(io.File('${cacheDir().path}/page2.ttf').existsSync(), isFalse);
  });

  test('إصدار مطابق: لا يُمس الكاش القائم', () async {
    cacheDir().createSync(recursive: true);
    versionFile().writeAsStringSync('2');
    final cachedTtf = io.File('${cacheDir().path}/page1.ttf')
      ..writeAsBytesSync([1, 2, 3]);

    await QuranFontsService.ensurePagesLoaded(1, radius: 0);

    expect(cachedTtf.existsSync(), isTrue);
    expect(cachedTtf.lengthSync(), 3, reason: 'يُقرأ من الكاش دون إعادة فك');
    expect(versionFile().readAsStringSync().trim(), '2');
  });

  test('ملف إصدار فاسد: يُعامل كتثبيت قديم ويُعاد بناؤه', () async {
    cacheDir().createSync(recursive: true);
    versionFile().writeAsStringSync('ليس رقمًا');
    io.File('${cacheDir().path}/stale_marker.txt').writeAsStringSync('قديم');
    io.File('${cacheDir().path}/page1.ttf').writeAsBytesSync([1, 2, 3]);

    await QuranFontsService.ensurePagesLoaded(1, radius: 0);

    expect(versionFile().readAsStringSync().trim(), '2');
    expect(
      io.File('${cacheDir().path}/stale_marker.txt').existsSync(),
      isFalse,
    );
    expect(
      io.File('${cacheDir().path}/page1.ttf').lengthSync(),
      greaterThan(10000),
    );
  });
}
