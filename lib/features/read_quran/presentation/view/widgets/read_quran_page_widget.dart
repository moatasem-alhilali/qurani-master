import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/bottom_sheet/extension_sheet.dart';
import 'package:quran_app/core/models_public/surahs_model.dart';
import 'package:quran_app/core/widgets/read_quran/surah_name_with_banner.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/ayah_text_span.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/menu_action_buttons.dart';

class ReadQuranPageWidget extends StatefulWidget {
  const ReadQuranPageWidget({required this.pageIndex, super.key});
  final int pageIndex;

  @override
  State<ReadQuranPageWidget> createState() => _ReadQuranPageWidgetState();
}

class _ReadQuranPageWidgetState extends State<ReadQuranPageWidget> {
  int? selectedAyahUQNumber;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        return BlocBuilder<ReadQuranBloc, ReadQuranState>(
          builder: (context, state) {
            final quranCtrl = context.read<ReadQuranBloc>().quranRH;

            return LayoutBuilder(
              builder: (context, constraints) {
                final fontSize = _calculateFontSize(constraints.maxWidth);
                final padding = _getPagePadding(context);
                final margin = _getPageMargin(context);

                return BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    final currentPageAyahsSeparatedForBasmalah =
                        quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(
                      widget.pageIndex,
                    );
                    return Container(
                      padding: padding,
                      margin: margin,
                      child: quranCtrl.pages.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                  currentPageAyahsSeparatedForBasmalah.length,
                                  (i) {
                                final ayahs =
                                    currentPageAyahsSeparatedForBasmalah[i];
                                return Column(
                                  children: [
                                    context.surahBannerFirstPlace(
                                      widget.pageIndex,
                                      i,
                                      context,
                                    ),
                                    _buildBasmalahIfNeeded(
                                      quranCtrl,
                                      ayahs,
                                      context,
                                    ),
                                    BlocBuilder<BookmarkBloc, BookmarkState>(
                                      builder: (context, state) {
                                        return FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: RichText(
                                            text: TextSpan(
                                              style: _getTextStyle(
                                                fontSize,
                                                context,
                                              ),
                                              children: _buildAyahSpans(
                                                context,
                                                quranCtrl,
                                                ayahs,
                                                fontSize,
                                                selectedAyahUQNumber,
                                                (uq) => setState(
                                                  () =>
                                                      selectedAyahUQNumber = uq,
                                                ),
                                                () => setState(
                                                  () => selectedAyahUQNumber =
                                                      null,
                                                ),
                                              ),
                                            ),
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      },
                                    ),
                                    context.surahBannerLastPlace(
                                      widget.pageIndex,
                                      i,
                                      context,
                                    ),
                                  ],
                                );
                              }),
                            ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBasmalahIfNeeded(
    QuranReadHelper quranCtrl,
    List<Ayah> ayahs,
    BuildContext context,
  ) {
    final surahNumber = quranCtrl.getSurahNumberByAyah(ayahs.first);
    final isFirstAyah = ayahs.first.ayahNumber == 1;
    final isExcludedSurah = surahNumber == 9 || surahNumber == 1;

    if (isExcludedSurah || !isFirstAyah) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: (surahNumber == 95 || surahNumber == 97)
          ? besmAllah2(context)
          : besmAllah(context),
    );
  }

  List<TextSpan> _buildAyahSpans(
    BuildContext context,
    QuranReadHelper quranCtrl,
    List<Ayah> ayahs,
    double fontSize,
    int? selectedAyahUQNumber,
    void Function(int)? onSelect,
    VoidCallback? onUnselect,
  ) {
    return List.generate(
      ayahs.length,
      (ayahIndex) {
        final ayah = ayahs[ayahIndex];
        final isFirstAyah = ayahIndex == 0;
        final surahNum = quranCtrl.getSurahNumberFromPage(widget.pageIndex);

        return ayahTextSpan(
          context: context,
          isFirstAyah: isFirstAyah,
          text: isFirstAyah
              ? "${ayah.code_v2[0]}${ayah.code_v2.substring(1)}"
              : ayah.code_v2,
          pageIndex: widget.pageIndex,
          isSelected: selectedAyahUQNumber == ayah.ayahUQNumber,
          fontSize: fontSize,
          surahNum: surahNum,
          ayahNum: ayah.ayahUQNumber,
          onLongPressStart: (details) {
            onSelect?.call(ayah.ayahUQNumber);

            _showAyahMenu(
              context,
              quranCtrl,
              ayahs,
              ayahIndex,
              details,
            );
          },
          onTapUp: () => onUnselect?.call(),
        );
      },
    );
  }

  TextStyle _getTextStyle(double fontSize, BuildContext context) {
    return TextStyle(
      fontFamily: 'page${widget.pageIndex + 1}',
      fontSize: fontSize,
      height: 2,
      letterSpacing: 2,
      color: context.quranTheme.colorScheme.inversePrimary,
      shadows: const [
        Shadow(
          blurRadius: 0.5,
          offset: Offset(0.5, 0.5),
        ),
      ],
    );
  }

  EdgeInsets _getPagePadding(BuildContext context) {
    return widget.pageIndex == 0 || widget.pageIndex == 1
        ? EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.13,
          )
        : const EdgeInsets.symmetric(horizontal: 16);
  }

  EdgeInsets _getPageMargin(BuildContext context) {
    return widget.pageIndex == 0 || widget.pageIndex == 1
        ? EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.34,
          )
        : const EdgeInsets.symmetric(vertical: 32);
  }

  double _calculateFontSize(double width) {
    if (width <= 480) return 100;
    if (width > 480 && width <= 960) return 90;
    return 100;
  }

  void _showAyahMenu(
    BuildContext context,
    QuranReadHelper quranCtrl,
    List<Ayah> ayahs,
    int ayahIndex,
    LongPressStartDetails details, {
    VoidCallback? onClose,
  }) {
    final ayah = ayahs[ayahIndex];
    context.showSmoothSheetStyle(
      
      child: MenuActionWidget(
        ayahNum: ayah.ayahNumber,
        surahName: quranCtrl.getSurahNameFromPage(widget.pageIndex),
        ayahTextNormal: ayah.text,
        cancel: onClose,
        ayahUQNum: ayah.ayahUQNumber,
        pageIndex: widget.pageIndex,
        surahNum: quranCtrl.getSurahNumberFromPage(widget.pageIndex),
        ayahUrl: ayah.audio,
        myContext: context,
      ),
    );
    // showAyahMenuActionButton(
    //   quranCtrl.getSurahNumberFromPage(widget.pageIndex),
    //   ayah.ayahNumber,
    //   ayah.code_v2,
    //   widget.pageIndex,
    //   ayah.text,
    //   ayah.ayahUQNumber,
    //   quranCtrl.getSurahNameFromPage(widget.pageIndex),
    //   ayahIndex,
    //   details: details,
    //   myContext: context,
    //   ayahUrl: ayah.audio,
    //   context: context,
    //   onClose: onClose,
    // );
  }
}
