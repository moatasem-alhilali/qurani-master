part of '/quran.dart';

class _SearchTab extends StatefulWidget {
  final bool isDark;
  final String languageCode;
  final SearchTabStyle? style;
  const _SearchTab(
      {required this.isDark, required this.languageCode, this.style});

  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  @override
  void initState() {
    super.initState();
    // على الويب: عطّل تركيز PageView مؤقتًا وأعطِ التركيز لحقل البحث
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kIsWeb) {
        final ctrl = QuranCtrl.instance;
        ctrl.state.quranPageRLFocusNode.canRequestFocus = false;
        if (ctrl.searchFocusNode.canRequestFocus) {
          ctrl.searchFocusNode.requestFocus();
        }
      }
    });
  }

  @override
  void dispose() {
    // عند إغلاق تبويب البحث: أعِد تمكين تركيز PageView للكيبورد على الويب
    if (kIsWeb) {
      final rl = QuranCtrl.instance.state.quranPageRLFocusNode;
      rl.canRequestFocus = true;
      // اطلب التركيز من جديد للسهام اليسار/اليمين
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FocusScope.of(context).requestFocus(rl);
        }
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.style ??
        SearchTabStyle.defaults(isDark: widget.isDark, context: context);
    final Color textColor =
        s.textColor ?? AppColors.getTextColor(widget.isDark);
    final Color accentColor =
        s.accentColor ?? Theme.of(context).colorScheme.primary;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Search TextField (خارج GetBuilder لتثبيت التركيز)
            TextField(
              controller: QuranCtrl.instance.searchTextController,
              focusNode: QuranCtrl.instance.searchFocusNode,
              autofocus: true,
              onTap: () {
                final ctrl = QuranCtrl.instance;
                // إزالة أي Overlay قد يعترض التركيز
                ctrl.state.isShowMenu.value = false;
                // تعطيل تركيز PageView مؤقتًا على الويب
                if (kIsWeb) {
                  ctrl.state.quranPageRLFocusNode.canRequestFocus = false;
                  if (ctrl.searchFocusNode.canRequestFocus) {
                    ctrl.searchFocusNode.requestFocus();
                  }
                }
              },
              onChanged: (txt) {
                final quranCtrl = QuranCtrl.instance;
                if (txt.isEmpty) {
                  quranCtrl.searchResultAyahs.value = [];
                  quranCtrl.searchResultSurahs.value = [];
                  return;
                }
                final ayahResults = QuranLibrary().search(txt);
                quranCtrl.searchResultAyahs.value = [...ayahResults];
                final surahResults = QuranLibrary().surahSearch(txt);
                quranCtrl.searchResultSurahs.value = [...surahResults];
              },
              style: s.searchTextStyle ?? TextStyle(color: textColor),
              decoration: InputDecoration(
                fillColor:
                    accentColor.withValues(alpha: s.searchFillAlpha ?? 0.1),
                filled: true,
                contentPadding: s.searchContentPadding ??
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                suffixIcon: Icon(
                  s.searchSuffixIconData ?? Icons.search,
                  color: textColor.withValues(
                      alpha: s.searchSuffixIconAlpha ?? 0.6),
                ),
                hintText: s.searchHintText ?? 'بحث في القرآن',
                hintStyle: s.searchHintStyle ??
                    QuranLibrary().cairoStyle.copyWith(
                        color: textColor.withValues(alpha: 0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: textColor.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(
                      (s.searchBorderRadius ?? 10).toDouble()),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: textColor.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(
                      (s.searchBorderRadius ?? 10).toDouble()),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: textColor.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(
                      (s.searchBorderRadius ?? 10).toDouble()),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Surah chips row
            Obx(() {
              final quranCtrl = QuranCtrl.instance;
              if (quranCtrl.searchResultSurahs.isEmpty) {
                return const SizedBox.shrink();
              }
              return SizedBox(
                height: s.surahChipRowHeight ?? 64,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  itemCount: quranCtrl.searchResultSurahs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final search = quranCtrl.searchResultSurahs[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                            (s.surahChipRadius ?? 8).toDouble()),
                        onTap: () async {
                          Navigator.pop(context);
                          quranCtrl.searchResultSurahs.value = [];
                          // if (quranCtrl.isDownloadFonts) {
                          //   await quranCtrl.prepareFonts(search.startPage!);
                          // }
                          QuranLibrary().jumpToSurah(search.surahNumber);
                          // إعادة تمكين تركيز PageView بعد إغلاق البحث على الويب
                          if (kIsWeb) {
                            final rl =
                                QuranCtrl.instance.state.quranPageRLFocusNode;
                            rl.canRequestFocus = true;
                            rl.requestFocus();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: s.surahChipPadding ??
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          margin: s.surahChipMargin ??
                              const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: (s.surahChipBgColor ?? accentColor),
                            borderRadius: BorderRadius.all(Radius.circular(
                                (s.surahChipRadius ?? 8).toDouble())),
                          ),
                          child: Text(
                            search.surahNumber.toString(),
                            style: s.surahChipTextStyle ??
                                const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'surahName',
                                  fontSize: 28,
                                  package: 'quran_library',
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 8),
            // Ayah results list
            Expanded(
              child: GetX<QuranCtrl>(
                builder: (quranCtrl) => ListView.separated(
                  itemCount: quranCtrl.searchResultAyahs.length,
                  separatorBuilder: (_, __) => Divider(
                    color: s.resultsDividerColor ?? Colors.grey,
                    thickness: s.resultsDividerThickness ?? 1,
                  ),
                  itemBuilder: (context, i) {
                    final ayah = quranCtrl.searchResultAyahs[i];
                    return ListTile(
                      title: GetSingleAyah(
                        surahNumber: ayah.surahNumber!,
                        ayahNumber: ayah.ayahNumber,
                        isBold: false,
                        fontSize: 20,
                        useDefaultFont: true,
                        textColor: textColor,
                        isDark: widget.isDark,
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            ayah.arabicName ?? '',
                            style: TextStyle(
                                color: textColor.withValues(
                                    alpha: s.subtitleTextAlpha ?? 0.8)),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'صفحة: ${ayah.page.toString().convertNumbersAccordingToLang(languageCode: widget.languageCode)}',
                            style: TextStyle(
                                color: textColor.withValues(
                                    alpha: s.subtitleTextAlpha ?? 0.8)),
                          ),
                        ],
                      ),
                      contentPadding: s.listItemContentPadding ??
                          const EdgeInsets.symmetric(horizontal: 8),
                      onTap: () async {
                        Navigator.pop(context);
                        quranCtrl.searchResultAyahs.value = [];
                        // if (quranCtrl.isDownloadFonts) {
                        //   await quranCtrl.prepareFonts(ayah.page);
                        // }
                        QuranLibrary().jumpToAyah(ayah.page, ayah.ayahUQNumber);
                        // إعادة تمكين تركيز PageView بعد إغلاق البحث على الويب
                        if (kIsWeb) {
                          final rl =
                              QuranCtrl.instance.state.quranPageRLFocusNode;
                          rl.canRequestFocus = true;
                          rl.requestFocus();
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
