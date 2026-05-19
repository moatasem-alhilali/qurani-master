part of '/quran.dart';

/// وضع عرض آيات الصفحة مع تفسير كل آية (عمودي وأفقي)
///
/// يعرض آيات الصفحة الحالية مع تفسير كل آية تحتها مباشرة.
/// يمكن التمرير عموديًا لقراءة كل الآيات، والتقليب يمين/يسار لتغيير الصفحة.
///
/// [AyahWithTafsirInline] Displays page ayahs with inline tafsir below each
/// ayah. Vertically scrollable, swipe left/right to change pages.
class AyahWithTafsirInline extends StatelessWidget {
  const AyahWithTafsirInline({
    super.key,
    required this.quranCtrl,
    required this.isDark,
    required this.languageCode,
    required this.onPageChanged,
    required this.onPagePress,
    required this.parentContext,
    this.style,
    this.bannerStyle,
    this.surahNameStyle,
    this.onSurahBannerPress,
    this.basmalaStyle,
    this.audioStyle,
    this.ayahDownloadManagerStyle,
    this.ayahBookmarked,
    this.isAyahBookmarked,
    this.showAyahBookmarkedIcon = true,
    this.bookmarksColor,
    this.customBookmarksColor,
    this.usePageView = true,
    this.withOptionsBar = true,
    this.showAyahNumber = false,
  });

  final QuranCtrl quranCtrl;
  final bool isDark;
  final String languageCode;
  final Function(int pageNumber)? onPageChanged;
  final VoidCallback? onPagePress;
  final BuildContext parentContext;
  final AyahTafsirInlineStyle? style;
  final BannerStyle? bannerStyle;
  final SurahNameStyle? surahNameStyle;
  final Function(SurahNamesModel surah)? onSurahBannerPress;
  final BasmalaStyle? basmalaStyle;
  final AyahAudioStyle? audioStyle;
  final AyahDownloadManagerStyle? ayahDownloadManagerStyle;
  final List<int>? ayahBookmarked;
  final bool Function(AyahModel ayah)? isAyahBookmarked;
  final bool showAyahBookmarkedIcon;
  final Color? bookmarksColor;
  final Color? Function(AyahModel)? customBookmarksColor;

  /// عند `false` يُعرض المحتوى بدون PageView ويستمع لتغيّر الصفحة من [QuranCtrl].
  /// عند استخدامه داخل [QuranWithTafsirSide] يجب أن يكون `false`.
  ///
  /// When `false`, content is shown without PageView and listens to
  /// page changes from [QuranCtrl]. Set to `false` inside [QuranWithTafsirSide].
  final bool usePageView;
  final bool? withOptionsBar;
  final bool? showAyahNumber;

  @override
  Widget build(BuildContext context) {
    final s = style ??
        (AyahTafsirInlineTheme.of(context)?.style ??
            AyahTafsirInlineStyle.defaults(isDark: isDark, context: context));

    // بدون PageView: يستمع لرقم الصفحة الحالية ويعرض المحتوى مباشرة
    if (!usePageView) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Obx(() {
          final currentPage = quranCtrl.state.currentPageNumber.value;
          final pageIndex = (currentPage - 1).clamp(0, 603);
          return _AyahTafsirInlinePage(
            key: ValueKey('inline_page_$pageIndex'),
            pageIndex: pageIndex,
            isDark: isDark,
            style: s,
            languageCode: languageCode,
            bannerStyle: bannerStyle,
            surahNameStyle: surahNameStyle,
            onSurahBannerPress: onSurahBannerPress,
            basmalaStyle: basmalaStyle,
            audioStyle: audioStyle,
            ayahDownloadManagerStyle: ayahDownloadManagerStyle,
            ayahBookmarked: ayahBookmarked ?? const [],
            isAyahBookmarked: isAyahBookmarked,
            showAyahBookmarkedIcon: showAyahBookmarkedIcon,
            bookmarksColor: bookmarksColor,
            customBookmarksColor: customBookmarksColor,
            withOptionsBar: withOptionsBar,
            showAyahNumber: showAyahNumber,
          );
        }),
      );
    }

    // مع PageView: التقليب الأفقي بين الصفحات
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PatchedPreloadPageView.builder(
        preloadPagesCount: 1,
        padEnds: false,
        itemCount: 604,
        controller: quranCtrl.getPageController(context),
        physics: const ClampingScrollPhysics(),
        onPageChanged: (pageIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            if (onPageChanged != null) onPageChanged!(pageIndex);
            quranCtrl.state.currentPageNumber.value = pageIndex + 1;
            quranCtrl.saveLastPage(pageIndex + 1);
          });
        },
        pageSnapping: true,
        itemBuilder: (ctx, index) => InkWell(
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
          child: _AyahTafsirInlinePage(
            pageIndex: index,
            isDark: isDark,
            style: s,
            languageCode: languageCode,
            bannerStyle: bannerStyle,
            surahNameStyle: surahNameStyle,
            onSurahBannerPress: onSurahBannerPress,
            basmalaStyle: basmalaStyle,
            audioStyle: audioStyle,
            ayahDownloadManagerStyle: ayahDownloadManagerStyle,
            ayahBookmarked: ayahBookmarked ?? const [],
            isAyahBookmarked: isAyahBookmarked,
            showAyahBookmarkedIcon: showAyahBookmarkedIcon,
            bookmarksColor: bookmarksColor,
            customBookmarksColor: customBookmarksColor,
            withOptionsBar: withOptionsBar,
            showAyahNumber: showAyahNumber,
          ),
        ),
      ),
    );
  }
}

