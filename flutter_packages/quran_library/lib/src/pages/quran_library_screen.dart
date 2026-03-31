part of '/quran.dart';

/// A widget that displays the Quran library screen.
///
/// This screen is used to display the Quran library, which includes
/// the text of the Quran, bookmarks, and other relevant information.
///
/// The screen is customizable, with options to set the app bar,
/// ayah icon color, ayah selected background color, banner style,
/// basmala style, background color, bookmarks color, circular progress
/// widget, download fonts dialog style, and language code.
///
/// The screen also provides a callback for when the default ayah is
/// long pressed.
class QuranLibraryScreen extends StatelessWidget {
  /// Creates a new instance of [QuranLibraryScreen].
  ///
  /// This constructor is used to create a new instance of the
  /// [QuranLibraryScreen] widget.
  const QuranLibraryScreen({
    super.key,
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
    this.pageIndex = 0,
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
    this.appIconPathForPlayAudioInBackground,
    this.topBarStyle,
    this.tajweedMenuStyle,
    this.indexTabStyle,
    this.searchTabStyle,
    this.bookmarksTabStyle,
    this.ayahMenuStyle,
    this.snackBarStyle,
    this.tafsirStyle,
    this.ayahDownloadManagerStyle,
    required this.parentContext,
    this.topBottomQuranStyle,
  });

  /// إذا قمت بإضافة شريط التطبيقات هنا فإنه سيحل محل شريط التطبيقات الافتراضية [appBar]
  ///
  /// [appBar] if if provided it will replace the default app bar
  final PreferredSizeWidget? appBar;

  /// يمكنك تمرير لون لأيقونة الآية [ayahIconColor]
  ///
  /// [ayahIconColor] You can pass the color of the Ayah icon
  final Color? ayahIconColor;

  /// يمكنك تمرير لون خلفية الآية المحدد [ayahSelectedBackgroundColor]
  ///
  /// [ayahSelectedBackgroundColor] You can pass the color of the Ayah selected background
  final Color? ayahSelectedBackgroundColor;
  final Color? ayahSelectedFontColor;

  /// تغيير نمط البسملة بواسطة هذه الفئة [BasmalaStyle]
  ///
  /// [BasmalaStyle] Change the style of Basmala by BasmalaStyle class
  final BasmalaStyle? basmalaStyle;

  /// تغيير نمط الشعار من خلال هذه الفئة [BannerStyle]
  ///
  /// [BannerStyle] Change the style of banner by BannerStyle class
  final BannerStyle? bannerStyle;

  /// إذا كنت تريد إضافة قائمة إشارات مرجعية خاصة، فقط قم بتمريرها لـ [bookmarkList]
  ///
  /// If you want to add a private bookmark list, just pass it to [bookmarkList]
  final List bookmarkList;

  /// تغيير لون الإشارة المرجعية (اختياري) [bookmarksColor]
  ///
  /// [bookmarksColor] Change the bookmark color (optional)
  final Color? bookmarksColor;

  /// إذا كنت تريد تغيير لون خلفية صفحة القرآن [backgroundColor]
  ///
  /// [backgroundColor] if you wanna change the background color of Quran page
  final Color? backgroundColor;

  /// إذا كنت تريد إضافة ويدجت بدلًا من الويدجت الإفتراضية [circularProgressWidget]
  ///
  /// If you want to add a widget instead of the default widget [circularProgressWidget]
  final Widget? circularProgressWidget;

  /// تغيير نمط نافذة تحميل الخطوط بواسطة هذه الفئة [DownloadFontsDialogStyle]
  ///
  /// [DownloadFontsDialogStyle] Change the style of Download fonts dialog by DownloadFontsDialogStyle class
  final DownloadFontsDialogStyle? downloadFontsDialogStyle;

  /// قم بتمرير رقم الصفحة إذا كنت لا تريد عرض القرآن باستخدام PageView [pageIndex]
  ///
  /// [pageIndex] pass the page number if you do not want to display the Quran with PageView
  final int pageIndex;

  /// قم بتمكين هذا المتغير إذا كنت تريد عرض القرآن في النمط المظلم [isDark]
  ///
  /// [isDark] Enable this variable if you want to display the Quran with dark mode
  final bool isDark;

  /// إذا كنت تريد تمرير كود اللغة الخاصة بالتطبيق لتغيير الأرقام على حسب اللغة،
  /// :رمز اللغة الإفتراضي هو 'ar' [languageCode]
  ///
  /// [languageCode] If you want to pass the application's language code to change the numbers according to the language,
  /// the default language code is 'ar'
  final String? appLanguageCode;

