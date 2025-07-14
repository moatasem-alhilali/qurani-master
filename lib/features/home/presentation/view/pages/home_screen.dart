import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_header_widget.dart';
import 'package:quran_app/features/another_screen/presentation/view/widgets/another_featuers.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/current_prayer_home_widget.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/surah_audio_only.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenNew> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CurrentPrayerHomeWidget(),
        // PrayersHomeWidget(),

        SurahAudioOnly(),
        BaseHederWidget(text: 'المميزات'),
        AnotherFeatures(),
      ],
    );
  }
}
