import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/sheet/animated_bottom_sheet.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/models_public/surahs_model.dart';
import 'package:quran_app/core/widgets/read_quran/surah_name_with_banner.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/ayah_text_span.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/sheet/menu_action_buttons.dart';

class ReadQuranPageWidget extends StatefulWidget {
  const ReadQuranPageWidget({required this.pageIndex, super.key});
  final int pageIndex;

  @override
  State<ReadQuranPageWidget> createState() => _ReadQuranPageWidgetState();
}

class _ReadQuranPageWidgetState extends State<ReadQuranPageWidget> {
  int? selectedAyahUQNumber;

  // Cache expensive calculations
  double? _cachedFontSize;
  double? _cachedWidth;
  EdgeInsets? _cachedPadding;
  EdgeInsets? _cachedMargin;
  List<List<Ayah>>? _cachedAyahsData;
  int? _cachedDataVersion;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        return BlocBuilder<ReadQuranBloc, ReadQuranState>(
          builder: (context, state) {
            final quranCtrl = context.read<ReadQuranBloc>().quranRH;

            return LayoutBuilder(
              builder: (context, constraints) {
                // Cache font size calculation
                final fontSize = _getCachedFontSize(constraints.maxWidth);

                return BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    // Cache ayahs data
                    final currentPageAyahsSeparatedForBasmalah =
                        _getCachedAyahsData(quranCtrl);

                    return RepaintBoundary(
                      child: Container(
                        padding: _getCachedPadding(context),
                        margin: _getCachedMargin(context),
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
                                  return _AyahGroupWidget(
                                    key: ValueKey('${widget.pageIndex}_$i'),
                                    pageIndex: widget.pageIndex,
                                    groupIndex: i,
                                    ayahs: ayahs,
                                    fontSize: fontSize,
                                    selectedAyahUQNumber: selectedAyahUQNumber,
                                    onAyahSelect: (uq) => setState(
                                      () => selectedAyahUQNumber = uq,
                                    ),
                                    onAyahUnselect: () => setState(
                                      () => selectedAyahUQNumber = null,
                                    ),
                                    quranCtrl: quranCtrl,
                                  );
                                }),
                              ),
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

  double _getCachedFontSize(double width) {
    if (_cachedFontSize == null || _cachedWidth != width) {
      _cachedWidth = width;
      _cachedFontSize = _calculateFontSize(width);
    }
    return _cachedFontSize!;
  }

  EdgeInsets _getCachedPadding(BuildContext context) {
    _cachedPadding ??= _getPagePadding(context);
    return _cachedPadding!;
  }

  EdgeInsets _getCachedMargin(BuildContext context) {
    _cachedMargin ??= _getPageMargin(context);
    return _cachedMargin!;
  }

  List<List<Ayah>> _getCachedAyahsData(QuranReadHelper quranCtrl) {
    // Simple cache invalidation based on data version
    final currentDataVersion = quranCtrl.pages.length;
    if (_cachedAyahsData == null || _cachedDataVersion != currentDataVersion) {
      _cachedDataVersion = currentDataVersion;
      _cachedAyahsData =
          quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(widget.pageIndex);
    }
    return _cachedAyahsData!;
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

  // void _showAyahMenu(
  //   BuildContext context,
  //   QuranReadHelper quranCtrl,
  //   List<Ayah> ayahs,
  //   int ayahIndex,
  //   LongPressStartDetails details, {
  //   VoidCallback? onClose,
  // }) {
  //   final ayah = ayahs[ayahIndex];
  //   context.showSmoothSheetStyle(
  //     child: MenuActionWidget(
  //       ayahNum: ayah.ayahNumber,
  //       surahName: quranCtrl.getSurahNameFromPage(widget.pageIndex),
  //       ayahTextNormal: ayah.text,
  //       cancel: onClose,
  //       ayahUQNum: ayah.ayahUQNumber,
  //       pageIndex: widget.pageIndex,
  //       surahNum: quranCtrl.getSurahNumberFromPage(widget.pageIndex),
  //       ayahUrl: ayah.audio,
  //       myContext: context,
  //     ),
  //     backgroundColor: context.scaffoldBackgroundColor,
  //   );
  // }
}

// Extract ayah group to separate widget to reduce rebuild scope
class _AyahGroupWidget extends StatelessWidget {
  const _AyahGroupWidget({
    required this.pageIndex,
    required this.groupIndex,
    required this.ayahs,
    required this.fontSize,
    required this.selectedAyahUQNumber,
    required this.onAyahSelect,
    required this.onAyahUnselect,
    required this.quranCtrl,
    super.key,
  });

  final int pageIndex;
  final int groupIndex;
  final List<Ayah> ayahs;
  final double fontSize;
  final int? selectedAyahUQNumber;
  final void Function(int) onAyahSelect;
  final VoidCallback onAyahUnselect;
  final QuranReadHelper quranCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        context.surahBannerFirstPlace(pageIndex, groupIndex, context),
        _buildBasmalahIfNeeded(quranCtrl, ayahs, context),
        RepaintBoundary(
          child: _AyahTextWidget(
            pageIndex: pageIndex,
            ayahs: ayahs,
            fontSize: fontSize,
            selectedAyahUQNumber: selectedAyahUQNumber,
            onAyahSelect: onAyahSelect,
            onAyahUnselect: onAyahUnselect,
            quranCtrl: quranCtrl,
          ),
        ),
        context.surahBannerLastPlace(pageIndex, groupIndex, context),
      ],
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
}

// Extract ayah text to separate widget for better performance
class _AyahTextWidget extends StatefulWidget {
  const _AyahTextWidget({
    required this.pageIndex,
    required this.ayahs,
    required this.fontSize,
    required this.selectedAyahUQNumber,
    required this.onAyahSelect,
    required this.onAyahUnselect,
    required this.quranCtrl,
    super.key,
  });

  final int pageIndex;
  final List<Ayah> ayahs;
  final double fontSize;
  final int? selectedAyahUQNumber;
  final void Function(int) onAyahSelect;
  final VoidCallback onAyahUnselect;
  final QuranReadHelper quranCtrl;

  @override
  State<_AyahTextWidget> createState() => _AyahTextWidgetState();
}

class _AyahTextWidgetState extends State<_AyahTextWidget> {
  List<TextSpan>? _cachedTextSpans;
  int? _cachedSelectedAyah;
  double? _cachedFontSize;
  int? _cachedBookmarkStateHash;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        final textSpans = _getCachedTextSpans(context);

        return FittedBox(
          fit: BoxFit.fitWidth,
          child: RichText(
            text: TextSpan(
              style: _getTextStyle(widget.fontSize, context),
              children: textSpans,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  List<TextSpan> _getCachedTextSpans(BuildContext context) {
    // Generate hash of current bookmark state for this ayah group
    final currentBookmarkStateHash = _generateBookmarkStateHash(context);

    // Cache text spans only if selection, font size, or bookmark state changes
    if (_cachedTextSpans == null ||
        _cachedSelectedAyah != widget.selectedAyahUQNumber ||
        _cachedFontSize != widget.fontSize ||
        _cachedBookmarkStateHash != currentBookmarkStateHash) {
      _cachedSelectedAyah = widget.selectedAyahUQNumber;
      _cachedFontSize = widget.fontSize;
      _cachedBookmarkStateHash = currentBookmarkStateHash;
      _cachedTextSpans = _buildAyahSpans(
        context,
        widget.quranCtrl,
        widget.ayahs,
        widget.fontSize,
        widget.selectedAyahUQNumber,
        widget.onAyahSelect,
        widget.onAyahUnselect,
      );
    }
    return _cachedTextSpans!;
  }

  int _generateBookmarkStateHash(BuildContext context) {
    // Generate a hash based on bookmark state of all ayahs in this group
    final bookmarkBloc = context.read<BookmarkBloc>();
    var hash = 0;
    for (final ayah in widget.ayahs) {
      final surahNum = widget.quranCtrl.getSurahNumberByAyah(ayah);
      final isBookmarked =
          bookmarkBloc.hasBookmarkAyah(surahNum, ayah.ayahNumber);
      // Simple hash combining ayah unique number and bookmark state
      hash = hash ^ (ayah.ayahUQNumber * 31 + (isBookmarked ? 1 : 0));
    }
    return hash;
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
        // Fix: Get surah number for the specific ayah, not the page
        final surahNum = quranCtrl.getSurahNumberByAyah(ayah);

        return ayahTextSpan(
          context: context,
          isFirstAyah: isFirstAyah,
          text: isFirstAyah
              ? '${ayah.code_v2[0]}${ayah.code_v2.substring(1)}'
              : ayah.code_v2,
          pageIndex: widget.pageIndex,
          isSelected: selectedAyahUQNumber == ayah.ayahUQNumber,
          fontSize: fontSize,
          surahNum: surahNum,
          ayahUQNum: ayah.ayahUQNumber,
          ayahNum: ayah.ayahNumber,
          onTap: () {
            final boxController = context.read<ReadQuranBloc>().boxController;
            if (boxController.isBoxOpen) {
              boxController.closeBox();
            } else {
              onSelect?.call(ayah.ayahUQNumber);

              _showAyahMenu(context, quranCtrl, ayahs, ayahIndex, null);
            }
          },
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
      color: context.primaryScheme,
      shadows: const [
        Shadow(
          blurRadius: 0.5,
          offset: Offset(0.5, 0.5),
        ),
      ],
    );
  }

  void _showAyahMenu(
    BuildContext context,
    QuranReadHelper quranCtrl,
    List<Ayah> ayahs,
    int ayahIndex,
    VoidCallback? onClose,
  ) {
    final ayah = ayahs[ayahIndex];
    context.showAnimatedBottomSheet(
      child: MenuActionWidget(
        ayahNum: ayah.ayahNumber,
        surahName: quranCtrl.getSurahNameFromPage(widget.pageIndex),
        ayahTextNormal: ayah.text,
        cancel: onClose,
        ayahUQNum: ayah.ayahUQNumber,
        pageIndex: widget.pageIndex,
        surahNum: quranCtrl.getSurahNumberByAyah(ayah),
        ayahUrl: ayah.audio,
        myContext: context,
      ),
      backgroundColor: context.scaffoldBackgroundColor,
    );
  }
}
