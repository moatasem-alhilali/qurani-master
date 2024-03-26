import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

import 'svg_picture.dart';

extension CustomSurahNameWithBannerExtension on BuildContext {
  Widget surahNameWidget(String num, Color color,
      {double? height, double? width}) {
    return SvgPicture.asset(
      'assets/svg/surah_name/00$num.svg',
      height: height ?? 30,
      width: width,
      color: color,
    );
  }

  Widget bannerWithSurahName(Widget child, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          SizedBox(
              // height: 27.h,
              width: 120.w,
              child: surahNameWidget(
                number,
                const Color(0xffd0d0d0),
              )),
        ],
      ),
    );
  }

  Widget surahBannerWidget(String number, BuildContext context) {
    return bannerWithSurahName(
      surah_banner4(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 27.h,
      ),
      number,
    );
  }

  Widget surahAyahBannerWidget(String number) {
    return bannerWithSurahName(surah_ayah_banner4(), number);
  }

  String bookmarkPageIcon() {
    return 'assets/svg/bookmark.svg';
  }

  Widget surahAyahBannerFirstPlace(int pageIndex, int i, BuildContext context) {
    final quranCtrl = context.read<ReadQuranBloc>().quranRH;

    final ayahs =
        quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
    return ayahs.first.ayahNumber == 1
        ? Container(
            margin: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: const BoxDecoration(
                // color: Get.theme.colorScheme.surface.withOpacity(.4),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            width: double.infinity,
            child: Column(
              children: [
                surahAyahBannerWidget(
                    quranCtrl.getSurahNumberByAyah(ayahs.first).toString()),
                quranCtrl.getSurahNumberByAyah(ayahs.first) == 9 ||
                        quranCtrl.getSurahNumberByAyah(ayahs.first) == 1
                    ? const SizedBox.shrink()
                    : ayahs.first.ayahNumber == 1
                        ? (quranCtrl.getSurahNumberByAyah(ayahs.first) == 95 ||
                                quranCtrl.getSurahNumberByAyah(ayahs.first) ==
                                    97)
                            ? besmAllah2()
                            : besmAllah()
                        : const SizedBox.shrink(),
                const Gap(6),
              ],
            ))
        : const SizedBox.shrink();
  }

  Widget surahBannerLastPlace(int pageIndex, int i, BuildContext context) {
    final quranCtrl = context.read<ReadQuranBloc>().quranRH;
    final ayahs =
        quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
    return quranCtrl.downThePageIndex.contains(pageIndex)
        ? surahBannerWidget(
            (quranCtrl.getSurahNumberByAyah(ayahs.first) + 1).toString(),
            context)
        : const SizedBox.shrink();
  }

  Widget surahBannerFirstPlace(int pageIndex, int i, BuildContext context) {
    final quranCtrl = context.read<ReadQuranBloc>().quranRH;

    final ayahs =
        quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
    return ayahs.first.ayahNumber == 1
        ? quranCtrl.topOfThePageIndex.contains(pageIndex)
            ? const SizedBox.shrink()
            : surahBannerWidget(
                quranCtrl.getSurahNumberByAyah(ayahs.first).toString(), context)
        : const SizedBox.shrink();
  }
}
