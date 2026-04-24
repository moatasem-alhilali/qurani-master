part of '/quran.dart';

/// Extensions on [QuranCtrl] that provides getters
/// for [QuranCtrl]'s properties.
extension QuranGetters on QuranCtrl {
  /// -------- [Getter] ----------

  /// Get current recitation based on fontsSelected value
  QuranRecitation get currentRecitation =>
      QuranRecitation.fromIndex(state.fontsSelected.value);

  /// Get current font family for the selected recitation
  String get currentFontFamily => currentRecitation.fontFamily;

  // شرح: تحسين PageController للحصول على أداء أفضل
  // Explanation: Optimized PageController for better performance
  PreloadPageController get quranPagesController {
    // إذا لم يكن الـ controller مُهيأً بعد، أنشئه
    // لا تتحقق من hasClients هنا لأن ذلك يسبب إعادة إنشاء الـ controller
    // قبل أن يتم ربطه بالـ PageView
    QuranCtrl.instance._pageController ??= PreloadPageController(
      initialPage: (_quranRepository.getLastPage() ?? 1) - 1,
      keepPage: true,
      viewportFraction: 1.0,
    );
    return QuranCtrl.instance._pageController!;
  }

  set quranPagesController(PreloadPageController controller) {
    // حفظ الـ controller الجديد
    // إذا كان هناك controller قديم، قم بالتخلص منه أولاً
    if (QuranCtrl.instance._pageController != null &&
        QuranCtrl.instance._pageController!.hasClients) {
      try {
        QuranCtrl.instance._pageController!.dispose();
      } catch (_) {
        // تجاهل الأخطاء إذا كان قد تم التخلص منه مسبقاً
      }
    }
    QuranCtrl.instance._pageController = controller;
  }

  RxBool get isDownloadedFonts => state.fontsReady;

  bool get isPreparingDownloadFonts =>
      state.fontsSelected.value == 0 && !state.fontsReady.value;

  /// اختيار قراءة/خط المصحف باستخدام [QuranRecitation] كمصدر الحقيقة.
  ///
  /// خطوط التجويد تُحمّل ديناميكيًا عبر [QuranFontsService] عند الاختيار.
  Future<void> selectRecitation(
    QuranRecitation recitation, {
    bool isFontsLocal = false,
  }) async {
    final int idx = recitation.recitationIndex;

    if (state.fontsSelected.value == idx) {
      return;
    }

    state.fontsSelected.value = idx;
    GetStorage().write(_StorageConstants().fontsSelected, idx);

    Get.forceAppUpdate();

    if (idx == 0 && !QuranFontsService.allLoaded) {
      // خطوط التجويد: تحميل كسول — الصفحات القريبة أولاً ثم البقية في الخلفية
      final currentPage = lastPage.clamp(1, 604);
      QuranFontsService.ensurePagesLoaded(currentPage, radius: 10).then((_) {
        // update();
        // update(['_pageViewBuild']);
        // تحميل بقية الصفحات في الخلفية
        QuranFontsService.loadRemainingInBackground(
          startNearPage: currentPage,
          progress: state.fontsLoadProgress,
          ready: state.fontsReady,
        ).then((_) {
          // update();
          update(['_pageViewBuild']);
        });
      });
    }
  }

  /// تبديل نوع الخط وتحميله إذا لم يكن محملاً من قبل
  ///
  /// Switch font type and download it if not already downloaded
  Future<void> switchFontType({required int fontIndex}) async {
    // إعادة التحقق من حالة التحميل من التخزين
    // Re-check download status from storage
    final storageValue =
        GetStorage().read<bool>(_StorageConstants().isDownloadedCodeV4Fonts);
    state.isFontDownloaded.value = storageValue ?? false;

    await selectRecitation(QuranRecitation.fromIndex(fontIndex));
  }

  // List<int> get _topOfThePageIndex => [
  //       435,
  //       583,
  //     ];

