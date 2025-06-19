import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/allh_name/presentation/bloc/allah_names_bloc.dart';
import 'package:quran_app/features/allh_name/presentation/view/pages/allh_name_screen.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/hisn_muslim/hisn_muslim_bloc.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/surah_info/surah_info_bloc.dart';
import 'package:quran_app/features/another_screen/presentation/view/pages/husin_almuslim_screen.dart';
import 'package:quran_app/features/another_screen/presentation/view/widgets/azkar_after_pray.dart';
import 'package:quran_app/features/another_screen/presentation/view/widgets/hadith_40.dart';
import 'package:quran_app/features/another_screen/presentation/view/widgets/ruqia_shareia.dart';
import 'package:quran_app/features/another_screen/presentation/view/widgets/surah_and_detail_screen.dart';
import 'package:quran_app/features/my_adia/presentation/view/my_doa_provider.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_screen.dart';
import 'package:quran_app/features/qiblah/qiblah_main.dart';
import 'package:quran_app/features/quran_audio/presentation/view/pages/audio_quran_screen.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_app/features/sabih/presentation/view/tasbeeh_provider.dart';
import 'package:quran_app/features/thikr/presentation/view/pages/thikr_screen.dart';
import 'package:quran_app/features/thikr/presentation/view/pages/wird_screen.dart';

class AnotherFeatures extends StatelessWidget {
  const AnotherFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1 / 1.2,
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
          text: 'القرآن الكريم',
          icon: FlutterIslamicIcons.quran2,
        ),
        _Item(
          onPressed: () {
            context.push(const WirdScreen());
          },
          text: 'أذكار الصباح',
          icon: FlutterIslamicIcons.prayer,
        ),
        _Item(
          onPressed: () {
            context.push(QiblahMain());
          },
          text: 'القبلة',
          icon: FlutterIslamicIcons.qibla,
        ),
        _Item(
          onPressed: () {
            context.push(const WirdScreen());
          },
          text: 'أذكار المساء',
          icon: FlutterIslamicIcons.prayer,
        ),
        if (serviceEnabled)
          _Item(
            onPressed: () {
              // PrayerTimeController.getNextPrayerName();

              context.push(const PrayerTimeScreen());
            },
            text: 'أوقات الصلاة',
            icon: FlutterIslamicIcons.prayingPerson,
          ),

        _Item(
          onPressed: () {
            context.push(const TasbeehProvider());
          },
          text: 'التسبيح',
          icon: FlutterIslamicIcons.tasbih2,
        ),
        _Item(
          onPressed: () {
            context.push(
              BlocProvider(
                create: (_) => AllahNamesBloc(),
                child: const AllhNameScreen(),
              ),
            );
          },
          text: 'أسماء الله ',
          icon: FlutterIslamicIcons.allah,
        ),
        _Item(
          onPressed: () {
            context.push(const ThikrScreen());
          },
          text: 'الاذكار',
          icon: FlutterIslamicIcons.quran,
        ),
        _Item(
          onPressed: () {
            context.push(const AudioQuranScreen());
          },
          text: 'السماع',
          icon: FlutterIslamicIcons.quran,
        ),

        //
        _Item(
          onPressed: () {
            context.push(
              BlocProvider(
                create: (_) => HisnMuslimBloc(),
                child: const HisnMuslimScreen(),
              ),
            );
          },
          text: 'حصن المسلم',
          icon: FlutterIslamicIcons.quran,
        ),
        _Item(
          onPressed: () {
            context.push(const Hadith40());
          },
          text: 'الأربعين النووية',
          icon: FlutterIslamicIcons.quran,
        ),
        _Item(
          onPressed: () {
            context.push(const AzkarAfterPray());
          },
          text: 'أذكار بعد الصلاة',
          icon: FlutterIslamicIcons.tasbihHand,
        ),

        //second
        _Item(
          onPressed: () {
            context.push(const RuqiaShareiahScreen());
          },
          text: 'الرقية الشرعية',
          icon: FlutterIslamicIcons.quran,
        ),

        _Item(
          onPressed: () {
            context.push(
              BlocProvider(
                create: (_) => SurahInfoBloc(),
                child: const SurahWithAllDetailScreen(),
              ),
            );
          },
          text: 'السور وسبب النزول',
          icon: FlutterIslamicIcons.quran,
        ),
        _Item(
          onPressed: () {
            context.push(const MuDoaProvider());
          },
          text: 'ادعيتي',
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
          CardWidget(
            child: Icon(
              icon,
              size: 30.sp,
              color: context.primaryScheme,
              // color: DarkColors.customPrimary,
            ),
          ),
          // if (isSvgImage)

          SizedBox(height: 5.h),
          text.autoSize(
            context,
            maxLines: 3,
            minFontSize: 10,
            fontSize: 11.sp,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
