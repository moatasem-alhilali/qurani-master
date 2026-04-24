part of '/quran.dart';

class QuranCtrl extends GetxController {
  static QuranCtrl get instance => GetInstance().putOrFind(() => QuranCtrl());

  QuranCtrl({QuranRepository? quranRepository})
      : _quranRepository = quranRepository ?? QuranRepository(),
        super();

  final QuranRepository _quranRepository;

  // تحميل بيانات المصحف (V1/V3) مرة واحدة عند الحاجة (خصوصاً بعد hot restart)
  Future<void>? _coreDataLoadFuture;

  // --- QPC v4 (الخط المحمّل) ---
  QpcV4AssetsStore? _qpcV4Store;
  Future<void>? _qpcV4LoadFuture;
  QpcV4PageRenderer? _qpcV4PageRenderer;
  final Map<int, List<QpcV4RenderBlock>> _qpcV4BlocksByPage = {};
  Future<void>? _qpcV4PrebuildAllFuture;
  bool _qpcV4PrebuildStarted = false;
  Timer? _qpcV4IdlePrebuildTimer;

  bool get isQpcV4AllPagesPrebuilt => _qpcV4BlocksByPage.length >= 604;

  double get qpcV4PrebuildProgress {
    const totalPages = 604;
    final p = _qpcV4BlocksByPage.length / totalPages;
    if (p.isNaN || p.isInfinite) return 0.0;
    return p.clamp(0.0, 1.0);
  }

  // uq index: (surah,ayah) -> ayahUQNumber
  final Map<int, int> _ayahUqBySurahAyahKey = {};
  final Map<int, AyahModel> _ayahByUqCache = {};

  bool get isQpcV4Enabled => state.fontsSelected.value == 0;

  /// تفعيل مسار layout الموحد (QPC layout) للخطوط 0/1/2
  bool get isQpcLayoutEnabled => isQpcV4Enabled;

  RxList<QuranPageModel> staticPages = <QuranPageModel>[].obs;
  List<SurahModel> surahs = [];
  final List<AyahModel> ayahs = [];
  int lastPage = 1;
  int? initialPage;
  final RxList<AyahModel> searchResultAyahs = <AyahModel>[].obs;
  final RxList<SurahModel> searchResultSurahs = <SurahModel>[].obs;

  /// List of selected ayahs by their unique number
  final selectedAyahsByUnequeNumber = <int>[].obs;
  bool isAyahSelected = false;
  RxDouble scaleFactor = 1.0.obs;
  RxDouble baseScaleFactor = 1.0.obs;
  final isLoading = true.obs;
  RxList<SurahNamesModel> surahsList = <SurahNamesModel>[].obs;
  RxBool isShowControl = false.obs;
  // وضع تحديد متعدد للآيات
  final RxBool isMultiSelectMode = false.obs;
  // آيات مظللة برمجياً (لا تعتمد على اختيار المستخدم)
  final RxList<int> externallyHighlightedAyahs = <int>[].obs;
  late FocusNode searchFocusNode;
  late TextEditingController searchTextController;

  // PreloadPageController الداخلي
  PreloadPageController? _pageController;

  // متحكم صفحات محلي لشاشة QuranPagesScreen (نطاق محدود من الصفحات)
  PageController? _localPagesController;
  int _localPagesOffset = 0;
  int _localPagesCount = 0;

  /// تسجيل متحكم صفحات محلي مع إزاحة البداية وعدد الصفحات
  void registerLocalPageController(
      PageController controller, int startOffset, int count) {
    _localPagesController = controller;
    _localPagesOffset = startOffset;
    _localPagesCount = count;
  }

  /// إلغاء تسجيل متحكم الصفحات المحلي
  void unregisterLocalPageController() {
    _localPagesController = null;
    _localPagesOffset = 0;
    _localPagesCount = 0;
  }

  // late QuranSearch quranSearch;

  // final bool _scrollListenerAttached = false;
  // final int _lastPrefetchedForPage = -1;

  QuranState state = QuranState();

  @override
  void onInit() async {
    super.onInit();
    state.currentPageNumber.value = _quranRepository.getLastPage() ?? 1;
    junpTolastPage();

    // QuranFontsService.ensurePagesLoaded(state.currentPageNumber.value,
    //         radius: 5)
    //     .then((_) {
    //   // quranCtrl.update();
    //   // update(['_pageViewBuild']);
    //   // تحميل بقية الصفحات في الخلفية
    //   QuranFontsService.loadRemainingInBackground(
    //     startNearPage: state.currentPageNumber.value,
    //     progress: state.fontsLoadProgress,
    //     ready: state.fontsReady,
    //   ).then((_) {
    //     // update();
    //     update(['_pageViewBuild']);
    //   });
    // });

    // ضمان تحميل بيانات المصحف حتى لو لم يتم استدعاء QuranLibrary.init() في التطبيق المضيف.
    // نطلقها بشكل غير متزامن لتجنب إبطاء onInit.
    Future(() => ensureCoreDataLoaded());

    // تحميل آخر وضع عرض محفوظ
    // Load saved display mode
    loadSavedDisplayMode();

    searchFocusNode = FocusNode();
    searchTextController = TextEditingController();
  }