  /// Returns a list of lists of AyahModel, where each sublist contains Ayahs
  /// that are separated by a Basmalah, for the given page index.
  ///
  /// Parameters:
  ///   pageIndex (int): The index of the page for which to retrieve the Ayahs.
  ///
  /// Returns:
  ///   `List<List<AyahModel>>`: A list of lists of AyahModel, where each
  ///   sublist contains Ayahs separated by a Basmalah.
  List<List<AyahModel>> getCurrentPageAyahsSeparatedForBasmalah(
          int pageIndex) =>
      state.pages[pageIndex]
          .splitBetween((f, s) => f.ayahNumber > s.ayahNumber)
          .toList();
  List<List<LineModel>> getCurrentPageAyahsSeparatedForBasmalahQcfV1AsLines(
      int pageIndex) {
    final allLines = staticPages[pageIndex].lines.splitBetween((f, s) {
      return f.ayahs.first.ayahNumber > s.ayahs.first.ayahNumber;
    }).toList();
    log('All lines length: ${allLines.length}');
    return allLines;
  }

  /// Retrieves a list of AyahModel for a specific page index.
  ///
  /// Parameters:
  ///   pageIndex (int): The index of the page for which to retrieve the Ayahs.
  ///
  /// Returns:
  ///   `List<AyahModel>`: A list of AyahModel representing the Ayahs on the specified page.
  List<AyahModel> getPageAyahsByIndex(int pageIndex) => state.pages[pageIndex];

  /// get page number by ayah unique number

  int getPageNumberByAyahUqNumber(int ayahUnequeNumber) => state.pages
          .firstWhere(
              (p) =>
                  p.isEmpty == false &&
                  p.any((a) => a.ayahUQNumber == ayahUnequeNumber),
              orElse: () => [])
          .isEmpty
      ? 1
      : state.pages.indexOf(state.pages.firstWhere(
              (p) => p.any((a) => a.ayahUQNumber == ayahUnequeNumber))) +
          1;

  /// get page number by ayah number

  int getPageNumberByAyahNumber(int ayahNumber) => state.pages
          .firstWhere(
              (p) =>
                  p.isEmpty == false &&
                  p.any((a) => a.ayahNumber == ayahNumber),
              orElse: () => [])
          .isEmpty
      ? 1
      : state.pages.indexOf(state.pages
              .firstWhere((p) => p.any((a) => a.ayahNumber == ayahNumber))) +
          1;

  int getPageNumberByAyahAndSurahNumber(int ayahNumber, int surahNumber) {
    // التحقق من صحة المدخلات
    if (surahNumber < 1) return 1;
    if (surahNumber > 114) return 114;

    try {
      final ayah = surahs[surahNumber - 1].ayahs.firstWhere(
            (p) => p.ayahNumber == ayahNumber,
          );

      log('Ayah found: Surah $surahNumber, Ayah $ayahNumber, Page ${ayah.page}');

      return ayah.page > 0 ? ayah.page : 1;
    } catch (e) {
      return 1; // إرجاع الصفحة الأولى في حالة حدوث خطأ
    }
  }

  /// will return the surah number of the first ayahs..
  /// even if the page contains another surah.
  int getSurahNumberFromPage(int pageNumber) => surahs
      .firstWhere(
          (s) => s.ayahs.firstWhereOrNull((a) => a.page == pageNumber) != null)
      .surahNumber;

