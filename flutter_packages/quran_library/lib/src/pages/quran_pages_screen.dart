part of '/quran.dart';

/// شاشة لعرض صفحة واحدة أو مجموعة صفحات محددة من المصحف
///
/// - مرر [page] لعرض صفحة واحدة (1..604)
/// - أو مرر [startPage] و [endPage] لعرض نطاق صفحات (1..604)
///
/// بقية الخصائص مطابقة تقريبًا لـ [QuranLibraryScreen] لضمان التوافق والمرونة.
class QuranPagesScreen extends StatelessWidget {
  const QuranPagesScreen({
    super.key,
    // التخصيص العام
    this.appBar,
    this.ayahIconColor,
    this.ayahSelectedBackgroundColor,
    this.ayahSelectedFontColor,
    this.bannerStyle,
    this.basmalaStyle,
    this.backgroundColor,
    this.bookmarkList = const [],
    this.bookmarksColor,
    this.circularProgressWidget,
    this.downloadFontsDialogStyle,
    this.isDark = false,
    this.appLanguageCode,
    this.onAyahLongPress,
    this.onPageChanged,
    this.onPagePress,
    this.onSurahBannerPress,
    this.showAyahBookmarkedIcon = true,
    this.surahInfoStyle,
    this.surahNameStyle,
    this.surahNumber,
    this.textColor,
    this.singleAyahTextColors,
    this.useDefaultAppBar = true,
    this.withPageView = true,
    this.isFontsLocal = false,
    this.fontsName = '',
    this.ayahBookmarked = const [],
    this.ayahStyle,
    this.surahStyle,
    this.isShowAudioSlider = true,
    this.appIconUrlForPlayAudioInBackground,
    this.topBarStyle,
    this.tajweedMenuStyle,
    // تحديد الصفحات
    this.page,
    this.startPage,
    this.endPage,
    this.enableMultiSelect = false,
    this.highlightedAyahs = const [],
    this.highlightedAyahNumbersBySurah = const {},
    this.highlightedAyahNumbersInPages = const [],
    this.highlightedRanges = const [],
    this.highlightedRangesText = const [],
    required this.parentContext,
    this.indexTabStyle,
    this.searchTabStyle,
    this.ayahLongClickStyle,
    this.tafsirStyle,
    this.ayahDownloadManagerStyle,
    this.topBottomQuranStyle,
    this.snackBarStyle,
    this.ayahMenuStyle,
    this.bookmarksTabStyle,
  }) : assert(
          (page != null && startPage == null && endPage == null) ||
              (page == null && (startPage != null || endPage != null)),
          'حدد إما page لصفحة واحدة أو startPage/endPage لنطاق صفحات',
        );

  // ——— نفس خصائص شاشة المصحف الافتراضية تقريبًا ———
  final PreferredSizeWidget? appBar;
  final Color? ayahIconColor;
  final Color? ayahSelectedBackgroundColor;
  final Color? ayahSelectedFontColor;
  final BasmalaStyle? basmalaStyle;
  final BannerStyle? bannerStyle;
  final List bookmarkList;
  final Color? bookmarksColor;
  final Color? backgroundColor;
  final Widget? circularProgressWidget;
  final DownloadFontsDialogStyle? downloadFontsDialogStyle;
  final bool isDark;
  final String? appLanguageCode;
  final Function(int pageNumber)? onPageChanged;
  final VoidCallback? onPagePress;
  final void Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final void Function(SurahNamesModel surah)? onSurahBannerPress;
  final bool showAyahBookmarkedIcon;
  final int? surahNumber;
  final SurahInfoStyle? surahInfoStyle;
  final SurahNameStyle? surahNameStyle;
  final Color? textColor;
  final List<Color?>? singleAyahTextColors;
  final bool useDefaultAppBar;
  final bool withPageView;
  final bool? isFontsLocal;
  final String? fontsName;
  final List<int>? ayahBookmarked;
  final AyahAudioStyle? ayahStyle;
  final SurahAudioStyle? surahStyle;
  final bool? isShowAudioSlider;
  final String? appIconUrlForPlayAudioInBackground;
  final QuranTopBarStyle? topBarStyle;

  /// تخصيص نمط نافذة/قائمة أحكام التجويد
  final TajweedMenuStyle? tajweedMenuStyle;
  final BuildContext parentContext;

  /// تخصيص نمط تبويب الفهرس الخاص بالمصحف
  ///
  /// [indexTabStyle] Index tab style customization for the Quran
  final IndexTabStyle? indexTabStyle;

