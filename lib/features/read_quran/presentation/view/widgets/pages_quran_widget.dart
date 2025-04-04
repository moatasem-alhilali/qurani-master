import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/models_public/surahs_model.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/core/widgets/read_quran/surah_name_with_banner.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/ayah_text_span.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/menu_extension.dart';

class PagesQuranWidget extends StatelessWidget {
  final int pageIndex;

  const PagesQuranWidget({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
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
                return Container(
                  padding: padding,
                  margin: margin,
                  child: quranCtrl.pages.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : _buildPageContent(context, quranCtrl, fontSize),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPageContent(
    BuildContext context,
    QuranReadHelper quranCtrl,
    double fontSize,
  ) {
    final pageAyahs =
        quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(pageIndex);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageAyahs.length, (i) {
        final ayahs = pageAyahs[i];
        return Column(
          children: [
            context.surahBannerFirstPlace(pageIndex, i, context),
            _buildBasmalahIfNeeded(quranCtrl, ayahs, context),
            _buildAyahsText(context, quranCtrl, ayahs, fontSize),
            context.surahBannerLastPlace(pageIndex, i, context),
          ],
        );
      }),
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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: (surahNumber == 95 || surahNumber == 97)
          ? besmAllah2(context)
          : besmAllah(context),
    );
  }

  Widget _buildAyahsText(
    BuildContext context,
    QuranReadHelper quranCtrl,
    List<Ayah> ayahs,
    double fontSize,
  ) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: RichText(
        text: TextSpan(
          style: _getTextStyle(fontSize, context),
          children: _buildAyahSpans(context, quranCtrl, ayahs, fontSize),
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
      ),
    );
  }

  List<TextSpan> _buildAyahSpans(
    BuildContext context,
    QuranReadHelper quranCtrl,
    List<Ayah> ayahs,
    double fontSize,
  ) {
    return List.generate(ayahs.length, (ayahIndex) {
      final ayah = ayahs[ayahIndex];
      final isFirstAyah = ayahIndex == 0;
      final surahNum = quranCtrl.getSurahNumberFromPage(pageIndex);

      return ayahTextSpan(
        context: context,
        isFirstAyah: isFirstAyah,
        text: isFirstAyah
            ? "${ayah.code_v2[0]}${ayah.code_v2.substring(1)}"
            : ayah.code_v2,
        pageIndex: pageIndex,
        isSelected: false,
        fontSize: fontSize,
        surahNum: surahNum,
        ayahNum: ayah.ayahUQNumber,
        onLongPressStart: (details) => _showAyahMenu(
          context,
          quranCtrl,
          ayahs,
          ayahIndex,
          details,
        ),
      );
    });
  }

  TextStyle _getTextStyle(double fontSize, BuildContext context) {
    return TextStyle(
      fontFamily: 'page${pageIndex + 1}',
      fontSize: fontSize,
      height: 2,
      letterSpacing: 2,
      color: context.currentThemeData.colorScheme.inversePrimary,
      shadows: const [
        Shadow(
          blurRadius: 0.5,
          color: Colors.black,
          offset: Offset(0.5, 0.5),
        ),
      ],
    );
  }

  EdgeInsets _getPagePadding(BuildContext context) {
    return pageIndex == 0 || pageIndex == 1
        ? EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.13)
        : const EdgeInsets.symmetric(horizontal: 16.0);
  }

  EdgeInsets _getPageMargin(BuildContext context) {
    return pageIndex == 0 || pageIndex == 1
        ? EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.34)
        : const EdgeInsets.symmetric(horizontal: 0.0, vertical: 32.0);
  }

  double _calculateFontSize(double width) {
    if (width <= 480) return 100.0;
    if (width > 480 && width <= 960) return 90.0;
    return 100.0;
  }

  void _showAyahMenu(
    BuildContext context,
    QuranReadHelper quranCtrl,
    List<Ayah> ayahs,
    int ayahIndex,
    LongPressStartDetails details,
  ) {
    final ayah = ayahs[ayahIndex];
    showAyahMenu(
      quranCtrl.getSurahNumberFromPage(pageIndex),
      ayah.ayahNumber,
      ayah.code_v2,
      pageIndex,
      ayah.text,
      ayah.ayahUQNumber,
      quranCtrl.getSurahNameFromPage(pageIndex),
      ayahIndex,
      details: details,
      myContext: context,
      ayahUrl: ayah.audio,
      context: context,
    );
  }
}