  /// Retrieves a list of Surahs present on a specific page.
  ///
  /// Parameters:
  ///   pageNumber (int): The index of the page for which to retrieve the Surahs.
  ///
  /// Returns:
  ///   `List<SurahModel>`: A list of SurahModel representing the Surahs on the specified page.
  List<SurahModel> getSurahsByPageNumber(int pageNumber) {
    if (getPageAyahsByIndex(pageNumber - 1).isEmpty) return [];
    List<AyahModel> pageAyahs = getPageAyahsByIndex(pageNumber - 1);
    List<SurahModel> surahsOnPage = [];
    for (AyahModel ayah in pageAyahs) {
      SurahModel surah = surahs.firstWhere(
          (s) => s.ayahs.any((a) => a.ayahUQNumber == ayah.ayahUQNumber),
          orElse: () => SurahModel(
                surahNumber: 1,
                arabicName: 'Unknown',
                englishName: 'Unknown',
                revelationType: 'Unknown',
                ayahs: [],
              ));
      if (!surahsOnPage.any((s) => s.surahNumber == surah.surahNumber) &&
          surah.surahNumber != -1) {
        surahsOnPage.add(surah);
      }
    }
    return surahsOnPage;
  }

  /// Retrieves the current Surah data for a given page number.
  ///
  /// This method returns the SurahModel of the first Ayah on the specified page.
  /// It uses the Ayah data on the page to determine which Surah the page belongs to.
  ///
  /// Parameters:
  ///   pageNumber (int): The number of the page for which to retrieve the Surah.
  ///
  /// Returns:
  ///   `SurahModel`: The SurahModel representing the Surah of the first Ayah on the specified page.
  SurahModel getCurrentSurahByPageNumber(int pageNumber) {
    final firstAyah = getPageAyahsByIndex(pageNumber - 1).first;
    return surahs.firstWhere(
      (s) => s.ayahs.any((a) => a.ayahUQNumber == firstAyah.ayahUQNumber),
      orElse: () => surahs.first,
    );
  }

  /// Retrieves the Surah data for a given Ayah.
  ///
  /// This method returns the SurahModel of the Surah that contains the given Ayah.
  /// يستخدم [ayahUQNumber] للمقارنة بدلاً من المساواة المرجعية.
  ///
  /// Parameters:
  ///   ayah (AyahModel): The Ayah for which to retrieve the Surah data.
  ///
  /// Returns:
  ///   `SurahModel`: The SurahModel representing the Surah of the given Ayah.
  SurahModel getSurahDataByAyah(AyahModel ayah) => surahs.firstWhere(
        (s) => s.ayahs.any((a) => a.ayahUQNumber == ayah.ayahUQNumber),
        orElse: () => surahs.first,
      );

  /// Retrieves the Surah data for a given unique Ayah number.
  ///
  /// This method returns the SurahModel of the Surah that contains
  /// the Ayah with the specified unique number.
  ///
  /// Parameters:
  ///   ayah (int): The unique number of the Ayah for which to retrieve
  ///   the Surah data.
  ///
  /// Returns:
  ///   `SurahModel`: The SurahModel representing the Surah containing
  ///   the Ayah with the given unique number.
  SurahModel getSurahDataByAyahUQ(int ayah) =>
      surahs.firstWhere((s) => s.ayahs.any((a) => a.ayahUQNumber == ayah));

  /// Retrieves the Juz data for a given page number.
  ///
  /// This method returns the AyahModel of the Juz that contains the
  /// first Ayah on the specified page.
  ///
  /// Parameters:
  ///   page (int): The page number for which to retrieve the Juz data.
  ///
  /// Returns:
  ///   `AyahModel`: The AyahModel representing the Juz of the first
  ///   Ayah on the specified page. If no Ayah is found, an empty AyahModel
  ///   is returned.
  AyahModel getJuzByPage(int page) {
    return state.allAyahs.firstWhere(
      (a) => a.page == page + 1,
      orElse: () => AyahModel.empty(),
    );
  }

  AyahModel getJuzStartPage(int juzNumber) {
    return state.allAyahs.firstWhere(
      (a) => a.juz == juzNumber,
      orElse: () => AyahModel.empty(),
    );
  }

  AyahModel getHizbStartPage(int hizbNumber) {
    return state.allAyahs.firstWhere(
      (a) => a.hizb == hizbNumber,
      orElse: () => AyahModel.empty(),
    );
  }

