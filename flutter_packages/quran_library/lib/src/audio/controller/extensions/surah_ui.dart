part of '../../audio.dart';

extension SurahUi on AudioCtrl {
  /// تعيين مصدر السورة الحالي بشكل آمن (يوقف المشغّل أولًا لتجنّب Loading interrupted)
  Future<void> changeAudioSource() async {
    try {
      // أوقف أي تشغيل/تحميل جارٍ قبل تبديل المصدر
      await state.audioPlayer.stop();
      if (state
          .isSurahDownloadedByNumber(state.currentAudioListSurahNum.value)
          .value) {
        await state.audioPlayer.setAudioSource(
          AudioSource.file(
            localSurahFilePath,
            tag: mediaItem,
          ),
        );
      } else {
        await state.audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(urlSurahFilePath),
            tag: mediaItem,
          ),
        );
      }
    } catch (e, s) {
      log('changeAudioSource failed: $e', name: 'SurahUi', stackTrace: s);
    }
  }

  /// اختيار سورة من القائمة مع ضبط الحالة المناسبة لوضع السور
  Future<void> selectSurahFromList(BuildContext context, int index,
      {bool autoPlay = false, SurahAudioStyle? style}) async {
    final isConnected = InternetConnectionController.instance.isConnected;
    if (isConnected || state.isSurahDownloadedByNumber(index + 1).value) {
      // التحويل إلى وضع السور وتعطيل أي مستمعات قديمة
      state.isPlayingSurahsMode = true;
      disableSurahAutoNextListener();
      state.cancelAllSubscriptions();

      // عيّن الفهرس الجديد
      state.selectedSurahIndex.value = index;

      // بدّل المصدر بأمان
      await changeAudioSource();
      update(['CollSurahName']);

      // شغّل تلقائيًا إذا طُلب ذلك
      if (autoPlay) {
        enableSurahAutoNextListener();
        enableSurahPositionSaving();
        state.isPlaying.value = true;
        await state.audioPlayer.play();
      }
    } else {
      ToastUtils().showToast(context,
          style?.noInternetConnectionText ?? 'لا يوجد اتصال بالإنترنت');
    }
  }

  Future<void> changeSurahReadersOnTap(BuildContext context, int index) async {
    // إيقاف التشغيل وإلغاء الاشتراكات أولاً
    await state.stopAllAudio();

    // تغيير القارئ وحفظ الاختيار
    state.box.write(StorageConstants.surahReaderIndex, index);
    state.surahReaderIndex.value = index;

    // إعادة تهيئة حالة التحميل للقارئ الجديد
    await initializeSurahDownloadStatus();

    // إعادة تعيين المصدر وفق القارئ الجديد بأمان
    await changeAudioSource();

    update(['change_surah_reader']);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> changeAyahReadersOnTap(BuildContext context, int index) async {
    state.box.write(StorageConstants.ayahAudioPlayerSound,
        ReadersConstants.activeAyahReaders[index].readerNamePath);
    state.box.write(StorageConstants.ayahReaderIndex, index);
    state.ayahReaderIndex.value = index;
    Navigator.of(context).pop();
    update(['change_ayah_reader']);
    await _updateDownloadedAyahsMap();
    if (context.mounted) {
      state.isPlaying.value
          ? playAyah(context, state.currentAyahUniqueNumber.value,
              playSingleAyah: state.playSingleAyahOnly)
          : null;
    }
  }

  void lastListenSurahOnTap(
      {required BuildContext context, SurahAudioStyle? style}) {
    final isConnected = InternetConnectionController.instance.isConnected;
    if (isConnected ||
        state
            .isSurahDownloadedByNumber(state.currentAudioListSurahNum.value)
            .value) {
      state.isPlayingSurahsMode = true;
      enableSurahAutoNextListener();
      enableSurahPositionSaving();
      loadLastSurahAndPosition();
      state.audioPlayer.play();
      state.isSheetOpen.value = true;
    } else {
      ToastUtils().showToast(context,
          style?.noInternetConnectionText ?? 'لا يوجد اتصال بالإنترنت');
    }
  }
}