  /// تخصيص نمط تبويب البحث الخاص بالمصحف
  ///
  /// [searchTabStyle] Search tab style customization for the Quran
  final SearchTabStyle? searchTabStyle;

  final TafsirStyle? tafsirStyle;
  // تمكين تظليل/تحديد متعدد للآيات داخل هذه الشاشة فقط
  final bool enableMultiSelect;
  // قائمة أرقام الآيات الفريدة المراد تظليلها برمجياً
  final List<int> highlightedAyahs;
  // تظليل بحسب (رقم السورة -> قائمة أرقام الآيات داخل السورة)
  final Map<int, List<int>> highlightedAyahNumbersBySurah;
  // تظليل بحسب نطاق الصفحات مع أرقام آيات داخل السطر
  // مثال: [(start:6,end:11, ayahs:[1,3,5])]
  final List<({int start, int end, List<int> ayahs})>
      highlightedAyahNumbersInPages;
  // نطاقات عبر السور: من سورة/آية إلى سورة/آية
  // مثال: (startSurah:2,startAyah:15,endSurah:3,endAyah:25)
  final List<({int startSurah, int startAyah, int endSurah, int endAyah})>
      highlightedRanges;
  // صيغ نصية "2:15-3:25" (تدعم أرقام عربية أيضًا)
  final List<String> highlightedRangesText;

  /// تخصيص نمط الضغط المطوّل على الآية
  /// [ayahLongClickStyle] Long press style customization for ayahs
  final AyahMenuStyle? ayahLongClickStyle;

  // تخصيص نمط التنزيل الآيات
  /// [ayahDownloadManagerStyle] Ayah download manager style customization
  final AyahDownloadManagerStyle? ayahDownloadManagerStyle;

  // تخصيص نمط الجزء العلوي والسفلي للمصحف
  /// [topBottomQuranStyle] top/bottom style customization for the Quran
  final TopBottomQuranStyle? topBottomQuranStyle;

  /// تخصيص نمط Snackbar الخاص بالمكتبة
  /// [snackBarStyle] SnackBar style customization for the library
  final SnackBarStyle? snackBarStyle;

  /// تخصيص نمط الضغط المطوّل على الآية
  /// [ayahMenuStyle] Long press style customization for ayahs
  final AyahMenuStyle? ayahMenuStyle;

  /// تخصيص نمط تبويب الفواصل الخاص بالمصحف
  ///
  /// [bookmarksTabStyle] Bookmarks tab style customization for the Quran
  final BookmarksTabStyle? bookmarksTabStyle;

  // ——— تحديد صفحة واحدة أو نطاق صفحات ———
  final int? page; // 1..604
  final int? startPage; // 1..604
  final int? endPage; // 1..604 (شامل)

  // تحويل الإدخال إلى نطاق فعلي صالح (1..604)
  (int start, int end) _resolveRange() {
    int sp = page ?? startPage ?? 1;
    int ep = page ?? endPage ?? sp;
    // ضمان صحة القيم
    sp = sp.clamp(1, 604);
    ep = ep.clamp(1, 604);
    if (sp > ep) {
      final t = sp;
      sp = ep;
      ep = t;
    }
    return (sp, ep);
  }