  Future<void> ensureCoreDataLoaded() async {
    if (state.pages.isNotEmpty && state.allAyahs.isNotEmpty) return;

    _coreDataLoadFuture ??= () async {
      try {
        await Future.wait<void>([
          loadQuranDataV3(),
          fetchSurahs(),
        ]);
      } catch (e, st) {
        log('Failed to load core Quran data: $e',
            name: 'QuranCtrl', stackTrace: st);
      } finally {
        // تحديث عام + تحديث خاص بالـ PageViewBuild
        update();
        update(['_pageViewBuild']);
      }
    }();

    QuranCtrl.instance.state.isTajweedEnabled.value =
        GetStorage().read(_StorageConstants().isTajweed) ?? false;
    await _coreDataLoadFuture;
  }

  @override
  void onClose() {
    staticPages.close();
    selectedAyahsByUnequeNumber.close();
    searchResultAyahs.close();
    scaleFactor.close();
    baseScaleFactor.close();
    isLoading.close();
    surahsList.close();
    state.dispose();
    quranPagesController.dispose();
    super.onClose();
    searchFocusNode.dispose();
    searchTextController.dispose();

    _qpcV4BlocksByPage.clear();
    _ayahUqBySurahAyahKey.clear();
    _ayahByUqCache.clear();
    _qpcV4PageRenderer = null;
    _qpcV4Store = null;
    _qpcV4LoadFuture = null;
    _qpcV4IdlePrebuildTimer?.cancel();
  }

  /// -------- [Methods] ----------

  // Future<void> _initSearch() async {
  //   quranSearch = QuranSearch(ayahs); // تأكد من أن `ayahs` محملة مسبقًا
  //   await quranSearch.loadModel(); // تحميل نموذج BERT
  // }

  Future<void> loadQuranDataV3() async {
    lastPage = _quranRepository.getLastPage() ?? 1;
    state.currentPageNumber.value = lastPage;
    if (lastPage != 0) {
      jumpToPage(lastPage - 1);
    }
    if (surahs.isEmpty) {
      List<dynamic> surahsJson = await _quranRepository.getQuranDataV3();
      surahs =
          surahsJson.map((s) => SurahModel.fromDownloadedFontsJson(s)).toList();

      // مزامنة القوائم على مستوى الـ instance مع state لتجنب القوائم الفارغة
      // surahs.addAll(surahs);

      for (final surah in surahs) {
        // نقل بيانات السورة إلى كل آية حتى يعمل البحث بشكل صحيح
        for (final ayah in surah.ayahs) {
          ayah.surahNumber ??= surah.surahNumber;
          ayah.arabicName ??= surah.arabicName;
          ayah.englishName ??= surah.englishName;
        }
        state.allAyahs.addAll(surah.ayahs);
      }

      // مزامنة قائمة الآيات على مستوى الـ instance
      ayahs.addAll(state.allAyahs);
      List.generate(604, (pageIndex) {
        state.pages.add(state.allAyahs
            .where((ayah) => ayah.page == pageIndex + 1)
            .toList());
      });
      state.isQuranLoaded = true;
      _buildAyahUqIndexIfNeeded();

      // تحميل كسول لملفات QPC v4 فقط عند تفعيل الخط المحمّل (code v4)
      if (isQpcV4Enabled) {
        // لا ننتظر هنا لتجنب إبطاء init في الحالات الأخرى.
        Future(() => _ensureQpcV4AssetsLoaded());
      }
      // log('Pages Length: ${state.pages.length}', name: 'Quran Controller');
    }
  }

  int _surahAyahKey(int surahNumber, int ayahNumber) =>
      surahNumber * 1000 + ayahNumber;

  void _buildAyahUqIndexIfNeeded() {
    if (_ayahUqBySurahAyahKey.isNotEmpty) return;
    for (final surah in surahs) {
      for (final ayah in surah.ayahs) {
        _ayahUqBySurahAyahKey[
                _surahAyahKey(surah.surahNumber, ayah.ayahNumber)] =
            ayah.ayahUQNumber;
        _ayahByUqCache[ayah.ayahUQNumber] = ayah;
      }
    }
  }

