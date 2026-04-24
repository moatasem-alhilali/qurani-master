part of '/quran.dart';

class WordInfoCtrl extends GetxController
    with GetSingleTickerProviderStateMixin {
  static WordInfoCtrl get instance =>
      GetInstance().putOrFind(() => WordInfoCtrl());

  WordInfoCtrl({WordInfoRepository? repository})
      : _repository = repository ?? WordInfoRepository();

  final WordInfoRepository _repository;

  final RxBool isPreparingDownload = false.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;
  final Rx<WordInfoKind?> downloadingKind = Rx<WordInfoKind?>(null);

  final Rx<WordInfoKind> selectedKind = WordInfoKind.recitations.obs;

  /// رقم مراجعة (revision) يتغير عند وصول/تغير بيانات القراءات في الذاكرة.
  /// يُستخدم لإبطال كاش عرض سطور QPC v4 عند اكتمال prewarm.
  int recitationsDataRevision = 0;

  final Rx<WordRef?> selectedWordRef = Rx<WordRef?>(null);

  /// تفعيل/تعطيل تحديد الكلمة وعرض الـ BottomSheet
  /// يُضبط من خلال بارامتر [QuranLibraryScreen.enableWordSelection]
  bool isWordSelectionEnabled = true;
  late TabController tabController;
  VoidCallback? _tabControllerListener;
  int _lastTabIndexNotified = 0;

  bool get isTenRecitations => tabController.index == 1;

  @override
  void onInit() {
    tabController = TabController(
        initialIndex:
            GetStorage().read(_StorageConstants().isTenRecitations) ?? 0,
        length: 2,
        vsync: this);

    _lastTabIndexNotified = tabController.index;

    _tabControllerListener = () {
      // حدّث مرة واحدة لكل تغيّر فعلي بالـ index.
      final idx = tabController.index;
      if (idx == _lastTabIndexNotified) return;
      _lastTabIndexNotified = idx;
      GetStorage().write(
        _StorageConstants().isTenRecitations,
        idx,
      );
      update(['word_info_data']);
      QuranCtrl.instance.update();
    };
    tabController.addListener(_tabControllerListener!);
    super.onInit();
  }

  @override
  void onClose() {
    final listener = _tabControllerListener;
    if (listener != null) {
      tabController.removeListener(listener);
      _tabControllerListener = null;
    }
    tabController.dispose();
    WordAudioService.instance.stop();
    super.onClose();
  }

  void setSelectedKind(WordInfoKind kind) {
    selectedKind.value = kind;
    update(['word_info_kind']);
  }

  void _bumpRecitationsRevision() {
    recitationsDataRevision++;
  }

  void setSelectedWord(WordRef ref) {
    selectedWordRef.value = ref;
    update(['word_info_data']);
  }

  void clearSelectedWord() {
    if (selectedWordRef.value == null) return;
    selectedWordRef.value = null;
    update(['word_info_data']);
  }

  bool isKindAvailable(WordInfoKind kind) => _repository.isKindDownloaded(kind);

  QiraatWordInfo? getRecitationsInfoSync(WordRef ref) =>
      _repository.getRecitationWordInfoSync(ref: ref);

  Future<QiraatWordInfo?> getRecitationsInfo(WordRef ref) =>
      _repository.getWordInfo(kind: WordInfoKind.recitations, ref: ref);

  Future<QiraatWordInfo?> getWordInfo({
    required WordInfoKind kind,
    required WordRef ref,
  }) =>
      _repository.getWordInfo(kind: kind, ref: ref);

  Future<void> downloadKind(WordInfoKind kind) async {
    if (isDownloading.value) return;

    try {
      downloadingKind.value = kind;
      isPreparingDownload.value = true;
      isDownloading.value = true;
      downloadProgress.value = 0.0;
      update(['word_info_download']);

      await _repository.downloadKind(
        kind: kind,
        onProgress: (p) {
          isPreparingDownload.value = false;
          downloadProgress.value = p;
          update(['word_info_download']);
        },
      );

      if (kind == WordInfoKind.recitations) {
        _bumpRecitationsRevision();
      }

      isPreparingDownload.value = false;
      isDownloading.value = false;
      downloadingKind.value = null;
      downloadProgress.value = 100.0;
      update(['word_info_download', 'word_info_data']);
    } catch (e) {
      isPreparingDownload.value = false;
      isDownloading.value = false;
      downloadingKind.value = null;
      downloadProgress.value = 0.0;
      update(['word_info_download']);
      rethrow;
    }
  }

  Future<void> prewarmRecitationsSurah(int surahNumber) async {
    final didLoad = await _repository.prewarmRecitationsSurah(surahNumber);
    if (!didLoad) return;
    _bumpRecitationsRevision();
    update(['word_info_data']);
  }

  Future<void> prewarmRecitationsSurahs(Iterable<int> surahNumbers) async {
    final unique = surahNumbers.toSet();
    var didPrewarmAny = false;
    for (final s in unique) {
      final didLoad = await _repository.prewarmRecitationsSurah(s);
      if (didLoad) didPrewarmAny = true;
    }
    if (didPrewarmAny) {
      log('Prewarming recitations for surahs: $unique', name: 'WordInfoCtrl');
      _bumpRecitationsRevision();
      update(['word_info_data']);
    }
  }

  // ─── صوت الكلمات ───

  /// هل تمت تهيئة خدمة صوت الكلمات (OAuth2 credentials)؟
  bool get isWordAudioInitialized => WordAudioService.instance.isInitialized;

  /// تشغيل صوت كلمة واحدة.
  Future<void> playWordAudio(WordRef ref) async {
    final svc = WordAudioService.instance;

    // إذا كانت نفس الكلمة تُشغّل، أوقف
    if (svc.isPlaying.value &&
        !svc.isPlayingAyahWords.value &&
        svc.currentPlayingRef.value == ref) {
      await stopWordAudio();
      return;
    }

    await svc.playWord(ref);
    update(['word_info_audio']);
  }

  /// تشغيل كل كلمات الآية بالتسلسل.
  Future<void> playAyahWordsAudio(WordRef ref) async {
    final svc = WordAudioService.instance;

    // إذا كانت نفس الآية تُشغّل، أوقف
    if (svc.isPlaying.value &&
        svc.isPlayingAyahWords.value &&
        svc.currentPlayingRef.value?.surahNumber == ref.surahNumber &&
        svc.currentPlayingRef.value?.ayahNumber == ref.ayahNumber) {
      await stopWordAudio();
      return;
    }

    await svc.playAyahWords(
      surahNumber: ref.surahNumber,
      ayahNumber: ref.ayahNumber,
    );
    update(['word_info_audio']);
  }

  /// إيقاف صوت الكلمات.
  Future<void> stopWordAudio() async {
    await WordAudioService.instance.stop();
    update(['word_info_audio']);
  }
}
