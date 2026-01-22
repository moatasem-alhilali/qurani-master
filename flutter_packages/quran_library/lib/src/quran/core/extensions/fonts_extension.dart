part of '/quran.dart';

/// مُعرّف جيل لتحميل الخطوط يُستخدم لإلغاء دفعات قديمة عند تغيّر الصفحة بسرعة
/// Generation token to cancel outdated preloading batches when page changes quickly
// int _fontPreloadGeneration = 0;

/// Extension to handle font-related operations for the QuranCtrl class.
extension FontsExtension on QuranCtrl {
  bool get isPhones =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia);

  QuranRecitation get _activeRecitation => currentRecitation;

  bool get _isTajweed => _activeRecitation == QuranRecitation.hafsMushafTajweed;

  bool get _requiresDownloadedFonts => _activeRecitation.requiresDownload;

  /// جذر مجلد الخطوط بعد فك الضغط (غير الويب)
  Directory _fontsRootDirForIndex(int fontIndex) {
    // 1: qcf4 (مصحف) | 2: tajweed
    if (isPhones) {
      return Directory(
          fontIndex == 2 ? '${_dir.path}/woff' : '${_dir.path}/qcf4_woff');
    }
    return Directory(
        fontIndex == 2 ? '${_dir.path}/ttf' : '${_dir.path}/qcf4_ttf');
  }

  String getFontFullPath(Directory appDir, int pageIndex) {
    if (_isTajweed) {
      // ملاحظة: ملفات التجويد داخل zip تأتي بشكل مسطح: p1.woff / p1.ttf ...
      final fontsRoot =
          Directory(isPhones ? '${appDir.path}/woff' : '${appDir.path}/ttf');
      return isPhones
          ? '${fontsRoot.path}/p${pageIndex + 1}.woff'
          : '${fontsRoot.path}/p${pageIndex + 1}.ttf';
    }

    final id = (pageIndex + 1).toString().padLeft(3, '0');
    final fontsRoot =
        _fontsRootDirForIndex(QuranRecitation.hafsMushaf.recitationIndex);
    return isPhones
        ? '${fontsRoot.path}/qcf4_woff/QCF4${id}_X-Regular.woff'
        : '${fontsRoot.path}/qcf4_ttf/QCF4${id}_X-Regular.ttf';
  }

  String getFontPath(int pageIndex) {
    if (_isTajweed) {
      return 'p${pageIndex + 1}';
    }
    return 'QCF4${((pageIndex + 1).toString().padLeft(3, '0'))}_X-Regular';
  }

  /// URL مباشر لملف الخط على الويب (GitHub Raw)
  /// ملاحظة: بعض المستودعات/الفروع قد تختلف في المسار؛ جهّز بدائل متعددة وتحقّق بالتسلسل
  String getWebFontUrl(int pageIndex) {
    final id = _isTajweed
        ? (pageIndex + 1)
        : (pageIndex + 1).toString().padLeft(3, '0');
    // التجويد غير متاح كملفات منفصلة على الويب حالياً (متوفر فقط كـ zip).
    return state.fontsSelected.value == 2
        ? 'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/tajweed_woff/p$id.woff'
        : 'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/qcf4_woff/QCF4${id}_X-Regular.woff';
  }

  /// جميع المسارات المرشّحة لتحميل الخط على الويب (WOFF أولاً ثم TTF كاحتياط)
  List<String> _webFontCandidateUrls(int pageIndex) {
    final id = _isTajweed
        ? (pageIndex + 1)
        : (pageIndex + 1).toString().padLeft(3, '0');
    if (_isTajweed) {
      return <String>[
        'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/tajweed_woff/p$id.woff'
      ];
    }
    return [
      // CDN أولوية أولى: jsDelivr (يدعم CORS بشكل صحيح ويُخدِّم من GitHub)
      'https://cdn.jsdelivr.net/gh/alheekmahlib/Islamic_database@main/quran_database/Quran%20Font/qcf4_woff/QCF4${id}_X-Regular.woff',
      'https://cdn.jsdelivr.net/gh/alheekmahlib/Islamic_database@main/quran_database/Quran%20Font/qcf4_ttf/QCF4${id}_X-Regular.ttf',
      // githack كخيار CDN احتياطي
      'https://rawcdn.githack.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/qcf4_woff/QCF4${id}_X-Regular.woff',
      'https://rawcdn.githack.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/qcf4_ttf/QCF4${id}_X-Regular.ttf',
      // raw.githubusercontent.com مع main
      'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/qcf4_woff/QCF4${id}_X-Regular.woff',
      'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/qcf4_ttf/QCF4${id}_X-Regular.ttf',
      // raw.githubusercontent.com مع refs/heads/main
      'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/refs/heads/main/quran_database/Quran%20Font/qcf4_woff/QCF4${id}_X-Regular.woff',
      'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/refs/heads/main/quran_database/Quran%20Font/qcf4_ttf/QCF4${id}_X-Regular.ttf',
      // github.com/raw كحلٍ أخير
      'https://github.com/alheekmahlib/Islamic_database/raw/refs/heads/main/quran_database/Quran%20Font/qcf4_woff/QCF4${id}_X-Regular.woff',
      'https://github.com/alheekmahlib/Islamic_database/raw/refs/heads/main/quran_database/Quran%20Font/qcf4_ttf/QCF4${id}_X-Regular.ttf',
    ];
  }

  /// يحاول تحميل الخط من عدة روابط مرشّحة حتى ينجح
  Future<ByteData> _getWebFontBytes(int pageIndex) async {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    final candidates = _webFontCandidateUrls(pageIndex);
    DioException? lastError;
    for (final url in candidates) {
      try {
        // ملاحظة: لا نمرّر رؤوسًا محظورة على الويب (مثل User-Agent/Connection) لتجنّب فشل CORS/Preflight
        final resp = await dio.get<List<int>>(
          url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: true,
            // ملاحظة: على الويب، sendTimeout غير مدعوم لطلبات GET بدون جسم، لذا نستخدم receiveTimeout فقط
            receiveTimeout: const Duration(seconds: 30),
            validateStatus: (s) => s != null && s >= 200 && s < 400,
          ),
        );
        if (resp.statusCode == 200 &&
            resp.data != null &&
            resp.data!.isNotEmpty) {
          final buffer = Uint8List.fromList(List<int>.from(resp.data!)).buffer;
          return ByteData.view(buffer);
        }
      } on DioException catch (e) {
        lastError = e;
        // جرّب المرشح التالي
        continue;
      } catch (_) {
        // أي خطأ آخر، واصل المحاولة في الرابط التالي
        continue;
      }
    }
    // إذا فشلت كل الروابط
    throw Exception(
        'Failed to fetch web font for page ${(pageIndex + 1).toString().padLeft(3, '0')}. Last error: ${lastError?.message ?? 'unknown'}');
  }

  /// إرسال طلب تحميل خط إلى Isolate
  void _sendFontLoadRequest(
      int pageIndex, bool isFontsLocal, int generation) async {
    final fontName = getFontPath(pageIndex);
    final url = getWebFontUrl(pageIndex);
    // يجب أن يكون _dir متاحًا في QuranCtrl
    final fontsDir = Directory(_dir.path);
    final fontPath = getFontFullPath(fontsDir, pageIndex);
    // final localExists = await File(fontPath).exists();
    final candidateUrls = _webFontCandidateUrls(pageIndex);
    final message = FontLoadMessage(
        pageIndex: pageIndex,
        fontPath: fontPath,
        fontName: fontName,
        url: url,
        // لا نحاول الشبكة إذا الملف موجود محليًا (للعمل أوفلاين)
        isWeb: false, // (kIsWeb || !isFontsLocal) && !localExists,
        candidateUrls: candidateUrls,
        generation: generation);
    FontLoaderIsolateManager.sendRequest(message);
  }

  /// تسجيل الخط في واجهة المستخدم
  Future<void> _registerFontInUI(int pageIndex, String fontName,
      ByteData fontBytes, int generation) async {
    try {
      final loader = FontLoader(fontName);
      loader.addFont(Future.value(fontBytes));
      await loader.load();
      state.loadedFontPages.add(pageIndex);
      log('Font registered successfully for page ${pageIndex + 1} (Gen $generation)',
          name: 'FontsLoad');

      // تجميع تحديثات الواجهة (Batch Update)
      state._needsUpdate = true;
      _scheduleUpdate();
    } catch (e) {
      log('Failed to register font for page ${pageIndex + 1} in UI: $e',
          name: 'FontsLoad');
    }
  }

  /// جدولة تحديث واحد للواجهة بعد اكتمال دورة الإطار
  void _scheduleUpdate() {
    if (!state._needsUpdate || isClosed) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (state._needsUpdate && !isClosed) {
        state._needsUpdate = false;
        update(['_pageViewBuild']);
        log('UI updated after batch font registration.', name: 'FontsLoad');
      }
    });
  }

  /// **الدالة المعدلة:** تحضير الخطوط للصفحة الحالية والصفحات المجاورة
  Future<void> prepareFonts(int pageIndex, {bool isFontsLocal = false}) async {
    log('Preparing fonts for page ${pageIndex + 1}...', name: 'FontsLoad');
    if (_requiresDownloadedFonts) {
      // تحضير كامل صفحات QPC v4 لتفادي التقطيع أثناء تقليب الصفحات.
      if (isQpcV4Enabled) {
        Future(() => ensureQpcV4AllPagesPrebuilt());
      }

      // إذا كان محمّلًا بالفعل محليًا لا نعيد الإرسال
      if (state.loadedFontPages.contains(pageIndex) || isFontsLocal) return;

      final currentGeneration = ++state._fontPreloadGeneration;
      if (!kIsWeb) {
        _sendFontLoadRequest(pageIndex, isFontsLocal, currentGeneration);
      } else {
        await loadFont(state.currentPageNumber.value - 1);
      }

      // جدولة الصفحات المجاورة بعد تأخير بسيط
      state._debounceTimer?.cancel();
      state._debounceTimer = Timer(const Duration(milliseconds: 300), () {
        final gen = ++state._fontPreloadGeneration;
        final neighbors = [-2, -1, 1, 2, 3, 4];
        final candidates = neighbors
            .map((o) => pageIndex + o)
            .where((i) => i >= 0 && i < 604)
            .toList();
        if (!kIsWeb && state._fontPreloadGeneration != gen) return;
        for (final i in candidates) {
          if (state.loadedFontPages.contains(i)) continue;
          if (kIsWeb) {
            loadFont(i);
          } else {
            _sendFontLoadRequest(i, isFontsLocal, gen);
          }
        }
      });
    }
  }

  /// يجب استدعاء هذه الدالة في onInit() لـ QuranCtrl
  Future<void> initFontLoader() async {
    await FontLoaderIsolateManager.init(
      _registerFontInUI,
      (pageIndex, error, generation) => log(
          'Font load failed for page ${pageIndex + 1} (Gen $generation) in Isolate: $error',
          name: 'FontsLoad'),
    );
  }

  /// يجب استدعاء هذه الدالة في onClose() لـ QuranCtrl
  void disposeFontLoader() {
    state._debounceTimer?.cancel();
    FontLoaderIsolateManager.dispose();
  }

  /// Loads a font from a ZIP file for the specified page index.
  ///
  /// This method asynchronously loads a font from a ZIP file based on the given
  /// [pageIndex]. The font is then available for use within the application.
  ///
  /// [pageIndex] - The index of the page for which the font should be loaded.
  ///
  /// Returns a [Future] that completes when the font has been successfully loaded.
  Future<void> loadFontFromZip([int? pageIndex]) async {
    try {
      // مسار مجلد الخطوط بعد فك الضغط
      final fontsDir = Directory(isPhones
          ? state.fontsSelected.value == 2
              ? '${_dir.path}/woff'
              : '${_dir.path}/qcf4_woff'
          : state.fontsSelected.value == 2
              ? '${_dir.path}/ttf'
              : '${_dir.path}/qcf4_ttf');

      final loadedSet = state.loadedFontPages; // في الذاكرة

      // حمّل جميع الخطوط المتاحة 001..604
      for (int i = 0; i < 604; i++) {
        try {
          // إذا كان محمّلًا في هذه الجلسة، تخطّه
          if (loadedSet.contains(i)) continue;

          final fontPath = getFontFullPath(fontsDir, i);
          final fontFile = File(fontPath);
          if (!await fontFile.exists()) {
            // قد تكون بعض الملفات غير موجودة في مجموعة معينة
            continue;
          }

          final loader = FontLoader(getFontPath(i));
          loader.addFont(_getFontLoaderBytes(fontFile));
          await loader.load();
          loadedSet.add(i);
        } catch (e) {
          // تجاهل فشل صفحة واحدة واستمر
          log('Failed to register font for page ${i + 1}: $e',
              name: 'FontsLoad');
          continue;
        }
      }

      // حفظ الصفحات التي تم تحميل خطوطها
      GetStorage()
          .write(_StorageConstants().loadedFontPages, loadedSet.toList());
    } catch (e) {
      throw Exception("Failed to load fonts from disk: $e");
    }
  }

  /// Downloads a zip file containing all fonts for the specified font index.
  ///
  /// This method asynchronously downloads a zip file that contains all the fonts
  /// associated with the given [fontIndex]. The downloaded file will be saved
  /// locally for later use.
  ///
  /// [fontIndex] - The index of the font set to be downloaded.
  ///
  /// Returns a [Future] that completes when the download is finished.
  Future<void> downloadAllFontsZipFile(int fontIndex) async {
    // على الويب لا نحتاج التنزيل، سنحمّل مباشرة عند الحاجة
    if (kIsWeb) {
      if (!state.fontsDownloadedList.contains(fontIndex)) {
        state.fontsDownloadedList.add(fontIndex);
      }
      GetStorage().write(_StorageConstants().fontsDownloadedList,
          state.fontsDownloadedList.toList());

      GetStorage().write(_StorageConstants().isDownloadedCodeV4Fonts, true);

      state.isFontDownloaded.value = true;
      state.isDownloadingFonts.value = false;
      state.isPreparingDownload.value = false;
      state.downloadingFontIndex.value = -1;
      update(['fontsDownloadingProgress']);
      return;
    }
    // if (GetStorage().read(StorageConstants().isDownloadedCodeV2Fonts) ??
    //     false || state.isDownloadingFonts.value) {
    //   return Future.value();
    // }

    try {
      state.downloadingFontIndex.value = fontIndex;
      state.isPreparingDownload.value = true;
      state.isDownloadingFonts.value = true;
      update(['fontsDownloadingProgress']);

      // قائمة بالروابط البديلة للتحميل
      final urls = isPhones
          ? fontIndex == 2
              ? [
                  'https://github.com/alheekmahlib/Islamic_database/releases/download/tajweed_fonts/woff.zip'
                ]
              : [
                  'https://github.com/alheekmahlib/Islamic_database/releases/download/fonts/qcf4_woff.zip',
                  // مرايا WOFF
                  'https://cdn.jsdelivr.net/gh/alheekmahlib/Islamic_database@main/quran_database/Quran%20Font/qcf4_woff.zip',
                  'https://rawcdn.githack.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/qcf4_woff.zip',
                  'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/qcf4_woff.zip',
                  'https://github.com/alheekmahlib/Islamic_database/raw/refs/heads/main/quran_database/Quran%20Font/qcf4_woff.zip',
                ]
          : fontIndex == 2
              ? [
                  'https://github.com/alheekmahlib/Islamic_database/releases/download/tajweed_fonts/ttf.zip'
                ]
              : [
                  'https://github.com/alheekmahlib/Islamic_database/releases/download/fonts/qcf4_ttf.zip',
                  // مرايا TTF
                  'https://cdn.jsdelivr.net/gh/alheekmahlib/Islamic_database@main/quran_database/Quran%20Font/qcf4_ttf.zip',
                  'https://rawcdn.githack.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/qcf4_ttf.zip',
                  'https://raw.githubusercontent.com/alheekmahlib/Islamic_database/main/quran_database/Quran%20Font/qcf4_ttf.zip',
                  'https://github.com/alheekmahlib/Islamic_database/raw/refs/heads/main/quran_database/Quran%20Font/qcf4_ttf.zip',
                ];

      // حدد مسار الحفظ
      final fontsDir = _fontsRootDirForIndex(fontIndex);
      if (!await fontsDir.exists()) {
        await fontsDir.create(recursive: true);
      }

      final zipFile = File(isPhones
          ? fontIndex == 2
              ? '${_dir.path}/woff.zip'
              : '${_dir.path}/qcf4_woff.zip'
          : fontIndex == 2
              ? '${_dir.path}/ttf.zip'
              : '${_dir.path}/qcf4_ttf.zip');

      // حد أدنى للحجم لمنع ملفات HTML/أخطاء CDN المقنّعة
      const int minZipSizeBytes = 1024 * 1024; // ~1MB

      final dio = Dio()
        ..options.connectTimeout = const Duration(seconds: 20)
        ..options.receiveTimeout = const Duration(minutes: 2);

      bool extractionSucceeded = false;

      for (final url in urls) {
        try {
          log('Attempting to download from: $url', name: 'FontsDownload');

          final response = await dio.get(url,
              options: Options(
                responseType: ResponseType.stream,
                followRedirects: true,
                sendTimeout: const Duration(seconds: 30),
                headers: {
                  'User-Agent': 'Flutter/Quran-Library',
                  'Accept': '*/*',
                  'Accept-Encoding': 'identity',
                },
              ));

          if (response.statusCode != 200) {
            log('Failed to connect to $url: ${response.statusCode}',
                name: 'FontsDownload');
            continue;
          }

          final contentType =
              response.headers.value(Headers.contentTypeHeader) ?? '';
          final headerLenStr =
              response.headers.value(Headers.contentLengthHeader);
          final headerLen = int.tryParse(headerLenStr ?? '0') ?? 0;

          if (contentType.startsWith('text/') || contentType.contains('html')) {
            log('Rejected $url due to suspicious content-type: $contentType',
                name: 'FontsDownload');
            continue;
          }
          if (headerLen > 0 && headerLen < minZipSizeBytes) {
            log('Rejected $url due to too small content-length: $headerLen',
                name: 'FontsDownload');
            continue;
          }

          // نزّل إلى الملف
          final sink = zipFile.openWrite();
          int downloaded = 0;
          final completer = Completer<void>();

          (response.data as ResponseBody).stream.listen(
            (chunk) {
              downloaded += chunk.length;
              sink.add(chunk);
              state.isDownloadingFonts.value = true;
              state.isPreparingDownload.value = false;
              if (headerLen > 0) {
                state.fontsDownloadProgress.value =
                    downloaded / headerLen * 100;
                update(['fontsDownloadingProgress']);
              }
            },
            onDone: () async {
              await sink.flush();
              await sink.close();
              completer.complete();
            },
            onError: (e) async {
              await sink.close();
              completer.completeError(e);
            },
            cancelOnError: true,
          );

          await completer.future;

          final size = await zipFile.length();
          log('Downloaded ZIP file size: $size bytes');
          if (size < minZipSizeBytes) {
            log('Zip too small, trying next mirror...', name: 'FontsDownload');
            try {
              await zipFile.delete();
            } catch (_) {}
            continue;
          }

          try {
            final bytes = await zipFile.readAsBytes();
            final archive = ZipDecoder().decodeBytes(bytes);
            if (archive.isEmpty) {
              throw const FormatException(
                  'Failed to extract ZIP file: Archive is empty');
            }
            for (final file in archive) {
              final filename = '${fontsDir.path}/${file.name}';
              if (file.isFile) {
                final out = File(filename);
                await out.create(recursive: true);
                await out.writeAsBytes(file.content as List<int>);
              }
            }
            extractionSucceeded = true;
            break;
          } catch (e) {
            log('Failed to extract ZIP from $url: $e', name: 'FontsDownload');
            try {
              await zipFile.delete();
            } catch (_) {}
            continue;
          }
        } catch (e) {
          log('Download error with URL, trying next: $e',
              name: 'FontsDownload');
          try {
            if (await zipFile.exists()) await zipFile.delete();
          } catch (_) {}
          continue;
        }
      }

      if (!extractionSucceeded) {
        throw Exception(
            'All mirrors failed to provide a valid ZIP or extraction failed');
      }

      // حفظ حالة التحميل
      if (!state.fontsDownloadedList.contains(fontIndex)) {
        state.fontsDownloadedList.add(fontIndex);
      }
      GetStorage().write(_StorageConstants().fontsDownloadedList,
          state.fontsDownloadedList.toList());

      final bool anyDownloaded = state.fontsDownloadedList.isNotEmpty;
      GetStorage()
          .write(_StorageConstants().isDownloadedCodeV4Fonts, anyDownloaded);
      state.isFontDownloaded.value = anyDownloaded;

      state.isDownloadingFonts.value = false;
      state.isPreparingDownload.value = false;
      state.downloadingFontIndex.value = -1;
      state.fontsDownloadProgress.value = 100.0;
      update(['fontsDownloadingProgress']);
      Get.forceAppUpdate();
      log('Fonts unzipped successfully', name: 'FontsDownload');
    } catch (e) {
      log('Failed to Download Code_v4 fonts: $e', name: 'FontsDownload');
      state.isDownloadingFonts.value = false;
      state.isPreparingDownload.value = false;
      state.downloadingFontIndex.value = -1;
      state.fontsDownloadProgress.value = 0.0;
      update(['fontsDownloadingProgress']);
      throw Exception('Download failed: $e');
    }
  }

  Future<ByteData> _getFontLoaderBytes(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return ByteData.view(bytes.buffer);
    } catch (e) {
      throw Exception("Failed to get font loader bytes: $e");
    }
  }

  /// Loads the font for the specified page index.
  ///
  /// This method asynchronously loads the font for the given [pageIndex].
  /// The font is then available for use within the application.
  ///
  /// [pageIndex] - The index of the page for which the font should be loaded.
  ///
  /// Returns a [Future] that completes when the font has been successfully loaded.
  Future<void> loadFont(int pageIndex, {bool isFontsLocal = false}) async {
    try {
      // إذا كان الخط لهذه الصفحة محملًا، لا تعِد التحميل
      // If font for this page is already loaded, skip
      if (state.loadedFontPages.contains(pageIndex)) {
        return;
      }
      final fontLoader = FontLoader(getFontPath(pageIndex));
      if (kIsWeb) {
        log('Loading font for page ${pageIndex + 1} from web...',
            name: 'FontsLoad');
        fontLoader.addFont(_getWebFontBytes(pageIndex));
      }
      await fontLoader.load();
      state.loadedFontPages.add(pageIndex);
      update();
      // حفظ القائمة لتسريع الجلسات اللاحقة
      GetStorage().write(
          _StorageConstants().loadedFontPages, state.loadedFontPages.toList());
      // على الويب بشكل خاص: أعد بناء الواجهة لتفعيل الخط فورًا دون قلب الصفحة
      if (kIsWeb && !isClosed) {
        try {
          update();
        } catch (_) {}
      }
    } catch (e) {
      throw Exception(
          "Failed to load font for page ${(pageIndex + 1).toString().padLeft(3, '0')}: $e");
    }
  }

  /// Deletes the font at the specified index.
  ///
  /// This method asynchronously deletes the font from the storage or database
  /// based on the provided [fontIndex].
  ///
  /// [fontIndex]: The index of the font to be deleted.
  ///
  /// Returns a [Future] that completes when the font has been deleted.
  Future<void> deleteFontsForIndex(int fontIndex) async {
    if (kIsWeb) return;

    try {
      final fontsDir = _fontsRootDirForIndex(fontIndex);
      if (await fontsDir.exists()) {
        await fontsDir.delete(recursive: true);
        log('Fonts directory deleted: ${fontsDir.path}', name: 'FontsDelete');
      }

      state.fontsDownloadedList.remove(fontIndex);
      GetStorage().write(_StorageConstants().fontsDownloadedList,
          state.fontsDownloadedList.toList());

      final bool anyDownloaded = state.fontsDownloadedList.isNotEmpty;
      GetStorage()
          .write(_StorageConstants().isDownloadedCodeV4Fonts, anyDownloaded);
      state.isFontDownloaded.value = anyDownloaded;

      if (state.fontsSelected.value == fontIndex) {
        state.fontsSelected.value = 0;
        GetStorage().write(_StorageConstants().fontsSelected, 0);
      }

      state.isDownloadingFonts.value = false;
      state.isPreparingDownload.value = false;
      state.downloadingFontIndex.value = -1;
      state.fontsDownloadProgress.value = 0;

      update(['fontsDownloadingProgress', 'fontsSelected']);
      Get.forceAppUpdate();
    } catch (e) {
      log('Failed to delete fonts for index $fontIndex: $e',
          name: 'FontsDelete');
    }
  }

  Future<void> deleteFonts() async {
    try {
      await deleteFontsForIndex(1);
      await deleteFontsForIndex(2);
    } catch (e) {
      log('Failed to delete fonts: $e');
    }
  }

  Future<void> deleteOldFonts() async {
    if (GetStorage().read('isDownloadedCodeV2Fonts') == true) {
      try {
        state.fontsDownloadedList.value = [];
        final fontsDir = state.fontsSelected.value == 2
            ? Directory('${_dir.path}/tajweed_fonts')
            : Directory('${_dir.path}/quran_fonts');

        // التحقق من وجود مجلد الخطوط
        if (await fontsDir.exists()) {
          // حذف جميع الملفات والمجلدات داخل مجلد الخطوط
          await fontsDir.delete(recursive: true);
          log('Fonts directory deleted successfully.');

          // تحديث حالة التخزين المحلي
          GetStorage().write('isDownloadedCodeV2Fonts', false);
          GetStorage().write(_StorageConstants().fontsSelected, 0);
          // state.fontsDownloadedList.elementAt(fontIndex);
          GetStorage().write(_StorageConstants().fontsDownloadedList,
              state.fontsDownloadedList);
          state.isFontDownloaded.value = false;
          state.fontsSelected.value = 0;
          state.fontsDownloadProgress.value = 0;
          Get.forceAppUpdate();
        } else {
          log('Fonts directory does not exist.');
        }
      } catch (e) {
        log('Failed to delete fonts: $e');
      }
    }
  }
}