  int resolveAyahUq({required int surahNumber, required int ayahNumber}) {
    _buildAyahUqIndexIfNeeded();
    return _ayahUqBySurahAyahKey[_surahAyahKey(surahNumber, ayahNumber)] ?? 0;
  }

  AyahModel getAyahByUq(int ayahUqNumber) {
    _buildAyahUqIndexIfNeeded();
    final cached = _ayahByUqCache[ayahUqNumber];
    if (cached != null) return cached;
    final found = state.allAyahs.firstWhereOrNull(
      (a) => a.ayahUQNumber == ayahUqNumber,
    );
    return found ?? AyahModel.empty();
  }

  Future<void> _ensureQpcV4AssetsLoaded() async {
    if (!isQpcLayoutEnabled) return;
    if (_qpcV4Store != null) return;

    _qpcV4LoadFuture ??= () async {
      try {
        _qpcV4Store = await QpcV4AssetsLoader.load();
        _qpcV4PageRenderer = QpcV4PageRenderer(
          store: _qpcV4Store!,
          ayahUqResolver: ({required surahNumber, required ayahNumber}) =>
              resolveAyahUq(surahNumber: surahNumber, ayahNumber: ayahNumber),
        );
      } catch (e, st) {
        log('Failed to load QPC v4 assets: $e', name: 'QPCv4', stackTrace: st);
      } finally {
        // إعادة بناء الواجهة إن كانت الصفحة الحالية تعتمد على QPC
        update();
      }
    }();

    await _qpcV4LoadFuture;
  }

  /// يبني كل صفحات QPC v4 مرة واحدة لتجنّب التقطيع أثناء التقليب.
  ///
  /// ملاحظة: التنفيذ يتم على دفعات مع yield لتفادي تجميد واجهة المستخدم.
  Future<void> ensureQpcV4AllPagesPrebuilt() async {
    if (!isQpcV4Enabled) return;
    await _ensureQpcV4AssetsLoaded();
    final renderer = _qpcV4PageRenderer;
    if (renderer == null) return;

    // لا تعِد البناء إن تم البدء/الاكتمال.
    if (_qpcV4PrebuildAllFuture != null) {
      await _qpcV4PrebuildAllFuture;
      return;
    }

    _qpcV4PrebuildAllFuture = () async {
      if (_qpcV4BlocksByPage.length >= 604) return;
      _qpcV4PrebuildStarted = true;

      // نبني بزمن-ميزانية صغيرة مع تأخير بسيط لتقليل منافسة الـ UI أثناء الاستخدام.
      const totalPages = 604;
      const timeBudgetMs = 3;
      final sw = Stopwatch()..start();

      for (var page = 1; page <= totalPages; page++) {
        if (!isQpcV4Enabled) break;
        if (_qpcV4BlocksByPage.containsKey(page)) continue;
        _qpcV4BlocksByPage[page] = renderer.buildPage(pageNumber: page);

        if (sw.elapsedMilliseconds >= timeBudgetMs) {
          // yield إلى event loop (مع تأخير بسيط) حتى لا ننافس الرسم/الـ gestures.
          await Future<void>.delayed(const Duration(milliseconds: 4));
          sw
            ..reset()
            ..start();
        }
      }

      // لا حاجة لـ update() هنا: الصفحات المعروضة تمت تغذيتها بالفعل عبر prewarmQpcV4Pages.
      // الصفحات البعيدة ستحصل على البيانات عند التقليب إليها.
    }();

    await _qpcV4PrebuildAllFuture;
  }

  /// جدولة تحضير كل صفحات QPC v4 بعد فترة خمول.
  /// الهدف: منع منافسة CPU أثناء تقليب الصفحات.
  void scheduleQpcV4AllPagesPrebuild(
      {Duration delay = const Duration(seconds: 2)}) {
    if (!isQpcV4Enabled) return;
    if (_qpcV4BlocksByPage.length >= 604) return;
    if (_qpcV4PrebuildStarted) return;
    log('Scheduling QPC v4 prebuild for all pages after $delay of idle time',
        name: 'QPCv4');

    _qpcV4IdlePrebuildTimer?.cancel();
    _qpcV4IdlePrebuildTimer = Timer(delay, () {
      if (!isQpcV4Enabled) return;
      if (_qpcV4PrebuildStarted) return;
      Future(() => ensureQpcV4AllPagesPrebuilt());
    });
  }

