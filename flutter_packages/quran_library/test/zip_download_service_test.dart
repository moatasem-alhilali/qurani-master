import 'dart:convert' show utf8;
import 'dart:io' as io show ContentType, Directory, HttpServer, InternetAddress;
import 'dart:typed_data' show Uint8List;

import 'package:archive/archive.dart' show Archive, ArchiveFile, ZipEncoder;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_library/quran.dart';
// نفس المصدر الذي تستورد منه الخدمة أنواع File/Directory (شرطي الويب/IO)،
// كي تتطابق الأنواع بين الاختبار والمعاملات في التحليل وعند التشغيل.
import 'package:quran_library/src/core/platform/io_helpers.dart'
    show Directory, File;

void main() {
  late io.Directory temp;

  setUp(() async {
    temp = await io.Directory.systemTemp.createTemp('quran_lib_zip_test_');
  });

  tearDown(() async {
    if (await temp.exists()) {
      await temp.delete(recursive: true);
    }
  });

  /// خادم محلي يقدّم [bytes] لأي طلب بنوع application/zip.
  Future<io.HttpServer> serveBytes(List<int> bytes) async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      request.response.statusCode = 200;
      request.response.headers.contentType =
          io.ContentType('application', 'zip');
      request.response.contentLength = bytes.length;
      request.response.add(bytes);
      await request.response.close();
    });
    addTearDown(() => server.close(force: true));
    return server;
  }

  test('يستخرج محتوى الأرشيف ثم يحذف ملف ZIP بعد النجاح', () async {
    const content = '[{"aya_number":1,"words":[]}]';
    final contentBytes = utf8.encode(content);
    final archive = Archive()
      ..addFile(
        ArchiveFile('sura_001.json', contentBytes.length, contentBytes),
      );
    final zipBytes = Uint8List.fromList(ZipEncoder().encode(archive));

    final server = await serveBytes(zipBytes);

    final zipFile = File('${temp.path}/word_test.zip');
    final destDir = Directory('${temp.path}/word_test');

    await ZipDownloadService.downloadAndExtract(
      urls: ['http://127.0.0.1:${server.port}/word_test.zip'],
      zipFile: zipFile,
      destinationDir: destDir,
      onProgress: (_) {},
      minZipSizeBytes: 1,
    );

    expect(
      await File('${destDir.path}/sura_001.json').readAsString(),
      content,
    );
    expect(
      await zipFile.exists(),
      isFalse,
      reason: 'يجب حذف الأرشيف بعد نجاح الاستخراج كي لا يُهدر ~9MB في '
          'Documents بجوار المحتوى المفكوك',
    );
  });

  test('يفشل بأمان مع أرشيف تالف ويحذف الملف المؤقت', () async {
    // بيانات أكبر من الحد الأدنى لكنها ليست ZIP صالحًا.
    final garbage = Uint8List.fromList(
      List<int>.generate(4096, (i) => i % 251),
    );
    final server = await serveBytes(garbage);

    final zipFile = File('${temp.path}/word_test.zip');
    final destDir = Directory('${temp.path}/word_test');

    await expectLater(
      ZipDownloadService.downloadAndExtract(
        urls: ['http://127.0.0.1:${server.port}/word_test.zip'],
        zipFile: zipFile,
        destinationDir: destDir,
        onProgress: (_) {},
        minZipSizeBytes: 1,
      ),
      throwsException,
    );

    expect(await zipFile.exists(), isFalse);
    expect(
      await File('${destDir.path}/sura_001.json').exists(),
      isFalse,
      reason: 'لم ينجح الاستخراج فلا يجب أن توجد ملفات مستخرجة',
    );
  });
}
