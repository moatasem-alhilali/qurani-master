part of '/quran.dart';

/// كنترولر مخصص لعرض سورة واحدة بنفس تصميم QuranCtrl
/// Dedicated controller for displaying a single surah with the same design as QuranCtrl
class SurahCtrl extends GetxController {
  /// شرح: إنشاء instance singleton للكنترولر
  /// Explanation: Create singleton instance for the controller
  static SurahCtrl get instance => GetInstance().putOrFind(() => SurahCtrl());

  SurahCtrl({QuranRepository? quranRepository}) : super();

  /// رقم السورة المراد عرضها
  /// The surah number to display
  int? _surahNumber;
  int? get surahNumber => _surahNumber;

  /// صفحات السورة المقسمة
  /// Divided surah pages
  RxList<QuranPageModel> surahPages = <QuranPageModel>[].obs;

  /// آيات السورة
  /// Surah ayahs
  List<AyahModel> surahAyahs = [];

  /// معلومات السورة
  /// Surah information
  Rx<SurahModel?> currentSurah = Rx<SurahModel?>(null);

  /// حالة التحميل
  /// Loading state
  final isLoading = true.obs;

  /// PageController للسورة
  /// PageController for surah
  PageController _pageController = PageController(
    keepPage: true,
    viewportFraction: 1.0,
  );

  @override
  void onClose() {
    surahPages.close();
    currentSurah.close();
    isLoading.close();
    _pageController.dispose();
    super.onClose();
  }

  /// تحميل سورة محددة
  /// Load specific surah
  Future<void> loadSurah(int surahNumber) async {
    try {
      isLoading(true);

      // شرح: إعادة تعيين البيانات السابقة
      // Explanation: Reset previous data
      resetData();
      _surahNumber = surahNumber;

      // شرح: التأكد من تحميل القرآن الكامل أولاً
      // Explanation: Ensure full Quran is loaded first
      final quranCtrl = QuranCtrl.instance;
      if (quranCtrl.ayahs.isEmpty) {
        await quranCtrl.loadQuranDataV3();
      }

      // شرح: فلترة آيات السورة المطلوبة
      // Explanation: Filter required surah ayahs
      final selectedSurahAyahs = quranCtrl.ayahs
          .where((ayah) => ayah.surahNumber == surahNumber)
          .toList();

      log('Loading surah $surahNumber, found ${selectedSurahAyahs.length} ayahs',
          name: 'SurahCtrl');

      if (selectedSurahAyahs.isEmpty) {
        log('No ayahs found for surah $surahNumber', name: 'SurahCtrl');
        isLoading(false);
        return;
      }

      surahAyahs.assignAll(selectedSurahAyahs);

      // شرح: إنشاء معلومات السورة
      // Explanation: Create surah information
      currentSurah.value = _createSurahModel(selectedSurahAyahs.first);

      // شرح: تقسيم آيات السورة إلى صفحات باستخدام نفس منطق QuranCtrl
      // Explanation: Divide surah ayahs into pages using the same logic as QuranCtrl
      await _createSurahPages(selectedSurahAyahs);

      log('Created ${surahPages.length} pages for surah $surahNumber',
          name: 'SurahCtrl');

      isLoading(false);
      update();
    } catch (e) {
      log('Error loading surah: $e', name: 'SurahCtrl');
      isLoading(false);
    }
  }

  /// إنشاء صفحات السورة من بيانات QuranCtrl
  /// Create surah pages from QuranCtrl data
  Future<void> _createSurahPages(List<AyahModel> ayahs) async {
    surahPages.clear();

    if (ayahs.isEmpty) return;

    final quranCtrl = QuranCtrl.instance;

    final startPage = ayahs.first.page;
    final endPage = ayahs.last.page;
    if (startPage <= 0 || endPage <= 0) return;

    for (int page = startPage; page <= endPage; page++) {
      if (page - 1 < 0 || page - 1 >= quranCtrl.state.pages.length) continue;

      // فلترة آيات الصفحة لتكون من السورة فقط
      // Filter page ayahs to include only the target surah
      final pageAyahs = quranCtrl.state.pages[page - 1]
          .where((a) => a.surahNumber == _surahNumber)
          .toList(growable: false);

      if (pageAyahs.isEmpty) continue;

      surahPages.add(
        QuranPageModel(
          pageNumber: page,
          ayahs: pageAyahs,
          lines: const [],
          numberOfNewSurahs: page == startPage ? 1 : 0,
        ),
      );
    }
  }