  AyahModel getSingleAyahByAyahAndSurahNumber(int ayahNumber, int surahNumber) {
    return surahs[surahNumber - 1].ayahs.firstWhere(
          (ayah) => ayah.ayahNumber == ayahNumber,
          orElse: () => AyahModel.empty(),
        );
  }

  /// Retrieves the display string for the Hizb quarter of the given page number.
  ///
  /// This method returns a string indicating the Hizb quarter of the given page number.
  /// It takes into account whether the Hizb quarter is new or the same as the previous page's Hizb quarter,
  /// and formats the string accordingly.
  ///
  /// Parameters:
  ///    pageNumber (int): The page number for which to retrieve the Hizb quarter display string.
  ///
  /// Returns:
  ///   `String`: A string indicating the Hizb quarter of the given page number.
  String getHizbQuarterDisplayByPage(int pageNumber) {
    final List<AyahModel> currentPageAyahs =
        state.allAyahs.where((ayah) => ayah.page == pageNumber).toList();
    if (currentPageAyahs.isEmpty) return "";

    // Find the highest Hizb quarter on the current page
    int? currentMaxHizbQuarter =
        currentPageAyahs.map((ayah) => ayah.hizb!).reduce(math.max);

    // Store/update the highest Hizb quarter for this page
    state.pageToHizbQuarterMap[pageNumber] = currentMaxHizbQuarter;

    // For displaying the Hizb quarter, check if this is a new Hizb quarter different from the previous page's Hizb quarter
    // For the first page, there is no "previous page" to compare, so display its Hizb quarter
    if (pageNumber == 1 ||
        state.pageToHizbQuarterMap[pageNumber - 1] != currentMaxHizbQuarter) {
      int hizbNumber = ((currentMaxHizbQuarter - 1) ~/ 4) + 1;
      int quarterPosition = (currentMaxHizbQuarter - 1) % 4;

      switch (quarterPosition) {
        case 0:
          return "الحزب ${'$hizbNumber'.convertNumbersAccordingToLang()}";
        case 1:
          return "١/٤ الحزب ${'$hizbNumber'.convertNumbersAccordingToLang()}";
        case 2:
          return "١/٢ الحزب ${'$hizbNumber'.convertNumbersAccordingToLang()}";
        case 3:
          return "٣/٤ الحزب ${'$hizbNumber'.convertNumbersAccordingToLang()}";
        default:
          return "";
      }
    }

    // If the page's Hizb quarter is the same as the previous page, do not display it again
    return "";
  }

  /// Determines if there is a Sajda (prostration) on the given page of Ayahs.
  ///
  /// This function iterates through a list of AyahModel representing Ayahs on a page,
  /// checking if any Ayah contains a Sajda. If a Sajda is found, and it is either recommended or obligatory,
  /// the function updates the application state to indicate the presence of a Sajda on the page.
  ///
  /// Parameters:
  ///   pageAyahs (`List<AyahModel>`): The list of Ayahs to check for Sajda.
  ///
  /// Returns:
  ///   `bool`: A boolean value indicating whether a Sajda is present on the page.
  // bool getSajdaInfoForPage(List<AyahModel> pageAyahs) {
  //   for (var ayah in pageAyahs) {
  //     if (ayah.sajda != false && ayah.sajda is Map) {
  //       var sajdaDetails = ayah.sajda;
  //       if (sajdaDetails['recommended'] == true ||
  //           sajdaDetails['obligatory'] == true) {
  //         return state.isSajda.value = true;
  //       }
  //     }
  //   }
  //   // No sajda found on this page
  //   return
  // }

  /// Retrieves the list of Ayahs on the current page.
  ///
  /// This method returns the list of Ayahs on the page currently being viewed.
  ///
  /// Returns:
  ///   `List<AyahModel>`: The list of Ayahs on the current page.
  List<AyahModel> get currentPageAyahs =>
      state.pages[state.currentPageNumber.value];

