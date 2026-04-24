part of '/quran.dart';

/// متحكم السكرول التلقائي — يستخدم AnimationController للتمرير السلس
///
/// [AutoScrollCtrl] drives smooth continuous vertical scroll using vsync
class AutoScrollCtrl extends GetxController with GetTickerProviderStateMixin {
  static AutoScrollCtrl get instance => Get.find<AutoScrollCtrl>();

  final AutoScrollState state = AutoScrollState();

  ScrollController? _scrollController;
  ScrollController get scrollController =>
      _scrollController ??= ScrollController();

  AnimationController? _ticker;

  final _storage = GetStorage();
  final _keys = _StorageConstants();

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  @override
  void onClose() {
    stopAutoScroll();
    _scrollController?.dispose();
    _scrollController = null;
    state.dispose();
    super.onClose();
  }

  // ─── Public API ───────────────────────────────────────────────

  /// بدء السكرول التلقائي من الصفحة الحالية
  void startAutoScroll(int fromPage) {
    state.startPage.value = fromPage;
    state.currentScrollPage.value = fromPage;
    state.isActive.value = true;
    state.isPaused.value = false;

    QuranCtrl.instance.isShowControl.value = false;

    _calculateAndSetTargetPage(fromPage);

    // إنشاء ScrollController جديد — سيتم ربطه بالـ ListView
    _scrollController?.dispose();
    _scrollController = ScrollController();

    // بدء الـ ticker بعد أن يتم بناء الـ ListView
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTicker();
    });
  }

  /// إيقاف مؤقت بالضغط على الشاشة
  void pauseAutoScroll() {
    if (!state.isActive.value) return;
    state.isPaused.value = true;
    _ticker?.stop();
    // إظهار عناصر التحكم عند الإيقاف المؤقت
    QuranCtrl.instance.isShowControl.value = true;
    QuranCtrl.instance.update(['isShowControl']);
  }

  /// استئناف السكرول — يعيد حساب هدف التوقف إن كان الحالي قد تجاوزه
  void resumeAutoScroll() {
    if (!state.isActive.value) return;
    state.isPaused.value = false;
    // إخفاء عناصر التحكم عند الاستئناف
    QuranCtrl.instance.isShowControl.value = false;
    QuranCtrl.instance.update(['isShowControl']);

    // إعادة حساب هدف التوقف من الصفحة الحالية
    final currentPage = state.currentScrollPage.value;
    _calculateAndSetTargetPage(currentPage);

    _startTicker();
  }

  /// تبديل حالة الإيقاف/الاستئناف
  void togglePause() {
    if (state.isPaused.value) {
      resumeAutoScroll();
    } else {
      pauseAutoScroll();
    }
  }

  /// إيقاف السكرول التلقائي نهائيًا مع حفظ الصفحة التي وصل إليها المستخدم
  void stopAutoScroll() {
    // حفظ الصفحة الحالية قبل الإيقاف
    final reachedPage = state.currentScrollPage.value;

    state.isActive.value = false;
    state.isPaused.value = false;
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;

    // تحديث صفحة QuranCtrl والانتقال إليها في الـ PageView الأفقي
    if (reachedPage > 0) {
      final quranCtrl = QuranCtrl.instance;
      quranCtrl.state.currentPageNumber.value = reachedPage;
      quranCtrl.saveLastPage(reachedPage);
      // الانتقال للصفحة بعد أن يُعاد بناء الـ PageView الأفقي
      WidgetsBinding.instance.addPostFrameCallback((_) {
        quranCtrl.jumpToPage(reachedPage - 1);
      });
    }
  }

  /// تحديث السرعة من الـ Slider (أثناء السكرول)
  void updateSpeed(double newSpeed) {
    state.speed.value = newSpeed.clamp(0.1, 5.0);
    _saveSettings();
  }

  /// تحديث شرط التوقف
  void updateStopCondition(AutoScrollStopCondition condition) {
    state.stopCondition.value = condition;
    _saveSettings();
  }

  /// تحديث عدد الصفحات المستهدف
  void updateTargetPageCount(int count) {
    state.targetPageCount.value = count.clamp(1, 604);
    _saveSettings();
  }

  // ─── Animation Logic ──────────────────────────────────────────

  void _startTicker() {
    _ticker?.dispose();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(days: 1), // مدة طويلة — نتحكم يدويًا
    );

    _ticker!.addListener(_onTick);
    _ticker!.forward();
  }

  void _onTick() {
    final sc = _scrollController;
    if (sc == null || !sc.hasClients) return;

    final maxScroll = sc.position.maxScrollExtent;
    final current = sc.offset;

    // التحقق من الوصول لنهاية المحتوى
    if (current >= maxScroll) {
      pauseAutoScroll();
      return;
    }

    // حساب الصفحة الحالية من الـ offset
    final viewportHeight = sc.position.viewportDimension;
    if (viewportHeight > 0) {
      final pageIndex = (current / viewportHeight).floor();
      final currentPage = state.startPage.value + pageIndex;
      state.currentScrollPage.value = currentPage.clamp(1, 604);

      // التحقق من شرط التوقف — إيقاف مؤقت فقط عند الوصول للحد
      if (_shouldStop(currentPage)) {
        pauseAutoScroll();
        return;
      }
    }

    // تقدّم بمقدار السرعة المحددة
    sc.jumpTo((current + state.speed.value).clamp(0.0, maxScroll));
  }

  bool _shouldStop(int currentPage) {
    final targetPage = state.targetStopPage.value;
    if (targetPage <= 0) return false; // manual = لا حد
    return currentPage >= targetPage;
  }

  // ─── Target Page Calculation ──────────────────────────────────

  void _calculateAndSetTargetPage(int fromPage) {
    switch (state.stopCondition.value) {
      case AutoScrollStopCondition.nextJuz:
        state.targetStopPage.value = _getNextJuzPage(fromPage);
        break;
      case AutoScrollStopCondition.nextHizb:
        state.targetStopPage.value = _getNextHizbPage(fromPage);
        break;
      case AutoScrollStopCondition.pageCount:
        state.targetStopPage.value =
            (fromPage + state.targetPageCount.value).clamp(1, 604);
        break;
      case AutoScrollStopCondition.manual:
        state.targetStopPage.value = 0; // بلا حد
        break;
    }
  }

  int _getNextJuzPage(int currentPage) {
    final quranCtrl = QuranCtrl.instance;
    final currentAyah = quranCtrl.getJuzByPage(currentPage - 1);
    final currentJuz = currentAyah.juz;
    if (currentJuz >= 30) return 604;
    final nextJuzStart = quranCtrl.getJuzStartPage(currentJuz + 1);
    return nextJuzStart.page;
  }

  int _getNextHizbPage(int currentPage) {
    final quranCtrl = QuranCtrl.instance;
    // نحتاج إيجاد أعلى حزب ربع في الصفحة الحالية ثم الانتقال للحزب التالي
    final currentPageAyahs =
        quranCtrl.state.allAyahs.where((a) => a.page == currentPage).toList();
    if (currentPageAyahs.isEmpty) return 604;

    final maxHizbQuarter =
        currentPageAyahs.map((a) => a.hizb ?? 0).reduce(math.max);
    // الحزب الكامل التالي = ((maxHizbQuarter - 1) ~/ 4 + 1) * 4 + 1
    final currentHizbNumber = ((maxHizbQuarter - 1) ~/ 4) + 1;
    final nextHizbQuarter = (currentHizbNumber) * 4 + 1;
    if (nextHizbQuarter > 240) return 604;

    final nextHizbStart = quranCtrl.getHizbStartPage(nextHizbQuarter);
    return nextHizbStart.page > 0 ? nextHizbStart.page : 604;
  }

  // ─── Settings Persistence ─────────────────────────────────────

  void _saveSettings() {
    _storage.write(_keys.autoScrollSpeed, state.speed.value);
    _storage.write(
        _keys.autoScrollStopCondition, state.stopCondition.value.storageIndex);
    _storage.write(_keys.autoScrollPageCount, state.targetPageCount.value);
  }

  void _loadSettings() {
    state.speed.value =
        (_storage.read<double>(_keys.autoScrollSpeed) ?? 1.5).clamp(0.1, 5.0);
    state.stopCondition.value = AutoScrollStopConditionX.fromStorageIndex(
        _storage.read<int>(_keys.autoScrollStopCondition) ?? 3);
    state.targetPageCount.value =
        (_storage.read<int>(_keys.autoScrollPageCount) ?? 10).clamp(1, 604);
  }
}
