part of '/quran.dart';

/// شاشة لعرض سورة واحدة فقط باستخدام SurahCtrl
/// Screen for displaying a single surah only using SurahCtrl
class SurahDisplayScreen extends StatelessWidget {
  /// إنشاء مثيل جديد من SurahDisplayScreen
  /// Creates a new instance of SurahDisplayScreen
  const SurahDisplayScreen({
    super.key,
    required this.surahNumber,
    required this.parentContext,
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
    this.isDark = false,
    this.appLanguageCode,
    this.onAyahLongPress,
    this.onPageChanged,
    this.onPagePress,
    this.onSurahBannerPress,
    this.showAyahBookmarkedIcon = true,
    this.surahInfoStyle,
    this.surahNameStyle,
    this.textColor,
    this.useDefaultAppBar = true,
    this.ayahBookmarked = const [],
    this.isAyahBookmarked,
    this.ayahStyle,
    this.surahStyle,
    this.isShowAudioSlider = true,
    this.appIconUrlForPlayAudioInBackground,
    this.indexTabStyle,
    this.searchTabStyle,
    this.ayahLongClickStyle,
    this.tafsirStyle,
    this.bookmarksTabStyle,
    this.ayahDownloadManagerStyle,
    this.topBottomQuranStyle,
    this.snackBarStyle,
    this.ayahMenuStyle,
    this.topBarStyle,
    this.tajweedMenuStyle,
    this.downloadFontsDialogStyle,
    this.isFontsLocal = false,
    this.enableWordSelection = true,
    this.wordInfoBottomSheetStyle,
  });

  /// رقم السورة المراد عرضها (1-114)
  /// The surah number to display (1-114)
  final int surahNumber;

  /// شريط التطبيقات المخصص
  /// Custom app bar
  final PreferredSizeWidget? appBar;

  /// لون أيقونة الآية
  /// Ayah icon color
  final Color? ayahIconColor;

  /// لون خلفية الآية المختارة
  /// Selected ayah background color
  final Color? ayahSelectedBackgroundColor;
  final Color? ayahSelectedFontColor;

  /// نمط البسملة
  /// Basmala style
  final BasmalaStyle? basmalaStyle;

  /// نمط الشعار
  /// Banner style
  final BannerStyle? bannerStyle;

  /// قائمة الإشارات المرجعية
  /// Bookmark list
  final List bookmarkList;

  /// لون الإشارات المرجعية
  /// Bookmarks color
  final Color? bookmarksColor;

  /// لون الخلفية
  /// Background color
  final Color? backgroundColor;

  /// ويدجت التحميل
  /// Loading widget
  final Widget? circularProgressWidget;

  /// النمط المظلم
  /// Dark mode
  final bool isDark;

  /// كود اللغة
  /// Language code
  final String? appLanguageCode;

  /// دالة عند الضغط المطول على الآية
  /// Function when long pressing on ayah
  final void Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;

  /// دالة عند تغيير الصفحة
  /// Function when page changes
  final Function(int pageNumber)? onPageChanged;

  /// دالة عند الضغط على الصفحة
  /// Function when pressing on page
  final VoidCallback? onPagePress;

  /// دالة عند الضغط على شعار السورة
  /// Function when pressing on surah banner
  final void Function(SurahNamesModel surah)? onSurahBannerPress;

  /// إظهار أيقونة الإشارة المرجعية للآية
  /// Show ayah bookmark icon
  final bool showAyahBookmarkedIcon;

  /// نمط معلومات السورة
  /// Surah info style
  final SurahInfoStyle? surahInfoStyle;

  /// نمط اسم السورة
  /// Surah name style
  final SurahNameStyle? surahNameStyle;

  /// لون النص
  /// Text color
  final Color? textColor;

  /// استخدام شريط التطبيقات الافتراضي
  /// Use default app bar
  final bool useDefaultAppBar;

  /// قائمة الآيات المحفوظة
  /// List of bookmarked ayahs
  final List<int> ayahBookmarked;

