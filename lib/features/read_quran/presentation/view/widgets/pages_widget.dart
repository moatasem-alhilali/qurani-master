import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/models_public/surahs_model.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/core/widgets/custom_span.dart';
import 'package:quran_app/core/widgets/read_quran/surah_name_with_banner.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/menu_extension.dart';

class PagesWidget extends StatelessWidget {
  final int pageIndex;

  const PagesWidget({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, state) {
        final quranCtrl = context.read<ReadQuranBloc>().quranRH;
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            var fontSize = 100.0;

            if (width <= 480) {
              fontSize = 100.0;
            } else if (width > 480 && width <= 960) {
              fontSize = 90.0;
            } else {
              fontSize = 100.0;
            }
            print(fontSize);
            return Container(
              padding: pageIndex == 0 || pageIndex == 1
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.13)
                  : const EdgeInsets.symmetric(horizontal: 16.0),
              margin: pageIndex == 0 || pageIndex == 1
                  ? EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * 0.34)
                  : const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 32.0,
                    ),
              child: quranCtrl.pages.isEmpty
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        quranCtrl
                            .getCurrentPageAyahsSeparatedForBasmalah(pageIndex)
                            .length,
                        (i) {
                          final ayahs =
                              quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(
                                  pageIndex)[i];
                          return Column(
                            children: [
                              context.surahBannerFirstPlace(
                                  pageIndex, i, context),
                              quranCtrl.getSurahNumberByAyah(ayahs.first) ==
                                          9 ||
                                      quranCtrl.getSurahNumberByAyah(
                                              ayahs.first) ==
                                          1
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: ayahs.first.ayahNumber == 1
                                          ? (quranCtrl.getSurahNumberByAyah(
                                                          ayahs.first) ==
                                                      95 ||
                                                  quranCtrl
                                                          .getSurahNumberByAyah(
                                                              ayahs.first) ==
                                                      97)
                                              ? besmAllah2()
                                              : besmAllah()
                                          : const SizedBox.shrink(),
                                    ),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'page${pageIndex + 1}',
                                      fontSize: 100,
                                      height: 2,
                                      letterSpacing: 2,
                                      color: currentThemeData
                                          .colorScheme.inversePrimary,
                                      shadows: const [
                                        Shadow(
                                          blurRadius: 0.5,
                                          color: Colors.black,
                                          offset: Offset(0.5, 0.5),
                                        ),
                                      ],
                                    ),
                                    children: List.generate(
                                      ayahs.length,
                                      (ayahIndex) {
                                        if (ayahIndex == 0) {
                                          return span(
                                            context: context,
                                            isFirstAyah: true,
                                            text:
                                                "${ayahs[ayahIndex].code_v2[0]}${ayahs[ayahIndex].code_v2.substring(1)}",
                                            pageIndex: pageIndex,
                                            isSelected: false,
                                            // fontSize: const AdaptiveTextSize()
                                            //     .getAdaptiveSize(context, 100),
                                            fontSize: fontSize,
                                            surahNum: quranCtrl
                                                .getSurahNumberFromPage(
                                                    pageIndex),
                                            ayahNum:
                                                ayahs[ayahIndex].ayahUQNumber,
                                            onLongPressStart:
                                                (LongPressStartDetails
                                                    details) {
                                              shomCmenue(context, quranCtrl,
                                                  ayahs, ayahIndex, details);
                                            },
                                          );
                                        }
                                        return span(
                                          context: context,
                                          isFirstAyah: false,
                                          text: ayahs[ayahIndex].code_v2,
                                          pageIndex: pageIndex,
                                          isSelected: false,
                                          fontSize: fontSize,
                                          // fontSize: const AdaptiveTextSize()
                                          //     .getAdaptiveSize(context, 100),
                                          surahNum:
                                              quranCtrl.getSurahNumberFromPage(
                                                  pageIndex),
                                          ayahNum:
                                              ayahs[ayahIndex].ayahUQNumber,
                                          onLongPressStart:
                                              (LongPressStartDetails details) {
                                            shomCmenue(context, quranCtrl,
                                                ayahs, ayahIndex, details);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              context.surahBannerLastPlace(
                                  pageIndex, i, context),
                            ],
                          );
                        },
                      ),
                    ),
            );
          },
        );
      },
    );
  }

  void shomCmenue(
    BuildContext context,
    QuranReadHelper quranCtrl,
    List<Ayah> ayahs,
    int ayahIndex,
    LongPressStartDetails details,
  ) {
    return showAyahMenu(
      quranCtrl.getSurahNumberFromPage(pageIndex),
      ayahs[ayahIndex].ayahNumber,
      ayahs[ayahIndex].code_v2,
      pageIndex,
      ayahs[ayahIndex].text,
      ayahs[ayahIndex].ayahUQNumber,
      quranCtrl.getSurahNameFromPage(pageIndex),
      ayahIndex,
      details: details,
      myContext: context,
      ayahUrl: ayahs[ayahIndex].audio,
    );
  }
}

class AdaptiveTextSize {
  const AdaptiveTextSize();

  getAdaptiveSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}
