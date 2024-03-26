import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/core/theme/themeData.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/another_screen/widgets/surah_and_detail.dart';
import 'package:quran_app/features/my_adia/page/doua_home.dart';
import 'package:quran_app/features/quran_audio/ui/pages/audio_home.dart';
import 'package:quran_app/features/allh_name/pages/allh_name_screen.dart';
import 'package:quran_app/features/prayer_time/controllers/prayer_time_controller.dart';
import 'package:quran_app/features/prayer_time/pages/prayer_time_screen.dart';
import 'package:quran_app/features/qiblah/qiblah_main.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_app/features/sabih/pages/sabih_screen.dart';
import 'package:quran_app/features/thikr/pages/thikr_screen.dart';
import 'package:quran_app/features/thikr/pages/wird_screen.dart';

import 'azkar_after_pray.dart';
import 'hadith_40.dart';
import 'husin_almuslim.dart';
import 'ruqia_shareia.dart';

class AnotherFeatures extends StatelessWidget {
  const AnotherFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1 / 1.5,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _Item(
          onPressed: () {
            context.push(const ReadQuranScreen());
          },
          text: "القرآن الكريم",
          icon: FlutterIslamicIcons.quran2,
        ),
        _Item(
          onPressed: () {
            navigateTo(const WirdScreen(), context);
          },
          text: "أذكار الصباح",
          icon: FlutterIslamicIcons.prayer,
        ),
        _Item(
          onPressed: () {
            navigateTo(QiblahMain(), context);
          },
          text: "القبلة",
          icon: FlutterIslamicIcons.qibla,
        ),
        _Item(
          onPressed: () {
            navigateTo(const WirdScreen(), context);
          },
          text: "أذكار المساء",
          icon: FlutterIslamicIcons.prayer,
        ),
        if (serviceEnabled)
          _Item(
            onPressed: () {
              PrayerTimeController.setCurrentColorPrayer();

              navigateTo(const PrayerTimeScreen(), context);
            },
            text: "أوقات الصلاة",
            icon: FlutterIslamicIcons.prayingPerson,
          ),

        _Item(
          onPressed: () {
            navigateTo(SabihScreen(), context);
          },
          text: "التسبيح",
          icon: FlutterIslamicIcons.tasbih2,
        ),
        _Item(
          onPressed: () {
            navigateTo(const AllhNameScreen(), context);
          },
          text: "أسماء الله ",
          icon: FlutterIslamicIcons.allah,
        ),
        _Item(
          onPressed: () {
            navigateTo(const ThikrScreen(), context);
          },
          text: "الاذكار",
          icon: FlutterIslamicIcons.quran,
        ),
        _Item(
          onPressed: () {
            navigateTo(const AudioHome(), context);
          },
          text: "السماع",
          icon: FlutterIslamicIcons.quran,
        ),

        //
        _Item(
          onPressed: () {
            navigateTo(HisnMuslim(), context);
          },
          text: "حصن المسلم",
          icon: FlutterIslamicIcons.quran,
        ),
        _Item(
          onPressed: () {
            navigateTo(const Hadith40(), context);
          },
          text: "الأربعين النووية",
          icon: FlutterIslamicIcons.quran,
        ),
        _Item(
          onPressed: () {
            navigateTo(const AzkarAfterPray(), context);
          },
          text: "أذكار بعد الصلاة",
          icon: FlutterIslamicIcons.tasbihHand,
        ),

        //second
        _Item(
          onPressed: () {
            navigateTo(const RuqiaShareiahScreen(), context);
          },
          text: "الرقية الشرعية",
          icon: FlutterIslamicIcons.quran,
        ),

        _Item(
          onPressed: () {
            navigateTo(const SurahWithAllDetail(), context);
          },
          text: "السور وسبب النزول",
          icon: FlutterIslamicIcons.quran,
        ),
        _Item(
          onPressed: () {
            navigateTo(const DouaHome(), context);
          },
          text: "ادعيتي",
          icon: FlutterIslamicIcons.muslim2,
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.onPressed,
    required this.text,
    this.icon,
  });

  final String text;

  final IconData? icon;

  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: FxColors.secondary,
            ),
            child: Icon(
              icon,
              size: 40,
              // color: DarkColors.customPrimary,
            ),
          ),
          // if (isSvgImage)

          const SizedBox(height: 5),
          text.autoSize(context,
              maxLines: 3, minFontSize: 10, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