  /// Callback مخصص لتحديد هل الآية محفوظة أم لا
  /// Custom callback to determine whether an ayah is bookmarked
  final bool Function(AyahModel ayah)? isAyahBookmarked;

  /// نمط تخصيص مظهر المشغل الصوتي للآيات - يتحكم في الألوان والخطوط والأيقونات [ayahStyle]
  ///
  /// [ayahStyle] Audio player style customization for ayahs - controls colors, fonts, and icons
  final AyahAudioStyle? ayahStyle;

  /// نمط تخصيص مظهر المشغل الصوتي للسور - يتحكم في الألوان والخطوط والأيقونات [surahStyle]
  ///
  /// [surahStyle] Audio player style customization for surahs - controls colors, fonts, and icons
  final SurahAudioStyle? surahStyle;

  /// إظهار أو إخفاء سلايدر التحكم في الصوت السفلي [isShowAudioSlider]
  ///
  /// [isShowAudioSlider] Show or hide the bottom audio control slider
  final bool? isShowAudioSlider;

  /// رابط أيقونة التطبيق للمشغل الصوتي / App icon URL for audio player
  /// [appIconUrlForPlayAudioInBackground] يمكن تمرير رابط مخصص لأيقونة التطبيق في المشغل الصوتي
  /// [appIconUrlForPlayAudioInBackground] You can pass a custom URL for the app icon in the audio player
  final String? appIconUrlForPlayAudioInBackground;

  /// السياق المطلوب من المستخدم لإدارة العمليات الداخلية للمكتبة [parentContext]
  /// مثل الوصول إلى MediaQuery، Theme، والتنقل بين الصفحات
  ///
  /// [parentContext] Required context from user for internal library operations
  /// such as accessing MediaQuery, Theme, and navigation between pages
  final BuildContext parentContext;

  /// تخصيص نمط تبويب الفهرس الخاص بالمصحف
  ///
  /// [indexTabStyle] Index tab style customization for the Quran
  final IndexTabStyle? indexTabStyle;

  /// تخصيص نمط تبويب البحث الخاص بالمصحف
  ///
  /// [searchTabStyle] Search tab style customization for the Quran
  final SearchTabStyle? searchTabStyle;

  /// تخصيص نمط التفسير الخاص بالمصحف
  ///
  /// [tafsirStyle] Tafsir style customization for the Quran
  final TafsirStyle? tafsirStyle;

  /// تخصيص نمط الضغط المطول على الآية
  ///
  /// [ayahLongClickStyle] Ayah long click style customization for the Quran
  final AyahMenuStyle? ayahLongClickStyle;

  /// تخصيص نمط تبويب الفواصل الخاص بالمصحف
  ///
  /// [bookmarksTabStyle] Bookmarks tab style customization for the Quran
  final BookmarksTabStyle? bookmarksTabStyle;

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

  /// تخصيص نمط شريط الأعلى الخاص بالمصحف
  ///
  /// Customize the style of the Quran top bar
  final QuranTopBarStyle? topBarStyle;

  /// تخصيص نمط نافذة/قائمة أحكام التجويد
  final TajweedMenuStyle? tajweedMenuStyle;

  /// تغيير نمط نافذة تحميل الخطوط بواسطة هذه الفئة [DownloadFontsDialogStyle]
  ///
  /// [DownloadFontsDialogStyle] Change the style of Download fonts dialog by DownloadFontsDialogStyle class
  final DownloadFontsDialogStyle? downloadFontsDialogStyle;

  /// إذا كنت تريد استخدام خطوط موجودة مسبقًا في التطبيق، اجعل هذا المتغيير true [isFontsLocal]
  ///
  /// [isFontsLocal] If you want to use fonts that exists in the app, make this variable true
  final bool? isFontsLocal;