  List<QpcV4RenderBlock> getQpcV4BlocksForPageSync(int pageNumber) {
    final cached = _qpcV4BlocksByPage[pageNumber];
    if (cached != null) return cached;
    log('Building QPC v4 blocks for page $pageNumber synchronously',
        name: 'QPCv4');

    // تجنّب البناء المتزامن داخل build للصفحة (يسبب jank).
    // إذا لم تكن الصفحة جاهزة، نعطي أولوية لبناء هذه الصفحة (والمجاورة) أولاً،
    // ثم نطلق التحضير الكامل في الخلفية.
    if (isQpcV4Enabled) {
      Future(() async {
        // يبني الصفحة المطلوبة + صفحات مجاورة بسرعة لتحسين تجربة الفتح على صفحة بعيدة.
        await prewarmQpcV4Pages(pageNumber - 1);
        // التحضير الكامل يتم فقط بعد خمول، لتقليل التقطيع أثناء السحب.
      });
    }

    return const <QpcV4RenderBlock>[];
  }

  List<QpcV4RenderBlock> getQpcLayoutBlocksForPageSync(int pageNumber) {
    return getQpcV4BlocksForPageSync(pageNumber);
  }

  /// يعيد كتل العرض المتدفق (flowing) لصفحة — تجمّع segments حسب الآية.
  /// تُستخدم في وضع التكبير حيث لا نحتاج لتحديد موقع كل كلمة.
  List<QpcV4RenderBlock> getQpcFlowBlocksForPage(int pageNumber) {
    final lineBlocks = getQpcLayoutBlocksForPageSync(pageNumber);
    if (lineBlocks.isEmpty) return const [];

    final result = <QpcV4RenderBlock>[];
    final ayahSegmentsMap = <int, List<QpcV4WordSegment>>{};
    final ayahOrder = <int>[];

    for (final block in lineBlocks) {
      if (block is QpcV4SurahHeaderBlock || block is QpcV4BasmallahBlock) {
        // تفريغ الآيات المجمّعة قبل إضافة الهيدر/البسملة
        for (final uq in ayahOrder) {
          final segs = ayahSegmentsMap[uq]!;
          final first = segs.first;
          result.add(QpcV4AyahFlowBlock(
            ayahUq: uq,
            surahNumber: first.surahNumber,
            ayahNumber: first.ayahNumber,
            segments: segs,
          ));
        }
        ayahSegmentsMap.clear();
        ayahOrder.clear();
        result.add(block);
        continue;
      }

      if (block is QpcV4AyahLineBlock) {
        for (final seg in block.segments) {
          if (!ayahSegmentsMap.containsKey(seg.ayahUq)) {
            ayahSegmentsMap[seg.ayahUq] = [];
            ayahOrder.add(seg.ayahUq);
          }
          ayahSegmentsMap[seg.ayahUq]!.add(seg);
        }
      }
    }

    // تفريغ الآيات المتبقية
    for (final uq in ayahOrder) {
      final segs = ayahSegmentsMap[uq]!;
      final first = segs.first;
      result.add(QpcV4AyahFlowBlock(
        ayahUq: uq,
        surahNumber: first.surahNumber,
        ayahNumber: first.ayahNumber,
        segments: segs,
      ));
    }

    return result;
  }

  Future<void> prewarmQpcV4Pages(int pageIndex) async {
    if (!isQpcV4Enabled) return;
    await _ensureQpcV4AssetsLoaded();
    if (_qpcV4PageRenderer == null) return;

    final basePage = pageIndex + 1;
    final candidates = <int>{
      basePage,
      basePage - 1,
      basePage + 1,
      basePage - 2,
      basePage + 2,
    }.where((p) => p >= 1 && p <= 604);

    var didBuildAny = false;
    for (final p in candidates) {
      if (_qpcV4BlocksByPage.containsKey(p)) continue;
      _qpcV4BlocksByPage[p] = _qpcV4PageRenderer!.buildPage(pageNumber: p);
      didBuildAny = true;
    }

    if (didBuildAny) {
      // تحديث الصفحات المعنيّة فقط (بدل update() الذي يُعيد بناء الكل)
      update([
        for (final p in candidates) 'qpc_page_${p - 1}',
      ]);
    }
  }

  void junpTolastPage() {
    lastPage = state.currentPageNumber.value;
    if (lastPage != 0) {
      log('Jumping to last page: $lastPage', name: 'QuranCtrl');
      jumpToPage(lastPage - 1);
    }
  }

  List<AyahModel> getAyahsByPage(int page) {
    // تصفية القائمة بناءً على رقم الصفحة
    final filteredAyahs =
        state.allAyahs.where((ayah) => ayah.page == page).toList();

    // فرز القائمة حسب رقم الآية
    filteredAyahs.sort((a, b) => a.ayahNumber.compareTo(b.ayahNumber));

    return filteredAyahs;
  }

  Future<void> fetchSurahs() async {
    try {
      isLoading(true);
      final jsonResponse = await _quranRepository.getSurahs();
      final response = SurahResponseModel.fromJson(jsonResponse);
      surahsList.assignAll(response.surahs);
    } catch (e) {
      log('Error fetching data: $e');
    } finally {
      isLoading(false);
    }
    update();
  }

