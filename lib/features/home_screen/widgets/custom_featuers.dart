import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/theme/themeData.dart';
import 'package:quran_app/features/allh_name/pages/allh_name_screen.dart';
import 'package:quran_app/features/another_screen/pages/another_screen.dart';
import 'package:quran_app/features/my_adia/page/doua_home.dart';
import 'package:quran_app/features/prayer_time/controllers/prayer_time_controller.dart';
import 'package:quran_app/features/prayer_time/pages/prayer_time_screen.dart';
import 'package:quran_app/features/qiblah/qiblah_main.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit_cubit.dart';
import 'package:quran_app/features/quran/presentation/page/quran_pdf/page/quran_screen.dart';
import 'package:quran_app/features/quran/presentation/page/read/page/quran_read.dart';
import 'package:quran_app/features/quran_audio/ui/pages/audio_home.dart';
import 'package:quran_app/features/sabih/pages/sabih_screen.dart';
import 'package:quran_app/features/thikr/pages/wird_screen.dart';

class CustomFeatures extends StatelessWidget {
  const CustomFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Text(
              "المميزات",
              style: titleMedium(context)
                  .copyWith(color: ColorsManager.customPrimary),
            ),
          ),
          //
          Row(
            children: [
              _Item(
                svgSize: SizeConfig.blockSizeVertical! * 6,
                isSvgImage: true,
                onPressed: () {
                  navigateTo(WirdScreen(), context);
                },
                svg: AssetsManager.duas,
                asset: "assets/prayer_time/praying.png",
                text: "أذكار الصباح",
              ),
              _Item(
                isSvgImage: true,
                svgSize: SizeConfig.blockSizeVertical! * 6,
                onPressed: () {
                  navigateTo(QiblahMain(), context);
                },
                svg: AssetsManager.kiblat,
                text: "القبلة",
              ),
              _Item(
                svg: "assets/prayer_time/time_hourglass.svg",
                isSvgImage: true,
                svgSize: SizeConfig.blockSizeVertical! * 6,
                onPressed: () {
                  PrayerTimeController.setCurrentColorPrayer();

                  navigateTo(PrayerTimeScreen(), context);
                },
                text: "أوقات الصلاة",
                colorSvg: const Color.fromARGB(255, 50, 133, 184),
              ),
            ],
          ),

          //second
          Row(
            children: [
              _Item(
                isSvgImage: true,
                onPressed: () {
                  navigateTo(WirdScreen(), context);
                },
                svg: AssetsManager.duas,
                text: "أذكار المساء",
                asset: "assets/prayer_time/praying.png",
              ),
              _Item(
                isSvgImage: true,
                onPressed: () {
                  navigateTo(SabihScreen(), context);
                },
                svg: AssetsManager.tasbih,
                text: "التسبيح",
              ),
              _Item(
                isSvgImage: true,
                svgSize: SizeConfig.blockSizeVertical! * 5,
                onPressed: () {
                  navigateTo(const AllhNameScreen(), context);
                },
                svg: AssetsManager.allah,
                text: "أسماء الله ",
              ),
            ],
          ),
          //
          Row(
            children: [
              _Item(
                isSvgImage: true,
                onPressed: () {
                  navigateTo(AudioHome(), context);
                },
                svg: AssetsManager.quran,
                text: "السماع",
              ),
              _Item(
                isSvgImage: false,
                onPressed: () {
                  QuranCubit.get(context).initPlayerPlayAyah(
                    surahNumber: QuranCubit.get(context).indexSurahRead,
                  );
                  navigateTo(const QuranScreen(), context);
                },
                svgSize: SizeConfig.blockSizeVertical! * 5,
                svg: AssetsManager.quran,
                text: "القرآن الكريم",
                asset: "assets/athores/quranRail.png",
              ),
              _Item(
                isSvgImage: true,
                onPressed: () {
                  QuranCubit.get(context).isSurahReadAndListen = true;
                  navigateTo(QuranRead(), context);
                },
                svg: AssetsManager.quran,
                text: "تفسير القرأن",
                colorSvg: const Color.fromARGB(255, 101, 84, 254),
              ),
            ],
          ),
          Row(
            children: [
              _Item(
                isSvgImage: true,
                onPressed: () {
                  navigateTo(const AnotherScreen(), context);
                },
                svg: AssetsManager.other,
                svgSize: 50,
                text: "متفرقات",
              ),
              _Item(
                isSvgImage: true,
                onPressed: () {
                  navigateTo(DouaHome(), context);
                },
                svg: "assets/prayer_time/document_svgrepo.svg",
                text: "أدعيتي",
                colorSvg: const Color.fromARGB(255, 101, 84, 254),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ).animate(
      effects: [
        FadeEffect(duration: 1000.ms),
      ],
      autoPlay: true,
    );
  }
}

class _Item extends StatelessWidget {
  _Item({
    super.key,
    required this.onPressed,
    required this.svg,
    this.svgSize,
    required this.text,
    this.asset,
    required this.isSvgImage,
    this.colorSvg,
  });

  final String text;
  final String svg;
  String? asset;
  double? svgSize;
  Color? colorSvg;
  bool isSvgImage;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: ColorsManager.customMainThird,
              ),
              onPressed: onPressed,
              child: isSvgImage
                  ? SvgPicture.asset(
                      svg,
                      height: svgSize ?? SizeConfig.blockSizeVertical! * 5,
                      color: colorSvg,
                    )
                  : Image.asset(asset!,
                      height: svgSize ?? SizeConfig.blockSizeVertical! * 5),
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: titleSmall(context),
          ),
        ],
      ),
    );
  }
}
