part of '../../audio.dart';

extension SurahCtrlExtension on AudioCtrl {
  Future<void> playPreviousSurah() async {
    state.isPlayingSurahsMode = true;
    enableSurahAutoNextListener();
    enableSurahPositionSaving();
    if (state.currentAudioListSurahNum.value > 1) {
      state.currentAudioListSurahNum.value -= 1;
      state.selectedSurahIndex.value -= 1;
      state.isPlaying.value = true;
      saveLastSurahListen(state.currentAudioListSurahNum.value);
      await updateMediaItemAndPlay();
      await changeAudioSource()
          .then((_) async => await state.audioPlayer.play());
    } else {
      await state.audioPlayer.pause();
    }
  }

  Future<void> playNextSurah() async {
    state.isPlayingSurahsMode = true;
    enableSurahAutoNextListener();
    enableSurahPositionSaving();
    if (state.currentAudioListSurahNum.value < 114) {
      state.currentAudioListSurahNum.value += 1;
      state.selectedSurahIndex.value += 1;
      state.isPlaying.value = true;
      saveLastSurahListen(state.currentAudioListSurahNum.value);
      await updateMediaItemAndPlay();
      await changeAudioSource()
          .then((_) async => await state.audioPlayer.play());
    } else {
      await state.audioPlayer.pause();
    }
  }

  Future<void> playSurah(
      {required BuildContext context,
      required int surahNumber,
      SurahAudioStyle? style}) async {
    final isConnected = InternetConnectionController.instance.isConnected;

    // إذا كانت نفس السورة محمّلة والمشغّل جاهز (إيقاف مؤقت)، استأنف فقط
    if (state.isPlayingSurahsMode &&
        state.currentAudioListSurahNum.value == surahNumber &&
        state.audioPlayer.processingState == ProcessingState.ready &&
        !state.audioPlayer.playing) {
      state.isPlaying.value = true;
      enableSurahAutoNextListener();
      enableSurahPositionSaving();
      await state.audioPlayer.play();
      return;
    }

    if (!isConnected && state.isSurahDownloadedByNumber(surahNumber).value) {
      state.isPlayingSurahsMode = true;
      state.currentAudioListSurahNum.value = surahNumber;
      await changeAudioSource();
      enableSurahAutoNextListener();
      enableSurahPositionSaving();
      state.isPlaying.value = true;
      await state.audioPlayer.play();
    } else if (!isConnected) {
      ToastUtils().showToast(context,
          style?.noInternetConnectionText ?? 'لا يوجد اتصال بالإنترنت');
    } else {
      // التحقق من إمكانية التشغيل / Check if playback is allowed
      if (!await canPlayAudio()) {
        return;
      }

      state.isPlayingSurahsMode = true;
      state.currentAudioListSurahNum.value = surahNumber;
      cancelDownload();
      // تعيين مصدر الصوت: محلي إذا محمّل، أو بث مباشر من الرابط
      await changeAudioSource();
      enableSurahAutoNextListener();
      enableSurahPositionSaving();
      state.isPlaying.value = true;
      await state.audioPlayer.play();
    }
  }

  Future<void> _addFileAudioSourceToPlayList(String filePath) async {
    state.downloadSurahsPlayList.add({
      state.currentAudioListSurahNum.value: AudioSource.file(
        filePath,
        tag: mediaItem,
      )
    });
  }
}