  /// Retrieves the Ayah with a Sajda (prostration) on the given page.
  ///
  /// This method returns the AyahModel of the first Ayah on the given page
  /// that contains a Sajda. If no Sajda is found on the page, the method returns null.
  ///
  /// Parameters:
  ///   pageIndex (int): The index of the page for which to retrieve the Ayah with a Sajda.
  ///   isSurah (bool): Whether this is being called for a surah display (default: false).
  ///   surahNumber (int): The surah number if isSurah is true.
  ///
  /// Returns:
  ///   `AyahModel?`: The AyahModel of the first Ayah on the given page that contains a Sajda, or null if no Sajda is found.
  bool isThereAnySajdaInPage(
    int pageIndex,
  ) {
    if (pageIndex > 0 || pageIndex < state.pages.length) {
      return state.pages[pageIndex].any((ayah) {
        if (ayah.sajda != false) {
          if (ayah.sajda is Map) {
            var sajdaDetails = ayah.sajda;
            if (sajdaDetails['recommended'] == true ||
                sajdaDetails['obligatory'] == true) {
              return true;
            }
          } else if (ayah.sajda == true) {
            return true;
          }
        }
        return false;
      });
    }
    return false;
  }

  /// Checks if the current Surah number matches the specified Surah number.
  ///
  /// This method compares the Surah number of the current page with the given Surah number.
  ///
  /// Parameters:
  ///   surahNum (int): The number of the Surah to compare with the current Surah.
  ///
  /// Returns:
  ///   `bool`: true if the current Surah number matches the specified Surah number, false otherwise.
  bool getCurrentSurahNumber(int surahNum) =>
      getCurrentSurahByPageNumber(state.currentPageNumber.value).surahNumber -
          1 ==
      surahNum;

  /// Retrieves the unique Ayah number for a specific Ayah on a given page.
  int getAyahUnqNumberByPageAndIndex(int page, int index) =>
      state.pages[page - 1][index].ayahUQNumber;

  /// Retrieves the unique Ayah number for a specific Ayah given its Surah and Ayah numbers.
  int getAyahUnqNumberBySurahAndAyahNumber(int surahNumber, int ayahNumber) =>
      state.allAyahs
          .firstWhere(
              (a) => a.surahNumber == surahNumber && a.ayahNumber == ayahNumber)
          .ayahUQNumber;

  /// Checks if the current Juz number matches the specified Juz number.
  ///
  /// This method compares the Juz number of the current page with the given Juz number.
  ///
  /// Parameters:
  ///   juzNum (int): The number of the Juz to compare with the current Juz.
  ///
  /// Returns:
  ///   `bool`: true if the current Juz number matches the specified Juz number, false otherwise.
  bool getCurrentJuzNumber(int juzNum) =>
      getJuzByPage(state.currentPageNumber.value).juz - 1 == juzNum;

  /// Checks if the fonts are downloaded locally.
  ///
  /// This method returns a boolean indicating whether the fonts are downloaded locally.
  ///
  /// Returns:
  ///   `bool`: true if the fonts are downloaded, false otherwise.
  /// الخطوط المضغوطة تُحمّل عبر [QuranFontsService]
  bool get isDownloadFonts =>
      state.fontsSelected.value == 0 && !state.fontsReady.value;

  void showControlToggle({bool enableMultiSelect = false}) {
    state.isShowMenu.value = false;
    if (!enableMultiSelect) {
      if (AudioCtrl.instance.state.isPlaying.value) {
        isShowControl.toggle();
        update([
          'isShowControl',
          'selection_page_${state.currentPageNumber.value}'
        ]);
      } else if (selectedAyahsByUnequeNumber.isNotEmpty) {
        clearSelection();
      } else {
        clearSelection();
        isShowControl.toggle();
        update([
          'isShowControl',
          'selection_page_${state.currentPageNumber.value}'
        ]);
      }
    }
  }