/// رسالة تُرسل إلى Isolate لتحميل خط
class FontLoadMessage {
  final int pageIndex;
  final String fontPath;
  final String fontName;
  final String url;
  final bool isWeb;
  final int generation; // إضافة رقم الجيل

  FontLoadMessage({
    required this.pageIndex,
    required this.fontPath,
    required this.fontName,
    required this.url,
    required this.isWeb,
    this.candidateUrls,
    required this.generation,
  });

  final List<String>? candidateUrls; // روابط مرشّحة للتحميل الشبكي
}

/// نقطة دخول Isolate لتحميل الخطوط
void fontLoaderIsolate(SendPort sendPort) {
  // استقبال رسالة من Isolate الرئيسي
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((dynamic message) async {
    if (message is FontLoadMessage) {
      try {
        ByteData fontBytes;
        if (message.isWeb) {
          // تحميل من الويب مع تجريب عدة مرايا عند الحاجة
          final urls = (message.candidateUrls != null &&
                  message.candidateUrls!.isNotEmpty)
              ? message.candidateUrls!
              : [message.url];
          fontBytes = await _getWebFontBytesFromCandidatesIsolate(urls);
        } else {
          // تحميل من الملف المحلي أولاً، وفي حال عدم توفره جرّب الشبكي كملاذ أخير
          final fontFile = File(message.fontPath);
          if (await fontFile.exists()) {
            final bytes = await fontFile.readAsBytes();
            fontBytes = ByteData.view(Uint8List.fromList(bytes).buffer);
          } else if (message.candidateUrls != null &&
              message.candidateUrls!.isNotEmpty) {
            // fallback إلى الشبكة فقط إذا تم تزويد مرايا فعلية
            fontBytes = await _getWebFontBytesFromCandidatesIsolate(
                message.candidateUrls!);
          } else {
            throw Exception('Font file not found at: ${message.fontPath}');
          }
        }

        // إرسال البيانات مرة أخرى إلى Isolate الرئيسي
        sendPort.send({
          'pageIndex': message.pageIndex,
          'fontName': message.fontName,
          'fontBytes': fontBytes,
          'generation': message.generation, // إرجاع رقم الجيل
        });
      } catch (e) {
        // إرسال خطأ إلى Isolate الرئيسي
        sendPort.send({
          'pageIndex': message.pageIndex,
          'error': e.toString(),
          'generation': message.generation, // إرجاع رقم الجيل
        });
      }
    }
  });
}

