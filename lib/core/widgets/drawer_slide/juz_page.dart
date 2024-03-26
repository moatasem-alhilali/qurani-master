import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

import 'quran_surah_list.dart';

class QuranJuz extends StatelessWidget {
  final controller = ScrollController();

  QuranJuz({super.key});

  @override
  Widget build(BuildContext context) {
    final quranCtrl = context.read<ReadQuranBloc>().quranRH;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: currentThemeData.colorScheme.background,
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 30,
        // controller: sl<GeneralController>().surahListController,
        itemBuilder: (_, index) {
          final surah = quranCtrl.surahs[index];
          final juz = quranCtrl.allAyahs.firstWhere(
            (a) => a.juz == index + 1,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${'الجزء'} ${convertNumbers((index + 1).toString())}',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontFamily: "kufi",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 2,
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: (index % 2 == 0
                            ? currentThemeData.colorScheme.primary
                                .withOpacity(.15)
                            : Colors.transparent),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.transparent, Colors.black],
                              stops: [0.0, 0.2],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: SvgPicture.asset(
                                            'assets/svg/sora_num.svg',
                                            color: currentThemeData
                                                .colorScheme.primary,
                                          )),
                                      Transform.translate(
                                        offset: const Offset(0, 1),
                                        child: Text(
                                          convertNumbers(
                                              (index + 1).toString()),
                                          style: TextStyle(
                                              color: currentThemeData.hintColor,
                                              fontFamily: "kufi",
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              height: 2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      juz.text,
                                      style: TextStyle(
                                        color: currentThemeData.hintColor,
                                        fontFamily: "uthmanic2",
                                        fontSize: 20,
                                        height: 2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow
                                          .clip, // Change overflow to clip
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        '${surah.arabicName} ${convertNumbers(surah.surahNumber.toString())} - ${'الصفحه'} ${convertNumbers(juz.page.toString())}',
                                        style: TextStyle(
                                          fontFamily: "naskh",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: currentThemeData
                                              .colorScheme.surface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                onTap: () {
                  context
                      .read<ReadQuranBloc>()
                      .pageController
                      .jumpToPage(juz.page - 1);
                  context.pop();
                  context.pop();
                  // quranCtrl.changeSurahListOnTap(juz.page);
                },
              ),
              hDivider(
                  color: currentThemeData.colorScheme.primary.withOpacity(0.2)),
            ],
          );
        },
      ),
    );
  }
}