  // -------- [Display Mode] ----------

  /// الوضع الحالي للعرض
  /// Current display mode
  QuranDisplayMode get currentDisplayMode => state.displayMode.value;

  /// تعيين وضع العرض مع الحفظ في التخزين المحلي
  /// Set display mode and persist to local storage
  void setDisplayMode(QuranDisplayMode mode) {
    if (state.displayMode.value == mode) return;

    // حفظ الصفحة الحالية قبل تغيير الوضع لمنع العودة للصفحة الأولى
    // Save current page before mode switch to prevent jumping to page 1
    int currentPage = state.currentPageNumber.value - 1;
    if (quranPagesController.hasClients) {
      final double? p = quranPagesController.page;
      if (p != null) currentPage = p.round();
    }
    currentPage = currentPage.clamp(0, 603);

    // تحديث رقم الصفحة وحفظه في التخزين لضمان عدم فقدانه عند إعادة إنشاء الـ controller
    state.currentPageNumber.value = currentPage + 1;
    saveLastPage(currentPage + 1);

    // إعادة إنشاء الـ controller بالصفحة الحالية
    final oldController = quranPagesController;
    quranPagesController = PreloadPageController(
      initialPage: currentPage,
      keepPage: true,
      viewportFraction: 1.0,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (oldController != quranPagesController) oldController.dispose();
      } catch (_) {}
    });

    state.displayMode.value = mode;
    GetStorage().write(_StorageConstants().displayMode, mode.storageIndex);
    update(['display_mode', 'quran_display_content']);
  }

  /// تحميل آخر وضع عرض محفوظ من التخزين المحلي
  /// Load saved display mode from local storage
  void loadSavedDisplayMode() {
    final saved = GetStorage().read<int>(_StorageConstants().displayMode);
    if (saved != null) {
      state.displayMode.value =
          QuranDisplayModeExtension.fromStorageIndex(saved);
    }
  }

  /// الأوضاع المتاحة حسب الاتجاه وحجم الشاشة
  /// Available modes based on orientation and screen size
  List<QuranDisplayMode> getAvailableModes(BuildContext context) {
    return QuranDisplayModeExtension.availableModes(context);
  }

  List<TajweedRuleModel> getTajweedRulesListForLanguage({
    required String languageCode,
    String fallbackLanguageCode = 'ar',
  }) {
    final Map<String, dynamic> root = tajweedRules.first;
    final List<dynamic> rules = (root['rules'] as List<dynamic>?) ?? const [];

    return rules
        .whereType<Map<String, dynamic>>()
        .map((r) => TajweedRuleModel.fromJson(r).forLanguage(
              languageCode,
              fallbackLanguageCode: fallbackLanguageCode,
            ))
        .toList(growable: false);
  }
}

extension SplitBetweenExtension<T> on List<T> {
  List<List<T>> splitBetween(bool Function(T first, T second) condition) {
    if (isEmpty) return []; // إذا كانت القائمة فارغة، إرجاع قائمة فارغة.

    List<List<T>> result = []; // قائمة النتيجة التي ستحتوي على القوائم الفرعية.
    List<T> currentGroup = [first]; // المجموعة الحالية تبدأ بالعنصر الأول.

    for (int i = 1; i < length; i++) {
      if (condition(this[i - 1], this[i])) {
        // إذا تحقق الشرط، أضف المجموعة الحالية إلى النتيجة.
        result.add(currentGroup);
        currentGroup = []; // ابدأ مجموعة جديدة.
      }
      currentGroup.add(this[i]); // أضف العنصر الحالي إلى المجموعة.
    }

    if (currentGroup.isNotEmpty) {
      result.add(currentGroup); // أضف المجموعة الأخيرة.
    }

    return result;
  }
}
