import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/sheet/animated_bottom_sheet.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/read_quran/surah_name_with_banner.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/data/QuranReadHelperSqlite.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/horizontal/ayah_text_span_horizontal_widget.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/sheet/menu_action_buttons_widget.dart';

class ReadQuranPageHorizontalWidget extends StatefulWidget {
  const ReadQuranPageHorizontalWidget({required this.pageIndex, super.key});
  final int pageIndex;

  @override
  State<ReadQuranPageHorizontalWidget> createState() =>
      _ReadQuranPageHorizontalWidgetState();
}

class _ReadQuranPageHorizontalWidgetState
    extends State<ReadQuranPageHorizontalWidget> {
  int? selectedAyahUQNumber;

  // Cache expensive calculations
  double? _cachedFontSize;
  double? _cachedWidth;
  EdgeInsets? _cachedPadding;
  EdgeInsets? _cachedMargin;
  List<List<NewAyahModel>>? _cachedAyahsData;
  int? _cachedDataVersion;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, _) {
        return BlocBuilder<ReadQuranBloc, ReadQuranState>(
          builder: (context, state) {
            if (state.loadQuranState == RequestState.loading) {
              return const SizedBox();
            }
            if (state.loadQuranState == RequestState.error) {
              return const SizedBox();
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                // Cache font size calculation
                final fontSize = _getCachedFontSize(constraints.maxWidth);
                // Cache ayahs data
                final currentPageAyahsSeparatedForBasmalah =
                    _getCachedAyahsData(
                  state,
                );
                return RepaintBoundary(
                  child: Container(
                    padding: _getCachedPadding(context, size.width),
                    margin: _getCachedMargin(context, size.width),
                    child: state.pages.isEmpty
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
                                quranCtrl: context
                                    .read<ReadQuranBloc>()
                                    .quranReadHelperSqlite,
                                state: state,
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
  }

  double _getCachedFontSize(double width) {
    if (_cachedFontSize == null || _cachedWidth != width) {
      _cachedWidth = width;
      _cachedFontSize = _calculateFontSize(width);
    }
    return _cachedFontSize!;
  }

  EdgeInsets _getCachedPadding(BuildContext context, double width) {
    _cachedPadding ??= _getPagePadding(context, width);
    return _cachedPadding!;
  }

  EdgeInsets _getCachedMargin(BuildContext context, double width) {
    _cachedMargin ??= _getPageMargin(context, width);
    return _cachedMargin!;
  }

  List<List<NewAyahModel>> _getCachedAyahsData(
    ReadQuranState state,
  ) {
    // Simple cache invalidation based on data version
    final currentDataVersion = state.pages.length;
    if (_cachedAyahsData == null || _cachedDataVersion != currentDataVersion) {
      _cachedDataVersion = currentDataVersion;
      _cachedAyahsData = state.getCurrentPageAyahsSeparatedForBasmalah(
        widget.pageIndex,
      );
    }
    return _cachedAyahsData!;
  }

  EdgeInsets _getPagePadding(BuildContext context, double width) {
    return widget.pageIndex == 0 || widget.pageIndex == 1
        ? EdgeInsets.symmetric(
            horizontal: width * 0.13,
          )
        : const EdgeInsets.symmetric(horizontal: 16);
  }

  EdgeInsets _getPageMargin(BuildContext context, double width) {
    return widget.pageIndex == 0 || widget.pageIndex == 1
        ? EdgeInsets.symmetric(
            vertical: width * 0.34,
          )
        : const EdgeInsets.symmetric(vertical: 32);
  }

  double _calculateFontSize(double width) {
    if (width <= 480) return 100;
    if (width > 480 && width <= 960) return 90;
    return 100;
  }
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
    required this.state,
    super.key,
  });

  final int pageIndex;
  final int groupIndex;
  final List<NewAyahModel> ayahs;
  final double fontSize;
  final int? selectedAyahUQNumber;
  final void Function(int) onAyahSelect;
  final VoidCallback onAyahUnselect;
  final QuranReadHelperSqlite quranCtrl;
  final ReadQuranState state;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          child: context.surahBannerFirstPlace(pageIndex, groupIndex, context),
        ),
        RepaintBoundary(
          child: _buildBasmalahIfNeeded(state, ayahs, context, pageIndex),
        ),
        RepaintBoundary(
          child: _AyahTextWidget(
            pageIndex: pageIndex,
            ayahs: ayahs,
            fontSize: fontSize,
            selectedAyahUQNumber: selectedAyahUQNumber,
            onAyahSelect: onAyahSelect,
            onAyahUnselect: onAyahUnselect,
            quranCtrl: quranCtrl,
            state: state,
          ),
        ),
        RepaintBoundary(
          child: context.surahBannerLastPlace(pageIndex, groupIndex, context),
        ),
      ],
    );
  }

  Widget _buildBasmalahIfNeeded(
    ReadQuranState state,
    List<NewAyahModel> ayahs,
    BuildContext context,
    int pageIndex,
  ) {
    final surahNumber = state.getSurahNumberFromPage(pageIndex);
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
    required this.state,
    super.key,
  });

  final int pageIndex;
  final List<NewAyahModel> ayahs;
  final double fontSize;
  final int? selectedAyahUQNumber;
  final void Function(int) onAyahSelect;
  final VoidCallback onAyahUnselect;
  final QuranReadHelperSqlite quranCtrl;
  final ReadQuranState state;

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
    final textSpans = _getCachedTextSpans(context, widget.state);

    return RepaintBoundary(
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: RichText(
          text: TextSpan(
            style: _getTextStyle(widget.fontSize, context),
            children: textSpans,
          ),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  List<TextSpan> _getCachedTextSpans(
    BuildContext context,
    ReadQuranState state,
  ) {
    // Generate hash of current bookmark state for this ayah group
    final currentBookmarkStateHash = _generateBookmarkStateHash(context, state);

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
        widget.state,
      );
    }
    return _cachedTextSpans!;
  }

  int _generateBookmarkStateHash(BuildContext context, ReadQuranState state) {
    // Generate a hash based on bookmark state of all ayahs in this group
    final bookmarkBloc = context.read<BookmarkBloc>();
    var hash = 0;
    for (final ayah in widget.ayahs) {
      final surahNum = state.getSurahNumberByAyah(ayah);
      final isBookmarked =
          bookmarkBloc.hasBookmarkAyah(surahNum, ayah.ayahNumber);
      // Simple hash combining ayah unique number and bookmark state
      hash = hash ^ (ayah.numberGlobal * 31 + (isBookmarked ? 1 : 0));
    }
    return hash;
  }

  List<TextSpan> _buildAyahSpans(
    BuildContext context,
    QuranReadHelperSqlite quranCtrl,
    List<NewAyahModel> ayahs,
    double fontSize,
    int? selectedAyahUQNumber,
    void Function(int)? onSelect,
    VoidCallback? onUnselect,
    ReadQuranState state,
  ) {
    return List.generate(
      ayahs.length,
      (ayahIndex) {
        final ayah = ayahs[ayahIndex];
        final isFirstAyah = ayahIndex == 0;
        // Fix: Get surah number for the specific ayah, not the page
        final surahNum = state.getSurahNumberByAyah(ayah);

        return ayahTextSpanHorizontalWidget(
          context: context,
          isFirstAyah: isFirstAyah,
          text: isFirstAyah
              ? '${ayah.codeV2![0]}${ayah.codeV2!.substring(1)}'
              : ayah.codeV2 ?? '',
          pageIndex: widget.pageIndex,
          isSelected: selectedAyahUQNumber == ayah.numberGlobal,
          fontSize: fontSize,
          surahNum: surahNum,
          ayahUQNum: ayah.numberGlobal,
          ayahNum: ayah.ayahNumber,
          onTap: () {
            final boxController = context.read<ReadQuranBloc>().boxController;
            if (boxController.isBoxOpen) {
              boxController.closeBox();
            } else {
              onSelect?.call(ayah.numberGlobal);

              _showAyahMenu(
                context,
                quranCtrl,
                ayahs,
                ayahIndex,
                null,
                state,
                surahNum,
              );
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
      color: context.primaryColor,
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
    QuranReadHelperSqlite quranCtrl,
    List<NewAyahModel> ayahs,
    int ayahIndex,
    VoidCallback? onClose,
    ReadQuranState state,
    int surahNum,
  ) {
    final ayah = ayahs[ayahIndex];
    context.showAnimatedBottomSheet(
      child: MenuActionButtonWidget(
        ayahNum: ayah.ayahNumber,
        surahName: state.getSurahNameFromPage(widget.pageIndex),
        ayahTextNormal: ayah.text,
        cancel: onClose,
        ayahUQNum: ayah.numberGlobal,
        pageIndex: widget.pageIndex,
        surahNum: surahNum,
        ayahUrl: ayah.audio!,
        myContext: context,
      ),
      backgroundColor: context.scaffoldBackgroundColor,
    );
  }
}
