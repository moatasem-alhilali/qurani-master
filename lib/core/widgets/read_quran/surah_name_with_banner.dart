import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/widgets/images/image_widget.dart';
import 'package:quran_app/core/widgets/read_quran/besm_allah_widget.dart';
import 'package:quran_app/core/widgets/read_quran/surah_name_banner_image_widget.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
import 'package:quran_app/gen/assets.gen.dart';

class SurahBannerWidget extends StatelessWidget {
  const SurahBannerWidget({
    required this.number,
    super.key,
  });
  final String number;

  @override
  Widget build(BuildContext context) {
    return SurahNameBannerImageWidget(
      num: number,
      child: ImageWidget(
        Assets.svg.surahBanner3.path,
        width: MediaQuery.of(context).size.width * 0.8,
        height: 27.h,
      ),
    );
  }
}

class SurahAyahBannerWidget extends StatelessWidget {
  const SurahAyahBannerWidget({
    required this.number,
    this.width,
    this.height,
    super.key,
  });
  final String number;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SurahNameBannerImageWidget(
      num: number,
      child: ImageWidget(
        Assets.svg.surahBanner4.path,
        width: width,
        height: height ?? 35,
      ),
    );
  }
}

class SurahAyahBannerFirstPlace extends StatelessWidget {
  const SurahAyahBannerFirstPlace({
    required this.pageIndex,
    required this.i,
    super.key,
  });
  final int pageIndex;
  final int i;

  @override
  Widget build(BuildContext context) {
    final state = context.read<ReadQuranBloc>().state;
    final ayahs = state.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
    if (ayahs.first.ayahNumber != 1) {
      return const SizedBox.shrink();
    }
    final surahNumber = state.getSurahNumberByAyah(ayahs.first);
    return Container(
      margin: const EdgeInsets.only(top: 16, right: 8, left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      width: double.infinity,
      child: Column(
        children: [
          SurahAyahBannerWidget(
            number: surahNumber.toString(),
          ),
          if (surahNumber == 9 || surahNumber == 1)
            const SizedBox.shrink()
          else
            ayahs.first.ayahNumber == 1
                ? (surahNumber == 95 || surahNumber == 97)
                    ? const BesmAllah2Widget()
                    : const BesmAllahWidget()
                : const SizedBox.shrink(),
          const Gap(6),
        ],
      ),
    );
  }
}

class SurahBannerLastPlace extends StatelessWidget {
  const SurahBannerLastPlace({
    required this.pageIndex,
    required this.i,
    super.key,
  });
  final int pageIndex;
  final int i;

  @override
  Widget build(BuildContext context) {
    final state = context.read<ReadQuranBloc>().state;
    final ayahs = state.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
    if (state.downThePageIndex.contains(pageIndex)) {
      final nextSurahNumber = state.getSurahNumberByAyah(ayahs.first) + 1;
      return SurahBannerWidget(
        number: nextSurahNumber.toString(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class SurahBannerFirstPlace extends StatelessWidget {
  const SurahBannerFirstPlace({
    required this.pageIndex,
    required this.i,
    super.key,
  });
  final int pageIndex;
  final int i;

  @override
  Widget build(BuildContext context) {
    final state = context.read<ReadQuranBloc>().state;
    final ayahs = state.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
    if (ayahs.first.ayahNumber != 1) {
      return const SizedBox.shrink();
    }
    if (state.topOfThePageIndex.contains(pageIndex)) {
      return const SizedBox.shrink();
    }
    final surahNumber = state.getSurahNumberByAyah(ayahs.first);
    return SurahBannerWidget(
      number: surahNumber.toString(),
    );
  }
}
