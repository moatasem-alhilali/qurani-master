part of '../tafsir.dart';

class TajweedAyaCtrl extends GetxController {
  static TajweedAyaCtrl get instance =>
      GetInstance().putOrFind(() => TajweedAyaCtrl());

  TajweedAyaCtrl({TajweedAyaRepository? repository})
      : _repository = repository ?? TajweedAyaRepository();

  final TajweedAyaRepository _repository;

  final RxBool isPreparingDownload = false.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;

  bool get isAvailable => _repository.isDownloaded();

  Future<void> download() async {
    if (isDownloading.value) return;

    try {
      isPreparingDownload.value = true;
      isDownloading.value = true;
      downloadProgress.value = 0.0;
      update(['tajweed_download']);

      await _repository.download(
        onProgress: (p) {
          isPreparingDownload.value = false;
          downloadProgress.value = p;
          update(['tajweed_download']);
        },
      );

      isPreparingDownload.value = false;
      isDownloading.value = false;
      downloadProgress.value = 100.0;
      update(['tajweed_download', 'tajweed_data']);
    } catch (_) {
      isPreparingDownload.value = false;
      isDownloading.value = false;
      downloadProgress.value = 0.0;
      update(['tajweed_download']);
      rethrow;
    }
  }

  Future<TajweedAyahInfo?> getAyahInfo({
    required int surahNumber,
    required int ayahNumber,
  }) =>
      _repository.getAyahInfo(surahNumber: surahNumber, ayahNumber: ayahNumber);

  Future<void> prewarmSurah(int surahNumber) async {
    await _repository.prewarmSurah(surahNumber);
    update(['tajweed_data']);
  }
}
