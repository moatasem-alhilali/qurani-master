import 'dart:io' as io show Directory, File;

import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
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

  const kindsKey = 'word_info_downloaded_kinds';
  const tajweedKey = 'tajweed_test_flag';

  late io.Directory docs;

  setUpAll(() async {
    docs = await io.Directory.systemTemp.createTemp('quran_lib_flags_docs_');
    PathProviderPlatform.instance = _FakePathProvider(docs.path);
    await GetStorage.init();
  });

  setUp(() {
    WordInfoRepository.debugResetVerificationState();
    SuraJsonFilesService.debugResetVerificationState();
    GetStorage().write(kindsKey, <String>['recitations']);
    GetStorage().write(tajweedKey, true);
  });

  tearDown(() async {
    final qeraatDir = io.Directory('${docs.path}/word_qeraat');
    if (qeraatDir.existsSync()) {
      await qeraatDir.delete(recursive: true);
    }
    final tajweedDir = io.Directory('${docs.path}/tajweed_test_dir');
    if (tajweedDir.existsSync()) {
      await tajweedDir.delete(recursive: true);
    }
    GetStorage().remove(kindsKey);
    GetStorage().remove(tajweedKey);
  });

  group('WordInfoRepository.isKindDownloaded', () {
    test('العلم مع ملفات موجودة → مفعّل ويبقى العلم', () async {
      // الترتيب مهم: تجهيز الملفات قبل الإنشاء كي يلتقطها الفحص الخلفي.
      final dir = io.Directory('${docs.path}/word_qeraat')..createSync();
      io.File('${dir.path}/sura_001.json').writeAsStringSync('[]');

      final repo = WordInfoRepository();
      await pumpEventQueue();

      expect(repo.isKindDownloaded(WordInfoKind.recitations), isTrue);
      expect(
        (GetStorage().read(kindsKey) as List).contains('recitations'),
        isTrue,
      );
    });

    test('العلم مع مجلد محذوف → معطّل ويُمسح العلم (يتيح إعادة التنزيل)',
        () async {
      final repo = WordInfoRepository();
      await pumpEventQueue();

      expect(repo.isKindDownloaded(WordInfoKind.recitations), isFalse);
      expect(GetStorage().read(kindsKey) as List, isEmpty);
    });

    test('العلم مع مجلد فارغ → معطّل (استخراج غير مكتمل)', () async {
      io.Directory('${docs.path}/word_qeraat').createSync();

      final repo = WordInfoRepository();
      await pumpEventQueue();

      expect(repo.isKindDownloaded(WordInfoKind.recitations), isFalse);
    });
  });

  group('SuraJsonFilesService.isEnabled (تجويد الآية)', () {
    SuraJsonFilesService buildService() => SuraJsonFilesService(
          storageKey: tajweedKey,
          zipName: 'tajweed_test.zip',
          dirName: 'tajweed_test_dir',
          zipUrls: const <String>['http://127.0.0.1:1/never.zip'],
          webBaseUrl: 'https://example.invalid',
        );

    test('العلم مع ملفات موجودة → مفعّل', () async {
      final dir = io.Directory('${docs.path}/tajweed_test_dir')..createSync();
      io.File('${dir.path}/sura_001.json').writeAsStringSync('[]');

      final service = buildService();
      await pumpEventQueue();

      expect(service.isEnabled(), isTrue);
      expect(GetStorage().read(tajweedKey), isTrue);
    });

    test('العلم مع مجلد محذوف → معطّل ويُكتب false في العلم', () async {
      final service = buildService();
      await pumpEventQueue();

      expect(service.isEnabled(), isFalse);
      expect(GetStorage().read(tajweedKey), isFalse);
    });
  });
}