  List<AyahModel> search(String searchText) {
    if (searchText.isEmpty) {
      return [];
    } else {
      // تطبيع النصوص المدخلة
      final normalizedSearchText =
          normalizeText(searchText.toLowerCase().trim());

      final filteredAyahs = state.allAyahs.where((aya) {
        // تطبيع نص الآية واسم السورة
        final normalizedAyahText =
            normalizeText(aya.ayaTextEmlaey.toLowerCase());
        final normalizedSurahNameAr =
            normalizeText(aya.arabicName!.toLowerCase());
        final normalizedSurahNameEn =
            normalizeText(aya.englishName!.toLowerCase());

        // التحقق من تطابق نص الآية
        final containsWord = normalizedAyahText.contains(normalizedSearchText);

        // التحقق من تطابق رقم الصفحة
        final matchesPage = aya.page.toString() ==
            normalizedSearchText
                .convertArabicNumbersToEnglish(normalizedSearchText);

        // التحقق من تطابق اسم السورة بالعربية أو الإنجليزية
        final matchesSurahName =
            normalizedSurahNameAr == normalizedSearchText ||
                normalizedSurahNameEn == normalizedSearchText;

        // التحقق من رقم الآية
        final matchesAyahNumber = aya.ayahNumber.toString() ==
            normalizedSearchText
                .convertArabicNumbersToEnglish(normalizedSearchText);

        // إذا تحقق أي شرط من الشروط أعلاه باستثناء رقم السورة
        return containsWord ||
            matchesPage ||
            matchesSurahName ||
            matchesAyahNumber;
      }).toList();

      return filteredAyahs;
    }
  }

// دالة تطبيع النصوص لتحويل الأحرف
  String normalizeText(String text) {
    return text
        .replaceAll('ة', 'ه')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ئ', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll(RegExp(r'\s+'), ' '); // إزالة الفراغات الزائدة
  }

  List<SurahModel> searchSurah(String searchText) {
    if (searchText.isEmpty) {
      return [];
    } else {
      // تحويل الأرقام العربية إلى إنجليزية في النص المدخل
      // Convert Arabic numbers to English in the input text
      final convertedSearchText =
          searchText.convertArabicNumbersToEnglish(searchText);

      // إزالة التشكيل وتطبيع النص المدخل
      // Remove diacritics and normalize the input text
      final cleanedSearchText = removeDiacriticsQuran(convertedSearchText);
      final normalizedSearchText =
          normalizeText(cleanedSearchText.toLowerCase().trim());

      final filteredSurahs = surahs.where((surah) {
        // إزالة التشكيل وتطبيع أسماء السور
        // Remove diacritics and normalize surah names
        final cleanedSurahNameAr = removeDiacriticsQuran(surah.arabicName);
        final normalizedSurahNameAr =
            normalizeText(cleanedSurahNameAr.toLowerCase());
        final normalizedSurahNameEn =
            normalizeText(surah.englishName.toLowerCase());

        // استخدام contains بدلاً من == للسماح بمطابقة جزئية
        // Use contains instead of == to allow partial matching
        final matchesSurahName =
            normalizedSurahNameAr.contains(normalizedSearchText) ||
                normalizedSurahNameEn.contains(normalizedSearchText);

        // تحويل رقم السورة إلى نص مع تحويل الأرقام العربية
        // Convert surah number to text with Arabic number conversion
        final surahNumberText = surah.surahNumber.toString();
        final matchesSurahNumber = surahNumberText == normalizedSearchText;

        return matchesSurahName || matchesSurahNumber;
      }).toList();

      return filteredSurahs;
    }
  }

  void saveLastPage(int lastPage) {
    this.lastPage = lastPage;
    // كتابة فورية — GetStorage يحدّث الذاكرة لحظياً ويدير كتابة القرص تلقائياً بتأجيل 16ms.
    _quranRepository.saveLastPage(lastPage);
    log('Saved last page: $lastPage', name: 'QuranCtrl');
  }

