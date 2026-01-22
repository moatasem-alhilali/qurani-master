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

    if (!isConnected && state.isSurahDownloadedByNumber(surahNumber).value) {
      await startDownloadOrPlayExistsSurah();
    } else if (!isConnected) {
      ToastUtils().showToast(context,
          style?.noInternetConnectionText ?? 'لا يوجد اتصال بالإنترنت');
    } else {
      // التحقق من إمكانية التشغيل / Check if playback is allowed
      if (!await canPlayAudio()) {
        return;
      }

      state.isPlayingSurahsMode = true;
      enableSurahAutoNextListener();
      enableSurahPositionSaving();
      state.currentAudioListSurahNum.value = surahNumber;
      cancelDownload();
      state.isPlaying.value = true;
      state.isSurahDownloadedByNumber(surahNumber).value
          ? await startDownloadOrPlayExistsSurah()
          : await state.audioPlayer.play();
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