/// صفحة واحدة في وضع الآية مع التفسير
class _AyahTafsirInlinePage extends StatefulWidget {
  const _AyahTafsirInlinePage({
    super.key,
    required this.pageIndex,
    required this.isDark,
    required this.style,
    required this.languageCode,
    this.bannerStyle,
    this.surahNameStyle,
    this.onSurahBannerPress,
    this.basmalaStyle,
    this.audioStyle,
    this.ayahDownloadManagerStyle,
    required this.ayahBookmarked,
    this.isAyahBookmarked,
    this.showAyahBookmarkedIcon = true,
    this.bookmarksColor,
    this.customBookmarksColor,
    this.withOptionsBar = true,
    this.showAyahNumber = false,
  });

  final int pageIndex;
  final bool isDark;
  final AyahTafsirInlineStyle style;
  final String languageCode;
  final BannerStyle? bannerStyle;
  final SurahNameStyle? surahNameStyle;
  final Function(SurahNamesModel surah)? onSurahBannerPress;
  final BasmalaStyle? basmalaStyle;
  final AyahAudioStyle? audioStyle;
  final AyahDownloadManagerStyle? ayahDownloadManagerStyle;
  final List<int> ayahBookmarked;
  final bool Function(AyahModel ayah)? isAyahBookmarked;
  final bool showAyahBookmarkedIcon;
  final Color? bookmarksColor;
  final Color? Function(AyahModel)? customBookmarksColor;
  final bool? withOptionsBar;
  final bool? showAyahNumber;

  @override
  State<_AyahTafsirInlinePage> createState() => _AyahTafsirInlinePageState();
}

