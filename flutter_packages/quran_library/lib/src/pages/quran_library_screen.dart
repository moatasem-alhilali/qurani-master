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
    this.customBookmarksColor,
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
    this.isAyahBookmarked,
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
    this.isShowTabBar = true,
    this.enableWordSelection = true,
    this.displayModeBarStyle,
    this.ayahTafsirInlineStyle,
    this.quranTafsirSideStyle,
    this.wordInfoBottomSheetStyle,
    this.isShowDisplayModeBar = true,
    this.autoScrollStyle,
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
  final Color? Function(AyahModel)? customBookmarksColor;

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

  /// Callback اختياري لتحديد ما إذا كانت الآية محفوظة.
  ///
  /// عند توفيره سيتم تجاهل [ayahBookmarked] و BookmarksCtrl.bookmarksAyahs
  /// في تحديد حالة الحفظ (الأيقونة/الخلفية).
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

  /// لتحديد ما إذا كان يجب عرض شريط التبويب أم لا
  /// [isShowTabBar] To specify whether to show the tab bar or not
  final bool? isShowTabBar;

  /// تفعيل أو تعطيل تحديد الكلمة وعرض نافذة معلومات الكلمة عند الضغط [enableWordSelection]
  ///
  /// [enableWordSelection] Enable or disable word selection and word info bottom sheet on tap
  final bool enableWordSelection;

  /// نمط تخصيص شريط اختيار وضع العرض
  ///
  /// [displayModeBarStyle] Style customization for the display mode selector bar
  final DisplayModeBarStyle? displayModeBarStyle;

  /// نمط تخصيص وضع عرض الآية مع التفسير المُدمج
  ///
  /// [ayahTafsirInlineStyle] Style customization for the ayah-with-inline-tafsir display mode
  final AyahTafsirInlineStyle? ayahTafsirInlineStyle;

  /// نمط تخصيص وضع عرض القرآن مع التفسير الجانبي
  ///
  /// [quranTafsirSideStyle] Style customization for the quran-with-tafsir-side display mode
  final QuranTafsirSideStyle? quranTafsirSideStyle;

  /// نمط تخصيص معلومات الكلمة
  ///
  /// [wordInfoBottomSheetStyle] Style customization for the word info bottom sheet display mode
  final WordInfoBottomSheetStyle? wordInfoBottomSheetStyle;

  /// نمط تخصيص معلومات الكلمة
  ///
  /// [autoScrollStyle] Style customization for the auto scroll feature
  final AutoScrollStyle? autoScrollStyle;

  /// نمط تخصيص شريط اختيار وضع العرض
  ///
  /// [isShowDisplayModeBar] To specify whether to show the display mode bar or not
  final bool? isShowDisplayModeBar;

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
    // ضبط الصفحة فقط إذا مُرِّر pageIndex غير صفري — لتجنّب إعادة تعيين الصفحة المحفوظة
    if (pageIndex > 0) {
      QuranCtrl.instance.state.currentPageNumber.value = pageIndex + 1;
    }
    WordInfoCtrl.instance.isWordSelectionEnabled = enableWordSelection;
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
            displayModeBarStyle: displayModeBarStyle ??
                DisplayModeBarStyle.defaults(isDark: isDark, context: context),
            ayahTafsirInlineStyle: ayahTafsirInlineStyle ??
                AyahTafsirInlineStyle.defaults(
                    isDark: isDark, context: context),
            quranTafsirSideStyle: quranTafsirSideStyle ??
                QuranTafsirSideStyle.defaults(isDark: isDark, context: context),
            wordInfoBottomSheetStyle: wordInfoBottomSheetStyle ??
                WordInfoBottomSheetStyle.defaults(
                    isDark: isDark, context: context),
            autoScrollStyle: autoScrollStyle ??
                AutoScrollStyle.defaults(isDark: isDark, context: context),
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

                  // عند تعطيل PageView، لن يتم استدعاء onPageChanged، وبالتالي لن يتم
                  // تحضير الخطوط/بيانات QPC v4 تلقائياً. نُطلق التحضير هنا مرة واحدة
                  // بعد أول إطار لضمان عدم بقاء الصفحة على مؤشر التحميل.
                  if (!withPageView) {
                    Future(() async {
                      await quranCtrl.prewarmQpcV4Pages(pageIndex);
                    });
                  }
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
                              _onScaleUpdate(details, quranCtrl);
                            },
                            onScaleEnd: (_) {
                              if (quranCtrl.state.isScaling.value) {
                                quranCtrl.state.isScaling.value = false;
                                quranCtrl.update();
                              }
                            },
                            child: Obx(() {
                              // تحقق من تفعيل السكرول التلقائي أولاً
                              if (AutoScrollCtrl
                                  .instance.state.isActive.value) {
                                return AutoScrollPageView(
                                  quranCtrl: quranCtrl,
                                  autoScrollCtrl: AutoScrollCtrl.instance,
                                  isDark: isDark,
                                  languageCode: languageCode,
                                  onPagePress: onPagePress,
                                  circularProgressWidget:
                                      circularProgressWidget,
                                  bookmarkList: bookmarkList,
                                  ayahSelectedFontColor: ayahSelectedFontColor,
                                  textColor: textColor,
                                  ayahIconColor: ayahIconColor,
                                  showAyahBookmarkedIcon:
                                      showAyahBookmarkedIcon,
                                  onAyahLongPress: onAyahLongPress,
                                  bookmarksColor: bookmarksColor,
                                  customBookmarksColor: customBookmarksColor,
                                  surahNameStyle: surahNameStyle,
                                  bannerStyle: bannerStyle,
                                  basmalaStyle: basmalaStyle,
                                  onSurahBannerPress: onSurahBannerPress,
                                  surahNumber: surahNumber,
                                  ayahSelectedBackgroundColor:
                                      ayahSelectedBackgroundColor,
                                  fontsName: fontsName,
                                  ayahBookmarked: ayahBookmarked,
                                  isAyahBookmarked: isAyahBookmarked,
                                  parentContext: parentContext,
                                  isFontsLocal: isFontsLocal,
                                );
                              }
                              final mode = quranCtrl.state.displayMode.value;
                              switch (mode) {
                                case QuranDisplayMode.singleScrollable:
                                  return SingleScrollablePage(
                                    quranCtrl: quranCtrl,
                                    isDark: isDark,
                                    languageCode: languageCode,
                                    onPageChanged: (idx) =>
                                        _onPageChange(context, idx, quranCtrl),
                                    onPagePress: onPagePress,
                                    circularProgressWidget:
                                        circularProgressWidget,
                                    bookmarkList: bookmarkList,
                                    ayahSelectedFontColor:
                                        ayahSelectedFontColor,
                                    textColor: textColor,
                                    ayahIconColor: ayahIconColor,
                                    showAyahBookmarkedIcon:
                                        showAyahBookmarkedIcon,
                                    onAyahLongPress: onAyahLongPress,
                                    bookmarksColor: bookmarksColor,
                                  customBookmarksColor: customBookmarksColor,
                                    surahNameStyle: surahNameStyle,
                                    bannerStyle: bannerStyle,
                                    basmalaStyle: basmalaStyle,
                                    onSurahBannerPress: onSurahBannerPress,
                                    surahNumber: surahNumber,
                                    ayahSelectedBackgroundColor:
                                        ayahSelectedBackgroundColor,
                                    fontsName: fontsName,
                                    ayahBookmarked: ayahBookmarked,
                                    isAyahBookmarked: isAyahBookmarked,
                                    parentContext: parentContext,
                                    isFontsLocal: isFontsLocal,
                                  );
                                case QuranDisplayMode.dualPage:
                                  return DualPageView(
                                    quranCtrl: quranCtrl,
                                    isDark: isDark,
                                    languageCode: languageCode,
                                    onPageChanged: (idx) =>
                                        _onPageChange(context, idx, quranCtrl),
                                    onPagePress: onPagePress,
                                    circularProgressWidget:
                                        circularProgressWidget,
                                    bookmarkList: bookmarkList,
                                    ayahSelectedFontColor:
                                        ayahSelectedFontColor,
                                    textColor: textColor,
                                    ayahIconColor: ayahIconColor,
                                    showAyahBookmarkedIcon:
                                        showAyahBookmarkedIcon,
                                    onAyahLongPress: onAyahLongPress,
                                    bookmarksColor: bookmarksColor,
                                  customBookmarksColor: customBookmarksColor,
                                    surahNameStyle: surahNameStyle,
                                    bannerStyle: bannerStyle,
                                    basmalaStyle: basmalaStyle,
                                    onSurahBannerPress: onSurahBannerPress,
                                    surahNumber: surahNumber,
                                    ayahSelectedBackgroundColor:
                                        ayahSelectedBackgroundColor,
                                    fontsName: fontsName,
                                    ayahBookmarked: ayahBookmarked,
                                    isAyahBookmarked: isAyahBookmarked,
                                    parentContext: parentContext,
                                    isFontsLocal: isFontsLocal,
                                  );
                                case QuranDisplayMode.quranWithTafsirSide:
                                  return QuranWithTafsirSide(
                                    quranCtrl: quranCtrl,
                                    isDark: isDark,
                                    languageCode: languageCode,
                                    onPageChanged: (idx) =>
                                        _onPageChange(context, idx, quranCtrl),
                                    onPagePress: onPagePress,
                                    circularProgressWidget:
                                        circularProgressWidget,
                                    bookmarkList: bookmarkList,
                                    ayahSelectedFontColor:
                                        ayahSelectedFontColor,
                                    textColor: textColor,
                                    ayahIconColor: ayahIconColor,
                                    showAyahBookmarkedIcon:
                                        showAyahBookmarkedIcon,
                                    onAyahLongPress: onAyahLongPress,
                                    bookmarksColor: bookmarksColor,
                                  customBookmarksColor: customBookmarksColor,
                                    surahNameStyle: surahNameStyle,
                                    bannerStyle: bannerStyle,
                                    basmalaStyle: basmalaStyle,
                                    onSurahBannerPress: onSurahBannerPress,
                                    surahNumber: surahNumber,
                                    ayahSelectedBackgroundColor:
                                        ayahSelectedBackgroundColor,
                                    fontsName: fontsName,
                                    ayahBookmarked: ayahBookmarked,
                                    isAyahBookmarked: isAyahBookmarked,
                                    parentContext: parentContext,
                                    isFontsLocal: isFontsLocal,
                                  );
                                case QuranDisplayMode.ayahWithTafsirInline:
                                  return AyahWithTafsirInline(
                                    quranCtrl: quranCtrl,
                                    isDark: isDark,
                                    languageCode: languageCode,
                                    onPageChanged: (idx) =>
                                        _onPageChange(context, idx, quranCtrl),
                                    onPagePress: onPagePress,
                                    parentContext: parentContext,
                                    bannerStyle: bannerStyle,
                                    surahNameStyle: surahNameStyle,
                                    onSurahBannerPress: onSurahBannerPress,
                                    basmalaStyle: basmalaStyle,
                                    ayahBookmarked: ayahBookmarked,
                                    isAyahBookmarked: isAyahBookmarked,
                                    showAyahBookmarkedIcon:
                                        showAyahBookmarkedIcon,
                                    bookmarksColor: bookmarksColor,
                                  customBookmarksColor: customBookmarksColor,
                                    style: ayahTafsirInlineStyle ??
                                        AyahTafsirInlineStyle.defaults(
                                          isDark: isDark,
                                          context: context,
                                        ),
                                    audioStyle: ayahStyle ??
                                        AyahAudioStyle.defaults(
                                          isDark: isDark,
                                          context: context,
                                        ),
                                    ayahDownloadManagerStyle:
                                        ayahDownloadManagerStyle ??
                                            AyahDownloadManagerStyle.defaults(
                                              isDark: isDark,
                                              context: context,
                                            ),
                                  );
                                case QuranDisplayMode.defaultMode:
                                  return _buildDefaultPageView(
                                      context, quranCtrl, languageCode);
                              }
                            }),
                          ),
                        ),
                        _ControlWidget(
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
                          isShowTabBar: isShowTabBar,
                          topBarStyle: topBarStyle,
                          isShowDisplayModeBar: isShowDisplayModeBar,
                          autoScrollStyle: autoScrollStyle,
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

  void _onScaleUpdate(ScaleUpdateDetails details, QuranCtrl quranCtrl) {
    // عند وجود إصبعين أو أكثر نعتبرها عملية تكبير/تصغير ونوقف سكرول الصفحات
    if (details.pointerCount >= 2 && quranCtrl.state.isScaling.value == false) {
      quranCtrl.state.isScaling.value = true;
      quranCtrl.update();
    } else if (details.pointerCount < 2 &&
        quranCtrl.state.isScaling.value == true) {
      // عاد المستخدم لإصبع واحد -> أعِد تفعيل السحب
      quranCtrl.state.isScaling.value = false;
      quranCtrl.update();
    }
    quranCtrl.updateTextScale(details);
  }

  /// بناء عرض الصفحة الافتراضي (PageView أو صفحة واحدة بدون سحب)
  Widget _buildDefaultPageView(
      BuildContext context, QuranCtrl quranCtrl, String languageCode) {
    if (withPageView) {
      return Focus(
        focusNode: quranCtrl.state.quranPageRLFocusNode,
        autofocus: kIsWeb ? false : true,
        onKeyEvent: (node, event) => quranCtrl.controlRLByKeyboard(node, event),
        child: PatchedPreloadPageView.builder(
          preloadPagesCount: 2,
          padEnds: false,
          itemCount: 604,
          controller: quranCtrl.getPageController(context),
          physics: quranCtrl.state.isScaling.value
              ? const NeverScrollableScrollPhysics()
              : const ClampingScrollPhysics(),
          onPageChanged: (idx) => _onPageChange(context, idx, quranCtrl),
          pageSnapping: true,
          itemBuilder: (ctx, index) => _ItemBuilderWidget(
            index: index,
            quranCtrl: quranCtrl,
            onPagePress: onPagePress,
            circularProgressWidget: circularProgressWidget,
            languageCode: languageCode,
            bookmarkList: bookmarkList,
            ayahSelectedFontColor: ayahSelectedFontColor,
            textColor: textColor,
            ayahIconColor: ayahIconColor,
            showAyahBookmarkedIcon: showAyahBookmarkedIcon,
            onAyahLongPress: onAyahLongPress,
            bookmarksColor: bookmarksColor,
                                  customBookmarksColor: customBookmarksColor,
            surahNameStyle: surahNameStyle,
            bannerStyle: bannerStyle,
            basmalaStyle: basmalaStyle,
            onSurahBannerPress: onSurahBannerPress,
            surahNumber: surahNumber,
            ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
            isDark: isDark,
            fontsName: fontsName,
            ayahBookmarked: ayahBookmarked,
            isAyahBookmarked: isAyahBookmarked,
            parentContext: parentContext,
            isFontsLocal: isFontsLocal,
          ),
        ),
      );
    }
    return _ItemBuilderWidget(
      index: pageIndex,
      quranCtrl: quranCtrl,
      onPagePress: onPagePress,
      circularProgressWidget: circularProgressWidget,
      languageCode: languageCode,
      bookmarkList: bookmarkList,
      ayahSelectedFontColor: ayahSelectedFontColor,
      textColor: textColor,
      ayahIconColor: ayahIconColor,
      showAyahBookmarkedIcon: showAyahBookmarkedIcon,
      onAyahLongPress: onAyahLongPress,
      bookmarksColor: bookmarksColor,
                                  customBookmarksColor: customBookmarksColor,
      surahNameStyle: surahNameStyle,
      bannerStyle: bannerStyle,
      basmalaStyle: basmalaStyle,
      onSurahBannerPress: onSurahBannerPress,
      surahNumber: surahNumber,
      ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
      isDark: isDark,
      fontsName: fontsName,
      ayahBookmarked: ayahBookmarked,
      isAyahBookmarked: isAyahBookmarked,
      parentContext: parentContext,
      isFontsLocal: isFontsLocal,
    );
  }

  void _onPageChange(BuildContext context, int pageIndex, QuranCtrl quranCtrl) {
    // تشغيل العمليات في الخلفية لتجنب تجميد UI
    // Run operations in background to avoid UI freeze
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;
      if (onPageChanged != null) {
        // لا تلمس الـ Overlay إذا كان المستخدم يدير الحدث بنفسه
        onPageChanged!(pageIndex);
      }
      quranCtrl.state.currentPageNumber.value = pageIndex + 1;
      quranCtrl.saveLastPage(pageIndex + 1);

      if (quranCtrl.state.fontsSelected.value == 0) {
        // جدولة تحضير QPC v4 بعد خمول حتى لا ينافس أثناء التقليب.
        quranCtrl.scheduleQpcV4AllPagesPrebuild();
        // تحميل كسول: تأكد من جاهزية الصفحات القريبة من الصفحة الحالية
        // QuranFontsService.ensurePagesLoaded(pageIndex + 1, radius: 3);
      }
    });
  }
}

