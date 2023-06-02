import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/theme/themeData.dart';
import 'package:quran_app/features/another_screen/widgets/surah_and_detail.dart';
import 'package:quran_app/features/quran_audio/ui/pages/audio_home.dart';
import 'package:quran_app/features/search_ayah/pages/search_ayah.dart';

import 'azkar_after_pray.dart';
import 'hadith_40.dart';
import 'husin_almuslim.dart';
import 'ruqia_shareia.dart';

class AnotherFeatures extends StatelessWidget {
  const AnotherFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          //
          Row(
            children: [
              _Item(
                onPressed: () {
                  navigateTo(HisnMuslim(), context);
                },
                svg: "assets/prayer_time/document_svgrepo.svg",
                colorSvg: const Color.fromARGB(255, 132, 210, 84),
                text: "حصن المسلم",
              ),
              _Item(
                onPressed: () {
                  navigateTo(const Hadith40(), context);
                },
                svg: "assets/prayer_time/document_svgrepo.svg",
                colorSvg: const Color.fromARGB(255, 57, 156, 205),
                text: "الأربعين النووية",
              ),
              _Item(
                onPressed: () {
                  navigateTo(const AzkarAfterPray(), context);
                },
                svg: "assets/prayer_time/document_svgrepo.svg",
                colorSvg: const Color.fromARGB(255, 241, 72, 72),
                text: "أذكار بعد الصلاة",
              ),
            ],
          ),

          //second
          Row(
            children: [
              _Item(
                onPressed: () {
                  navigateTo(const RuqiaShareiahScreen(), context);
                },
                svg: "assets/prayer_time/document_svgrepo.svg",
                colorSvg: const Color.fromARGB(255, 226, 113, 236),
                text: "الرقية الشرعية",
              ),
              _Item(
                onPressed: () {
                  navigateTo(SearchAyahScreen(), context);
                },
                svg: "assets/prayer_time/document_svgrepo.svg",
                text: "البحث على أية",
                colorSvg: const Color.fromARGB(255, 255, 136, 72),
              ),
              _Item(
                onPressed: () {
                  navigateTo(const SurahWithAllDetail(), context);
                },
                svg: AssetsManager.quran,
                text: "السور وسبب النزول",
              ),
            ],
          ),
        ],
      ),
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
    this.colorSvg,
  });

  final String text;
  final String svg;
  double? svgSize;
  Color? colorSvg;
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
                backgroundColor: ColorsManager.customMainSecondary,
              ),
              onPressed: onPressed,
              child: SvgPicture.asset(
                svg,
                height: svgSize ?? SizeConfig.blockSizeVertical! * 6,
                color: colorSvg,
              ),
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