/// دالة مساعدة لتحميل الخطوط من الويب داخل Isolate
Future<ByteData> _getWebFontBytesIsolate(String url) async {
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 15);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  final resp = await dio.get<List<int>>(
    url,
    options: Options(
      responseType: ResponseType.bytes,
      followRedirects: true,
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (s) => s != null && s >= 200 && s < 400,
    ),
  );
  if (resp.statusCode == 200 && resp.data != null && resp.data!.isNotEmpty) {
    final buffer = Uint8List.fromList(List<int>.from(resp.data!)).buffer;
    return ByteData.view(buffer);
  }
  throw Exception('Failed to fetch web font from $url');
}

/// يحاول تنزيل الخط من قائمة مرايا ويُرجع أول نجاح
Future<ByteData> _getWebFontBytesFromCandidatesIsolate(
    List<String> urls) async {
  DioException? lastError;
  for (final url in urls) {
    try {
      return await _getWebFontBytesIsolate(url);
    } on DioException catch (e) {
      lastError = e;
      continue;
    } catch (_) {
      continue;
    }
  }
  throw Exception(
      'All mirrors failed. Last error: ${lastError?.message ?? 'unknown'}');
}

// *****************************************************************************
// *                                 Isolate Manager (v6)                      *
// *****************************************************************************