  /// تفعيل أو تعطيل تحديد الكلمة وعرض نافذة معلومات الكلمة عند الضغط [enableWordSelection]
  ///
  /// [enableWordSelection] Enable or disable word selection and word info bottom sheet on tap
  final bool enableWordSelection;

  /// نمط تخصيص معلومات الكلمة
  ///
  /// [wordInfoBottomSheetStyle] Style customization for the word info bottom sheet display mode
  final WordInfoBottomSheetStyle? wordInfoBottomSheetStyle;

  @override
  Widget build(BuildContext context) {
    final quranCtrl = QuranCtrl.instance;

    // تهيئة كنترولر الصوت
    // Initialize audio controller
    AudioCtrl.instance;

    // تحديث رابط أيقونة التطبيق إذا تم تمريره
    // Update app icon URL if provided
    if (appIconUrlForPlayAudioInBackground != null &&
        appIconUrlForPlayAudioInBackground!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          AudioCtrl.instance
              .updateAppIconUrl(appIconUrlForPlayAudioInBackground!);
        }
      });
    }

    // تفعيل تحديد الكلمات
    // Enable word selection
    WordInfoCtrl.instance.isWordSelectionEnabled = enableWordSelection;

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
          wordInfoBottomSheetStyle: wordInfoBottomSheetStyle ??
              WordInfoBottomSheetStyle.defaults(
                  isDark: isDark, context: context),
          child: GetBuilder<SurahCtrl>(
            init: SurahCtrl.instance,
            initState: (state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;

                // على الويب: لا تسرق التركيز من حقول الكتابة
                // On web: don't steal focus from text fields
                if (kIsWeb) {
                  final pf = FocusManager.instance.primaryFocus;
                  final isTextFieldFocused =
                      pf?.context?.widget is EditableText;
                  if (!isTextFieldFocused) {
                    FocusScope.of(context)
                        .requestFocus(quranCtrl.state.quranPageRLFocusNode);
                  }
                }

                final ctrl = state.controller!;
                // تحميل السورة عند التهيئة أو إعادة التحميل إذا تغيّر الرقم أو كانت الصفحات فارغة
                // Load surah on init or reload if number changed or pages are empty
                if (ctrl.surahNumber != surahNumber ||
                    ctrl.surahPages.isEmpty) {
                  ctrl.loadSurah(surahNumber).then((_) {
                    // تحضير خطوط QPC v4 لصفحات السورة بعد التحميل
                    // Prewarm QPC v4 fonts for surah pages after loading
                    if (ctrl.surahPages.isNotEmpty) {
                      final firstRealPage =
                          ctrl.surahPages.first.pageNumber - 1;
                      quranCtrl.prewarmQpcV4Pages(firstRealPage);
                    }
                  });
                }
              });
            },
            builder: (surahCtrl) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor:
                      backgroundColor ?? AppColors.getBackgroundColor(isDark),
                  body: SafeArea(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // محتوى السورة مع دعم التكبير/التصغير
                        // Surah content with pinch-to-zoom support
                        GestureDetector(
                          onScaleStart: (details) => quranCtrl
                              .state
                              .baseScaleFactor
                              .value = quranCtrl.state.scaleFactor.value,
                          onScaleUpdate: (details) =>
                              _onScaleUpdate(details, quranCtrl),
                          onScaleEnd: (_) {
                            if (quranCtrl.state.isScaling.value) {
                              quranCtrl.state.isScaling.value = false;
                              quranCtrl.update();
                            }
                          },
                          child: InkWell(
                            onTap: () {
                              if (onPagePress != null) {
                                onPagePress!();
                              } else {
                                quranCtrl.showControlToggle();
                                quranCtrl.state.isShowMenu.value = false;
                              }
                            },
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: _buildSurahBody(
                                parentContext, surahCtrl, quranCtrl),
                          ),
                        ),
                        // طبقة عناصر التحكم (شريط الأعلى + الصوت)
                        // Controls overlay (top bar + audio)
                        _SurahControlWidget(
                          isShowAudioSlider: isShowAudioSlider,
                          ayahStyle: ayahStyle,
                          isDark: isDark,
                          languageCode: languageCode,
                          ayahDownloadManagerStyle: ayahDownloadManagerStyle,
                          backgroundColor: backgroundColor,
                          textColor: textColor,
                          appBar: appBar,
                          useDefaultAppBar: useDefaultAppBar,
                          surahStyle: surahStyle,
                          downloadFontsDialogStyle: downloadFontsDialogStyle,
                          isFontsLocal: isFontsLocal,
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
    );
  }

  /// معالجة حركة التكبير/التصغير
  /// Handle pinch-to-zoom gesture
  void _onScaleUpdate(ScaleUpdateDetails details, QuranCtrl quranCtrl) {
    if (details.pointerCount >= 2 && !quranCtrl.state.isScaling.value) {
      quranCtrl.state.isScaling.value = true;
      quranCtrl.update();
    } else if (details.pointerCount < 2 && quranCtrl.state.isScaling.value) {
      quranCtrl.state.isScaling.value = false;
      quranCtrl.update();
    }
    quranCtrl.updateTextScale(details);
  }

  /// بناء محتوى السورة الواحدة
  /// Build single surah content
  Widget _buildSurahBody(
      BuildContext context, SurahCtrl surahCtrl, QuranCtrl quranCtrl) {
    // التحقق من حالة التحميل
    // Check loading state
    if (surahCtrl.isLoading.value) {
      return Center(
        child: circularProgressWidget ??
            const CircularProgressIndicator.adaptive(),
      );
    }

    // التحقق من وجود صفحات السورة
    // Check if surah pages exist
    if (surahCtrl.surahPages.isEmpty) {
      return Center(
        child: Text(
          'لا توجد آيات للسورة المحددة',
          style: TextStyle(
            color: AppColors.getTextColor(isDark),
            fontSize: 16,
          ),
        ),
      );
    }

    // عرض صفحات السورة الواحدة فقط باستخدام PageView
    // Display only the single surah pages using PageView
    return Obx(
      () => PageView.builder(
        controller: surahCtrl.pageController,
        itemCount: surahCtrl.surahPages.length,
        physics: quranCtrl.state.isScaling.value
            ? const NeverScrollableScrollPhysics()
            : const ClampingScrollPhysics(),
        onPageChanged: (pageIndex) => _onSurahPageChanged(
          context,
          pageIndex,
          surahCtrl,
          quranCtrl,
        ),
        itemBuilder: (context, pageIndex) {
          return _buildSurahPage(
            context,
            surahCtrl.surahPages[pageIndex],
            pageIndex,
            surahCtrl,
          );
        },
      ),
    );
  }

  /// معالجة تغيير الصفحة داخل السورة
  /// Handle page change within surah
  void _onSurahPageChanged(
    BuildContext context,
    int pageIndex,
    SurahCtrl surahCtrl,
    QuranCtrl quranCtrl,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;

      if (onPageChanged != null) {
        onPageChanged!(pageIndex);
      }

      final realQuranPage = surahCtrl.getRealQuranPageNumber(pageIndex);
      quranCtrl.state.currentPageNumber.value = realQuranPage;
      quranCtrl.saveLastPage(realQuranPage);

      // تحضير خطوط QPC v4 للصفحات المجاورة
      // Prewarm QPC v4 fonts for adjacent pages
      if (quranCtrl.state.fontsSelected.value == 0) {
        quranCtrl.prewarmQpcV4Pages(realQuranPage - 1);
      }
    });
  }

  /// بناء صفحة واحدة من صفحات السورة
  /// Build a single page from surah pages
  Widget _buildSurahPage(
    BuildContext context,
    QuranPageModel surahPage,
    int pageIndex,
    SurahCtrl surahCtrl,
  ) {
    final realPageIndex = surahCtrl.getRealQuranPageNumber(pageIndex);
    QuranFontsService.ensurePagesLoaded(realPageIndex, radius: 10).then((_) {
      // update();
      // update(['_pageViewBuild']);
      // تحميل بقية الصفحات في الخلفية
      QuranFontsService.loadRemainingInBackground(
        startNearPage: realPageIndex,
        progress: QuranCtrl.instance.state.fontsLoadProgress,
        ready: QuranCtrl.instance.state.fontsReady,
      ).then((_) {
        // update();
        surahCtrl.update(['_pageViewBuild']);
      });
    });

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UiHelper.currentOrientation(16.0, 64.0, context),
        vertical: 16.0,
      ),
      child: RepaintBoundary(
        key: ValueKey('quran_surah_page_${surahNumber}_$pageIndex'),
        child: GetBuilder<SurahCtrl>(
            id: '_pageViewBuild',
            builder: (surahCtrl) {
              return SurahPageViewBuild(
                userContext: parentContext,
                surahPage: surahPage,
                surahPageIndex: pageIndex,
                globalPageIndex: realPageIndex - 1,
                surahNumber: surahNumber,
                isDark: isDark,
                languageCode: appLanguageCode,
                circularProgressWidget: circularProgressWidget,
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
                ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
                ayahBookmarked: ayahBookmarked,
                isAyahBookmarked: isAyahBookmarked,
              );
            }),
      ),
    );
  }
}

