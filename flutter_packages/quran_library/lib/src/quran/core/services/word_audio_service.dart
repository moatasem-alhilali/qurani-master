part of '/quran.dart';

/// خدمة تشغيل صوت الكلمات (word-by-word) من CDN.
///
/// الملفات الصوتية متاحة على `https://audio.qurancdn.com/wbw/{sss}_{aaa}_{www}.mp3`
/// بدون حاجة لمصادقة.
///
/// يجب استدعاء [init] مرة واحدة قبل الاستخدام:
/// ```dart
/// QuranLibrary.initWordAudio();
/// ```
class WordAudioService {
  WordAudioService._();

  static final WordAudioService _instance = WordAudioService._();
  static WordAudioService get instance => _instance;

  static const _cdnBase = 'https://audio.qurancdn.com';

  // ─── المشغّل ───
  AudioPlayer? _player;

  /// وصول عام للمشغّل — يُستخدم للاستماع إلى currentIndexStream من الخارج.
  AudioPlayer get player => _audioPlayer;

  AudioPlayer get _audioPlayer {
    _player ??= AudioPlayer();
    return _player!;
  }

  // ─── الحالة التفاعلية ───
  final RxBool isPlaying = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<WordRef?> currentPlayingRef = Rx<WordRef?>(null);

  /// true إذا يتم تشغيل كلمات آية كاملة (وليس كلمة واحدة فقط)
  final RxBool isPlayingAyahWords = false.obs;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  StreamSubscription<PlayerState>? _playerStateSubscription;

  // ─── التهيئة ───

  /// تفعيل خدمة صوت الكلمات.
  void init() {
    _initialized = true;
  }

  // ─── بناء URL ───

  /// بناء URL لكلمة واحدة بصيغة wbw/{sss}_{aaa}_{www}.mp3
  String _buildWordUrl({
    required int surahNumber,
    required int ayahNumber,
    required int wordNumber,
  }) {
    final s = surahNumber.toString().padLeft(3, '0');
    final a = ayahNumber.toString().padLeft(3, '0');
    final w = wordNumber.toString().padLeft(3, '0');
    return '$_cdnBase/wbw/${s}_${a}_$w.mp3';
  }

  // ─── حساب عدد الكلمات ───

  /// حساب عدد الكلمات الفعلية (بدون end marker) في آية معيّنة
  /// باستخدام بيانات QPC v4 المحمّلة.
  int getAyahWordCount(int surahNumber, int ayahNumber) {
    final store = QuranCtrl.instance._qpcV4Store;
    if (store == null) return 0;

    int count = 0;
    for (final w in store.wordsById.values) {
      if (w.surah == surahNumber && w.ayah == ayahNumber) {
        count++;
      }
    }
    // آخر wordIndex هو end marker (رقم الآية)، نستبعده
    return count > 0 ? count - 1 : 0;
  }

  // ─── التشغيل ───

  /// تشغيل كلمة واحدة.
  Future<void> playWord(WordRef ref) async {
    if (!isInitialized) return;
    final isConnected = InternetConnectionController.instance.isConnected;

    if (isConnected) {
      try {
        // إيقاف أي تشغيل سابق
        await stop();

        isLoading.value = true;
        currentPlayingRef.value = ref;
        isPlayingAyahWords.value = false;

        final url = _buildWordUrl(
          surahNumber: ref.surahNumber,
          ayahNumber: ref.ayahNumber,
          wordNumber: ref.wordNumber,
        );
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));

        isLoading.value = false;
        isPlaying.value = true;

        _listenForCompletion();
        await _audioPlayer.play();
      } catch (e) {
        log('WordAudioService.playWord error: $e', name: 'WordAudioService');
        isLoading.value = false;
        isPlaying.value = false;
        currentPlayingRef.value = null;
      }
    } else {
      ToastUtils().showToast(
        Get.context!,
        'لا يوجد اتصال بالإنترنت',
      );
    }
  }

  /// تشغيل كل كلمات آية بالتسلسل.
  Future<void> playAyahWords({
    required int surahNumber,
    required int ayahNumber,
    int? totalWords,
  }) async {
    if (!isInitialized) return;

    final isConnected = InternetConnectionController.instance.isConnected;

    if (isConnected) {
      try {
        await stop();

        isLoading.value = true;
        currentPlayingRef.value = WordRef(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          wordNumber: 0, // يشير إلى كل الآية
        );
        isPlayingAyahWords.value = true;

        final wordCount =
            totalWords ?? getAyahWordCount(surahNumber, ayahNumber);
        if (wordCount <= 0) {
          isLoading.value = false;
          isPlaying.value = false;
          currentPlayingRef.value = null;
          isPlayingAyahWords.value = false;
          return;
        }

        final sources = List<AudioSource>.generate(
          wordCount,
          (i) => AudioSource.uri(
            Uri.parse(_buildWordUrl(
              surahNumber: surahNumber,
              ayahNumber: ayahNumber,
              wordNumber: i + 1,
            )),
          ),
        );
        await _audioPlayer.setAudioSources(sources);

        isLoading.value = false;
        isPlaying.value = true;

        _listenForCompletion();
        await _audioPlayer.play();
      } catch (e) {
        log('WordAudioService.playAyahWords error: $e',
            name: 'WordAudioService');
        isLoading.value = false;
        isPlaying.value = false;
        currentPlayingRef.value = null;
        isPlayingAyahWords.value = false;
      }
    } else {
      ToastUtils().showToast(
        Get.context!,
        'لا يوجد اتصال بالإنترنت',
      );
    }
  }

  /// إيقاف التشغيل.
  Future<void> stop() async {
    _playerStateSubscription?.cancel();
    _playerStateSubscription = null;

    try {
      if (_player != null) {
        await _audioPlayer.stop();
      }
    } catch (_) {}

    isPlaying.value = false;
    isLoading.value = false;
    currentPlayingRef.value = null;
    isPlayingAyahWords.value = false;
  }

  void _listenForCompletion() {
    _playerStateSubscription?.cancel();
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        currentPlayingRef.value = null;
        isPlayingAyahWords.value = false;
        _playerStateSubscription?.cancel();
        _playerStateSubscription = null;
      }
    });
  }

  /// تنظيف الموارد.
  void dispose() {
    _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    _player?.dispose();
    _player = null;
  }
}