  // شرح: تحسين التنقل للحصول على سكرول أكثر سلاسة
  // Explanation: Improved navigation for smoother scrolling
  void jumpToPage(int page) {
    // في وضع الصفحتين (viewportFraction < 1): محاذاة الفهرس إلى رقم زوجي
    // لضمان عرض الزوج الصحيح (1-2, 3-4, 5-6, ...).
    final isDual = quranPagesController.viewportFraction < 1.0;
    final targetPage = isDual ? page - (page % 2) : page;
    state.currentPageNumber.value = page + 1;
    // تحقق من المتحكم المحلي أولاً (QuranPagesScreen)
    if (_localPagesController != null && _localPagesController!.hasClients) {
      final localIndex = targetPage - _localPagesOffset;
      if (localIndex >= 0 && localIndex < _localPagesCount) {
        log('Jumping to local page: $localIndex (global: $targetPage)',
            name: 'QuranCtrl');
        _localPagesController!.jumpToPage(localIndex);
        return;
      }
    }
    if (quranPagesController.hasClients) {
      log('Jumping to page: $targetPage (requested: $page, isDual: $isDual)',
          name: 'QuranCtrl');
      quranPagesController.jumpToPage(
        targetPage,
      );
    } else {
      log('Creating new PageController for page: $targetPage',
          name: 'QuranCtrl');
      quranPagesController = PreloadPageController(
        initialPage: targetPage,
        keepPage: true,
        viewportFraction: 1.0,
      );
    }
  }

  // شرح: تحسين التنقل للحصول على سكرول أكثر سلاسة
  // Explanation: Improved navigation for smoother scrolling
  void animateToPage(int page) {
    if (quranPagesController.hasClients) {
      // في وضع الصفحتين: محاذاة الفهرس إلى رقم زوجي لعرض الزوج الصحيح
      final isDual = quranPagesController.viewportFraction < 1.0;
      final targetPage = isDual ? page - (page % 2) : page;
      log('Animating to page: $targetPage (requested: $page, isDual: $isDual)',
          name: 'QuranCtrl');
      quranPagesController.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      log('Creating new PageController for page: $page', name: 'QuranCtrl');
      quranPagesController = PreloadPageController(
        initialPage: page,
        keepPage: true,
        viewportFraction: 1.0,
      );
    }
  }