  /// إذا تم توفيره فسيتم استدعاؤه عند تغيير صفحة القرآن [onPageChanged]
  ///
  /// [onPageChanged] if provided it will be called when a quran page changed
  final Function(int pageNumber)? onPageChanged;

  /// عند الضغط على الصفحة يمكنك إضافة بعض المميزات مثل حذف التظليل عن الآية وغيرها [onPagePress]
  ///
  /// [onPagePress] When you click on the page, you can add some features,
  /// such as deleting the shading from the verse and others
  final VoidCallback? onPagePress;

  /// * تُستخدم مع الخطوط المحملة *
  /// عند الضغط المطوّل على أي آية باستخدام الخطوط المحملة، يمكنك تفعيل ميزات إضافية
  /// مثل نسخ الآية أو مشاركتها وغير ذلك عبر [onAyahLongPress].
  ///
  /// * Used with loaded fonts *
  /// When long-pressing on any verse with the loaded fonts, you can enable additional features
  /// such as copying the verse, sharing it, and more using [onAyahLongPress].
  final void Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;

  /// * تُستخدم مع الخطوط المحملة *
  /// عند الضغط على أي لافتة سورة باستخدام الخطوط المحملة، يمكنك إضافة بعض التفاصيل حول السورة [onSurahBannerPress]
  ///
  /// * Used with loaded fonts *
  /// [onSurahBannerPress] When you press on any Surah banner with the loaded fonts,
  /// you can add some details about the surah
  final void Function(SurahNamesModel surah)? onSurahBannerPress;

  /// يمكنك تمكين أو تعطيل عرض أيقونة الإشارة المرجعية للآية [showAyahBookmarkedIcon]
  ///
  /// [showAyahBookmarkedIcon] You can enable or disable the display of the Ayah bookmarked icon
  final bool showAyahBookmarkedIcon;

  /// يمكنك تمرير رقم السورة [surahNumber]
  ///
  /// [surahNumber] You can pass the Surah number
  final int? surahNumber;

  /// تغيير نمط معلومات السورة بواسطة هذه الفئة [SurahInfoStyle]
  ///
  /// [SurahInfoStyle] Change the style of surah information by SurahInfoStyle class
  final SurahInfoStyle? surahInfoStyle;

  /// تغيير نمط اسم السورة بهذه الفئة [SurahNameStyle]
  ///
  /// [SurahNameStyle] Change the style of surah name by SurahNameStyle class
  final SurahNameStyle? surahNameStyle;

  /// يمكنك تمرير لون نص القرآن [textColor]
  ///
  /// [textColor] You can pass the color of the Quran text
  final Color? textColor;
  final List<Color?>? singleAyahTextColors;

  /// متغير لتعطيل أو تمكين شريط التطبيقات الافتراضية [useDefaultAppBar]
  ///
  /// [useDefaultAppBar] is a bool to disable or enable the default app bar widget
  ///
  final bool useDefaultAppBar;

  /// قم بتمكين هذا المتغير إذا كنت تريد عرض القرآن باستخدام PageView [withPageView]
  ///
  /// [withPageView] Enable this variable if you want to display the Quran with PageView
  final bool withPageView;

  /// إذا كنت تريد استخدام خطوط موجودة مسبقًا في التطبيق، اجعل هذا المتغيير true [isFontsLocal]
  ///
  /// [isFontsLocal] If you want to use fonts that exists in the app, make this variable true
  final bool? isFontsLocal;

  /// قم بتمرير إسم الخط الموجود في التطبيق لكي تستطيع إستخدامه [fontsName]
  ///
  /// [fontsName] Pass the name of the font that exists in the app so you can use it
  final String? fontsName;

  /// قم بتمرير قائمة الآيات المحفوظة [ayahBookmarked]
  ///
  /// [ayahBookmarked] Pass the list of bookmarked ayahs
  final List<int>? ayahBookmarked;

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

  /// مسار أيقونة التطبيق للمشغل الصوتي / App icon path for audio player
  /// [appIconPathForPlayAudioInBackground] يمكن تمرير مسار مخصص لأيقونة التطبيق في المشغل الصوتي
  /// [appIconPathForPlayAudioInBackground] You can pass a custom path for the app icon in the audio player
  final String? appIconPathForPlayAudioInBackground;

  /// تخصيص نمط شريط الأعلى الخاص بالمصحف
  ///
  /// Customize the style of the Quran top bar
  final QuranTopBarStyle? topBarStyle;