  /// إنشاء نموذج السورة
  /// Create surah model
  SurahModel _createSurahModel(AyahModel firstAyah) {
    return SurahModel(
      surahNumber: firstAyah.surahNumber!,
      arabicName: firstAyah.arabicName!,
      englishName: firstAyah.englishName!,
      ayahs: surahAyahs,
    );
  }

  /// الانتقال لصفحة معينة
  /// Navigate to specific page
  void jumpToPage(int page) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController = PageController(
        initialPage: page,
        keepPage: true,
        viewportFraction: 1.0,
      );
    }
  }

  /// الحصول على PageController
  /// Get PageController
  PageController get pageController => _pageController;

  /// الحصول على اسم السورة
  /// Get surah name
  String getSurahName() {
    return currentSurah.value?.arabicName ?? 'السورة $_surahNumber';
  }

  /// الحصول على عدد صفحات السورة
  /// Get surah pages count
  int get pagesCount => surahPages.length;

  /// التحقق من أن الصفحة هي الأولى في السورة
  /// Check if page is first in surah
  bool isFirstPage(int pageIndex) => pageIndex == 0;

  /// التحقق من أن الصفحة هي الأولى في السورة
  /// Check if page is first in surah
  bool isFirstPageInFirstOrSecondSurah(int pageIndex, int surahNumber) =>
      (surahNumber == 1 || surahNumber == 2) && pageIndex == 0;

  /// التحقق من أن السورة ليست التوبة (لعرض البسملة)
  /// Check if surah is not At-Tawbah (for displaying Basmala)
  bool shouldShowBasmala() => (_surahNumber != 1) && (_surahNumber != 9);

  /// الحصول على رقم الصفحة الحقيقي في القرآن الكريم
  /// Get the real page number in the Quran
  int getRealQuranPageNumber(int surahPageIndex) {
    if (surahPageIndex < 0 || surahPageIndex >= surahPages.length) {
      return surahAyahs.isNotEmpty ? surahAyahs.first.page : 1;
    }

    // بعد إعادة بناء surahPages على صفحات المصحف الحقيقية، pageNumber هو الرقم الحقيقي.
    return surahPages[surahPageIndex].pageNumber;
  }

  /// الحصول على رقم الصفحة الحقيقي الحالي (الصفحة المعروضة حالياً)
  /// Get the current real page number (currently displayed page)
  int getCurrentRealQuranPageNumber() {
    if (!_pageController.hasClients) return getRealQuranPageNumber(0);

    final currentPageIndex = _pageController.page?.round() ?? 0;
    return getRealQuranPageNumber(currentPageIndex);
  }

  /// الحصول على نطاق الصفحات الحقيقية للسورة
  /// Get the real page range for the surah
  Map<String, int> getSurahRealPageRange() {
    if (surahAyahs.isEmpty) return {'start': 1, 'end': 1};

    final startPage = surahAyahs.first.page;
    final endPage = surahAyahs.last.page;

    return {
      'start': startPage,
      'end': endPage,
      'total': endPage - startPage + 1,
    };
  }

  /// إعادة تعيين البيانات
  /// Reset data
  void resetData() {
    surahPages.clear();
    surahAyahs.clear();
    currentSurah.value = null;
  }

  /// التحقق من أن الصفحة هي الأخيرة في السورة
  /// Check if page is the last in surah
  bool isLastPage(int pageIndex) {
    return pageIndex == surahPages.length - 1;
  }

  /// حساب عدد الأسطر المتوقع للصفحة الحالية بناءً على موقعها
  /// Calculate expected lines count for current page based on its position
  int getExpectedLinesCount(int pageIndex) {
    final actualLines = surahPages[pageIndex].lines.length;

    // شرح: إذا كانت الصفحة الأولى
    // Explanation: If it's the first page
    if (pageIndex == 0) {
      // شرح: الصفحة الأولى لها عدد أسطر أقل بسبب البنر والبسملة
      // Explanation: First page has fewer lines due to banner and basmala
      if (_surahNumber == 2) {
        return 6; // سورة البقرة
      } else if (_surahNumber == 9) {
        return 14; // سورة التوبة
      } else {
        return 13; // باقي السور
      }
    }

    // شرح: إذا كانت الصفحة الأخيرة
    // Explanation: If it's the last page
    if (isLastPage(pageIndex)) {
      // شرح: للصفحة الأخيرة نستخدم الحد الأقصى بين الأسطر الفعلية و10 أسطر لضمان توزيع جيد للمساحة
      // Explanation: For last page use maximum between actual lines and 10 lines to ensure good space distribution
      return math.max(actualLines, 15);
    }

    // شرح: للصفحات العادية
    // Explanation: For normal pages
    return 15;
  }

  /// حساب ارتفاع السطر الديناميكي للصفحة
  /// Calculate dynamic line height for page
  double calculateDynamicLineHeight({
    required double availableHeight,
    required int pageIndex,
    required bool hasHeader,
    required bool hasBasmala,
  }) {
    // شرح: حساب المساحة المستخدمة للعناصر الإضافية
    // Explanation: Calculate space used by additional elements
    double usedSpace = 0;

    if (hasHeader) {
      usedSpace += 80; // مساحة البنر
    }

    if (hasBasmala) {
      usedSpace += 50; // مساحة البسملة
    }

    // شرح: المساحة المتبقية للأسطر
    // Explanation: Remaining space for lines
    final remainingHeight = (availableHeight - usedSpace) *
        (surahNumber == 2 && pageIndex == 0 ? 0.40 : 0.95);

    // شرح: الحصول على عدد الأسطر المتوقع
    // Explanation: Get expected lines count
    final expectedLines = getExpectedLinesCount(pageIndex);

    // شرح: حساب ارتفاع السطر
    // Explanation: Calculate line height
    if (expectedLines > 0) {
      return pageIndex == 0 && shouldShowBasmala()
          ? remainingHeight / expectedLines + 9.3
          : pageIndex == 0 && surahNumber == 9
              ? remainingHeight / expectedLines + 5
              : remainingHeight / expectedLines;
    }

    // شرح: ارتفاع افتراضي
    // Explanation: Default height
    return 40.0;
  }

  /// الحصول على معلومات الصفحة الحالية
  /// Get current page information
  Map<String, dynamic> getCurrentPageInfo() {
    if (!_pageController.hasClients || surahPages.isEmpty) {
      return {
        'currentPageIndex': 0,
        'totalPages': surahPages.length,
        'isFirstPage': true,
        'isLastPage': surahPages.length <= 1,
        'expectedLines': surahPages.isNotEmpty ? getExpectedLinesCount(0) : 15,
        'actualLines': surahPages.isNotEmpty ? surahPages[0].lines.length : 0,
      };
    }

    final currentPageIndex = _pageController.page?.round() ?? 0;
    return {
      'currentPageIndex': currentPageIndex,
      'totalPages': surahPages.length,
      'isFirstPage': currentPageIndex == 0,
      'isLastPage': isLastPage(currentPageIndex),
      'expectedLines': getExpectedLinesCount(currentPageIndex),
      'actualLines': surahPages[currentPageIndex].lines.length,
      'realQuranPage': getRealQuranPageNumber(currentPageIndex),
    };
  }
}