  @override
  Widget build(BuildContext context) {
    // تحديث رابط أيقونة التطبيق إذا وُجد
    if (appIconUrlForPlayAudioInBackground != null &&
        appIconUrlForPlayAudioInBackground!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          AudioCtrl.instance
              .updateAppIconUrl(appIconUrlForPlayAudioInBackground!);
        }
      });
    }

    // إعداد وضع التحديد المتعدد والتظليل الخارجي (بدون Stateful)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      final ctrl = QuranCtrl.instance;
      ctrl.setMultiSelectMode(enableMultiSelect);
      final combined = <int>{};
      if (highlightedAyahs.isNotEmpty) {
        combined.addAll(highlightedAyahs);
      }
      if (highlightedAyahNumbersBySurah.isNotEmpty) {
        highlightedAyahNumbersBySurah.forEach((surah, ayahs) {
          for (final n in ayahs) {
            final id = ctrl.getAyahUQBySurahAndAyah(surah, n);
            if (id != null) combined.add(id);
          }
        });
      }
      if (highlightedAyahNumbersInPages.isNotEmpty) {
        for (final item in highlightedAyahNumbersInPages) {
          combined.addAll(ctrl.getAyahUQsForPagesByAyahNumbers(
              startPage: item.start,
              endPage: item.end,
              ayahNumbers: item.ayahs));
        }
      }
      if (highlightedRanges.isNotEmpty) {
        for (final r in highlightedRanges) {
          combined.addAll(ctrl.getAyahUQsForSurahAyahRange(
            startSurah: r.startSurah,
            startAyah: r.startAyah,
            endSurah: r.endSurah,
            endAyah: r.endAyah,
          ));
        }
      }
      if (highlightedRangesText.isNotEmpty) {
        for (final s in highlightedRangesText) {
          final parsed = ctrl.parseSurahAyahRangeString(s);
          if (parsed != null) {
            combined.addAll(ctrl.getAyahUQsForSurahAyahRange(
              startSurah: parsed.$1,
              startAyah: parsed.$2,
              endSurah: parsed.$3,
              endAyah: parsed.$4,
            ));
          }
        }
      }
      if (combined.isNotEmpty) {
        ctrl.setExternalHighlights(combined.toList());
      }
    });

    final (sp, ep) = _resolveRange();
    final int startIndex = sp - 1; // محول إلى 0-based
    final int count = (ep - sp) + 1; // عدد الصفحات

    if (QuranCtrl.instance.isDownloadFonts) {
      // تنفيذ بعد انتهاء الإطار لتجنّب أي تجميد
      Future.microtask(() => QuranCtrl.instance
          .prepareFonts(startIndex, isFontsLocal: isFontsLocal!));
    }
    final String deviceLocale = Localizations.localeOf(context).languageCode;
    final String languageCode = appLanguageCode ?? deviceLocale;
    return PopScope(
      onPopInvokedWithResult: (b, _) async {
        QuranCtrl.instance.state.isShowMenu.value = false;
      },
      child: ScaleKitBuilder(
        designWidth: 375,
        designHeight: 812,
        designType: DeviceType.mobile,
        child: QuranLibraryTheme(
          snackBarStyle: snackBarStyle ??
              SnackBarStyle.defaults(isDark: isDark, context: context),
          ayahLongClickStyle: ayahMenuStyle ??
              AyahMenuStyle.defaults(isDark: isDark, context: context),
          indexTabStyle: indexTabStyle ??
              IndexTabStyle.defaults(isDark: isDark, context: context),
          topBarStyle: topBarStyle ??
              QuranTopBarStyle.defaults(isDark: isDark, context: context),
          tajweedMenuStyle: tajweedMenuStyle ??
              TajweedMenuStyle.defaults(isDark: isDark, context: context),
          searchTabStyle: searchTabStyle ??
              SearchTabStyle.defaults(isDark: isDark, context: context),
          surahInfoStyle: surahInfoStyle ??
              SurahInfoStyle.defaults(isDark: isDark, context: context),
          tafsirStyle: tafsirStyle ??
              TafsirStyle.defaults(isDark: isDark, context: context),
          bookmarksTabStyle: bookmarksTabStyle ??
              BookmarksTabStyle.defaults(isDark: isDark, context: context),
          topBottomQuranStyle: topBottomQuranStyle ??
              TopBottomQuranStyle.defaults(isDark: isDark, context: context),
          ayahDownloadManagerStyle: ayahDownloadManagerStyle ??
              AyahDownloadManagerStyle.defaults(
                  isDark: isDark, context: context),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor:
                backgroundColor ?? AppColors.getBackgroundColor(isDark),
            body: SafeArea(
              child: GetBuilder<QuranCtrl>(
                builder: (quranCtrl) {
                  // شرح: تحميل السورة عند بناء الشاشة
                  // Explanation: Load surah when building screen
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!context.mounted) return;
                    // على الويب: لا تسرق التركيز من حقول الكتابة
                    if (kIsWeb) {
                      final pf = FocusManager.instance.primaryFocus;
                      final isTextFieldFocused =
                          pf?.context?.widget is EditableText;
                      if (!isTextFieldFocused) {
                        FocusScope.of(context)
                            .requestFocus(quranCtrl.state.quranPageRLFocusNode);
                      }
                    }
                  });
                  Widget singlePage(int globalIndex) {
                    return InkWell(
                      onTap: () {
                        if (onPagePress != null) {
                          onPagePress!();
                        } else {
                          quranCtrl.showControlToggle(
                              enableMultiSelect: !enableMultiSelect);
                          quranCtrl.state.isShowMenu.value = false;
                        }
                      },
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: RepaintBoundary(
                        key: ValueKey('quran_partial_page_$globalIndex'),
                        child: PageViewBuild(
                          circularProgressWidget: circularProgressWidget,
                          languageCode: languageCode,
                          bookmarkList: bookmarkList,
                          ayahSelectedFontColor: ayahSelectedFontColor,
                          textColor: textColor,
                          ayahIconColor: ayahIconColor,
                          showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                          onAyahLongPress: onAyahLongPress,
                          bookmarksColor: bookmarksColor,
                          surahNameStyle: surahNameStyle,
                          bannerStyle: bannerStyle,
                          basmalaStyle: basmalaStyle,
                          onSurahBannerPress: onSurahBannerPress,
                          surahNumber: surahNumber,
                          ayahSelectedBackgroundColor:
                              ayahSelectedBackgroundColor,
                          onPagePress: onPagePress,
                          isDark: isDark,
                          fontsName: fontsName,
                          ayahBookmarked: ayahBookmarked,
                          userContext: parentContext,
                          pageIndex: globalIndex,
                          quranCtrl: quranCtrl,
                          isFontsLocal: isFontsLocal!,
                        ),
                      ),
                    );
                  }

                  Widget body;
                  if (withPageView) {
                    // PageView محلي على النطاق فقط
                    final controller = PageController(initialPage: 0);
                    body = PageView.builder(
                      itemCount: count,
                      controller: controller,
                      padEnds: false,
                      physics: const ClampingScrollPhysics(),
                      allowImplicitScrolling: false,
                      clipBehavior: Clip.hardEdge,
                      onPageChanged: (localIndex) {
                        final globalIndex = startIndex + localIndex;
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          if (!context.mounted) return;
                          if (onPageChanged != null) {
                            onPageChanged!(globalIndex);
                          } else {
                            quranCtrl.state.isShowMenu.value = false;
                          }
                          quranCtrl.state.currentPageNumber.value =
                              globalIndex + 1;
                          quranCtrl.saveLastPage(globalIndex + 1);
                          if (quranCtrl.currentRecitation.requiresDownload) {
                            await quranCtrl.prepareFonts(globalIndex);
                          }
                        });
                      },
                      itemBuilder: (ctx, localIndex) {
                        final globalIndex = startIndex + localIndex;
                        return singlePage(globalIndex);
                      },
                    );
                  } else {
                    if (count == 1) {
                      body = singlePage(startIndex);
                    } else {
                      // عرض رأسي لعدة صفحات (استخدمه بحذر للنطاقات الكبيرة)
                      body = ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: count,
                        itemBuilder: (_, localIndex) {
                          final globalIndex = startIndex + localIndex;
                          return singlePage(globalIndex);
                        },
                      );
                    }
                  }

                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Scaffold(
                      backgroundColor: backgroundColor ??
                          AppColors.getBackgroundColor(isDark),
                      body: SafeArea(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            body,
                            GetBuilder<QuranCtrl>(
                              id: 'isShowControl',
                              builder: (quranCtrl) {
                                final visible = quranCtrl.isShowControl.value;
                                return RepaintBoundary(
                                  child: IgnorePointer(
                                    ignoring: !visible,
                                    child: AnimatedOpacity(
                                      opacity: visible ? 1.0 : 0.0,
                                      duration:
                                          const Duration(milliseconds: 150),
                                      curve: Curves.easeInOut,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // السلايدر السفلي - يظهر من الأسفل للأعلى
                                          // Bottom slider - appears from bottom to top
                                          isShowAudioSlider!
                                              ? AyahsAudioWidget(
                                                  style: ayahStyle ??
                                                      AyahAudioStyle.defaults(
                                                          isDark: isDark,
                                                          context: context),
                                                  isDark: isDark,
                                                  languageCode: languageCode,
                                                  downloadManagerStyle:
                                                      ayahDownloadManagerStyle,
                                                )
                                              : const SizedBox.shrink(),
                                          kIsWeb
                                              ? JumpingPageControllerWidget(
                                                  backgroundColor:
                                                      backgroundColor,
                                                  isDark: isDark,
                                                  textColor: textColor,
                                                  quranCtrl: quranCtrl,
                                                )
                                              : const SizedBox.shrink(),
                                          appBar == null &&
                                                  useDefaultAppBar &&
                                                  visible
                                              ? _QuranTopBar(
                                                  languageCode,
                                                  isDark,
                                                  style: surahStyle ??
                                                      SurahAudioStyle.defaults(
                                                          isDark: isDark,
                                                          context: context),
                                                  backgroundColor:
                                                      backgroundColor,
                                                  downloadFontsDialogStyle:
                                                      downloadFontsDialogStyle,
                                                  isFontsLocal: isFontsLocal,
                                                  isSingleSurah: true,
                                                  isPagesView: true,
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
