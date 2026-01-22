part of '/quran.dart';

/// شاشة لعرض سورة واحدة باستخدام SurahCtrl و _QuranLinePage
/// Screen for displaying a single surah using SurahCtrl and _QuranLinePage
class SurahDisplayScreen extends StatelessWidget {
  /// إنشاء مثيل جديد من SurahDisplayScreen
  /// Creates a new instance of SurahDisplayScreen
  SurahDisplayScreen({
    super.key,
    required this.surahNumber,
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
    this.ayahStyle,
    this.surahStyle,
    this.isShowAudioSlider = true,
    this.appIconUrlForPlayAudioInBackground,
    required this.parentContext,
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
  });

  /// رقم السورة المراد عرضها
  /// The surah number to display
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
  /// مثال على الاستخدام:
  /// ```dart
  /// QuranLibraryScreen(
  ///   parentContext: context, // تمرير السياق من الويدجت الأب
  ///   // باقي المعاملات...
  /// )
  /// ```
  ///
  /// [parentContext] Required context from user for internal library operations
  /// such as accessing MediaQuery, Theme, and navigation between pages
  ///
  /// Usage example:
  /// ```dart
  /// QuranLibraryScreen(
  ///   parentContext: context, // Pass context from parent widget
  ///   // other parameters...
  /// )
  /// ```
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

  final quranCtrl = QuranCtrl.instance;

  @override
  Widget build(BuildContext context) {
    AudioCtrl.instance;
    // تحديث رابط أيقونة التطبيق إذا تم تمريره / Update app icon URL if provided
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
    quranCtrl.state.fontsSelected.value = 0;
    final String deviceLocale = Localizations.localeOf(context).languageCode;
    final String languageCode = appLanguageCode ?? deviceLocale;
    // شرح: تهيئة الشاشة وإعداد المقاييس
    // Explanation: Initialize screen and setup dimensions
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
          child: GetBuilder<SurahCtrl>(
            init: SurahCtrl.instance,
            initState: (state) {
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
                final ctrl = state.controller!;
                // شرح: إعادة تحميل السورة إذا تغير رقمها
                // Explanation: Reload surah if its number changed
                AudioCtrl.instance;
                if (ctrl.surahNumber != surahNumber) {
                  ctrl.loadSurah(surahNumber);
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildSurahBody(parentContext, surahCtrl),
                        GetBuilder<QuranCtrl>(
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
                                              backgroundColor: backgroundColor,
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
                                                  SurahAudioStyle(),
                                              backgroundColor: backgroundColor,
                                              downloadFontsDialogStyle:
                                                  downloadFontsDialogStyle,
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
                        ),
                      ],
                    ),
                  )),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// بناء محتوى السورة
  /// Build surah content
  Widget _buildSurahBody(BuildContext context, SurahCtrl surahCtrl) {
    // شرح: التحقق من تحميل البيانات
    // Explanation: Check if data is loaded
    if (surahCtrl.isLoading.value) {
      return Center(
        child: circularProgressWidget ??
            const CircularProgressIndicator.adaptive(),
      );
    }

    // شرح: التحقق من وجود صفحات السورة
    // Explanation: Check if surah pages exist
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

    // شرح: استخدام PageView مع صفحات السورة من SurahCtrl
    // Explanation: Use PageView with surah pages from SurahCtrl
    return Obx(
      () => PageView.builder(
        controller: surahCtrl.pageController,
        itemCount: surahCtrl.surahPages.length,
        onPageChanged: (pageIndex) {
          // تشغيل العمليات في الخلفية لتجنب تجميد UI
          // Run operations in background to avoid UI freeze
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!context.mounted) return;
            if (onPageChanged != null) {
              // لا تلمس الـ Overlay إذا كان المستخدم يدير الحدث بنفسه
              onPageChanged!(pageIndex);
            } else {}
            final realQuranPage = surahCtrl.getRealQuranPageNumber(pageIndex);
            quranCtrl.state.currentPageNumber.value = realQuranPage;
            quranCtrl.saveLastPage(realQuranPage);
            // if (quranCtrl.currentRecitation.requiresDownload) {
            //   log('Preparing fonts for page $realQuranPage');
            //   await quranCtrl.prepareFonts(realQuranPage);
            // }
          });
        },
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

  /// بناء صفحة السورة
  /// Build surah page
  Widget _buildSurahPage(BuildContext context, QuranPageModel surahPage,
      int pageIndex, SurahCtrl surahCtrl) {
    int realPageIndex = surahCtrl.getRealQuranPageNumber(pageIndex);
    log('Building surah page: $realPageIndex for index: $pageIndex');

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UiHelper.currentOrientation(16.0, 64.0, context),
        vertical: 16.0,
      ),
      child: RepaintBoundary(
        key: ValueKey('quran_partial_page_${realPageIndex - 1}'),
        child: SurahPageViewBuild(
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
        ),
      ),
    );
  }
}