class _AyahTafsirInlinePageState extends State<_AyahTafsirInlinePage>
    with AutomaticKeepAliveClientMixin {
  /// حفظ الـ Future مرة واحدة لتجنب إعادة التحميل في كل build
  late Future<void> _tafsirFuture;
  late int _lastRadioValue;

  bool _lastIsDark = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _lastRadioValue = TafsirCtrl.instance.radioValue.value;
    _lastIsDark = widget.isDark;
    _tafsirFuture = _loadTafsir(widget.pageIndex + 1);
  }

  @override
  void didUpdateWidget(covariant _AyahTafsirInlinePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentRadio = TafsirCtrl.instance.radioValue.value;
    // أعد تحميل التفسير فقط إذا تغيّر رقم الصفحة أو مصدر التفسير
    if (oldWidget.pageIndex != widget.pageIndex ||
        _lastRadioValue != currentRadio) {
      final sourceChanged = _lastRadioValue != currentRadio;
      _lastRadioValue = currentRadio;
      _tafsirFuture =
          _loadTafsir(widget.pageIndex + 1, forceReload: sourceChanged);
    }
    if (widget.isDark != _lastIsDark) {
      _lastIsDark = widget.isDark;
    }
  }

  Future<void> _loadTafsir(int pageNumber, {bool forceReload = false}) async {
    final tafsirCtrl = TafsirCtrl.instance;
    if (tafsirCtrl.selectedTafsir.isTafsir) {
      // تحميل فقط إذا كانت القائمة فارغة أو تغيّر المصدر
      if (forceReload || tafsirCtrl.tafseerList.isEmpty) {
        await tafsirCtrl.fetchData(pageNumber);
      }
    } else {
      if (forceReload || tafsirCtrl.translationList.isEmpty) {
        await tafsirCtrl.fetchTranslate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // مطلوب لـ AutomaticKeepAliveClientMixin
    final quranCtrl = QuranCtrl.instance;

    return FutureBuilder<void>(
      future: _tafsirFuture,
      builder: (context, snapshot) {
        final pageAyahs = quranCtrl.getPageAyahsByIndex(widget.pageIndex);
        if (pageAyahs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // شريط تغيير التفسير وحجم الخط
            widget.style.headerWidget ??
                _InlineTafsirHeader(
                  isDark: widget.isDark,
                  style: widget.style,
                  languageCode: widget.languageCode,
                ),
            // الآيات مع التفسير
            Expanded(
              child: GetBuilder<TafsirCtrl>(
                id: 'change_font_size',
                builder: (ctrl) {
                  final isTafsir = ctrl.selectedTafsir.isTafsir;
                  final language = ctrl
                      .tafsirAndTranslationsItems[ctrl.radioValue.value].name;

                  // بناء Map للتفسير مرة واحدة بدل البحث الخطي لكل آية
                  final tafsirMap = <int, TafsirTableData>{};
                  if (isTafsir) {
                    for (final t in ctrl.tafseerList) {
                      tafsirMap[t.id] = t;
                    }
                  }

                  // بناء Map للترجمة عند وضع الترجمة
                  final translationMap = <String, TranslationModel>{};
                  if (!isTafsir) {
                    for (final t in ctrl.translationList) {
                      translationMap['${t.surahNumber}:${t.ayahNumber}'] = t;
                    }
                  }

                  return GetBuilder<BookmarksCtrl>(
                    id: 'bookmarks',
                    builder: (bookmarksCtrl) {
                      final bookmarksSet = bookmarksCtrl.bookmarksAyahsSet;
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: pageAyahs.length,
                        addAutomaticKeepAlives: true,
                        cacheExtent: 600,
                        itemBuilder: (context, index) {
                          final ayah = pageAyahs[index];
                          final tafsir = isTafsir
                              ? (tafsirMap[ayah.ayahUQNumber] ??
                                  const TafsirTableData(
                                    id: 0,
                                    tafsirText: '',
                                    ayahNum: 0,
                                    pageNum: 0,
                                    surahNum: 0,
                                  ))
                              : const TafsirTableData(
                                  id: 0,
                                  tafsirText: '',
                                  ayahNum: 0,
                                  pageNum: 0,
                                  surahNum: 0,
                                );

                          // البحث عن الترجمة بناءً على رقم السورة والآية
                          final translation = !isTafsir
                              ? translationMap[
                                  '${ayah.surahNumber}:${ayah.ayahNumber}']
                              : null;

                          // O(1) بدل O(n) — الوصول المباشر عبر surahNumber
                          final surahNum = ayah.surahNumber ?? 0;
                          final surah = (surahNum > 0 &&
                                  surahNum <= quranCtrl.surahs.length)
                              ? quranCtrl.surahs[surahNum - 1]
                              : quranCtrl
                                  .getCurrentSurahByPageNumber(ayah.page);

                          return RepaintBoundary(
                            child: _InlineAyahTafsirItem(
                              ayah: ayah,
                              tafsir: tafsir,
                              surah: surah,
                              isDark: widget.isDark,
                              style: widget.style,
                              tafsirCtrl: ctrl,
                              pageIndex: widget.pageIndex,
                              languageCode: widget.languageCode,
                              bannerStyle: widget.bannerStyle,
                              surahNameStyle: widget.surahNameStyle,
                              onSurahBannerPress: widget.onSurahBannerPress,
                              basmalaStyle: widget.basmalaStyle,
                              audioStyle: widget.audioStyle,
                              ayahDownloadManagerStyle:
                                  widget.ayahDownloadManagerStyle,
                              ayahBookmarked: widget.ayahBookmarked,
                              isAyahBookmarked: widget.isAyahBookmarked,
                              showAyahBookmarkedIcon:
                                  widget.showAyahBookmarkedIcon,
                              bookmarksColor: widget.bookmarksColor,
                              customBookmarksColor: widget.customBookmarksColor,
                              withOptionsBar: widget.withOptionsBar,
                              showAyahNumber: widget.showAyahNumber,
                              translation: translation,
                              bookmarksSet: bookmarksSet,
                              language: language,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// شريط تغيير التفسير العلوي لوضع الآية مع التفسير
class _InlineTafsirHeader extends StatelessWidget {
  const _InlineTafsirHeader({
    required this.isDark,
    required this.style,
    required this.languageCode,
  });

  final bool isDark;
  final AyahTafsirInlineStyle style;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: style.backgroundColor ?? AppColors.getBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          bottom: BorderSide(
            width: 5,
            color: style.dividerColor ?? Colors.teal,
          ),
        ),
      ),
      child: Row(
        children: [
          GetBuilder<TafsirCtrl>(
              id: 'actualTafsirContent',
              builder: (_) => ChangeTafsirDialog(
                  tafsirStyle: TafsirTheme.of(context)?.style ??
                      TafsirStyle.defaults(isDark: isDark, context: context),
                  isDark: isDark)),
          const Spacer(),
          style.fontSizeWidget ??
              fontSizeDropDown(
                height: 30.0,
                tafsirStyle: TafsirTheme.of(context)?.style ??
                    TafsirStyle.defaults(isDark: isDark, context: context),
                isDark: isDark,
              ),
        ],
      ),
    );
  }
}

/// عنصر آية واحدة مع التفسير في وضع العرض المدمج
class _InlineAyahTafsirItem extends StatelessWidget {
  const _InlineAyahTafsirItem({
    required this.ayah,
    required this.tafsir,
    required this.surah,
    required this.isDark,
    required this.style,
    required this.tafsirCtrl,
    required this.pageIndex,
    required this.languageCode,
    this.bannerStyle,
    this.surahNameStyle,
    this.onSurahBannerPress,
    this.basmalaStyle,
    this.audioStyle,
    this.ayahDownloadManagerStyle,
    required this.ayahBookmarked,
    this.isAyahBookmarked,
    this.showAyahBookmarkedIcon = true,
    this.bookmarksColor,
    this.customBookmarksColor,
    this.withOptionsBar = true,
    this.showAyahNumber = false,
    this.translation,
    required this.bookmarksSet,
    required this.language,
  });

  final AyahModel ayah;
  final TafsirTableData tafsir;
  final SurahModel surah;
  final bool isDark;
  final AyahTafsirInlineStyle style;
  final TafsirCtrl tafsirCtrl;
  final int pageIndex;
  final String languageCode;
  final BannerStyle? bannerStyle;
  final SurahNameStyle? surahNameStyle;
  final Function(SurahNamesModel surah)? onSurahBannerPress;
  final BasmalaStyle? basmalaStyle;
  final AyahAudioStyle? audioStyle;
  final AyahDownloadManagerStyle? ayahDownloadManagerStyle;
  final List<int> ayahBookmarked;
  final bool Function(AyahModel ayah)? isAyahBookmarked;
  final bool showAyahBookmarkedIcon;
  final Color? bookmarksColor;
  final Color? Function(AyahModel)? customBookmarksColor;
  final bool? withOptionsBar;
  final bool? showAyahNumber;
  final TranslationModel? translation;
  final Set<int> bookmarksSet;
  final String language;

  @override
  Widget build(BuildContext context) {
    final isTafsir = tafsirCtrl.selectedTafsir.isTafsir;
    final fontSize = tafsirCtrl.fontSizeArabic.value;

    // الحصول على نمط الصوت / Get audio style
    final sAudio =
        audioStyle ?? AyahAudioStyle.defaults(isDark: isDark, context: context);
    final sDownloadManager = ayahDownloadManagerStyle ??
        AyahDownloadManagerStyle.defaults(isDark: isDark, context: context);

    final colors = style.bookmarkColorCodes ??
        const [
          0xAAFFD354,
          0xAAF36077,
          0xAA00CD00,
        ];

    final int ayahUQNum = ayah.ayahUQNumber;
    final hasBookmark = isAyahBookmarked != null
        ? isAyahBookmarked!(ayah)
        : (ayahBookmarked.contains(ayahUQNum) ||
            bookmarksSet.contains(ayahUQNum));

    return Container(
      padding: style.ayahPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: style.backgroundColor ?? AppColors.getBackgroundColor(isDark),
        border: Border(
          bottom: BorderSide(
            color: style.dividerColor ??
                (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            width: style.dividerThickness ?? 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ayah.ayahNumber == 1
              ? SurahHeaderWidget(
                  surah.surahNumber,
                  bannerStyle: bannerStyle ??
                      BannerStyle().copyWith(
                        bannerSvgHeight: 35.w,
                      ),
                  surahNameStyle: surahNameStyle ??
                      SurahNameStyle(
                        surahNameSize: 35.w,
                        surahNameColor: AppColors.getTextColor(isDark),
                      ),
                  onSurahBannerPress: onSurahBannerPress,
                  isDark: isDark,
                )
              : const SizedBox.shrink(),
          ayah.ayahNumber == 1 &&
                  surah.surahNumber != 9 &&
                  surah.surahNumber != 1
              ? BasmallahWidget(
                  surahNumber: surah.surahNumber,
                  basmalaStyle: basmalaStyle ??
                      BasmalaStyle(
                        basmalaColor: AppColors.getTextColor(isDark),
                        basmalaFontSize: 23.0.w,
                        verticalPadding: 0.0,
                      ),
                )
              : const SizedBox.shrink(),
          // رقم الآية واسم السورة — يتفاعل مع تغييرات الإشارات المرجعية

          if (withOptionsBar == true)
            (style.optionsBarWidget?.call(ayah, surah, pageIndex)) ??
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: style.optionsBarBackgroundColor ??
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      (hasBookmark && showAyahBookmarkedIcon)
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: SvgPicture.asset(
                                AssetsPath.assets.ayahBookmarked,
                                height: 30,
                                width: 30,
                              ),
                            )
                          : Text(
                              '${ayah.ayahNumber}'
                                  .convertEnglishNumbersToArabic(
                                      ayah.ayahNumber.toString()),
                              style: TextStyle(
                                fontFamily: 'ayahNumber',
                                fontSize: (fontSize + 5),
                                height: 1.5,
                                package: 'quran_library',
                                color: style.ayahNumberColor ??
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                      const Spacer(),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              AudioCtrl.instance.playAyah(
                                context,
                                ayah.ayahUQNumber,
                                playSingleAyah: true,
                                ayahAudioStyle: sAudio,
                                ayahDownloadManagerStyle: sDownloadManager,
                                isDarkMode: isDark,
                              );
                              log('Second Menu Child Tapped: ${ayah.ayahUQNumber}');
                            },
                            child: Icon(
                              style.playIconData,
                              color: style.playIconColor,
                              size: style.iconSize,
                            ),
                          ),
                          SizedBox(width: style.iconHorizontalPadding ?? 4.0),
                          GestureDetector(
                            onTap: () {
                              AudioCtrl.instance.playAyah(
                                context,
                                ayah.ayahUQNumber,
                                playSingleAyah: false,
                                ayahAudioStyle: sAudio,
                                ayahDownloadManagerStyle: sDownloadManager,
                                isDarkMode: isDark,
                              );
                              log('Second Menu Child Tapped: ${ayah.ayahUQNumber}');
                            },
                            child: Icon(
                              style.playAllIconData,
                              color: style.playAllIconColor,
                              size: style.iconSize,
                            ),
                          ),
                          SizedBox(width: style.iconHorizontalPadding ?? 4.0),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: ayah.text));
                            },
                            child: Icon(
                              style.copyIconData,
                              color: style.copyIconColor,
                              size: style.iconSize,
                            ),
                          ),
                          SizedBox(width: style.iconHorizontalPadding ?? 4.0),

                          // أزرار العلامات المرجعية

                          for (final colorCode in colors) ...{
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: style.iconHorizontalPadding ?? 4.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  final bmCtrl = BookmarksCtrl.instance;
                                  final existing = bmCtrl.bookmarks[colorCode]
                                      ?.cast<BookmarkModel?>()
                                      .firstWhere(
                                        (b) => b!.ayahId == ayah.ayahUQNumber,
                                        orElse: () => null,
                                      );
                                  if (existing != null) {
                                    bmCtrl.removeBookmark(existing.id);
                                  } else {
                                    bmCtrl.saveBookmark(
                                      surahName: surah.arabicName,
                                      ayahNumber: ayah.ayahNumber,
                                      ayahId: ayah.ayahUQNumber,
                                      page: ayah.page,
                                      colorCode: colorCode,
                                    );
                                  }
                                },
                                child: Icon(
                                  style.bookmarkIconData,
                                  color: Color(colorCode),
                                  size: style.iconSize,
                                ),
                              ),
                            ),
                          }
                        ],
                      )
                    ],
                  ),
                ),
          // نص الآية
          GetSingleAyah(
            surahNumber: surah.surahNumber,
            ayahNumber: ayah.ayahNumber,
            fontSize: fontSize,
            isBold: false,
            ayahs: ayah,
            isSingleAyah: false,
            showAyahNumber: showAyahNumber,
            isDark: isDark,
            pageIndex: pageIndex + 1,
            textColor: style.ayahTextColor,
            textAlign: TextAlign.center,
            enabledTajweed: QuranCtrl.instance.state.isTajweedEnabled.value,
          ),
          const SizedBox(height: 10),
          // خلفية التفسير
          Container(
            width: double.infinity,
            padding: style.tafsirPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: style.tafsirBackgroundColor ??
                  (isDark
                      ? Colors.grey.shade900.withValues(alpha: .5)
                      : Colors.grey.shade100.withValues(alpha: .7)),
              borderRadius: BorderRadius.circular(
                  style.tafsirBackgroundBorderRadius ?? 12.0),
            ),
            child: _buildTafsirOrTranslationContent(
              context: context,
              isTafsir: isTafsir,
              fontSize: fontSize,
              language: language,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTafsirOrTranslationContent({
    required BuildContext context,
    required bool isTafsir,
    required double fontSize,
    required String language,
  }) {
    final rawText = isTafsir ? tafsir.tafsirText : translation?.text;
    final hasContent = rawText != null && rawText.isNotEmpty;

    if (!hasContent) {
      return Text(
        languageCode == 'ar' ? 'لا يوجد تفسير متاح' : 'No tafsir available',
        style: TextStyle(
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    final textColor = style.tafsirTextColor ??
        (isDark ? Colors.grey.shade300 : Colors.grey.shade800);

    return _ExpandableTafsirText(
      rawText: rawText,
      isDark: isDark,
      fontSize: fontSize,
      textColor: textColor,
      textDirection: context.alignmentLayoutWPassLang(
          language, TextDirection.rtl, TextDirection.ltr),
      maxLines: style.tafsirMaxLines ?? 4,
      readMoreText: style.readMoreText ?? 'اقرأ المزيد',
      readLessText: style.readLessText ?? 'اقرأ أقل',
      readMoreButtonColor: style.readMoreButtonColor,
      readMoreTextStyle: style.readMoreTextStyle,
      translation: !isTafsir ? translation : null,
    );
  }
}

/// ويدجت عرض التفسير/الترجمة بأداء عالي:
/// - في الوضع المطوي: يعرض نص عادي مُجرّد من HTML (بدون parsing ثقيل)
/// - عند الضغط على "اقرأ المزيد": يحلّل HTML ويعرض النص المنسّق كاملاً
/// هذا يتجنب أعباء toFlutterText() و TextPainter.layout() للنصوص الطويلة
class _ExpandableTafsirText extends StatefulWidget {
  const _ExpandableTafsirText({
    required this.rawText,
    required this.isDark,
    required this.fontSize,
    required this.textColor,
    required this.textDirection,
    this.maxLines = 4,
    this.readMoreText = 'اقرأ المزيد',
    this.readLessText = 'اقرأ أقل',
    this.readMoreButtonColor,
    this.readMoreTextStyle,
    this.translation,
  });

  final String rawText;
  final bool isDark;
  final double fontSize;
  final Color textColor;
  final TextDirection textDirection;
  final int maxLines;
  final String readMoreText;
  final String readLessText;
  final Color? readMoreButtonColor;
  final TextStyle? readMoreTextStyle;
  final TranslationModel? translation;

  @override
  State<_ExpandableTafsirText> createState() => _ExpandableTafsirTextState();
}

class _ExpandableTafsirTextState extends State<_ExpandableTafsirText> {
  bool _expanded = false;
  List<TextSpan>? _parsedSpans;
  String? _strippedText;

  static final _htmlTagRegex = RegExp(r'<[^>]*>');
  static final _multiSpaceRegex = RegExp(r'\s+');

  String get _stripped {
    return _strippedText ??= widget.rawText
        .replaceAll(_htmlTagRegex, ' ')
        .replaceAll(_multiSpaceRegex, ' ')
        .trim();
  }

  List<TextSpan> _getFullSpans() {
    if (_parsedSpans != null) return _parsedSpans!;
    var spans = widget.rawText
        .toFlutterText(widget.isDark)
        .map((e) => e is TextSpan ? e : const TextSpan())
        .toList()
        .cast<TextSpan>();
    if (widget.translation != null) {
      final footnotes = widget.translation!.orderedFootnotesWithNumbers;
      if (footnotes.isNotEmpty) {
        final footnoteSpans = <TextSpan>[
          const TextSpan(text: '\n\n'),
          TextSpan(
            text: 'الحواشي:\n',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: widget.fontSize * 0.95,
              color: widget.textColor,
            ),
          ),
        ];
        for (final footnoteEntry in footnotes) {
          final number = footnoteEntry.key;
          final footnoteData = footnoteEntry.value;
          footnoteSpans.add(TextSpan(
            children: [
              TextSpan(
                text: '($number) ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSize * 0.9,
                  color: widget.textColor,
                ),
              ),
              TextSpan(
                text: '${footnoteData.value}\n\n',
                style: TextStyle(
                  fontSize: widget.fontSize * 0.85,
                  color: widget.textColor,
                  height: 1.4,
                ),
              ),
            ],
          ));
        }
        spans = [...spans, ...footnoteSpans];
      }
    }
    _parsedSpans = spans;
    return spans;
  }

  @override
  void didUpdateWidget(covariant _ExpandableTafsirText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rawText != widget.rawText ||
        oldWidget.isDark != widget.isDark ||
        oldWidget.translation != widget.translation) {
      _parsedSpans = null;
      _strippedText = null;
      _expanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        widget.readMoreButtonColor ?? Theme.of(context).colorScheme.primary;
    final buttonStyle = widget.readMoreTextStyle ??
        TextStyle(
          color: buttonColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        );

    final textStyle = TextStyle(
      color: widget.textColor,
      fontSize: widget.fontSize,
      height: 1.5,
    );

    if (_expanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(children: _getFullSpans(), style: textStyle),
            textDirection: widget.textDirection,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.visible,
          ),
          _buildToggleButton(widget.readLessText, buttonStyle, buttonColor,
              Icons.keyboard_arrow_up),
        ],
      );
    }

    // الوضع المطوي: نص عادي مُجرّد — بدون HTML parsing
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _stripped,
          maxLines: widget.maxLines,
          overflow: TextOverflow.ellipsis,
          textDirection: widget.textDirection,
          textAlign: TextAlign.justify,
          style: textStyle,
        ),
        _buildToggleButton(widget.readMoreText, buttonStyle, buttonColor,
            Icons.keyboard_arrow_down),
      ],
    );
  }

  Widget _buildToggleButton(
    String text,
    TextStyle buttonStyle,
    Color buttonColor,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: buttonStyle),
            Icon(icon, color: buttonColor, size: 18),
          ],
        ),
      ),
    );
  }
}