  /// تخصيص نمط نافذة/قائمة أحكام التجويد
  ///
  /// Customize the style of Tajweed menu dialog
  final TajweedMenuStyle? tajweedMenuStyle;

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

  /// تخصيص نمط تبويب الفواصل الخاص بالمصحف
  ///
  /// [bookmarksTabStyle] Bookmarks tab style customization for the Quran
  final BookmarksTabStyle? bookmarksTabStyle;

  /// تخصيص نمط الضغط المطوّل على الآية
  /// [ayahMenuStyle] Long press style customization for ayahs
  final AyahMenuStyle? ayahMenuStyle;

  /// تخصيص نمط Snackbar الخاص بالمكتبة
  /// [snackBarStyle] SnackBar style customization for the library
  final SnackBarStyle? snackBarStyle;

  // تخصيص نمط التفسير
  /// [tafsirStyle] Tafsir style customization
  final TafsirStyle? tafsirStyle;

  // تخصيص نمط التنزيل الآيات
  /// [ayahDownloadManagerStyle] Ayah download manager style customization
  final AyahDownloadManagerStyle? ayahDownloadManagerStyle;

  // تخصيص نمط الجزء العلوي والسفلي للمصحف
  /// [topBottomQuranStyle] top/bottom style customization for the Quran
  final TopBottomQuranStyle? topBottomQuranStyle;

