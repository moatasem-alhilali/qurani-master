part of '../audio.dart';

class AudioCtrl extends GetxController {
  // AudioCtrl._();
  static AudioCtrl get instance => Get.isRegistered<AudioCtrl>()
      ? Get.find<AudioCtrl>()
      : Get.put<AudioCtrl>(AudioCtrl(), permanent: true);

  SurahState state = SurahState();

  @override
  Future<void> onInit() async {
    super.onInit();
    loadReaderIndex();
    await initializeSurahDownloadStatus();
    // تأكد من مزامنة حالة آيات السور مع الملفات الفعلية عند التشغيل/Hot reload
    // await _updateDownloadedAyahsMap();
    // التحقق من عدم وجود مشغل صوت نشط آخر / Check if no other audio service is active
    if (SurahState.isAudioServiceActive) {
      log('Audio service already active, skipping initialization',
          name: 'AudioCtrl');
      return;
    }
    QuranCtrl.instance;
    if (!kIsWeb) {
      state._dir ??= await getApplicationDocumentsDirectory();
    }
    // loadLastSurahAndPosition();
    await Future.wait([
      _addDownloadedSurahToPlaylist(),
      _updateDownloadedAyahsMap(),
    ]);
    getAyahUQNumber(QuranCtrl.instance.state.currentPageNumber.value - 1);

    ever(QuranCtrl.instance.state.currentPageNumber, (pageNumber) {
      getAyahUQNumber(pageNumber - 1);
    });

    state.surahsPlayList = List.generate(114, (i) {
      state.selectedSurahIndex.value = i;
      return AudioSource.uri(
        Uri.parse(urlSurahFilePath),
      );
    });
    state.selectedSurahIndex.value = 0;

    // ابدأ كل جلسة باعتبار الخدمة غير مهيّأة، ولا تستخدم تخزينًا دائمًا
    state.audioServiceInitialized.value = false;
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid || Platform.isMacOS)) {
      if (!state.audioServiceInitialized.value) {
        if (!QuranCtrl.instance.state.isQuranLoaded) {
          await QuranCtrl.instance.loadQuranDataV1().then((_) async {
            await initAudioService();
            await setCachedArtUri();
            await lastAudioSource();
          });
        } else {
          await initAudioService();
          await setCachedArtUri();
          await lastAudioSource();
        }
      } else {
        await QuranCtrl.instance.loadQuranDataV1();
        log("Audio service already initialized",
            name: 'surah_audio_controller');
        // ضمن حالة التهيئة المسبقة، احرص على مزامنة صورة الغلاف وMediaItem
        await setCachedArtUri();
        await lastAudioSource();
      }
    }
    // Future.delayed(const Duration(milliseconds: 700))
    //     .then((_) => jumpToSurah(state.currentAudioListSurahNum.value - 1));

    // لا ننشئ مستمعًا عامًا دائمًا هنا.
    // سيتم تفعيل/إلغاء مستمع وضع السور عبر دوال مخصصة حسب الحاجة.

    // تسجيل الخدمة كنشطة / Register service as active
    SurahState.setAudioServiceActive(true);
  }

  @override
  void onClose() {
    super.onClose();
    // إيقاف جميع المشغلات والاشتراكات / Stop all players and subscriptions
    state.cancelAllSubscriptions();
    state.audioPlayer.pause();
    state.audioPlayer.dispose();

    // إلغاء تسجيل الخدمة / Unregister service
    SurahState.setAudioServiceActive(false);
    state.audioServiceInitialized.value = false;
  }

  /// -------- [Methods] ----------

  /// تفعيل مستمع وضع السور: عند اكتمال السورة انتقل تلقائيًا للسورة التالية
  void enableSurahAutoNextListener() {
    // ألغِ أي مستمع سابق مشغّل على نفس الاشتراك المركزي
    state._playerStateSubscription?.cancel();
    state._playerStateSubscription =
        state.audioPlayer.playerStateStream.listen((playerState) async {
      // فحص الحالة فقط عند الاكتمال - تقليل الاستدعاءات
      if (playerState.processingState != ProcessingState.completed) return;
      if (!state.isPlayingSurahsMode) return;
      if (state.surahAutoNextInProgress) return;

      state.surahAutoNextInProgress = true;
      final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
      final last = state.lastTime ?? 0.0;
      // زيادة النافذة الزمنية لمنع التفعيل المزدوج - من 0.3 إلى 1 ثانية
      if ((now - last) < 1.0) {
        state.surahAutoNextInProgress = false;
        return;
      }
      state.lastTime = now;
      try {
        // أوقف أي تحميل/تشغيل قائم قبل إعداد السورة التالية لتفادي Loading interrupted
        await state.audioPlayer.stop();
        await playNextSurah();
      } catch (e, s) {
        log('Auto-next failed: $e', name: 'AudioCtrl', stackTrace: s);
      } finally {
        state.surahAutoNextInProgress = false;
      }
    });
  }

  /// تعطيل مستمع وضع السور
  void disableSurahAutoNextListener() {
    state._playerStateSubscription?.cancel();
    state._playerStateSubscription = null;
  }

  Future<void> initAudioService() async {
    try {
      await AudioService.init(
        builder: () => AudioHandler.instance,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.alheekmah.quranPackage.audio',
          androidNotificationChannelName: 'Audio playback',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
        ),
      );
      state.audioServiceInitialized.value = true;
    } on PlatformException catch (e, s) {
      // منع تعطل تطبيق المستهلك وإظهار إرشاد واضح للمطور
      log(
        'تعذّرت تهيئة AudioService. تأكد أن MainActivity يرث AudioServiceActivity.\n'
        'Kotlin: class MainActivity: AudioServiceActivity()\n'
        'Java: public class MainActivity extends AudioServiceActivity {}\n'
        'الرسالة الأصلية: ${e.message}',
        name: 'AudioCtrl',
        error: e,
        stackTrace: s,
      );
      if (Get.context != null) {
        // تنبيه ودّي للمستخدم النهائي بدون تفاصيل تقنية
        ToastUtils().showToast(
            Get.context!, 'تعذّرت تهيئة خدمة الصوت. ستعمل دون تحكم بالنظام.');
      }
      // علّم الحالة ليتصرّف المشغّل دون تكامل النظام
      state.audioServiceInitialized.value = false;
      SurahState.setAudioServiceActive(false);
    } catch (e, s) {
      log('Unexpected error initializing AudioService: $e',
          name: 'AudioCtrl', stackTrace: s);
      state.audioServiceInitialized.value = false;
      SurahState.setAudioServiceActive(false);
    }
  }

  /// -------- [DownloadingMethods] ----------

  Future<void> downloadSurah({int? surahNum}) async {
    final isConnected = InternetConnectionController.instance.isConnected;
    // إيقاف أي صوت نشط أولاً / Stop any active audio first
    await state.stopAllAudio();

    // تفعيل حفظ موضع السورة عند بدء التشغيل
    enableSurahPositionSaving();

    if (surahNum != null) {
      state.selectedSurahIndex.value = (surahNum - 1);
    }
    // على الويب: لا تنزيلات محلية، شغّل مباشرةً من الرابط
    if (kIsWeb) {
      state.isPlaying.value = true;
      await state.audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(urlSurahFilePath), tag: mediaItem),
      );
      state.audioPlayer.play();
      return;
    }
    String filePath = localSurahFilePath;
    File file = File(filePath);
    log("File Path: $filePath", name: 'AudioCtrl');
    if (await file.exists()) {
      state.isPlaying.value = true;
      log("File exists. Playing...", name: 'AudioCtrl');

      await state.audioPlayer.setAudioSource(AudioSource.file(
        filePath,
        tag: mediaItem,
      ));
      state.audioPlayer.play();
    } else {
      if (!isConnected) {
        if (Get.context != null) {
          ToastUtils().showToast(Get.context!, 'لا يوجد اتصال بالإنترنت');
        }
      } else {
        state.isPlaying.value = true;
        log("File doesn't exist. Downloading...", name: 'AudioCtrl');
        log("state.sorahReaderNameValue: ${state.surahReaderNamePath}",
            name: 'AudioCtrl');
        log("Downloading from URL: $urlSurahFilePath", name: 'AudioCtrl');
        if (await _downloadFile(filePath, urlSurahFilePath)) {
          _addFileAudioSourceToPlayList(filePath);
          onDownloadSuccess(state.currentAudioListSurahNum.value);
          log("File successfully downloaded and saved to $filePath",
              name: 'AudioCtrl');
          await state.audioPlayer
              .setAudioSource(AudioSource.file(
                filePath,
                tag: mediaItem,
              ))
              .then((_) => state.audioPlayer.play());
        }
      }
    }
    // إزالة إنشاء listener جديد هنا لتجنب التداخل / Remove creating new listener here to avoid conflicts
  }

  Future<String> _downloadFileIfNotExist(String url, String fileName,
      {BuildContext? context,
      bool showSnakbars = true,
      bool setDownloadingStatus = true,
      int? ayahUqNumber}) async {
    final isConnected = InternetConnectionController.instance.isConnected;
    final isPhoneData = InternetConnectionController.instance.isPhoneData;
    String path = join((await state.dir).path, fileName);
    var file = File(path);
    bool exists = await file.exists();

    if (!exists) {
      if (setDownloadingStatus && state.isDownloading.isFalse) {
        state.isDownloading.value = true;
      }

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        log('Error creating directory: $e', name: 'AudioCtrl');
      }

      if (context!.mounted) {
        if (showSnakbars && !state.snackBarShownForBatch) {
          if (!isConnected) {
            ToastUtils().showToast(context, 'لا يوجد اتصال بالإنترنت');
          } else if (isPhoneData) {
            state.snackBarShownForBatch = true; // Set the flag to true
            ToastUtils()
                .showToast(context, 'تنبيه: أنت تستخدم بيانات الجوال للتحميل');
          }
        }
      }

      // Proceed with the download
      if (isConnected) {
        try {
          await _downloadFile(path, url,
              ayahUqNumber: ayahUqNumber,
              updateGlobalDownloading: setDownloadingStatus);
          // if (await _downloadFile(path, url)) return path;
        } catch (e) {
          log('Error downloading file: $e', name: 'AudioCtrl');
        }
      } else {
        if (context.mounted) {
          ToastUtils().showToast(context, 'لا يوجد اتصال بالإنترنت');
        }
      }
    }

    if (setDownloadingStatus && state.isDownloading.isTrue) {
      state.isDownloading.value = false;
    }

    // update(['audio_seekBar_id']);
    return path;
  }

  Future<bool> _downloadFile(String path, String url,
      {int? ayahUqNumber, bool updateGlobalDownloading = true}) async {
    Dio dio = Dio();
    state.cancelToken = CancelToken();

    try {
      // Get file size before downloading
      Response response = await dio.head(url);
      int? contentLength =
          response.headers.value(HttpHeaders.contentLengthHeader) != null
              ? int.tryParse(
                  response.headers.value(HttpHeaders.contentLengthHeader)!)
              : null;

      if (contentLength != null) {
        state.fileSize.value = contentLength;
        log('File size: $contentLength bytes');
      } else {
        log('Could not determine file size.');
      }

      await Directory(dirname(path)).create(recursive: true);
      if (updateGlobalDownloading) {
        state.isDownloading.value = true;
      }
      state.progressString.value = "0";
      state.progress.value = 0;
      update(['surahDownloadManager_id']);

      await dio.download(url, path, onReceiveProgress: (rec, total) {
        state.progressString.value = ((rec / total) * 100).toStringAsFixed(0);
        state.progress.value = (rec / total).toDouble();
        state.downloadProgress.value = rec;
        update(['surahDownloadManager_id']);
      }, cancelToken: state.cancelToken);

      if (updateGlobalDownloading) {
        state.isDownloading.value = false;
      }
      state.progressString.value = "100";
      log("Download completed for $path", name: 'AudioCtrl');
      if (ayahUqNumber != null) {
        state.ayahsDownloadStatus[ayahUqNumber] = true;
        // تحديث واجهة مدير تنزيل الآيات لعرض التقدم
        update(['ayahDownloadManager']);
      }
      return true;
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        log('Download canceled', name: 'AudioCtrl');
        // Delete partially downloaded file
        try {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
            if (updateGlobalDownloading) {
              state.isDownloading.value = false;
            }
            log('Partially downloaded file deleted', name: 'AudioCtrl');
          }
        } catch (e) {
          log('Error deleting partially downloaded file: $e',
              name: 'AudioCtrl');
        }
        return false;
      } else {
        log('$e', name: 'AudioCtrl');
      }
      if (updateGlobalDownloading) {
        state.isDownloading.value = false;
      }
      state.progressString.value = "0";
      update(['surahDownloadManager_id']);
      return false;
    }
  }

  Future<void> initializeSurahDownloadStatus() async {
    Map<String, bool> initialStatus = await checkAllSurahsDownloaded();
    state.surahDownloadStatus.value = initialStatus;
  }

  void updateDownloadStatus(int surahNumber, bool downloaded) {
    String key = '${state.surahReaderIndex.value}_$surahNumber';
    final newStatus = Map<String, bool>.from(state.surahDownloadStatus.value);
    newStatus[key] = downloaded;
    state.surahDownloadStatus.value = newStatus;
  }

  void onDownloadSuccess(int surahNumber) {
    updateDownloadStatus(surahNumber, true);
  }

  Future<Map<String, bool>> checkAllSurahsDownloaded() async {
    Map<String, bool> surahDownloadStatus = {};
    int currentReaderIndex = state.surahReaderIndex.value;

    if (kIsWeb) {
      // على الويب لا ندير ملفات محلية؛ اعتبر جميع السور غير مُحمّلة محليًا
      for (int i = 1; i <= 114; i++) {
        String key = '${currentReaderIndex}_$i';
        surahDownloadStatus[key] = false;
      }
      return surahDownloadStatus;
    }
    final directory = await state.dir;

    for (int i = 1; i <= 114; i++) {
      String filePath =
          '${directory.path}/${state.surahReaderNamePath}${i.toString().padLeft(3, '0')}.mp3';
      File file = File(filePath);
      String key = '${currentReaderIndex}_$i';
      surahDownloadStatus[key] = await file.exists();
    }
    return surahDownloadStatus;
  }

  void cancelDownload() {
    state.isPlaying.value = false;
    // علّم التحميل كمتوقف فورًا لتنعكس الحالة في الواجهة
    state.isDownloading.value = false;
    // إعادة ضبط مؤشر السورة الجاري تحميل آياتها
    state.currentDownloadingAyahSurahNumber.value = -1;
    try {
      if (!(state.cancelToken.isCancelled)) {
        state.cancelToken.cancel('Request cancelled');
      }
    } catch (_) {}
    // جهّز CancelToken جديدًا لعمليات التحميل القادمة
    state.cancelToken = CancelToken();
  }

  Future<void> startDownloadOrPlayExistsSurah({int? surahNumber}) async {
    await state.stopAllAudio();
    await downloadSurah(surahNum: surahNumber);
  }

  Future<void> _addDownloadedSurahToPlaylist() async {
    if (kIsWeb) {
      // على الويب: قائمة التحميلات المحلية غير مدعومة
      return;
    }
    final directory = await state.dir;
    for (int i = 1; i <= 114; i++) {
      String filePath =
          '${directory.path}/${state.surahReaderNamePath}${i.toString().padLeft(3, '0')}.mp3';

      File file = File(filePath);

      if (await file.exists()) {
        state.downloadSurahsPlayList.add({
          i: AudioSource.file(
            filePath,
            tag: mediaItem,
          )
        });
      }
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  /// تفعيل حفظ آخر موضع استماع للسور فقط
  void enableSurahPositionSaving() {
    // إلغاء أي اشتراك سابق لتفادي التكرار
    state._surahPositionSubscription?.cancel();

    // استخدام DateTime لتتبع آخر وقت حفظ فعلي
    DateTime? lastSaveTime;
    int? lastSavedPosition;

    state._surahPositionSubscription =
        state.audioPlayer.positionStream.listen((position) {
      // حفظ الموضع فقط في وضع السور
      if (state.isPlayingSurahsMode) {
        final positionInSeconds = position.inSeconds;
        state.lastPosition.value = positionInSeconds;
        state.seekNextSeconds.value = positionInSeconds;

        final now = DateTime.now();
        final shouldSave = lastSaveTime == null ||
            now.difference(lastSaveTime!).inSeconds >= 3 ||
            (lastSavedPosition != null &&
                (positionInSeconds - lastSavedPosition!).abs() >= 5);

        // احفظ فقط إذا مر 3 ثوان من آخر حفظ، أو تغير الموضع بشكل كبير (تنقل يدوي)
        if (shouldSave) {
          state.box.write(StorageConstants.lastPosition, positionInSeconds);
          lastSavedPosition = positionInSeconds;
          lastSaveTime = now;

          saveLastSurahListen(state.currentAudioListSurahNum.value);
        }
      }
    });
  }

  /// تعطيل حفظ موضع السورة
  void disableSurahPositionSaving() {
    state._surahPositionSubscription?.cancel();
    state._surahPositionSubscription = null;

    // حفظ الموضع والسورة الأخيرة قبل التعطيل
    if (state.isPlayingSurahsMode && state.lastPosition.value > 0) {
      state.box.write(StorageConstants.lastPosition, state.lastPosition.value);
      saveLastSurahListen(state.currentAudioListSurahNum.value);
    }
  }

  Future<void> setCachedArtUri() async {
    await resetAppIconToDefault();
    return;
  }

  Future<void> setCachedArtUriFromAsset() async {
    try {
      log('Setting cached art URI from asset', name: 'AudioCtrl');

      // ضمن نفس الحزمة يُفضّل استخدام مسار الأصل مباشرة كما هو مُعلن في pubspec.yaml
      const assetPath =
          'packages/quran_library/assets/images/quran_library_logo.png';
      // 1. تحميل الصورة من مجلد assets
      final byteData = await rootBundle.load(assetPath);

      // 2. إنشاء مسار مؤقت (احرص أن يكون الاسم فريدًا عشان ما يطغى على ملفات أخرى)
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${assetPath.split('/').last}');

      // 3. كتابة البيانات في الملف المؤقت
      await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

      // 4. إرجاع URI صالح للاستخدام في MediaItem

      state.cachedArtUri = Uri.file(file.path);
      log('Cached art URI set from asset successfully', name: 'AudioCtrl');
      // أعِد بث MediaItem الحالي ليتم تحديث صورة الغلاف فورًا
      await _refreshCurrentMediaItemArt();
    } catch (e) {
      log('Exception in setCachedArtUri: $e', name: 'AudioCtrl');
    }
  }

  Future<void> pausePlayer() async {
    state.isPlaying.value = false;
    await state.audioPlayer.pause();
    // إيقاف جميع الاشتراكات عند الإيقاف / Cancel all subscriptions when pausing
    state.cancelAllSubscriptions();
    // تعطيل حفظ موضع السورة عند الإيقاف
    disableSurahPositionSaving();
  }

  /// التحقق من الصلاحيات الصوتية / Check audio permissions
  Future<bool> requestAudioFocus() async {
    try {
      // التأكد من عدم وجود مشغل صوت آخر نشط
      // Make sure no other audio player is active
      if (SurahState.isAudioServiceActive &&
          !identical(this, AudioCtrl.instance)) {
        log('Another audio service is already active', name: 'AudioCtrl');
        return false;
      }
      return true;
    } catch (e) {
      log('Error requesting audio focus: $e', name: 'AudioCtrl');
      return false;
    }
  }

  /// التحقق من إمكانية التشغيل / Check if playback is allowed
  Future<bool> canPlayAudio() async {
    final hasAudioFocus = await requestAudioFocus();
    if (!hasAudioFocus) {
      if (Get.context != null) {
        ToastUtils().showToast(
            Get.context!, 'يتم تشغيل صوت آخر في التطبيق. يرجى إيقافه أولاً.');
      }
      return false;
    }
    return true;
  }

  /// تحديث رابط أيقونة التطبيق / Update app icon URL
  /// [iconUrl] - الرابط الجديد لأيقونة التطبيق / New URL for app icon
  Future<void> updateAppIconUrl(String iconUrl) async {
    log('Updating app icon URL to: $iconUrl', name: 'AudioCtrl');

    // تحديث الرابط / Update the URL
    state.appIconUrl.value = iconUrl;

    // تحديث الأيقونة المخزنة مؤقتاً / Update cached icon
    await setCachedArtUri();
  }

  /// الحصول على رابط أيقونة التطبيق الحالي / Get current app icon URL
  String get currentAppIconUrl => state.appIconUrl.value;

  /// إعادة تعيين أيقونة التطبيق للرابط الافتراضي / Reset app icon to default URL
  Future<void> resetAppIconToDefault() async {
    await setCachedArtUriFromAsset();
  }

  void didChangeAppLifecycleState(AppLifecycleState states) {
    if (states == AppLifecycleState.paused) {
      state.audioPlayer.stop();
      state.isPlaying.value = false;
    }
  }

  /// إعادة بث MediaItem الحالي ليعكس artUri المحدث
  Future<void> _refreshCurrentMediaItemArt() async {
    if (!state.audioServiceInitialized.value) return;
    try {
      final updated = mediaItem; // سيحمل artUri الحالي
      AudioHandler.instance.mediaItem.add(updated);
    } catch (e, s) {
      log('Failed to refresh MediaItem art: $e',
          name: 'AudioCtrl', stackTrace: s);
    }
  }

  void getAyahUQNumber(int pageNumber) {
    final ayahs =
        QuranCtrl.instance.getCurrentPageAyahsSeparatedForBasmalah(pageNumber);
    log('Fetching AyahUQNumber for page $pageNumber', name: 'AudioCtrl');
    if (ayahs.isNotEmpty) {
      state.currentAyahUniqueNumber.value = ayahs.first.first.ayahUQNumber;
      log('Updated currentAyahUniqueNumber to ${state.currentAyahUniqueNumber.value} for page $pageNumber',
          name: 'AudioCtrl');
    }
  }
}