/// كلاس مساعد ساكن لإدارة حالة Isolate تحميل الخطوط
class FontLoaderIsolateManager {
  static Isolate? _fontLoaderIsolate;
  static SendPort? _fontLoaderSendPort;
  static final ReceivePort _fontLoaderReceivePort = ReceivePort();
  static Completer<void>? _readyCompleter;

  /// تهيئة Isolate لتحميل الخطوط
  static Future<void> init(Function(int, String, ByteData, int) onFontLoaded,
      Function(int, String, int) onError) async {
    if (_fontLoaderIsolate != null) {
      return _readyCompleter?.future;
    }

    _readyCompleter = Completer<void>();

    _fontLoaderIsolate = await Isolate.spawn(
      fontLoaderIsolate,
      _fontLoaderReceivePort.sendPort,
      debugName: 'FontLoaderIsolate',
    );

    _fontLoaderReceivePort.listen((dynamic message) {
      if (message is SendPort) {
        _fontLoaderSendPort = message;
        if (!_readyCompleter!.isCompleted) {
          _readyCompleter!.complete();
        }
      } else if (message is Map) {
        final pageIndex = message['pageIndex'] as int;
        final fontName = message.containsKey('fontName')
            ? message['fontName'] as String
            : '';
        final fontBytes = message['fontBytes'] as ByteData?;
        final error = message['error'] as String?;
        final generation = message['generation'] as int;

        if (error != null) {
          onError(pageIndex, error, generation);
        } else if (fontBytes != null) {
          onFontLoaded(pageIndex, fontName, fontBytes, generation);
        }
      }
    });

    return _readyCompleter!.future;
  }

  /// إرسال طلب تحميل خط إلى Isolate
  static void sendRequest(FontLoadMessage message) {
    if (_fontLoaderSendPort == null) {
      log('FontLoader Isolate not ready. Request for page ${message.pageIndex + 1} dropped.',
          name: 'FontsLoad');
      return;
    }
    _fontLoaderSendPort!.send(message);
  }

  /// تنظيف Isolate
  static void dispose() {
    _fontLoaderReceivePort.close();
    _fontLoaderIsolate?.kill();
    _fontLoaderIsolate = null;
    _fontLoaderSendPort = null;
    _readyCompleter = null;
    log('FontLoader Isolate disposed.', name: 'FontsLoad');
  }
}