  @override
  Widget build(BuildContext context) {
    // تحديث رابط أيقونة التطبيق إذا تم تمريره / Update app icon URL if provided
    // Update app icon URL if provided
    if (appIconPathForPlayAudioInBackground != null &&
        appIconPathForPlayAudioInBackground!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          AudioCtrl.instance
              .updateAppIconUrl(appIconPathForPlayAudioInBackground!);
        }
      });
    }

    // if (isDark!) {
    //   QuranCtrl.instance.state.isTajweed.value = 1;
    //   GetStorage().write(StorageConstants().isTajweed, 1);
    // }
    final String deviceLocale = Localizations.localeOf(context).languageCode;
    final String languageCode = appLanguageCode ?? deviceLocale;
    QuranCtrl.instance.state.currentPageNumber.value = pageIndex + 1;
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
            child: GetBuilder<QuranCtrl>(
              builder: (quranCtrl) {
                // تهيئة خاملة لخطوط الصفحات المجاورة حول الصفحة الحالية بعد أول إطار
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
                  // } else {
                  //   // على المنصات الأخرى أبقِ السلوك كما هو
                  //   FocusScope.of(context)
                  //       .requestFocus(quranCtrl.state.quranPageRLFocusNode);
                  // }
                });
                return Scaffold(
                  backgroundColor:
                      backgroundColor ?? AppColors.getBackgroundColor(isDark),
                  body: SafeArea(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: GestureDetector(
                            onScaleStart: (details) => quranCtrl
                                .state
                                .baseScaleFactor
                                .value = quranCtrl.state.scaleFactor.value,
                            onScaleUpdate: (ScaleUpdateDetails details) {
                              // عند وجود إصبعين أو أكثر نعتبرها عملية تكبير/تصغير ونوقف سكرول الصفحات
                              if (details.pointerCount >= 2 &&
                                  quranCtrl.state.isScaling.value == false) {
                                quranCtrl.state.isScaling.value = true;
                                quranCtrl.update();
                              } else if (details.pointerCount < 2 &&
                                  quranCtrl.state.isScaling.value == true) {
                                // عاد المستخدم لإصبع واحد -> أعِد تفعيل السحب
                                quranCtrl.state.isScaling.value = false;
                                quranCtrl.update();
                              }
                              quranCtrl.updateTextScale(details);
                            },
                            onScaleEnd: (_) {
                              if (quranCtrl.state.isScaling.value) {
                                quranCtrl.state.isScaling.value = false;
                                quranCtrl.update();
                              }
                            },
                            child: withPageView
                                ? Focus(
                                    focusNode:
                                        quranCtrl.state.quranPageRLFocusNode,
                                    // على الويب، إيقاف الـ autofocus لتجنّب سرقة التركيز
                                    autofocus: kIsWeb ? false : true,
                                    onKeyEvent: (node, event) => quranCtrl
                                        .controlRLByKeyboard(node, event),
                                    child: PageView.builder(
                                      itemCount: 604,
                                      controller:
                                          quranCtrl.getPageController(context),
                                      padEnds: false,
                                      // شرح: اختيار نوع الفيزياء حسب إعداد التحسين QuranPagesScreen
                                      // Explanation: Choose physics type based on optimization setting
                                      physics: quranCtrl.state.isScaling.value
                                          ? const NeverScrollableScrollPhysics()
                                          : const ClampingScrollPhysics(),
                                      // شرح: إضافة allowImplicitScrolling لتحسين الأداء
                                      // Explanation: Adding allowImplicitScrolling for better performance
                                      allowImplicitScrolling: true,
                                      scrollBehavior:
                                          const MaterialScrollBehavior()
                                              .copyWith(
                                        dragDevices: {
                                          PointerDeviceKind.touch,
                                          PointerDeviceKind.mouse,
                                          PointerDeviceKind.trackpad,
                                          PointerDeviceKind.stylus,
                                          PointerDeviceKind.unknown
                                        },
                                      ),

                                      // شرح: تقليل القص لتخفيف كلفة الرسم ما لم نحتاجه
                                      // Explanation: Reduce clipping cost unless necessary
                                      clipBehavior: Clip.none,
                                      // شرح: تحسين معالجة تغيير الصفحة لتقليل التقطيع
                                      // Explanation: Optimized page change handling to reduce stuttering
                                      onPageChanged: (pageIndex) {
                                        // تشغيل العمليات في الخلفية لتجنب تجميد UI
                                        // Run operations in background to avoid UI freeze
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) async {
                                          if (!context.mounted) return;
                                          if (onPageChanged != null) {
                                            // لا تلمس الـ Overlay إذا كان المستخدم يدير الحدث بنفسه
                                            onPageChanged!(pageIndex);
                                          } else {}
                                          quranCtrl.state.currentPageNumber
                                              .value = pageIndex + 1;
                                          quranCtrl.saveLastPage(pageIndex + 1);

                                          await quranCtrl
                                              .prepareFonts(pageIndex);
                                        });
                                      },
                                      pageSnapping: true,
                                      itemBuilder: (ctx, index) {
                                        // شرح: تحسين أداء itemBuilder لتقليل التقطيع
                                        // Explanation: Optimize itemBuilder performance to reduce stuttering
                                        return InkWell(
                                          onTap: () {
                                            if (onPagePress != null) {
                                              onPagePress!();
                                            } else {
                                              quranCtrl.showControlToggle();
                                              QuranCtrl.instance.state
                                                  .isShowMenu.value = false;
                                            }
                                          },
                                          hoverColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: RepaintBoundary(
                                            key: ValueKey('quran_page_$index'),
                                            child: _KeepAlive(
                                              child: PageViewBuild(
                                                circularProgressWidget:
                                                    circularProgressWidget,
                                                languageCode: languageCode,
                                                bookmarkList: bookmarkList,
                                                ayahSelectedFontColor:
                                                    ayahSelectedFontColor,
                                                textColor: textColor,
                                                ayahIconColor: ayahIconColor,
                                                showAyahBookmarkedIcon:
                                                    showAyahBookmarkedIcon,
                                                onAyahLongPress:
                                                    onAyahLongPress,
                                                bookmarksColor: bookmarksColor,
                                                surahNameStyle: surahNameStyle,
                                                bannerStyle: bannerStyle,
                                                basmalaStyle: basmalaStyle,
                                                onSurahBannerPress:
                                                    onSurahBannerPress,
                                                surahNumber: surahNumber,
                                                ayahSelectedBackgroundColor:
                                                    ayahSelectedBackgroundColor,
                                                onPagePress: onPagePress,
                                                isDark: isDark,
                                                fontsName: fontsName,
                                                ayahBookmarked: ayahBookmarked,
                                                userContext: parentContext,
                                                pageIndex: index,
                                                quranCtrl: quranCtrl,
                                                isFontsLocal: isFontsLocal!,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      if (onPagePress != null) {
                                        onPagePress!();
                                      } else {
                                        quranCtrl.showControlToggle();
                                        quranCtrl.state.isShowMenu.value =
                                            false;
                                      }
                                    },
                                    hoverColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: PageViewBuild(
                                      circularProgressWidget:
                                          circularProgressWidget,
                                      languageCode: languageCode,
                                      bookmarkList: bookmarkList,
                                      ayahSelectedFontColor:
                                          ayahSelectedFontColor,
                                      textColor: textColor,
                                      ayahIconColor: ayahIconColor,
                                      showAyahBookmarkedIcon:
                                          showAyahBookmarkedIcon,
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
                                      pageIndex: pageIndex,
                                      quranCtrl: quranCtrl,
                                      isFontsLocal: isFontsLocal!,
                                    ),
                                  ),
                          ),
                        ),
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
                );
              },
            )),
      ),
    );
  }
}
