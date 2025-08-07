import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/sheet/animated_bottom_sheet.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/read_quran/besm_allah_widget.dart';
import 'package:quran_app/core/widgets/read_quran/surah_name_with_banner.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/data/QuranReadHelperSqlite.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/horizontal/ayah_text_span_horizontal_widget.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/sheet/menu_action_buttons_widget.dart';
import 'package:quran_app/gen/fonts.gen.dart';
import 'package:quran_app/main.dart';

class ReadQuranPageVerticalWidget extends StatefulWidget {
  const ReadQuranPageVerticalWidget({required this.pageIndex, super.key});
  final int pageIndex;

  @override
  State<ReadQuranPageVerticalWidget> createState() =>
      _ReadQuranPageVerticalWidgetState();
}

class _ReadQuranPageVerticalWidgetState
    extends State<ReadQuranPageVerticalWidget> {
  int? selectedAyahUQNumber;

  // Cache
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
                final fontSize = _getCachedFontSize(constraints.maxWidth);
                final currentPageAyahsSeparatedForBasmalah =
                    _getCachedAyahsData(state);
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
                              },
                            ),
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

  List<List<NewAyahModel>> _getCachedAyahsData(ReadQuranState state) {
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
        ? EdgeInsets.symmetric(horizontal: width * 0.13)
        : const EdgeInsets.symmetric(horizontal: 16);
  }

  EdgeInsets _getPageMargin(BuildContext context, double width) {
    return widget.pageIndex == 0 || widget.pageIndex == 1
        ? EdgeInsets.symmetric(vertical: width * 0.34)
        : const EdgeInsets.symmetric(vertical: 32);
  }

  double _calculateFontSize(double width) {
    if (width <= 480) return 100;
    if (width > 480 && width <= 960) return 90;
    return 100;
  }
}

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
        const RepaintBoundary(child: SizedBox.shrink()),
        RepaintBoundary(
          child: SurahBannerFirstPlace(pageIndex: pageIndex, i: groupIndex),
        ),
        RepaintBoundary(
          child: _buildBasmalahIfNeeded(state, ayahs, context, pageIndex),
        ),
        RepaintBoundary(
          child: _AyahTextWidget(
            pageIndex: pageIndex,
            ayahs: ayahs,
            fontSize: fontSize, // kept for signature compatibility
            selectedAyahUQNumber: selectedAyahUQNumber,
            onAyahSelect: onAyahSelect,
            onAyahUnselect: onAyahUnselect,
            quranCtrl: quranCtrl,
            state: state,
          ),
        ),
        RepaintBoundary(
          child: SurahBannerLastPlace(pageIndex: pageIndex, i: groupIndex),
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

    if (isExcludedSurah || !isFirstAyah) return const SizedBox.shrink();

    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: BesmAllahWidget(), // سيبدّل داخليًا حسب السورة لو عندك منطق
    );
  }
}

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
  final double fontSize; // لم يعد مستخدمًا للحساب الفعلي
  final int? selectedAyahUQNumber;
  final void Function(int) onAyahSelect;
  final VoidCallback onAyahUnselect;
  final QuranReadHelperSqlite quranCtrl;
  final ReadQuranState state;

  @override
  State<_AyahTextWidget> createState() => _AyahTextWidgetState();
}

class _AyahTextWidgetState extends State<_AyahTextWidget> {
  static const double _lineHeight = 1.6;
  static const double _ayahNumberScale = 0.42; // نسبة من حجم الآية

  @override
  Widget build(BuildContext context) {
    // نبني النص الكامل (للحالات التي قد تحتاجه)
    final pageText =
        widget.ayahs.map((a) => '${a.text} ﴿${a.ayahNumber}﴾').join(' ');
    logger.d('pageText length: ${pageText.length}');

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final media = MediaQuery.of(ctx);
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : media.size.width;

        // تقدير ارتفاع متاح: لو غير محدود، نستخدم جزءًا من ارتفاع الشاشة
        final estimatedHeight =
            constraints.maxHeight.isFinite && constraints.maxHeight > 0
                ? constraints.maxHeight
                : media.size.height * 0.68;

        final maxFont = _dynamicMaxFont(maxWidth);
        final fittedFont = _bestFitFontSize(
          textBuilder: (s) => _buildSpan(ctx, s),
          maxWidth: maxWidth,
          maxHeight: estimatedHeight,
          min: 18,
          max: maxFont,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        );

        return RichText(
          text: _buildSpan(ctx, fittedFont),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        );
      },
    );
  }

  TextSpan _buildSpan(BuildContext context, double baseFont) {
    final spans = <TextSpan>[];
    for (final ayah in widget.ayahs) {
      spans
        ..add(
          TextSpan(
            text: ayah.text,
            style: TextStyle(
              fontFamily: FontFamily.scheherazade,
              fontSize: baseFont,
              height: _lineHeight,
              color: Colors.black,
            ),
          ),
        )
        ..add(
          TextSpan(
            text: '﴿${ayah.ayahNumber}﴾',
            style: TextStyle(
              fontFamily: FontFamily.scheherazade,
              fontSize: baseFont * _ayahNumberScale,
              height: 1,
              color: context.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        ..add(const TextSpan(text: ' '));
    }
    return TextSpan(children: spans);
  }

  double _bestFitFontSize({
    required TextSpan Function(double baseSize) textBuilder,
    required double maxWidth,
    required double maxHeight,
    required double min,
    required double max,
    required TextDirection textDirection,
    required TextAlign textAlign,
    Locale? locale,
  }) {
    var lo = min;
    var hi = max;
    var ans = min;
    for (var i = 0; i < 20; i++) {
      final mid = (lo + hi) / 2;
      final tp = TextPainter(
        text: textBuilder(mid),
        textDirection: textDirection,
        textAlign: textAlign,
        locale: locale ?? const Locale('ar'),
        strutStyle: StrutStyle(
          fontFamily: FontFamily.scheherazade,
          fontSize: mid,
          height: _lineHeight,
          forceStrutHeight: false,
        ),
      )..layout(maxWidth: maxWidth);

      final fits = tp.height <= maxHeight;
      if (fits) {
        ans = mid;
        lo = mid; // جرّب أكبر
      } else {
        hi = mid; // صغّر
      }
    }
    return ans.clamp(min, max);
  }

  double _dynamicMaxFont(double width) {
    // سقف ديناميكي يمنع تضخيم الخط بالصفحات القصيرة
    return (width / 8).clamp(24, 52);
  }
}
