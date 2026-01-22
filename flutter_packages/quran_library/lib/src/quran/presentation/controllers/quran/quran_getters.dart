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
  PageController get quranPagesController {
    // إذا لم يكن الـ controller مُهيأً بعد، أنشئه
    // لا تتحقق من hasClients هنا لأن ذلك يسبب إعادة إنشاء الـ controller
    // قبل أن يتم ربطه بالـ PageView
    QuranCtrl.instance._pageController ??= PageController(
      initialPage: (_quranRepository.getLastPage() ?? 1) - 1,
      keepPage: true,
      viewportFraction: 1.0,
    );
    return QuranCtrl.instance._pageController!;
  }

  set quranPagesController(PageController controller) {
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

  RxBool get isDownloadedFonts =>
      currentRecitation.requiresDownload ? true.obs : false.obs;

  bool get isPreparingDownloadFonts => state.isPreparingDownload.value;

  /// اختيار قراءة/خط المصحف باستخدام [QuranRecitation] كمصدر الحقيقة.
  ///
  /// - يحافظ على التوافق مع النظام الحالي المعتمد على `fontsSelected`.
  /// - يراعي الويب: لا تنزيلات، التحميل يكون عند الحاجة.
  /// - يراعي حالة الخطوط المحلية [isFontsLocal] عند دمج المكتبة داخل تطبيقات أخرى.
  Future<void> selectRecitation(
    QuranRecitation recitation, {
    bool isFontsLocal = false,
  }) async {
    state.loadedFontPages.clear();
    final int idx = recitation.recitationIndex;

    final bool isAvailable = !recitation.requiresDownload ||
        kIsWeb ||
        isFontsLocal ||
        state.fontsDownloadedList.contains(idx) ||
        (state.isFontDownloaded.value && state.fontsDownloadedList.isEmpty);

    if (!isAvailable) {
      // الواجهة هي التي ستعرض خيار التحميل؛ هنا نتجنب تغيير الحالة إلى وضع غير متاح.
      log('Recitation not available yet (needs download): $idx',
          name: 'QuranGetters');
      return;
    }

    if (state.fontsSelected.value == idx) {
      return;
    }

    state.fontsSelected.value = idx;
    GetStorage().write(_StorageConstants().fontsSelected, idx);

    // للخطوط التي تتطلب تحميل: حضّر الـ Isolate والصفحة الحالية
    if (!kIsWeb && recitation.requiresDownload) {
      await initFontLoader();
    }

    Get.forceAppUpdate();

    if (recitation.requiresDownload) {
      // حضّر الخطوط للصفحة الحالية والصفحات المجاورة
      await prepareFonts((_quranRepository.getLastPage() ?? 1),
          isFontsLocal: isFontsLocal);
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

  List<int> get _topOfThePageIndex => [
        435,
        583,
      ];

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
      final ayah = state.surahs[surahNumber - 1].ayahs.firstWhere(
        (p) => p.ayahNumber == ayahNumber,
      );

      return ayah.page > 0 ? ayah.page : 1;
    } catch (e) {
      return 1; // إرجاع الصفحة الأولى في حالة حدوث خطأ
    }
  }

  /// will return the surah number of the first ayahs..
  /// even if the page contains another surah.
  int getSurahNumberFromPage(int pageNumber) => state.surahs
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
      SurahModel surah = state.surahs.firstWhere((s) => s.ayahs.contains(ayah),
          orElse: () => SurahModel(
                surahNumber: 1,
                arabicName: 'Unknown',
                englishName: 'Unknown',
                revelationType: 'Unknown',
                ayahs: [],
                isDownloadedFonts: false,
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
  SurahModel getCurrentSurahByPageNumber(int pageNumber) =>
      state.surahs.firstWhere(
          (s) => s.ayahs.contains(getPageAyahsByIndex(pageNumber - 1).first));

  /// Retrieves the Surah data for a given Ayah.
  ///
  /// This method returns the SurahModel of the Surah that contains the given Ayah.
  ///
  /// Parameters:
  ///   ayah (AyahModel): The Ayah for which to retrieve the Surah data.
  ///
  /// Returns:
  ///   `SurahModel`: The SurahModel representing the Surah of the given Ayah.
  SurahModel getSurahDataByAyah(AyahModel ayah) =>
      state.surahs.firstWhere((s) => s.ayahs.contains(ayah));

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
  SurahModel getSurahDataByAyahUQ(int ayah) => state.surahs
      .firstWhere((s) => s.ayahs.any((a) => a.ayahUQNumber == ayah));

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

  AyahModel getSingleAyahByAyahAndSurahNumber(int ayahNumber, int surahNumber) {
    return state.surahs[surahNumber - 1].ayahs.firstWhere(
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
  bool get isDownloadFonts => currentRecitation.requiresDownload;

  void showControlToggle({bool enableMultiSelect = false}) {
    state.isShowMenu.value = false;
    if (!enableMultiSelect) {
      if (AudioCtrl.instance.state.isPlaying.value) {
        isShowControl.toggle();
        update(['isShowControl']);
      } else if (selectedAyahsByUnequeNumber.isNotEmpty) {
        clearSelection();
      } else {
        clearSelection();
        isShowControl.toggle();
        update(['isShowControl']);
      }
    }
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