class _ControlWidget extends StatelessWidget {
  const _ControlWidget({
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
    required this.isShowTabBar,
    required this.topBarStyle,
    required this.isShowDisplayModeBar,
    required this.autoScrollStyle,
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
  final bool? isShowTabBar;
  final bool? isShowDisplayModeBar;
  final QuranTopBarStyle? topBarStyle;
  final AutoScrollStyle? autoScrollStyle;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranCtrl>(
      id: 'isShowControl',
      builder: (quranCtrl) {
        return Obx(() {
          final visible = quranCtrl.isShowControl.value;
          // إخفاء كل عناصر التحكم أثناء السكرول التلقائي النشط (غير المتوقف)
          final autoScroll = AutoScrollCtrl.instance;
          final isAutoScrollRunning = autoScroll.state.isActive.value &&
              !autoScroll.state.isPaused.value;
          final shouldShow = visible && !isAutoScrollRunning;

          return RepaintBoundary(
            child: IgnorePointer(
              ignoring: !shouldShow,
              child: AnimatedOpacity(
                opacity: shouldShow ? 1.0 : 0.0,
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
                                    isDark: isDark, context: context),
                            isDark: isDark,
                            languageCode: languageCode,
                            downloadManagerStyle: ayahDownloadManagerStyle,
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
                    appBar == null && useDefaultAppBar && visible
                        ? _QuranTopBar(
                            languageCode,
                            isDark,
                            style: surahStyle ?? SurahAudioStyle(),
                            backgroundColor: backgroundColor,
                            downloadFontsDialogStyle: downloadFontsDialogStyle,
                            isFontsLocal: isFontsLocal,
                          )
                        : const SizedBox.shrink(),
                    isShowTabBar!
                        ? Positioned(
                            top: 70,
                            child: QuranOrTenRecitationsTabBar(
                                bgColor: backgroundColor ??
                                    AppColors.getBackgroundColor(isDark),
                                defaults: topBarStyle ??
                                    QuranTopBarStyle.defaults(
                                        context: context, isDark: isDark),
                                isDark: isDark),
                          )
                        : const SizedBox.shrink(),
                    // شريط اختيار وضع العرض - يظهر على الجانب
                    // Display mode selector bar - appears on the side
                    if (isShowDisplayModeBar!)
                      Positioned(
                        right: 8,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: DisplayModeBar(
                            isDark: isDark,
                            languageCode: languageCode,
                          ),
                        ),
                      ),
                    // شريط التحكم بسرعة السكرول التلقائي — يبقى ظاهرًا بشكل مستقل
                    AutoScrollSpeedSlider(
                      isDark: isDark,
                      autoScrollStyle: autoScrollStyle ??
                          AutoScrollStyle.defaults(
                              isDark: isDark, context: context),
                      languageCode: languageCode,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

class _ItemBuilderWidget extends StatelessWidget {
  const _ItemBuilderWidget({
    required this.index,
    required this.quranCtrl,
    required this.onPagePress,
    required this.circularProgressWidget,
    required this.languageCode,
    required this.bookmarkList,
    required this.ayahSelectedFontColor,
    required this.textColor,
    required this.ayahIconColor,
    required this.showAyahBookmarkedIcon,
    required this.onAyahLongPress,
    required this.bookmarksColor,
    this.customBookmarksColor,
    required this.surahNameStyle,
    required this.bannerStyle,
    required this.basmalaStyle,
    required this.onSurahBannerPress,
    required this.surahNumber,
    required this.ayahSelectedBackgroundColor,
    required this.isDark,
    required this.fontsName,
    required this.ayahBookmarked,
    required this.isAyahBookmarked,
    required this.parentContext,
    required this.isFontsLocal,
  });

  final int index;
  final QuranCtrl quranCtrl;
  final VoidCallback? onPagePress;
  final Widget? circularProgressWidget;
  final String languageCode;
  final List<dynamic> bookmarkList;
  final Color? ayahSelectedFontColor;
  final Color? textColor;
  final Color? ayahIconColor;
  final bool showAyahBookmarkedIcon;
  final void Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final Color? bookmarksColor;
  final Color? Function(AyahModel)? customBookmarksColor;
  final SurahNameStyle? surahNameStyle;
  final BannerStyle? bannerStyle;
  final BasmalaStyle? basmalaStyle;
  final void Function(SurahNamesModel surah)? onSurahBannerPress;
  final int? surahNumber;
  final Color? ayahSelectedBackgroundColor;
  final bool isDark;
  final String? fontsName;
  final List<int>? ayahBookmarked;
  final bool Function(AyahModel ayah)? isAyahBookmarked;
  final BuildContext parentContext;
  final bool? isFontsLocal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onPagePress != null) {
          onPagePress!();
        } else {
          quranCtrl.showControlToggle();
          QuranCtrl.instance.state.isShowMenu.value = false;
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
            circularProgressWidget: circularProgressWidget,
            languageCode: languageCode,
            bookmarkList: bookmarkList,
            ayahSelectedFontColor: ayahSelectedFontColor,
            textColor: textColor,
            ayahIconColor: ayahIconColor,
            showAyahBookmarkedIcon: showAyahBookmarkedIcon,
            onAyahLongPress: onAyahLongPress,
            bookmarksColor: bookmarksColor,
                                  customBookmarksColor: customBookmarksColor,
            surahNameStyle: surahNameStyle,
            bannerStyle: bannerStyle,
            basmalaStyle: basmalaStyle,
            onSurahBannerPress: onSurahBannerPress,
            surahNumber: surahNumber,
            ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
            onPagePress: onPagePress,
            isDark: isDark,
            fontsName: fontsName,
            ayahBookmarked: ayahBookmarked,
            isAyahBookmarked: isAyahBookmarked,
            userContext: parentContext,
            pageIndex: index,
            quranCtrl: quranCtrl,
            isFontsLocal: isFontsLocal!,
          ),
        ),
      ),
    );
  }
}