/// ويدجت عناصر التحكم لشاشة السورة الواحدة (شريط علوي + صوت)
/// Control widget for single surah screen (top bar + audio)
class _SurahControlWidget extends StatelessWidget {
  const _SurahControlWidget({
    required this.isShowAudioSlider,
    required this.ayahStyle,
    required this.isDark,
    required this.languageCode,
    required this.ayahDownloadManagerStyle,
    required this.backgroundColor,
    required this.textColor,
    required this.appBar,
    required this.useDefaultAppBar,
    required this.surahStyle,
    required this.downloadFontsDialogStyle,
    required this.isFontsLocal,
  });

  final bool? isShowAudioSlider;
  final AyahAudioStyle? ayahStyle;
  final bool isDark;
  final String languageCode;
  final AyahDownloadManagerStyle? ayahDownloadManagerStyle;
  final Color? backgroundColor;
  final Color? textColor;
  final PreferredSizeWidget? appBar;
  final bool useDefaultAppBar;
  final SurahAudioStyle? surahStyle;
  final DownloadFontsDialogStyle? downloadFontsDialogStyle;
  final bool? isFontsLocal;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranCtrl>(
      id: 'isShowControl',
      builder: (quranCtrl) {
        final visible = quranCtrl.isShowControl.value;
        return RepaintBoundary(
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedOpacity(
              opacity: visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // السلايدر السفلي للصوت
                  // Bottom audio slider
                  isShowAudioSlider!
                      ? AyahsAudioWidget(
                          style: ayahStyle ??
                              AyahAudioStyle.defaults(
                                  isDark: isDark, context: context),
                          isDark: isDark,
                          languageCode: languageCode,
                          downloadManagerStyle: ayahDownloadManagerStyle,
                        )
                      : const SizedBox.shrink(),
                  // التحكم بالصفحات على الويب
                  // Page control on web
                  kIsWeb
                      ? JumpingPageControllerWidget(
                          backgroundColor: backgroundColor,
                          isDark: isDark,
                          textColor: textColor,
                          quranCtrl: quranCtrl,
                        )
                      : const SizedBox.shrink(),
                  // شريط التطبيق العلوي
                  // Top app bar
                  appBar == null && useDefaultAppBar && visible
                      ? _QuranTopBar(
                          languageCode,
                          isDark,
                          style: surahStyle ?? SurahAudioStyle(),
                          backgroundColor: backgroundColor,
                          downloadFontsDialogStyle: downloadFontsDialogStyle,
                          isFontsLocal: isFontsLocal,
                          isSingleSurah: true,
                          isPagesView: false,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