  PreloadPageController getPageController(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    // احسب قيمة الـ viewportFraction الهدف بناءً على حجم/اتجاه الشاشة
    // viewportFraction 0.5 فقط في الوضع الافتراضي على شاشات الديسكتوب العريضة
    // Other display modes always use 1.0 to show a single page
    final bool isWideDesktop =
        Responsive.isDesktop(context) && orientation == Orientation.landscape;
    final currentMode = state.displayMode.value;
    final bool useDualFraction =
        isWideDesktop && currentMode == QuranDisplayMode.defaultMode;
    double targetFraction = useDualFraction ? 0.5 : 1.0;

    log(
        'getPageController: isDesktop=${GetPlatform.isDesktop}, isWideDesktop=$isWideDesktop, '
        'targetFraction=$targetFraction',
        name: 'QuranCtrl');

    // أعد إنشاء المتحكم فقط عند تغيّر viewportFraction.
    // لا نتحقق من hasClients لأن jumpToPage في onInit ينشئ controller بـ initialPage صحيح
    // وإعادة إنشائه قبل ربطه بالـ PageView يضيع تلك القيمة.
    final bool needsNewController =
        quranPagesController.viewportFraction != targetFraction;

    if (needsNewController) {
      // حافظ على الفهرس الحالي للصفحة
      int currentIndex;
      if (quranPagesController.hasClients) {
        final double? p = quranPagesController.page;
        currentIndex =
            (p != null) ? p.round() : state.currentPageNumber.value - 1;
      } else {
        // قراءة مباشرة من التخزين — المصدر الأوثق للصفحة المحفوظة
        final savedPage = _quranRepository.getLastPage() ?? 1;
        currentIndex = savedPage - 1;
      }
      currentIndex = currentIndex.clamp(0, 603);
      // في وضع الصفحتين: محاذاة الفهرس إلى رقم زوجي لعرض الزوج الصحيح
      if (targetFraction < 1.0) {
        currentIndex = currentIndex - (currentIndex % 2);
      }
      log('Creating new PageController with initialPage: $currentIndex',
          name: 'QuranCtrl');

      final oldController = quranPagesController;
      quranPagesController = PreloadPageController(
        initialPage: currentIndex,
        keepPage: kIsWeb || GetPlatform.isDesktop,
        viewportFraction: targetFraction,
      );

      // تخلّص من المتحكم القديم بعد الإطار لتجنّب تعارضات التثبيت
      if (oldController != quranPagesController) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            oldController.dispose();
          } catch (_) {
            // تجاهل أي أخطاء تصريف إن كان قد صُرّف سابقًا
          }
        });
      }
    }
    return quranPagesController;
  }

  /// Toggle the selection of an ayah by its unique number
  void toggleAyahSelection(int ayahUnequeNumber, {bool forceAddition = false}) {
    if (isClosed) return;
    log('selectedAyahs: ${selectedAyahsByUnequeNumber.join(', ')}');
    if (!forceAddition &&
        selectedAyahsByUnequeNumber.contains(ayahUnequeNumber)) {
      if (selectedAyahsByUnequeNumber.length > 1) {
        selectedAyahsByUnequeNumber.remove(ayahUnequeNumber);
      }
    } else {
      selectedAyahsByUnequeNumber.clear();
      selectedAyahsByUnequeNumber.add(ayahUnequeNumber);
    }
    selectedAyahsByUnequeNumber.refresh();
    update();
    log('selectedAyahs: ${selectedAyahsByUnequeNumber.join(', ')}');
  }

  /// إضافة/إزالة آية من التحديد بدون مسح بقية التحديد (للوضع المتعدد)
  void toggleAyahSelectionMulti(int ayahUniqueNumber) {
    if (isClosed) return;
    if (selectedAyahsByUnequeNumber.contains(ayahUniqueNumber)) {
      selectedAyahsByUnequeNumber.remove(ayahUniqueNumber);
    } else {
      selectedAyahsByUnequeNumber.add(ayahUniqueNumber);
    }
    selectedAyahsByUnequeNumber.refresh();
    update();
  }

  void setMultiSelectMode(bool enabled) {
    isMultiSelectMode.value = enabled;
  }

  // إدارة التظليل البرمجي
  void setExternalHighlights(List<int> ayahUQNumbers) {
    externallyHighlightedAyahs
        .assignAll(ayahUQNumbers.toSet().toList()..sort());
  }

  void addExternalHighlight(int ayahUQNumber) {
    if (!externallyHighlightedAyahs.contains(ayahUQNumber)) {
      externallyHighlightedAyahs.add(ayahUQNumber);
    }
  }

  void removeExternalHighlight(int ayahUQNumber) {
    externallyHighlightedAyahs.remove(ayahUQNumber);
  }

  void clearExternalHighlights() {
    externallyHighlightedAyahs.clear();
  }

  /// تحويل (رقم السورة، رقم الآية) إلى الرقم الفريد للآية
  int? getAyahUQBySurahAndAyah(int surahNumber, int ayahNumber) {
    try {
      final surah = surahs.firstWhere((s) => s.surahNumber == surahNumber);
      final ayah = surah.ayahs.firstWhere((a) => a.ayahNumber == ayahNumber);
      return ayah.ayahUQNumber;
    } catch (_) {
      return null;
    }
  }

  /// إرجاع أرقام UQ لكل الآيات ذات أرقام ayahNumber المحددة داخل نطاق صفحات
  List<int> getAyahUQsForPagesByAyahNumbers(
      {required int startPage,
      required int endPage,
      required List<int> ayahNumbers}) {
    final result = <int>{};
    final sp = startPage.clamp(1, 604);
    final ep = endPage.clamp(1, 604);
    for (int p = sp; p <= ep; p++) {
      final pageAyahs = staticPages.isNotEmpty
          ? staticPages[p - 1].ayahs
          : ayahs.where((a) => a.page == p).toList();
      for (final a in pageAyahs) {
        if (ayahNumbers.contains(a.ayahNumber)) {
          result.add(a.ayahUQNumber);
        }
      }
    }
    return result.toList();
  }

  /// إرجاع أرقام UQ لكل الآيات ضمن نطاق عبر السور، مثل 2:15-3:25 (شامل)
  List<int> getAyahUQsForSurahAyahRange({
    required int startSurah,
    required int startAyah,
    required int endSurah,
    required int endAyah,
  }) {
    // تصحيح الترتيب إذا كان البداية بعد النهاية
    bool swapNeeded = (startSurah > endSurah) ||
        (startSurah == endSurah && startAyah > endAyah);
    int sSurah = swapNeeded ? endSurah : startSurah;
    int sAyah = swapNeeded ? endAyah : startAyah;
    int eSurah = swapNeeded ? startSurah : endSurah;
    int eAyah = swapNeeded ? startAyah : endAyah;

    // ضبط الحدود ضمن المدى الصحيح للسور
    sSurah = sSurah.clamp(1, surahs.isEmpty ? 114 : surahs.length);
    eSurah = eSurah.clamp(1, surahs.isEmpty ? 114 : surahs.length);

    final result = <int>{};
    for (int s = sSurah; s <= eSurah; s++) {
      SurahModel? surah;
      try {
        surah = surahs.firstWhere((x) => x.surahNumber == s);
      } catch (_) {
        surah = null;
      }
      if (surah == null || surah.ayahs.isEmpty) continue;
      final int firstAyah = (s == sSurah) ? sAyah : 1;
      final int lastAyah = (s == eSurah)
          ? eAyah
          : surah.ayahs.last.ayahNumber; // آخر آية في السورة

      final int from = firstAyah.clamp(1, surah.ayahs.last.ayahNumber);
      final int to = lastAyah.clamp(1, surah.ayahs.last.ayahNumber);
      for (final a in surah.ayahs) {
        if (a.ayahNumber >= from && a.ayahNumber <= to) {
          result.add(a.ayahUQNumber);
        }
      }
    }
    return result.toList();
  }

  /// يحلل نص نطاق على شكل "2:15-3:25" إلى (startSurah,startAyah,endSurah,endAyah)
  /// يدعم الأرقام العربية والإنجليزية والمسافات.
  (int startSurah, int startAyah, int endSurah, int endAyah)?
      parseSurahAyahRangeString(String input) {
    final normalized = input.convertArabicNumbersToEnglish(input).trim();
    final reg = RegExp(r"^\s*(\d+)\s*:\s*(\d+)\s*-\s*(\d+)\s*:\s*(\d+)\s*$");
    final m = reg.firstMatch(normalized);
    if (m == null) return null;
    try {
      final ss = int.parse(m.group(1)!);
      final sa = int.parse(m.group(2)!);
      final es = int.parse(m.group(3)!);
      final ea = int.parse(m.group(4)!);
      return (ss, sa, es, ea);
    } catch (_) {
      return null;
    }
  }

  void clearSelection() {
    selectedAyahsByUnequeNumber.clear();
    update();
  }

  void updateTextScale(ScaleUpdateDetails details) {
    double newScaleFactor = state.baseScaleFactor.value * details.scale;
    if (newScaleFactor < 1.0) {
      newScaleFactor = 1.0;
    } else if (newScaleFactor < 4) {
      state.scaleFactor.value = newScaleFactor;
    }

    update(['_pageViewBuild']);
  }

  String removeDiacriticsQuran(String input) {
    final diacriticsMap = {
      'أ': 'ا',
      'إ': 'ا',
      'آ': 'ا',
      'إٔ': 'ا',
      'إٕ': 'ا',
      'إٓ': 'ا',
      'أَ': 'ا',
      'إَ': 'ا',
      'آَ': 'ا',
      'إُ': 'ا',
      'إٌ': 'ا',
      'إً': 'ا',
      'ة': 'ه',
      'ً': '',
      'ٌ': '',
      'ٍ': '',
      'َ': '',
      'ُ': '',
      'ِ': '',
      'ّ': '',
      'ْ': '',
      'ـ': '',
      'ٰ': '',
      'ٖ': '',
      'ٗ': '',
      'ٕ': '',
      'ٓ': '',
      'ۖ': '',
      'ۗ': '',
      'ۘ': '',
      'ۙ': '',
      'ۚ': '',
      'ۛ': '',
      'ۜ': '',
      '۝': '',
      '۞': '',
      '۟': '',
      '۠': '',
      'ۡ': '',
      'ۢ': '',
    };

    StringBuffer buffer = StringBuffer();
    Map<int, int> indexMapping =
        {}; // Ensure indexMapping is declared if not already globally declared
    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      String? mappedChar = diacriticsMap[char];
      if (mappedChar != null) {
        buffer.write(mappedChar);
        if (mappedChar.isNotEmpty) {
          indexMapping[buffer.length - 1] = i;
        }
      } else {
        buffer.write(char);
        indexMapping[buffer.length - 1] = i;
      }
    }
    return buffer.toString();
  }

  // List<TajweedRuleModel> getTajweedRules({required String languageCode}) {
  //   if (languageCode == "ar") {
  //     return tajweedRulesListAr;
  //   } else if (languageCode == "en") {
  //     return tajweedRulesListEn;
  //   } else if (languageCode == "bn") {
  //     return tajweedRulesListBn;
  //   } else if (languageCode == "id") {
  //     return tajweedRulesListId;
  //   } else if (languageCode == "tr") {
  //     return tajweedRulesListTr;
  //   } else if (languageCode == "ur") {
  //     return tajweedRulesListUr;
  //   }
  //   return tajweedRulesListAr;
  // }

  KeyEventResult controlRLByKeyboard(FocusNode node, KeyEvent event) {
    // على الويب، التقط فقط KeyDown لتجنب التكرارات أو التعارض مع KeyUp
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    // تأكد من جاهزية المتحكم قبل التحريك
    if (!quranPagesController.hasClients) return KeyEventResult.ignored;

    // وضع الصفحتين (viewportFraction < 1): نقفز بمقدار 2
    final step = quranPagesController.viewportFraction < 1.0 ? 2 : 1;
    final currentIndex = quranPagesController.page?.round() ?? 0;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      log('Left Arrow Pressed');
      final target = currentIndex + step;
      if (target <= 603) {
        quranPagesController.animateToPage(
          target,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      log('Right Arrow Pressed');
      final target = currentIndex - step;
      if (target >= 0) {
        quranPagesController.animateToPage(
          target,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
